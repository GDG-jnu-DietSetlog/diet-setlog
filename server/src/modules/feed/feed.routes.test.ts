import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { feedRouter, postsRouter } = await import('./feed.routes.js');
  app = makeApp(['/v1/feed', feedRouter], ['/v1/posts', postsRouter]);
});
afterAll(() => db.close());
beforeEach(() => db.reset());

function mkUser(displayName = 'u') {
  return db.prisma.user.create({ data: { displayName } });
}

let seq = 0;
function mkRecord(userId: string, over: Record<string, unknown> = {}) {
  seq += 1;
  return db.prisma.foodRecord.create({
    data: {
      userId,
      mealType: 'lunch',
      title: `글${seq}`,
      eatenAt: new Date('2026-06-20T03:00:00Z'),
      eatenLocalDate: new Date('2026-06-20T00:00:00Z'),
      totalCalories: 400,
      proteinG: 30,
      carbsG: 20,
      fatG: 10,
      publishedToFeed: true,
      ...over,
    },
  });
}

function follow(followerId: string, followingId: string) {
  return db.prisma.friendRelation.create({ data: { followerId, followingId } });
}

describe('GET /v1/feed', () => {
  it('인증 없음 → 401', async () => {
    expect((await request(app).get('/v1/feed')).status).toBe(401);
  });

  it('내 글 + 팔로위 공개 글만, 미공개/비팔로위 글 제외', async () => {
    const me = await mkUser('나');
    const friend = await mkUser('친구');
    const stranger = await mkUser('남');
    await follow(me.id, friend.id);

    await mkRecord(me.id, { title: '내공개글' });
    await mkRecord(me.id, { title: '내비공개글', publishedToFeed: false });
    await mkRecord(friend.id, { title: '친구공개글' });
    await mkRecord(stranger.id, { title: '남의글' });

    const res = await request(app).get('/v1/feed').set('authorization', authHeader(me.id));
    expect(res.status).toBe(200);
    const titles = res.body.posts.map((p: { title: string }) => p.title);
    expect(titles).toContain('내공개글');
    expect(titles).toContain('친구공개글');
    expect(titles).not.toContain('내비공개글');
    expect(titles).not.toContain('남의글');
  });

  it('mealType 필터', async () => {
    const me = await mkUser('나');
    await mkRecord(me.id, { mealType: 'breakfast' });
    await mkRecord(me.id, { mealType: 'dinner' });
    const res = await request(app)
      .get('/v1/feed?mealType=breakfast')
      .set('authorization', authHeader(me.id));
    expect(res.body.posts).toHaveLength(1);
    expect(res.body.posts[0].mealType).toBe('breakfast');
  });

  it('likedByMe + previewComments(최신 2개, 오래된→최신)', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id);
    await db.prisma.postLike.create({ data: { recordId: r.id, userId: me.id } });
    await db.prisma.foodRecord.update({ where: { id: r.id }, data: { likeCount: 1 } });
    for (const body of ['c1', 'c2', 'c3']) {
      await db.prisma.postComment.create({ data: { recordId: r.id, userId: me.id, body } });
    }
    const res = await request(app).get('/v1/feed').set('authorization', authHeader(me.id));
    const post = res.body.posts.find((p: { recordId: string }) => p.recordId === r.id);
    expect(post.likedByMe).toBe(true);
    expect(post.previewComments).toHaveLength(2);
    // 최신 2개(c3,c2)를 오래된→최신으로 표시 → [c2, c3]
    expect(post.previewComments.map((c: { body: string }) => c.body)).toEqual(['c2', 'c3']);
  });

  it('keyset 페이지네이션', async () => {
    const me = await mkUser('나');
    for (let i = 0; i < 3; i++) {
      await mkRecord(me.id, { createdAt: new Date(Date.now() + i * 1000) });
    }
    const p1 = await request(app).get('/v1/feed?limit=2').set('authorization', authHeader(me.id));
    expect(p1.body.posts).toHaveLength(2);
    expect(p1.body.nextCursor).not.toBeNull();
    const p2 = await request(app)
      .get(`/v1/feed?limit=2&cursor=${encodeURIComponent(p1.body.nextCursor)}`)
      .set('authorization', authHeader(me.id));
    expect(p2.body.posts).toHaveLength(1);
    expect(p2.body.nextCursor).toBeNull();
  });
});

