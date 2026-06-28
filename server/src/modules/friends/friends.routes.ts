import { Router } from 'express';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { AppError } from '../../http/errors.js';
import { kstToday } from '../../lib/kst.js';
import { encodeCursor, decodeCursor, parseLimit } from '../../lib/cursor.js';
import {
  goalSimilarity,
  activityRecency,
  compareCandidates,
  type RecSignals,
  type RankedCandidate,
} from '../../lib/recommend.js';

export const friendsRouter = Router();

const FOF_CAP = 200;
const FALLBACK_CAP = 100;
const SEARCH_CAP = 100;

interface SignalRow extends RecSignals {
  displayName: string;
  avatarUrl: string | null;
  followerCount: number;
}

// 내가 follow한 사용자 id 집합.
async function myFollowingIds(userId: string): Promise<Set<string>> {
  const rels = await prisma.friendRelation.findMany({
    where: { followerId: userId },
    select: { followingId: true },
  });
  return new Set(rels.map((r) => r.followingId));
}

// 후보별 mutualFriendCount = |내 following ∩ 후보의 following| (배치, N+1 금지).
async function mutualCounts(
  myFollowing: Set<string>,
  candidateIds: string[],
): Promise<Map<string, number>> {
  const map = new Map<string, number>();
  if (candidateIds.length === 0) return map;
  const rels = await prisma.friendRelation.findMany({
    where: { followerId: { in: candidateIds } },
    select: { followerId: true, followingId: true },
  });
  for (const r of rels) {
    if (myFollowing.has(r.followingId)) map.set(r.followerId, (map.get(r.followerId) ?? 0) + 1);
  }
  return map;
}

// 오늘 기록 1건+ 인 사용자 집합.
async function certifiedTodaySet(userIds: string[], todayDate: Date): Promise<Set<string>> {
  if (userIds.length === 0) return new Set();
  const recs = await prisma.foodRecord.findMany({
    where: { userId: { in: userIds }, eatenLocalDate: todayDate },
    select: { userId: true },
    distinct: ['userId'],
  });
  return new Set(recs.map((r) => r.userId));
}

// 사용자 신호(User + Profile) 배치 로드.
async function loadSignals(userIds: string[]): Promise<Map<string, SignalRow>> {
  const map = new Map<string, SignalRow>();
  if (userIds.length === 0) return map;
  const users = await prisma.user.findMany({
    where: { id: { in: userIds } },
    include: { profile: true },
  });
  for (const u of users) {
    map.set(u.id, {
      goalDirection: u.goalDirection,
      weeklyWeightDelta: u.profile?.weeklyWeightDelta ?? null,
      ageBucket: u.ageBucket,
      dailyCalorieTarget: u.profile?.dailyCalorieTarget ?? null,
      postCount: u.postCount,
      lastPostedAt: u.lastPostedAt,
      followerCount: u.followerCount,
      displayName: u.displayName,
      avatarUrl: u.avatarUrl,
    });
  }
  return map;
}

// ── GET /v1/friends — 친구 목록(내가 follow한 사람). keyset 무한스크롤.
friendsRouter.get(
  '/',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const limit = parseLimit(req.query.limit);
    const cur = decodeCursor<{ c: string; id: string }>(req.query.cursor as string | undefined);

    const relations = await prisma.friendRelation.findMany({
      where: cur
        ? {
            followerId: me,
            OR: [
              { createdAt: { lt: new Date(cur.c) } },
              { createdAt: new Date(cur.c), id: { lt: cur.id } },
            ],
          }
        : { followerId: me },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
      include: { following: { select: { id: true, displayName: true, avatarUrl: true } } },
    });

    const hasMore = relations.length > limit;
    const page = relations.slice(0, limit);
    const ids = page.map((r) => r.followingId);
    const [myFollowing, certified] = await Promise.all([
      myFollowingIds(me),
      certifiedTodaySet(ids, kstToday().date),
    ]);
    const mutual = await mutualCounts(myFollowing, ids);

    const friends = page.map((r) => ({
      id: r.following.id,
      displayName: r.following.displayName,
      avatarUrl: r.following.avatarUrl,
      mutualFriendCount: mutual.get(r.following.id) ?? 0,
      certifiedToday: certified.has(r.following.id),
    }));
    const last = page[page.length - 1];
    res.json({
      friends,
      nextCursor:
        hasMore && last ? encodeCursor({ c: last.createdAt.toISOString(), id: last.id }) : null,
    });
  }),
);

