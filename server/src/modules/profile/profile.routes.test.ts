import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { profileRouter } = await import('./profile.routes.js');
  app = makeApp(['/v1/me', profileRouter]);
});
afterAll(() => db.close());
beforeEach(() => db.reset());

function user() {
  return db.prisma.user.create({ data: { displayName: '홍길동', isGuest: false } });
}

// 2년 이내 미래 날짜(YYYY-MM-DD) — targetDate 검증 통과용.
function futureYmd(days: number): string {
  return new Date(Date.now() + days * 86400000).toISOString().slice(0, 10);
}

const validBody = () => ({
  displayName: '홍길동',
  gender: 'male' as const,
  birthYear: 1995,
  heightCm: 178,
  currentWeightKg: 80,
  targetWeightKg: 72,
  targetDate: futureYmd(120),
});

describe('GET /v1/me/profile', () => {
  it('인증 없음 → 401', async () => {
    expect((await request(app).get('/v1/me/profile')).status).toBe(401);
  });

  it('프로필 없음 → 200 + profile:null', async () => {
    const u = await user();
    const res = await request(app).get('/v1/me/profile').set('authorization', authHeader(u.id));
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ profile: null, dailyCalorieTarget: 0, weeklyWeightDelta: 0 });
  });
});

describe('PUT /v1/me/profile', () => {
  it('잘못된 입력(미성년 출생연도) → 400 + fields', async () => {
    const u = await user();
    const res = await request(app)
      .put('/v1/me/profile')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), birthYear: new Date().getUTCFullYear() });
    expect(res.status).toBe(400);
    expect(res.body.error.fields).toHaveProperty('birthYear');
  });

  it('과거 targetDate → 400', async () => {
    const u = await user();
    const res = await request(app)
      .put('/v1/me/profile')
      .set('authorization', authHeader(u.id))
      .send({ ...validBody(), targetDate: '2000-01-01' });
    expect(res.status).toBe(400);
    expect(res.body.error.fields).toHaveProperty('targetDate');
  });

  it('정상 → 프로필 생성 + 권장칼로리 계산 + User 갱신', async () => {
    const u = await user();
    const res = await request(app)
      .put('/v1/me/profile')
      .set('authorization', authHeader(u.id))
      .send(validBody());
    expect(res.status).toBe(200);
    expect(res.body.dailyCalorieTarget).toBeGreaterThan(0);
    expect(res.body.profile.displayName).toBe('홍길동');

    const p = await db.prisma.profile.findUnique({ where: { userId: u.id } });
    expect(p).not.toBeNull();
    const updated = await db.prisma.user.findUnique({ where: { id: u.id } });
    expect(updated!.goalDirection).not.toBeNull(); // calc 결과 반영
  });

  it('두 번 PUT → upsert(업데이트), 프로필 1개', async () => {
    const u = await user();
    const h = authHeader(u.id);
    await request(app).put('/v1/me/profile').set('authorization', h).send(validBody());
    const res2 = await request(app)
      .put('/v1/me/profile')
      .set('authorization', h)
      .send({ ...validBody(), currentWeightKg: 78 });
    expect(res2.status).toBe(200);
    const p = await db.prisma.profile.findMany({ where: { userId: u.id } });
    expect(p).toHaveLength(1);
    expect(p[0]!.currentWeightKg).toBe(78);
  });

  it('GET 으로 생성된 프로필 재조회', async () => {
    const u = await user();
    const h = authHeader(u.id);
    await request(app).put('/v1/me/profile').set('authorization', h).send(validBody());
    const res = await request(app).get('/v1/me/profile').set('authorization', h);
    expect(res.body.profile).not.toBeNull();
    expect(res.body.profile.gender).toBe('male');
    expect(res.body.dailyCalorieTarget).toBeGreaterThan(0);
  });
});
