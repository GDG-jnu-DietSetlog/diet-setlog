import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { calendarRouter } = await import('./calendar.routes.js');
  app = makeApp(['/v1/calendar', calendarRouter]);
});
afterAll(() => db.close());
beforeEach(() => db.reset());

const DATE = '2026-06-20';

async function userWithProfile(calorieTarget = 2000) {
  const u = await db.prisma.user.create({ data: { displayName: '나' } });
  await db.prisma.profile.create({
    data: {
      userId: u.id,
      gender: 'female',
      birthYear: 1996,
      heightCm: 165,
      currentWeightKg: 60,
      targetWeightKg: 55,
      targetDate: new Date('2027-01-01'),
      dailyCalorieTarget: calorieTarget,
      weeklyWeightDelta: -0.3,
    },
  });
  return u;
}

function seedRecord(userId: string, mealType: string, totalCalories: number) {
  return db.prisma.foodRecord.create({
    data: {
      userId,
      mealType: mealType as 'breakfast',
      title: mealType,
      eatenAt: new Date(`${DATE}T03:00:00Z`),
      eatenLocalDate: new Date(`${DATE}T00:00:00Z`),
      totalCalories,
      proteinG: 10,
      carbsG: 20,
      fatG: 5,
    },
  });
}

describe('GET /v1/calendar/daily-summary', () => {
  it('인증 없음 → 401', async () => {
    expect((await request(app).get(`/v1/calendar/daily-summary?date=${DATE}`)).status).toBe(401);
  });

  it('date 누락 → 400', async () => {
    const u = await userWithProfile();
    const res = await request(app)
      .get('/v1/calendar/daily-summary')
      .set('authorization', authHeader(u.id));
    expect(res.status).toBe(400);
  });

  it('달력상 불가능한 날짜(2026-02-30) → 400', async () => {
    const u = await userWithProfile();
    const res = await request(app)
      .get('/v1/calendar/daily-summary?date=2026-02-30')
      .set('authorization', authHeader(u.id));
    expect(res.status).toBe(400);
  });

  it('기록 없는 날 → 4끼 키 모두 빈 배열, progress 0', async () => {
    const u = await userWithProfile();
    const res = await request(app)
      .get(`/v1/calendar/daily-summary?date=${DATE}`)
      .set('authorization', authHeader(u.id));
    expect(res.status).toBe(200);
    expect(Object.keys(res.body.recordsByMeal).sort()).toEqual([
      'breakfast',
      'dinner',
      'lunch',
      'snack',
    ]);
    expect(res.body.recordsByMeal.lunch).toEqual([]);
    expect(res.body.totalCalories).toBe(0);
    expect(res.body.progressPercent).toBe(0);
  });

  it('끼니별 그룹핑 + 합계 + progressPercent 반올림', async () => {
    const u = await userWithProfile(2000);
    await seedRecord(u.id, 'breakfast', 300);
    await seedRecord(u.id, 'lunch', 500);
    await seedRecord(u.id, 'lunch', 200);
    const res = await request(app)
      .get(`/v1/calendar/daily-summary?date=${DATE}`)
      .set('authorization', authHeader(u.id));
    expect(res.body.recordsByMeal.breakfast).toHaveLength(1);
    expect(res.body.recordsByMeal.lunch).toHaveLength(2);
    expect(res.body.recordsByMeal.dinner).toEqual([]);
    expect(res.body.totalCalories).toBe(1000);
    expect(res.body.progressPercent).toBe(50); // 1000/2000
  });

  it('프로필 없으면 calorieTarget 0, progressPercent 0', async () => {
    const u = await db.prisma.user.create({ data: { displayName: '무프로필' } });
    await seedRecord(u.id, 'lunch', 500);
    const res = await request(app)
      .get(`/v1/calendar/daily-summary?date=${DATE}`)
      .set('authorization', authHeader(u.id));
    expect(res.status).toBe(200);
    expect(res.body.calorieTarget).toBe(0);
    expect(res.body.progressPercent).toBe(0);
    expect(res.body.totalCalories).toBe(500);
  });
});