// ── GET /v1/friends/search?q= — q 빈값=추천, q 있음=검색.
friendsRouter.get(
  '/search',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const q = ((req.query.q as string) ?? '').trim();
    const limit = parseLimit(req.query.limit);
    const now = new Date();

    const myFollowing = await myFollowingIds(me);
    const meSig = (await loadSignals([me])).get(me) ?? null;

    let candidateIds: string[];
    if (q.length > 0) {
      // 검색: displayName 부분일치(본인 제외). 이미 친구도 표시(selected=true).
      const matches = await prisma.user.findMany({
        where: { id: { not: me }, displayName: { contains: q, mode: 'insensitive' } },
        select: { id: true },
        take: SEARCH_CAP,
      });
      candidateIds = matches.map((m) => m.id);
    } else {
      // 추천: 후보 union(FoF + 목표/활동 폴백), 본인·이미친구·dismissed/hidden 제외.
      const excluded = new Set<string>([me, ...myFollowing]);
      const feedback = await prisma.friendRecFeedback.findMany({
        where: { userId: me, action: { in: ['dismissed', 'hidden'] } },
        select: { candidateId: true },
      });
      for (const f of feedback) excluded.add(f.candidateId);

      const set = new Set<string>();
      // ① FoF: 내 친구가 follow한 사람
      if (myFollowing.size > 0) {
        const fof = await prisma.friendRelation.findMany({
          where: { followerId: { in: [...myFollowing] } },
          select: { followingId: true },
          take: FOF_CAP,
        });
        for (const r of fof) if (!excluded.has(r.followingId)) set.add(r.followingId);
      }
      // ② 목표/나이 폴백
      if (meSig?.goalDirection != null && meSig.ageBucket != null) {
        const fb = await prisma.user.findMany({
          where: {
            goalDirection: meSig.goalDirection,
            ageBucket: meSig.ageBucket,
            id: { notIn: [...excluded] },
          },
          select: { id: true },
          take: FALLBACK_CAP,
        });
        for (const u of fb) set.add(u.id);
      }
      // ③ 활동 폴백(부족 시): 최근 글
      if (set.size < limit) {
        const recent = await prisma.user.findMany({
          where: { id: { notIn: [...excluded] }, lastPostedAt: { not: null } },
          orderBy: { lastPostedAt: 'desc' },
          select: { id: true },
          take: FALLBACK_CAP,
        });
        for (const u of recent) set.add(u.id);
      }
      candidateIds = [...set];
    }

    const [signals, mutual] = await Promise.all([
      loadSignals(candidateIds),
      mutualCounts(myFollowing, candidateIds),
    ]);

    const ranked: Array<RankedCandidate & { selected: boolean }> = candidateIds
      .map((id) => {
        const sig = signals.get(id);
        if (!sig) return null;
        return {
          id,
          mutualFriendCount: mutual.get(id) ?? 0,
          goalSim: meSig ? goalSimilarity(meSig, sig) : 0,
          activity: activityRecency(sig, now),
          followerCount: sig.followerCount,
          selected: myFollowing.has(id),
        };
      })
      .filter((x): x is RankedCandidate & { selected: boolean } => x !== null)
      .sort(compareCandidates);

    // 계산값 정렬이라 DB keyset 불가 → offset 커서(spec-lock §8: Redis 캐시는 인프라 wave).
    const offset = decodeCursor<{ o: number }>(req.query.cursor as string | undefined)?.o ?? 0;
    const pageRows = ranked.slice(offset, offset + limit);

    const users = pageRows.map((r) => {
      const sig = signals.get(r.id)!;
      return {
        id: r.id,
        displayName: sig.displayName,
        avatarUrl: sig.avatarUrl,
        followerCount: sig.followerCount,
        postCount: sig.postCount,
        mutualFriendCount: r.mutualFriendCount,
        selected: r.selected,
      };
    });
    res.json({
      users,
      nextCursor: offset + limit < ranked.length ? encodeCursor({ o: offset + limit }) : null,
    });
  }),
);

// ── POST /v1/friends/{friendUserId}/follow — 친구 추가(멱등).
friendsRouter.post(
  '/:friendUserId/follow',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const target = req.params.friendUserId!;
    if (target === me) throw new AppError('VALIDATION_FAILED', 'cannot follow yourself');
    const exists = await prisma.user.findUnique({ where: { id: target }, select: { id: true } });
    if (!exists) throw new AppError('NOT_FOUND', 'target user not found');

    await prisma.$transaction(async (tx) => {
      const rel = await tx.friendRelation.findUnique({
        where: { followerId_followingId: { followerId: me, followingId: target } },
      });
      if (!rel) {
        await tx.friendRelation.create({ data: { followerId: me, followingId: target } });
        await tx.user.update({ where: { id: me }, data: { followingCount: { increment: 1 } } });
        await tx.user.update({ where: { id: target }, data: { followerCount: { increment: 1 } } });
      }
    });
    res.json({ friendUserId: target, selected: true });
  }),
);

// ── DELETE /v1/friends/{friendUserId}/follow — 친구 제거(멱등).
friendsRouter.delete(
  '/:friendUserId/follow',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const target = req.params.friendUserId!;
    await prisma.$transaction(async (tx) => {
      const del = await tx.friendRelation.deleteMany({
        where: { followerId: me, followingId: target },
      });
      if (del.count > 0) {
        await tx.user.update({ where: { id: me }, data: { followingCount: { decrement: 1 } } });
        await tx.user.update({ where: { id: target }, data: { followerCount: { decrement: 1 } } });
      }
    });
    res.json({ friendUserId: target, selected: false });
  }),
);
