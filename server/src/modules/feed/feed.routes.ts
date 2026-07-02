import { Router } from 'express';
import { z } from 'zod';
import type { FoodRecord, PostComment, User } from '@prisma/client';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { AppError } from '../../http/errors.js';
import { encodeCursor, decodeCursor, parseLimit } from '../../lib/cursor.js';
import { isStrictYmd } from '../../lib/kst.js';
import { macros } from '../../lib/serialize.js';

// 피드(/v1/feed)와 글 상호작용(/v1/posts/...)을 한 모듈에서 두 라우터로 노출.
export const feedRouter = Router(); // mount: /v1/feed
export const postsRouter = Router(); // mount: /v1/posts

type AuthorSel = Pick<User, 'id' | 'displayName' | 'avatarUrl'>;

function authorRef(u: AuthorSel) {
  return { id: u.id, displayName: u.displayName, avatarUrl: u.avatarUrl };
}

function commentCard(c: PostComment & { user: AuthorSel }) {
  return {
    id: c.id,
    author: authorRef(c.user),
    body: c.body,
    createdAt: c.createdAt.toISOString(),
  };
}

const feedScopeSchema = z.enum(['all', 'mine', 'friends']);

// 글이 나에게 보이는지(본인/팔로위 + publishedToFeed) 확인, 아니면 404.
async function assertVisiblePost(recordId: string, me: string): Promise<FoodRecord> {
  const record = await prisma.foodRecord.findUnique({ where: { id: recordId } });
  if (!record || !record.publishedToFeed) throw new AppError('NOT_FOUND', 'post not found');
  if (record.userId !== me) {
    const rel = await prisma.friendRelation.findUnique({
      where: { followerId_followingId: { followerId: me, followingId: record.userId } },
    });
    if (!rel) throw new AppError('NOT_FOUND', 'post not found');
  }
  return record;
}

// ── GET /v1/feed — (나 ∪ 팔로위)의 공개 글, createdAt desc keyset.
feedRouter.get(
  '/',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const limit = parseLimit(req.query.limit);
    const cur = decodeCursor<{ c: string; id: string }>(req.query.cursor as string | undefined);
    const mealType = req.query.mealType as string | undefined;
    const scope = feedScopeSchema.parse(req.query.scope ?? 'all');
    const date = req.query.date;

    if (date !== undefined && (typeof date !== 'string' || !isStrictYmd(date))) {
      throw new AppError('VALIDATION_FAILED', 'date must be YYYY-MM-DD');
    }

    const following = await prisma.friendRelation.findMany({
      where: { followerId: me },
      select: { followingId: true },
    });
    const followingIds = following.map((f) => f.followingId);
    const authorIds =
      scope === 'mine' ? [me] : scope === 'friends' ? followingIds : [me, ...followingIds];

    const records = await prisma.foodRecord.findMany({
      where: {
        userId: { in: authorIds },
        publishedToFeed: true,
        ...(date ? { eatenLocalDate: new Date(`${date}T00:00:00Z`) } : {}),
        ...(mealType ? { mealType: mealType as FoodRecord['mealType'] } : {}),
        ...(cur
          ? {
              OR: [
                { createdAt: { lt: new Date(cur.c) } },
                { createdAt: new Date(cur.c), id: { lt: cur.id } },
              ],
            }
          : {}),
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
      include: { user: { select: { id: true, displayName: true, avatarUrl: true } } },
    });

    const hasMore = records.length > limit;
    const page = records.slice(0, limit);
    const ids = page.map((r) => r.id);

    // 배치(N+1 금지): 내 좋아요 + 최신 댓글 2개.
    const [myLikes, comments] = await Promise.all([
      ids.length
        ? prisma.postLike.findMany({
            where: { recordId: { in: ids }, userId: me },
            select: { recordId: true },
          })
        : Promise.resolve([]),
      ids.length
        ? prisma.postComment.findMany({
            where: { recordId: { in: ids } },
            orderBy: { createdAt: 'desc' },
            include: { user: { select: { id: true, displayName: true, avatarUrl: true } } },
          })
        : Promise.resolve([]),
    ]);
    const likedSet = new Set(myLikes.map((l) => l.recordId));
    const previewByRecord = new Map<string, ReturnType<typeof commentCard>[]>();
    for (const c of comments) {
      const arr = previewByRecord.get(c.recordId) ?? [];
      if (arr.length < 2) arr.push(commentCard(c)); // 최신 2개
      previewByRecord.set(c.recordId, arr);
    }

    const posts = page.map((r) => ({
      recordId: r.id,
      author: authorRef(r.user),
      title: r.title,
      imageUrl: r.imageUrl,
      mealType: r.mealType,
      eatenAt: r.eatenAt.toISOString(),
      totalCalories: r.totalCalories,
      macros: macros(r),
      memo: r.memo,
      likeCount: r.likeCount,
      commentCount: r.commentCount,
      likedByMe: likedSet.has(r.id),
      previewComments: (previewByRecord.get(r.id) ?? []).reverse(), // 오래된→최신 표시
    }));
    const last = page[page.length - 1];
    res.json({
      posts,
      nextCursor:
        hasMore && last ? encodeCursor({ c: last.createdAt.toISOString(), id: last.id }) : null,
    });
  }),
);

