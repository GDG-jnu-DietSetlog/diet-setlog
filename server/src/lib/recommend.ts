import type { GoalDir } from '@prisma/client';

// 친구 추천 점수/정렬 — spec-lock §8 (ADR 0001 §3·§4). ML 없는 결정론적 정렬키.

const NORM_W = 1.0; // kg/주
const NORM_CAL = 800; // kcal
const POST_CAP = 20;
const RECENT_DAYS = 7;

const clamp01 = (x: number) => Math.max(0, Math.min(1, x));

// 추천 신호(후보·나 공통). 그래프 신호는 후보별로 따로 계산해 주입.
export interface RecSignals {
  goalDirection: GoalDir | null;
  weeklyWeightDelta: number | null;
  ageBucket: number | null;
  dailyCalorieTarget: number | null;
  postCount: number;
  lastPostedAt: Date | null;
}

// goalSimilarity(me, c) ∈ [0,1] — spec-lock §8.
export function goalSimilarity(me: RecSignals, c: RecSignals): number {
  const dirSame = me.goalDirection != null && me.goalDirection === c.goalDirection ? 1 : 0;
  const ageSame = me.ageBucket != null && me.ageBucket === c.ageBucket ? 1 : 0;

  const wMe = me.weeklyWeightDelta ?? 0;
  const wC = c.weeklyWeightDelta ?? 0;
  const wSim = clamp01(1 - Math.abs(wMe - wC) / NORM_W);

  const calMe = me.dailyCalorieTarget ?? 0;
  const calC = c.dailyCalorieTarget ?? 0;
  const calSim = clamp01(1 - Math.abs(calMe - calC) / NORM_CAL);

  return 0.4 * dirSame + 0.25 * wSim + 0.2 * ageSame + 0.15 * calSim;
}

// activityRecency = 0.5·min(postCount,20)/20 + 0.5·[lastPostedAt ≤ 7d]
export function activityRecency(c: RecSignals, now: Date): number {
  const postScore = Math.min(c.postCount, POST_CAP) / POST_CAP;
  const recent =
    c.lastPostedAt != null && now.getTime() - c.lastPostedAt.getTime() <= RECENT_DAYS * 86400_000
      ? 1
      : 0;
  return 0.5 * postScore + 0.5 * recent;
}

// 정렬키: mutualFriendCount → goalSimilarity → activityRecency → followerCount → id.
export interface RankedCandidate {
  id: string;
  mutualFriendCount: number;
  goalSim: number;
  activity: number;
  followerCount: number;
}

export function compareCandidates(a: RankedCandidate, b: RankedCandidate): number {
  return (
    b.mutualFriendCount - a.mutualFriendCount ||
    b.goalSim - a.goalSim ||
    b.activity - a.activity ||
    b.followerCount - a.followerCount ||
    (a.id < b.id ? -1 : a.id > b.id ? 1 : 0)
  );
}
