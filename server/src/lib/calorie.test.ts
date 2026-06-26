import { describe, it, expect } from 'vitest';
import { calcProfile } from './calorie.js';

const DAY = 24 * 60 * 60 * 1000;

describe('calcProfile (Mifflin–St Jeor, api-db §3.1 / spec-lock §8)', () => {
  const today = new Date(Date.UTC(2026, 0, 1));

  it('male 감량 케이스 — 손계산과 일치', () => {
    // age=2026-1994=32, BMR=10*80+6.25*175-5*32+5=1738.75, TDEE*1.4=2434.25
    // 15주(-6kg) → weekly=-0.4, dailyAdjust=-440 → round(1994.25)=1994
    const r = calcProfile({
      gender: 'male',
      birthYear: 1994,
      heightCm: 175,
      currentWeightKg: 80,
      targetWeightKg: 74,
      targetDate: new Date(today.getTime() + 105 * DAY),
      today,
    });
    expect(r.dailyCalorieTarget).toBe(1994);
    expect(r.weeklyWeightDelta).toBeCloseTo(-0.4, 5);
    expect(r.goalDirection).toBe('lose');
    expect(r.ageBucket).toBe(1990);
  });

  it('하한 clamp 1200 적용', () => {
    // 짧은 기간에 큰 감량 → 음수 폭주, clamp 하한.
    const r = calcProfile({
      gender: 'female',
      birthYear: 2000,
      heightCm: 160,
      currentWeightKg: 90,
      targetWeightKg: 50,
      targetDate: new Date(today.getTime() + 14 * DAY),
      today,
    });
    expect(r.dailyCalorieTarget).toBe(1200);
  });

  it('증량 방향 / ageBucket', () => {
    const r = calcProfile({
      gender: 'male',
      birthYear: 2003,
      heightCm: 180,
      currentWeightKg: 60,
      targetWeightKg: 70,
      targetDate: new Date(today.getTime() + 200 * DAY),
      today,
    });
    expect(r.goalDirection).toBe('gain');
    expect(r.ageBucket).toBe(2000);
  });
});
