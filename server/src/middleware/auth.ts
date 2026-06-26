import type { Request, Response, NextFunction } from 'express';
import { verifySessionToken } from '../lib/jwt.js';
import { AppError } from '../http/errors.js';

// Request 에 인증 컨텍스트 부착.
declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      auth?: { userId: string; ver: number };
    }
  }
}

// authGuard — 모든 protected 라우트. spec-lock: stateless(요청마다 DB 조회 없이 서명만 검증).
// ⚠️ 계약 긴장: tokenVersion 무효화는 DB 조회가 필요해 "순수 stateless"와 충돌.
//    파일럿 결정 = 서명만 검증(무DB). tokenVersion 체크는 민감 동작에서만(후속). spec-lock 보강 필요.
export function authGuard(req: Request, _res: Response, next: NextFunction): void {
  const header = req.header('authorization') ?? '';
  const [scheme, token] = header.split(' ');
  if (scheme !== 'Bearer' || !token) {
    throw new AppError('UNAUTHORIZED', 'missing or malformed Authorization header');
  }
  try {
    const payload = verifySessionToken(token);
    req.auth = { userId: payload.sub, ver: payload.ver };
    next();
  } catch {
    throw new AppError('UNAUTHORIZED', 'invalid or expired token');
  }
}
