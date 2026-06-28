import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));
// 외부 I/O 는 목 — GCS 업로드와 BullMQ 큐(redis)는 통합 테스트 범위 밖.
vi.mock('../../lib/storage.js', () => ({
  uploadImage: vi.fn(async () => ({ key: 'uploads/x.jpg', url: 'http://gcs/x.jpg' })),
}));
vi.mock('./analysis.queue.js', () => ({ enqueueAnalysis: vi.fn(async () => {}) }));

import { uploadImage } from '../../lib/storage.js';
import { enqueueAnalysis } from './analysis.queue.js';
const mockUpload = vi.mocked(uploadImage);
const mockEnqueue = vi.mocked(enqueueAnalysis);

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { analysesRouter } = await import('./analyses.routes.js');
  app = makeApp(['/v1/food-analyses', analysesRouter]);
});
afterAll(() => db.close());
beforeEach(() => {
  mockUpload.mockClear();
  mockEnqueue.mockClear();
  return db.reset();
});

const jpeg = (bytes: number) => Buffer.alloc(bytes, 1);

describe('POST /v1/food-analyses', () => {
  it('인증 없음 → 401', async () => {
    expect((await request(app).post('/v1/food-analyses')).status).toBe(401);
  });

  it('파일 없음 → 400 image required', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const res = await request(app).post('/v1/food-analyses').set('authorization', authHeader(u.id));
    expect(res.status).toBe(400);
    expect(res.body.error.fields).toHaveProperty('image');
  });

  it('허용 안 되는 타입 → 400', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const res = await request(app)
      .post('/v1/food-analyses')
      .set('authorization', authHeader(u.id))
      .attach('image', jpeg(2048), { filename: 'a.txt', contentType: 'text/plain' });
    expect(res.status).toBe(400);
    expect(mockEnqueue).not.toHaveBeenCalled();
  });

  it('1KB 미만 → 400 too small', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const res = await request(app)
      .post('/v1/food-analyses')
      .set('authorization', authHeader(u.id))
      .attach('image', jpeg(500), { filename: 'a.jpg', contentType: 'image/jpeg' });
    expect(res.status).toBe(400);
  });

  it('정상 → 202 processing, 업로드+큐 호출, analysis 생성', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const res = await request(app)
      .post('/v1/food-analyses')
      .set('authorization', authHeader(u.id))
      .field('source', 'camera')
      .attach('image', jpeg(2048), { filename: 'a.jpg', contentType: 'image/jpeg' });
    expect(res.status).toBe(202);
    expect(res.body.status).toBe('processing');
    expect(res.body.imageUrl).toBe('http://gcs/x.jpg');
    expect(mockUpload).toHaveBeenCalledOnce();
    expect(mockEnqueue).toHaveBeenCalledWith(res.body.analysisId);

    const saved = await db.prisma.foodAnalysis.findUnique({ where: { id: res.body.analysisId } });
    expect(saved!.status).toBe('processing');
    expect(saved!.source).toBe('camera');
  });
});

describe('GET /v1/food-analyses/:id (폴링)', () => {
  function seed(userId: string, over: Record<string, unknown> = {}) {
    return db.prisma.foodAnalysis.create({
      data: {
        userId,
        imageKey: 'k',
        imageUrl: 'http://gcs/x.jpg',
        status: 'processing',
        ...over,
      },
    });
  }

  it('없는 분석 → 404', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const res = await request(app)
      .get('/v1/food-analyses/00000000-0000-0000-0000-000000000000')
      .set('authorization', authHeader(u.id));
    expect(res.status).toBe(404);
  });

  it('남의 분석 → 404', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const other = await db.prisma.user.create({ data: { displayName: '남' } });
    const a = await seed(other.id);
    const res = await request(app)
      .get(`/v1/food-analyses/${a.id}`)
      .set('authorization', authHeader(u.id));
    expect(res.status).toBe(404);
  });

  it('processing → status processing', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const a = await seed(u.id);
    const res = await request(app)
      .get(`/v1/food-analyses/${a.id}`)
      .set('authorization', authHeader(u.id));
    expect(res.body.status).toBe('processing');
  });

  it('completed → result + needsReview', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const a = await seed(u.id, {
      status: 'completed',
      result: { dishName: '샐러드' },
      needsReview: true,
    });
    const res = await request(app)
      .get(`/v1/food-analyses/${a.id}`)
      .set('authorization', authHeader(u.id));
    expect(res.body.status).toBe('completed');
    expect(res.body.result).toEqual({ dishName: '샐러드' });
    expect(res.body.needsReview).toBe(true);
  });

  it('failed → errorCode + message', async () => {
    const u = await db.prisma.user.create({ data: { displayName: 'u' } });
    const a = await seed(u.id, {
      status: 'failed',
      errorCode: 'NO_FOOD_DETECTED',
      errorMsg: '음식 없음',
    });
    const res = await request(app)
      .get(`/v1/food-analyses/${a.id}`)
      .set('authorization', authHeader(u.id));
    expect(res.body.status).toBe('failed');
    expect(res.body.errorCode).toBe('NO_FOOD_DETECTED');
    expect(res.body.message).toBe('음식 없음');
  });
});
