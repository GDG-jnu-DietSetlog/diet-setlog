import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { friendsRouter } = await import('./friends.routes.js');
  app = makeApp(['/v1/friends', friendsRouter]);
});
afterAll(() => db.close());
beforeEach(() => db.reset());

// 시드 헬퍼.
function user(over: Record<string, unknown> = {}) {
  return db.prisma.user.create({
    data: { displayName: 'u', isGuest: false, ...over },
  });
}

describe('POST /v1/friends/:id/follow (멱등 팔로우)', () => {
  it('인증 없음 → 401', async () => {
    const res = await request(app).post('/v1/friends/x/follow');
    expect(res.status).toBe(401);
  });

  it('자기 자신 팔로우 → 400 VALIDATION_FAILED', async () => {
    const me = await user();
    const res = await request(app)
      .post(`/v1/friends/${me.id}/follow`)
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(400);
    expect(res.body.error.code).toBe('VALIDATION_FAILED');
  });

  it('없는 대상 → 404 NOT_FOUND', async () => {
    const me = await user();
    const res = await request(app)
      .post('/v1/friends/00000000-0000-0000-0000-000000000000/follow')
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(404);
  });

  it('성공 → relation 생성 + 카운트 증가', async () => {
    const me = await user();
    const target = await user();
    const res = await request(app)
      .post(`/v1/friends/${target.id}/follow`)
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ friendUserId: target.id, selected: true });

    const rel = await db.prisma.friendRelation.findUnique({
      where: { followerId_followingId: { followerId: me.id, followingId: target.id } },
    });
    expect(rel).not.toBeNull();
    const [m, t] = await Promise.all([
      db.prisma.user.findUnique({ where: { id: me.id } }),
      db.prisma.user.findUnique({ where: { id: target.id } }),
    ]);
    expect(m!.followingCount).toBe(1);
    expect(t!.followerCount).toBe(1);
  });

  it('두 번 팔로우해도 카운트는 1 (멱등)', async () => {
    const me = await user();
    const target = await user();
    const h = authHeader(me.id);
    await request(app).post(`/v1/friends/${target.id}/follow`).set('authorization', h);
    await request(app).post(`/v1/friends/${target.id}/follow`).set('authorization', h);
    const t = await db.prisma.user.findUnique({ where: { id: target.id } });
    expect(t!.followerCount).toBe(1);
    const count = await db.prisma.friendRelation.count();
    expect(count).toBe(1);
  });
});

describe('DELETE /v1/friends/:id/follow (멱등 언팔로우)', () => {
  it('팔로우 상태 해제 → 카운트 감소', async () => {
    const me = await user();
    const target = await user();
    const h = authHeader(me.id);
    await request(app).post(`/v1/friends/${target.id}/follow`).set('authorization', h);
    const res = await request(app)
      .delete(`/v1/friends/${target.id}/follow`)
      .set('authorization', h);
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ friendUserId: target.id, selected: false });
    const t = await db.prisma.user.findUnique({ where: { id: target.id } });
    expect(t!.followerCount).toBe(0);
  });

  it('팔로우 안 한 상태에서 언팔로우 → 카운트 음수로 안 감 (멱등)', async () => {
    const me = await user();
    const target = await user();
    const res = await request(app)
      .delete(`/v1/friends/${target.id}/follow`)
      .set('authorization', authHeader(me.id));
    expect(res.status).toBe(200);
    const t = await db.prisma.user.findUnique({ where: { id: target.id } });
    expect(t!.followerCount).toBe(0);
  });
});