describe('POST/DELETE /v1/posts/:id/like (멱등)', () => {
  it('비공개 글 → 404', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id, { publishedToFeed: false });
    const res = await request(app)
      .post(`/v1/posts/${r.id}/like`)
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(404);
  });

  it('비팔로위의 공개 글 → 404 (가시성 없음)', async () => {
    const me = await mkUser('나');
    const stranger = await mkUser('남');
    const r = await mkRecord(stranger.id);
    const res = await request(app)
      .post(`/v1/posts/${r.id}/like`)
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(404);
  });

  it('좋아요 → liked true, likeCount 1; 두 번 눌러도 1 (멱등)', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id);
    const h = authHeader(me.id);
    const first = await request(app).post(`/v1/posts/${r.id}/like`).set('authorization', h);
    expect(first.body).toEqual({ recordId: r.id, liked: true, likeCount: 1 });
    const second = await request(app).post(`/v1/posts/${r.id}/like`).set('authorization', h);
    expect(second.body.likeCount).toBe(1);
    expect(await db.prisma.postLike.count()).toBe(1);
  });

  it('좋아요 취소 → liked false, likeCount 0; 중복 취소도 0 (멱등)', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id);
    const h = authHeader(me.id);
    await request(app).post(`/v1/posts/${r.id}/like`).set('authorization', h);
    const del = await request(app).delete(`/v1/posts/${r.id}/like`).set('authorization', h);
    expect(del.body).toEqual({ recordId: r.id, liked: false, likeCount: 0 });
    const del2 = await request(app).delete(`/v1/posts/${r.id}/like`).set('authorization', h);
    expect(del2.body.likeCount).toBe(0);
  });
});

describe('comments', () => {
  it('빈 body → 400', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id);
    const res = await request(app)
      .post(`/v1/posts/${r.id}/comments`)
      .set('authorization', authHeader(me.id))
      .send({ body: '' });
    expect(res.status).toBe(400);
  });

  it('작성 → 201 + commentCount 증가', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id);
    const res = await request(app)
      .post(`/v1/posts/${r.id}/comments`)
      .set('authorization', authHeader(me.id))
      .send({ body: '맛있겠다' });
    expect(res.status).toBe(201);
    expect(res.body.comment.body).toBe('맛있겠다');
    const rec = await db.prisma.foodRecord.findUnique({ where: { id: r.id } });
    expect(rec!.commentCount).toBe(1);
  });

  it('목록 → createdAt asc + 페이지네이션', async () => {
    const me = await mkUser('나');
    const r = await mkRecord(me.id);
    const h = authHeader(me.id);
    for (const body of ['첫째', '둘째', '셋째']) {
      await request(app).post(`/v1/posts/${r.id}/comments`).set('authorization', h).send({ body });
    }
    const p1 = await request(app).get(`/v1/posts/${r.id}/comments?limit=2`).set('authorization', h);
    expect(p1.body.comments.map((c: { body: string }) => c.body)).toEqual(['첫째', '둘째']);
    expect(p1.body.nextCursor).not.toBeNull();
    const p2 = await request(app)
      .get(`/v1/posts/${r.id}/comments?limit=2&cursor=${encodeURIComponent(p1.body.nextCursor)}`)
      .set('authorization', h);
    expect(p2.body.comments.map((c: { body: string }) => c.body)).toEqual(['셋째']);
    expect(p2.body.nextCursor).toBeNull();
  });

  it('보이지 않는 글의 댓글 조회 → 404', async () => {
    const me = await mkUser('나');
    const stranger = await mkUser('남');
    const r = await mkRecord(stranger.id);
    const res = await request(app)
      .get(`/v1/posts/${r.id}/comments`)
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(404);
  });
});
