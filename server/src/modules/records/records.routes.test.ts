import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { recordsRouter } = await import('./records.routes.js');
  app = makeApp(['/v1/food-records', recordsRouter]);
});
afterAll(() => db.close());
beforeEach(() => db.reset());

async function userWithProfile(calorieTarget = 2000) {
  const u = await db.prisma.user.create({ data: { displayName: '나' } });
  await db.prisma.profile.create({
    data: {
      userId: u.id,
      gender: 'male',
      birthYear: 1995,
      heightCm: 178,
      currentWeightKg: 80,
      targetWeightKg: 72,
      targetDate: new Date('2027-01-01'),
      dailyCalorieTarget: calorieTarget,
      weeklyWeightDelta: -0.4,
    },
  });
  return u;
}

const validBody = () => ({
  mealType: 'lunch' as const,
  eatenAt: '2026-06-20T12:30:00+09:00',
  title: '닭가슴살 도시락',
  totalCalories: 450,
  macros: { proteinG: 40, carbsG: 30, fatG: 12 },
  items: [
    { name: '닭가슴살', calories: 180, proteinG: 35, carbsG: 0, fatG: 4 },
    { name: '현미밥', calories: 270, proteinG: 5, carbsG: 30, fatG: 8 },
  ],
  publishToFeed: false,
});

describe('POST /v1/food-records', () => {
  it('인증 없음 → 401', async () => {
    expect((await request(app).post('/v1/food-records').send(validBody())).status).toBe(401);
  });

  it('잘못된 mealType → 400', async () => {
    const u = await userWithProfile();
    const res = await request(app)
      .post('/v1/food-records')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), mealType: 'brunch' });
    expect(res.status).toBe(400);
  });

  it('title 빈 문자열 → 400', async () => {
    const u = await userWithProfile();
    const res = await request(app)
      .post('/v1/food-records')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), title: '' });
    expect(res.status).toBe(400);
  });

  it('정상 → 201, 기록+아이템 저장, dailySummary 반환', async () => {
    const u = await userWithProfile(2000);
    const res = await request(app)
      .post('/v1/food-records')
      .set('authorization', authHeader(u.id))
      .send(validBody());
    expect(res.status).toBe(201);
    expect(res.body.recordId).toBeTruthy();
    expect(res.body.record.items).toHaveLength(2);
    // items 는 sortOrder(입력 순서) 유지
    expect(res.body.record.items.map((i: { name: string }) => i.name)).toEqual([
      '닭가슴살',
      '현미밥',
    ]);
    expect(res.body.dailySummary.totalCalories).toBe(450);
    expect(res.body.dailySummary.remainingCalories).toBe(1550);

    const saved = await db.prisma.foodRecord.findUnique({
      where: { id: res.body.recordId },
      include: { items: true },
    });
    expect(saved!.items).toHaveLength(2);
  });

  it('publishToFeed=true → postCount 증가 + lastPostedAt 설정', async () => {
    const u = await userWithProfile();
    await request(app)
      .post('/v1/food-records')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), publishToFeed: true });
    const updated = await db.prisma.user.findUnique({ where: { id: u.id } });
    expect(updated!.postCount).toBe(1);
    expect(updated!.lastPostedAt).not.toBeNull();
  });

  it('남의 analysisId → 404 NOT_FOUND', async () => {
    const u = await userWithProfile();
    const other = await db.prisma.user.create({ data: { displayName: '남' } });
    const analysis = await db.prisma.foodAnalysis.create({
      data: { userId: other.id, imageKey: 'k', imageUrl: 'http://img/x.jpg', status: 'completed' },
    });
    const res = await request(app)
      .post('/v1/food-records')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), analysisId: analysis.id });
    expect(res.status).toBe(404);
  });

  it('내 analysisId → imageUrl 승계', async () => {
    const u = await userWithProfile();
    const analysis = await db.prisma.foodAnalysis.create({
      data: {
        userId: u.id,
        imageKey: 'k',
        imageUrl: 'http://img/mine.jpg',
        status: 'completed',
      },
    });
    const res = await request(app)
      .post('/v1/food-records')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), analysisId: analysis.id });
    expect(res.status).toBe(201);
    expect(res.body.record.imageUrl).toBe('http://img/mine.jpg');
  });
});
