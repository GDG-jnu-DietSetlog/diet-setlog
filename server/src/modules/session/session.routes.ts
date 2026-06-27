import { Router } from 'express';
import { randomBytes } from 'node:crypto';
import { z } from 'zod';
import { prisma } from '../../prisma.js';
import { signSessionToken, verifySessionToken } from '../../lib/jwt.js';
import { fetchKakaoProfile } from '../../lib/kakao.js';
import { AppError } from '../../http/errors.js';
import { asyncHandler } from '../../http/asyncHandler.js';

export const sessionRouter = Router();

// spec-lock §7: 게스트 displayName = "user-" + 6자리 소문자 영숫자(base36).
function guestDisplayName(): string {
  const rnd = BigInt('0x' + randomBytes(8).toString('hex'))
    .toString(36)
    .slice(0, 6)
    .padStart(6, '0');
  return `user-${rnd}`;
}

// POST /v1/sessions/guest — authGuard 예외(토큰 발급).
sessionRouter.post(
  '/guest',
  asyncHandler(async (_req, res) => {
    const user = await prisma.user.create({
      data: { displayName: guestDisplayName(), isGuest: true, tokenVersion: 0 },
    });
    const sessionToken = signSessionToken({ sub: user.id, ver: user.tokenVersion });
    res.status(201).json({ userId: user.id, sessionToken, isNewUser: true });
  }),
);

const kakaoSchema = z.object({ accessToken: z.string().min(1) });

// 현재 요청의 Bearer 가 유효한 게스트 토큰이면 그 userId 를 반환(승격 후보). 아니면 null.
function readGuestUserId(authHeader: string): string | null {
  const [scheme, token] = authHeader.split(' ');
  if (scheme !== 'Bearer' || !token) return null;
  try {
    return verifySessionToken(token).sub;
  } catch {
    return null;
  }
}

// POST /v1/sessions/kakao — authGuard 예외. api-db-design §1.5.
// 카카오 SDK 로그인으로 받은 accessToken 을 검증해 AuthIdentity(kakao) upsert 후 세션 토큰 발급.
// 게스트 Bearer 가 함께 오면 게스트→카카오 승격(userId 유지).
sessionRouter.post(
  '/kakao',
  asyncHandler(async (req, res) => {
    const parsed = kakaoSchema.safeParse(req.body);
    if (!parsed.success) {
      throw new AppError('VALIDATION_FAILED', 'accessToken is required', {
        accessToken: 'required',
      });
    }

    const kakao = await fetchKakaoProfile(parsed.data.accessToken);
    const guestUserId = readGuestUserId(req.header('authorization') ?? '');
    const displayName = kakao.nickname || guestDisplayName();

    const { user, isNewUser } = await prisma.$transaction(async (tx) => {
      // 1) 이미 연결된 카카오 계정 → 로그인.
      const identity = await tx.authIdentity.findUnique({
        where: {
          provider_providerUserId: { provider: 'kakao', providerUserId: kakao.kakaoId },
        },
      });
      if (identity) {
        const existing = await tx.user.findUniqueOrThrow({ where: { id: identity.userId } });
        return { user: existing, isNewUser: false };
      }

      // 2) 게스트 승격 — 게스트 유저가 있고 아직 어떤 identity 도 없을 때(userId 유지).
      if (guestUserId) {
        const guest = await tx.user.findUnique({
          where: { id: guestUserId },
          include: { identities: true },
        });
        if (guest && guest.isGuest && guest.identities.length === 0) {
          const upgraded = await tx.user.update({
            where: { id: guest.id },
            data: {
              isGuest: false,
              displayName,
              ...(kakao.profileImageUrl ? { avatarUrl: kakao.profileImageUrl } : {}),
              identities: { create: { provider: 'kakao', providerUserId: kakao.kakaoId } },
            },
          });
          return { user: upgraded, isNewUser: true };
        }
      }

      // 3) 신규 카카오 계정.
      const created = await tx.user.create({
        data: {
          displayName,
          ...(kakao.profileImageUrl ? { avatarUrl: kakao.profileImageUrl } : {}),
          isGuest: false,
          tokenVersion: 0,
          identities: { create: { provider: 'kakao', providerUserId: kakao.kakaoId } },
        },
      });
      return { user: created, isNewUser: true };
    });

    const sessionToken = signSessionToken({ sub: user.id, ver: user.tokenVersion });
    res.status(isNewUser ? 201 : 200).json({ userId: user.id, sessionToken, isNewUser });
  }),
);
