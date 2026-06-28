import { describe, it, expect, beforeAll, beforeEach, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createTestDb, makeApp, authHeader, type TestDb } from '../../test/db.js';
import { verifySessionToken } from '../../lib/jwt.js';

vi.mock('../../prisma.js', () => import('../../test/prismaMock.js'));
// 카카오 외부 API 는 목 — accessToken 검증/프로필 조회는 단위로 따로 다룬다.
vi.mock('../../lib/kakao.js', () => ({ fetchKakaoProfile: vi.fn() }));

import { fetchKakaoProfile } from '../../lib/kakao.js';
const mockKakao = vi.mocked(fetchKakaoProfile);

let db: TestDb;
let app: ReturnType<typeof makeApp>;

beforeAll(async () => {
  db = await createTestDb();
  const { sessionRouter } = await import('./session.routes.js');
  app = makeApp(['/v1/sessions', sessionRouter]);
});
afterAll(() => db.close());
beforeEach(() => {
  mockKakao.mockReset();
  return db.reset();
});

describe('POST /v1/sessions/guest', () => {
  it('게스트 유저 생성 + 유효 토큰 발급', async () => {
    const res = await request(app).post('/v1/sessions/guest');
    expect(res.status).toBe(201);
    expect(res.body.isNewUser).toBe(true);
    expect(res.body.userId).toBeTruthy();
    // 발급된 토큰이 그 userId 로 검증되어야 한다.
    expect(verifySessionToken(res.body.sessionToken).sub).toBe(res.body.userId);

    const u = await db.prisma.user.findUnique({ where: { id: res.body.userId } });
    expect(u!.isGuest).toBe(true);
    expect(u!.displayName).toMatch(/^user-[a-z0-9]{6}$/);
  });
});

describe('POST /v1/sessions/kakao', () => {
  it('accessToken 없음 → 400 VALIDATION_FAILED', async () => {
    const res = await request(app).post('/v1/sessions/kakao').send({});
    expect(res.status).toBe(400);
    expect(res.body.error.code).toBe('VALIDATION_FAILED');
    expect(mockKakao).not.toHaveBeenCalled();
  });

  it('신규 카카오 계정 → 201, isNewUser true, identity 생성', async () => {
    mockKakao.mockResolvedValue({ kakaoId: 'k-1', nickname: '카카오철수', profileImageUrl: null });
    const res = await request(app).post('/v1/sessions/kakao').send({ accessToken: 'tok' });
    expect(res.status).toBe(201);
    expect(res.body.isNewUser).toBe(true);

    const u = await db.prisma.user.findUnique({
      where: { id: res.body.userId },
      include: { identities: true },
    });
    expect(u!.isGuest).toBe(false);
    expect(u!.displayName).toBe('카카오철수');
    expect(u!.identities).toHaveLength(1);
    expect(u!.identities[0]!.providerUserId).toBe('k-1');
  });

  it('이미 연결된 카카오 계정 → 200 로그인(isNewUser false), 같은 userId', async () => {
    mockKakao.mockResolvedValue({ kakaoId: 'k-2', nickname: '기존', profileImageUrl: null });
    const first = await request(app).post('/v1/sessions/kakao').send({ accessToken: 'tok' });
    expect(first.status).toBe(201);

    const second = await request(app).post('/v1/sessions/kakao').send({ accessToken: 'tok' });
    expect(second.status).toBe(200);
    expect(second.body.isNewUser).toBe(false);
    expect(second.body.userId).toBe(first.body.userId);
    // 중복 유저가 생기지 않아야 한다.
    expect(await db.prisma.user.count()).toBe(1);
  });

  it('게스트 Bearer 동반 → 게스트 승격(같은 userId 유지, isGuest false)', async () => {
    // 1) 게스트 생성
    const guest = await request(app).post('/v1/sessions/guest');
    const guestId = guest.body.userId;
    // 2) 게스트 토큰을 들고 카카오 로그인
    mockKakao.mockResolvedValue({
      kakaoId: 'k-3',
      nickname: '승격유저',
      profileImageUrl: 'http://img/x.png',
    });
    const res = await request(app)
      .post('/v1/sessions/kakao')
      .set('authorization', authHeader(guestId))
      .send({ accessToken: 'tok' });

    expect(res.status).toBe(201);
    expect(res.body.userId).toBe(guestId); // userId 유지
    const u = await db.prisma.user.findUnique({
      where: { id: guestId },
      include: { identities: true },
    });
    expect(u!.isGuest).toBe(false);
    expect(u!.displayName).toBe('승격유저');
    expect(u!.avatarUrl).toBe('http://img/x.png');
    expect(u!.identities).toHaveLength(1);
    expect(await db.prisma.user.count()).toBe(1); // 새 유저 안 생김
  });

  it('nickname 없으면 게스트 형식 displayName 으로 폴백', async () => {
    mockKakao.mockResolvedValue({ kakaoId: 'k-4', nickname: null, profileImageUrl: null });
    const res = await request(app).post('/v1/sessions/kakao').send({ accessToken: 'tok' });
    const u = await db.prisma.user.findUnique({ where: { id: res.body.userId } });
    expect(u!.displayName).toMatch(/^user-[a-z0-9]{6}$/);
  });
});