describe('GET /v1/friends (친구 목록 페이지네이션)', () => {
  it('내가 follow 한 사람만, mutual/certified 포함', async () => {
    const me = await user();
    const a = await user({ displayName: '친구A' });
    const b = await user({ displayName: '친구B' });
    const h = authHeader(me.id);
    await request(app).post(`/v1/friends/${a.id}/follow`).set('authorization', h);
    await request(app).post(`/v1/friends/${b.id}/follow`).set('authorization', h);

    const res = await request(app).get('/v1/friends').set('authorization', h);
    expect(res.status).toBe(200);
    expect(res.body.friends).toHaveLength(2);
    expect(res.body.nextCursor).toBeNull();
    expect(res.body.friends[0]).toHaveProperty('mutualFriendCount');
    expect(res.body.friends[0]).toHaveProperty('certifiedToday');
  });

  it('limit 로 페이지 분할 + nextCursor 로 다음 페이지', async () => {
    const me = await user();
    const h = authHeader(me.id);
    for (let i = 0; i < 3; i++) {
      const f = await user({ displayName: `f${i}` });
      await request(app).post(`/v1/friends/${f.id}/follow`).set('authorization', h);
    }
    const p1 = await request(app).get('/v1/friends?limit=2').set('authorization', h);
    expect(p1.body.friends).toHaveLength(2);
    expect(p1.body.nextCursor).not.toBeNull();

    const p2 = await request(app)
      .get(`/v1/friends?limit=2&cursor=${encodeURIComponent(p1.body.nextCursor)}`)
      .set('authorization', h);
    expect(p2.body.friends).toHaveLength(1);
    expect(p2.body.nextCursor).toBeNull();
  });
});

describe('GET /v1/friends/search', () => {
  it('q 있음 → displayName 부분일치(본인 제외), 이미 친구는 selected=true', async () => {
    const me = await user({ displayName: '내계정' });
    const kim1 = await user({ displayName: '김철수' });
    const kim2 = await user({ displayName: '김영희' });
    await user({ displayName: '박지성' });
    const h = authHeader(me.id);
    await request(app).post(`/v1/friends/${kim1.id}/follow`).set('authorization', h);

    const res = await request(app).get('/v1/friends/search?q=김').set('authorization', h);
    expect(res.status).toBe(200);
    const ids = res.body.users.map((u: { id: string }) => u.id);
    expect(ids).toContain(kim1.id);
    expect(ids).toContain(kim2.id);
    expect(ids).not.toContain(me.id);
    const k1 = res.body.users.find((u: { id: string }) => u.id === kim1.id);
    expect(k1.selected).toBe(true); // 이미 친구
  });

  it('q 대소문자 무시(insensitive)', async () => {
    const me = await user({ displayName: '나' });
    const target = await user({ displayName: 'Alice' });
    const res = await request(app)
      .get('/v1/friends/search?q=alice')
      .set('authorization', authHeader(me.id));
    expect(res.body.users.map((u: { id: string }) => u.id)).toContain(target.id);
  });

  it('q 빈값 → 추천: 이미 친구·본인 제외', async () => {
    const me = await user({ displayName: '나', goalDirection: 'lose', ageBucket: 1995 });
    const friend = await user({ displayName: '이미친구' });
    const reco = await user({
      displayName: '추천대상',
      goalDirection: 'lose',
      ageBucket: 1995,
    });
    const h = authHeader(me.id);
    await request(app).post(`/v1/friends/${friend.id}/follow`).set('authorization', h);

    const res = await request(app).get('/v1/friends/search').set('authorization', h);
    expect(res.status).toBe(200);
    const ids = res.body.users.map((u: { id: string }) => u.id);
    expect(ids).not.toContain(me.id);
    expect(ids).not.toContain(friend.id);
    expect(ids).toContain(reco.id); // 같은 목표/나이대 폴백
  });

  it('q 빈값 → dismissed 피드백한 후보 제외', async () => {
    const me = await user({ displayName: '나', goalDirection: 'lose', ageBucket: 1995 });
    const dismissed = await user({
      displayName: '싫어요',
      goalDirection: 'lose',
      ageBucket: 1995,
    });
    await db.prisma.friendRecFeedback.create({
      data: { userId: me.id, candidateId: dismissed.id, action: 'dismissed' },
    });
    const res = await request(app)
      .get('/v1/friends/search')
      .set('authorization', authHeader(me.id));
    const ids = res.body.users.map((u: { id: string }) => u.id);
    expect(ids).not.toContain(dismissed.id);
  });
});
