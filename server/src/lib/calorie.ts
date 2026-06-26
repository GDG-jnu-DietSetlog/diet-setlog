import type { Gender, GoalDir } from '@prisma/client';

// 권장 칼로리/주간 체중변화 계산 — api-db-design §3.1 + spec-lock §8.
// 서버 단일 책임(클라는 계산하지 않음).

const ACTIVITY_FACTOR = 1.4; // 활동량 미입력, 고정계수
const KCAL_PER_KG = 7700; // 지방 1kg
const CAL_MIN = 1200;
const CAL_MAX = 5000;

export interface ProfileCalcInput {
  gender: Gender;
  birthYear: number;
  heightCm: number;
  currentWeightKg: number;
  targetWeightKg: number;
  targetDate: Date; // 자정 KST 가정(@db.Date)
  today: Date;
}

export interface ProfileCalcResult {
  dailyCalorieTarget: number;
  weeklyWeightDelta: number;
  goalDirection: GoalDir;
  ageBucket: number;
}

// Mifflin–St Jeor. ⚠️ 계약 구멍: gender="other"의 BMR 상수가 명세에 없음
// → 파일럿 결정: male(+5)/female(−161) 상수의 평균(−78) 사용. spec-lock 반영 필요.
function bmr(gender: Gender, kg: number, cm: number, age: number): number {
  const base = 10 * kg + 6.25 * cm - 5 * age;
  if (gender === 'male') return base + 5;
  if (gender === 'female') return base - 161;
  return base - 78; // other
}

export function calcProfile(input: ProfileCalcInput): ProfileCalcResult {
  const age = input.today.getUTCFullYear() - input.birthYear;
  const tdee = bmr(input.gender, input.currentWeightKg, input.heightCm, age) * ACTIVITY_FACTOR;

  const msPerWeek = 7 * 24 * 60 * 60 * 1000;
  const weeks = Math.max(1, (input.targetDate.getTime() - input.today.getTime()) / msPerWeek);
  const weeklyWeightDelta = (input.targetWeightKg - input.currentWeightKg) / weeks;
  const dailyAdjust = (weeklyWeightDelta * KCAL_PER_KG) / 7;

  const dailyCalorieTarget = Math.min(
    CAL_MAX,
    Math.max(CAL_MIN, Math.round(tdee + dailyAdjust)),
  );

  const diff = input.targetWeightKg - input.currentWeightKg;
  const goalDirection: GoalDir = diff < 0 ? 'lose' : diff > 0 ? 'gain' : 'maintain';
  const ageBucket = Math.floor(input.birthYear / 10) * 10;

  return { dailyCalorieTarget, weeklyWeightDelta, goalDirection, ageBucket };
}
