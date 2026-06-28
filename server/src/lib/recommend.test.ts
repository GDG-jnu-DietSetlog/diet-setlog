import { describe, it, expect } from 'vitest';
import {
  goalSimilarity,
  activityRecency,
  compareCandidates,
  type RecSignals,
} from './recommend.js';

const base: RecSignals = {
  goalDirection: 'lose',
  weeklyWeightDelta: -0.4,
  ageBucket: 1990,
  dailyCalorieTarget: 1800,
  postCount: 0,
  lastPostedAt: null,
};

describe('goalSimilarity (spec-lock §8)', () => {
  it('동일 신호 → 1.0', () => {
    expect(goalSimilarity(base, base)).toBeCloseTo(1.0, 5);
  });

  it('목표방향만 다름 → 0.4 감점', () => {
    const c = { ...base, goalDirection: 'gain' as const };
    expect(goalSimilarity(base, c)).toBeCloseTo(0.6, 5);
  });

  it('나이대만 다름 → 0.2 감점', () => {
    const c = { ...base, ageBucket: 1980 };
    expect(goalSimilarity(base, c)).toBeCloseTo(0.8, 5);
  });

  it('칼로리 800차이 → calSim=0(0.15 감점)', () => {
    const c = { ...base, dailyCalorieTarget: 1000 };
    expect(goalSimilarity(base, c)).toBeCloseTo(0.85, 5);
  });
});

describe('activityRecency', () => {
  const now = new Date('2026-06-26T00:00:00Z');
  it('최근글 없음 + post 0 → 0', () => {
    expect(activityRecency({ ...base, postCount: 0, lastPostedAt: null }, now)).toBe(0);
  });
  it('post 20 + 최근 글 → 1', () => {
    expect(
      activityRecency(
        { ...base, postCount: 20, lastPostedAt: new Date('2026-06-24T00:00:00Z') },
        now,
      ),
    ).toBe(1);
  });
});

describe('compareCandidates (정렬키)', () => {
  it('mutual 우선, 동률이면 goalSim', () => {
    const a = { id: 'a', mutualFriendCount: 1, goalSim: 0.5, activity: 0, followerCount: 0 };
    const b = { id: 'b', mutualFriendCount: 2, goalSim: 0.1, activity: 0, followerCount: 0 };
    expect([a, b].sort(compareCandidates)[0]!.id).toBe('b'); // mutual 높은 b 먼저
    const c = { id: 'c', mutualFriendCount: 1, goalSim: 0.9, activity: 0, followerCount: 0 };
    expect([a, c].sort(compareCandidates)[0]!.id).toBe('c'); // mutual 동률 → goalSim 높은 c
  });
});