// ── POST /v1/posts/{recordId}/like — 멱등.
postsRouter.post(
  '/:recordId/like',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const recordId = req.params.recordId!;
    await assertVisiblePost(recordId, me);

    const likeCount = await prisma.$transaction(async (tx) => {
      const existing = await tx.postLike.findUnique({
        where: { recordId_userId: { recordId, userId: me } },
      });
      if (!existing) {
        await tx.postLike.create({ data: { recordId, userId: me } });
        const r = await tx.foodRecord.update({
          where: { id: recordId },
          data: { likeCount: { increment: 1 } },
        });
        return r.likeCount;
      }
      const r = await tx.foodRecord.findUnique({
        where: { id: recordId },
        select: { likeCount: true },
      });
      return r!.likeCount;
    });
    res.json({ recordId, liked: true, likeCount });
  }),
);

// ── DELETE /v1/posts/{recordId}/like — 멱등.
postsRouter.delete(
  '/:recordId/like',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const recordId = req.params.recordId!;
    await assertVisiblePost(recordId, me);

    const likeCount = await prisma.$transaction(async (tx) => {
      const del = await tx.postLike.deleteMany({ where: { recordId, userId: me } });
      if (del.count > 0) {
        const r = await tx.foodRecord.update({
          where: { id: recordId },
          data: { likeCount: { decrement: 1 } },
        });
        return r.likeCount;
      }
      const r = await tx.foodRecord.findUnique({
        where: { id: recordId },
        select: { likeCount: true },
      });
      return r!.likeCount;
    });
    res.json({ recordId, liked: false, likeCount });
  }),
);

// ── GET /v1/posts/{recordId}/comments — createdAt asc keyset.
postsRouter.get(
  '/:recordId/comments',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const recordId = req.params.recordId!;
    await assertVisiblePost(recordId, me);
    const limit = parseLimit(req.query.limit);
    const cur = decodeCursor<{ c: string; id: string }>(req.query.cursor as string | undefined);

    const rows = await prisma.postComment.findMany({
      where: {
        recordId,
        ...(cur
          ? {
              OR: [
                { createdAt: { gt: new Date(cur.c) } },
                { createdAt: new Date(cur.c), id: { gt: cur.id } },
              ],
            }
          : {}),
      },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      take: limit + 1,
      include: { user: { select: { id: true, displayName: true, avatarUrl: true } } },
    });
    const hasMore = rows.length > limit;
    const page = rows.slice(0, limit);
    const last = page[page.length - 1];
    res.json({
      comments: page.map(commentCard),
      nextCursor:
        hasMore && last ? encodeCursor({ c: last.createdAt.toISOString(), id: last.id }) : null,
    });
  }),
);

// ── POST /v1/posts/{recordId}/comments — 작성.
const commentBodySchema = z.object({ body: z.string().min(1).max(300) });

postsRouter.post(
  '/:recordId/comments',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const recordId = req.params.recordId!;
    await assertVisiblePost(recordId, me);
    const { body } = commentBodySchema.parse(req.body);

    const comment = await prisma.$transaction(async (tx) => {
      const c = await tx.postComment.create({
        data: { recordId, userId: me, body },
        include: { user: { select: { id: true, displayName: true, avatarUrl: true } } },
      });
      await tx.foodRecord.update({
        where: { id: recordId },
        data: { commentCount: { increment: 1 } },
      });
      return c;
    });
    res.status(201).json({ comment: commentCard(comment) });
  }),
);
