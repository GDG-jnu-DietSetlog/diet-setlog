import jwt from 'jsonwebtoken';
import { env } from '../env.js';

// spec-lock §7: HS256, 만료 365일, payload { sub, ver, iat, exp }.
const EXPIRES_IN = '365d';

export interface TokenPayload {
  sub: string; // userId
  ver: number; // tokenVersion (일괄 무효화용)
}

export function signSessionToken(payload: TokenPayload): string {
  return jwt.sign(payload, env.JWT_SECRET, { algorithm: 'HS256', expiresIn: EXPIRES_IN });
}

export function verifySessionToken(token: string): TokenPayload {
  const decoded = jwt.verify(token, env.JWT_SECRET, { algorithms: ['HS256'] });
  if (typeof decoded === 'string') throw new Error('invalid token payload');
  return { sub: String(decoded.sub), ver: Number(decoded.ver) };
}
