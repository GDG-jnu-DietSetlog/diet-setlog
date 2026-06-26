import { Router } from 'express';
import { randomBytes } from 'node:crypto';
import { prisma } from '../../prisma.js';
import { signSessionToken } from '../../lib/jwt.js';
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
