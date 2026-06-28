import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';
import { kstToday } from '../../lib/kst.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { homeRouter } = await import('./home.routes.js');
  app = makeApp(['/v1/home', homeRouter]);
});
afterAll(() => db.close());
beforeEach(() => db.reset());

async function userWithProfile(calorieTarget = 2000, displayName = '나') {
  const u = await db.prisma.user.create({ data: { displayName, isGuest: false } });
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

function seedRecord(userId: string, over: Record<string, unknown> = {}) {
  const today = kstToday();
  return db.prisma.foodRecord.create({
    data: {
      userId,
      mealType: 'lunch',
      title: '점심',
      eatenAt: new Date(),
      eatenLocalDate: today.date,
      totalCalories: 500,
      proteinG: 40,
      carbsG: 30,
      fatG: 15,
      ...over,
    },
  });
}

describe('GET /v1/home', () => {
  it('인증 없음 → 401', async () => {
    expect((await request(app).get('/v1/home')).status).toBe(401);
  });

  it('토큰은 유효하나 유저 없음 → 401 UNAUTHORIZED', async () => {
    const res = await request(app)
      .get('/v1/home')
      .set('authorization', authHeader('00000000-0000-0000-0000-000000000000'));
    expect(res.status).toBe(401);
  });

  it('프로필 없음 → 404 NOT_FOUND', async () => {
    const u = await db.prisma.user.create({ data: { displayName: '무프로필' } });
    const res = await request(app).get('/v1/home').set('authorization', authHeader(u.id));
    expect(res.status).toBe(404);
  });

  it('기록 없는 날 → todaySummary 0, progressRatio 0', async () => {
    const u = await userWithProfile(2000);
    const res = await request(app).get('/v1/home').set('authorization', authHeader(u.id));
    expect(res.status).toBe(200);
    expect(res.body.todaySummary.totalCalories).toBe(0);
    expect(res.body.todaySummary.remainingCalories).toBe(2000);
    expect(res.body.todaySummary.progressRatio).toBe(0);
    expect(res.body.recentRecords).toEqual([]);
    expect(res.body.friendsCertifiedToday).toEqual([]);
  });

  it('오늘 기록 합산 → totalCalories/remaining/progressRatio 계산', async () => {
    const u = await userWithProfile(2000);
    await seedRecord(u.id, { totalCalories: 500 });
    await seedRecord(u.id, { totalCalories: 300, mealType: 'dinner' });
    const res = await request(app).get('/v1/home').set('authorization', authHeader(u.id));
    expect(res.body.todaySummary.totalCalories).toBe(800);
    expect(res.body.todaySummary.remainingCalories).toBe(1200);
    expect(res.body.todaySummary.progressRatio).toBeCloseTo(0.4, 5);
    expect(res.body.recentRecords).toHaveLength(2);
  });

  it('내가 follow 한 친구가 오늘 기록 → friendsCertifiedToday 에 1회만(중복 제거)', async () => {
    const me = await userWithProfile(2000);
    const friend = await db.prisma.user.create({ data: { displayName: '친구' } });
    await db.prisma.friendRelation.create({
      data: { followerId: me.id, followingId: friend.id },
    });
    await seedRecord(friend.id);
    await seedRecord(friend.id, { mealType: 'dinner' }); // 같은 친구 2건

    const res = await request(app).get('/v1/home').set('authorization', authHeader(me.id));
    expect(res.body.friendsCertifiedToday).toHaveLength(1);
    expect(res.body.friendsCertifiedToday[0].displayName).toBe('친구');
  });
});
