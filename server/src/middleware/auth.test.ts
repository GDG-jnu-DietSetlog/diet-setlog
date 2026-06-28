import { describe, it, expect, vi } from 'vitest';
import type { Request, Response } from 'express';
import { authGuard } from './auth.js';
import { AppError } from '../http/errors.js';
import { signSessionToken } from '../lib/jwt.js';

// Authorization 헤더만 보는 최소 Request 목.
function reqWith(authHeader?: string): Request {
  return {
    header: (name: string) => (name.toLowerCase() === 'authorization' ? authHeader : undefined),
  } as unknown as Request;
}

const res = {} as Response;

describe('authGuard (spec-lock: stateless 서명 검증)', () => {
  it('헤더 없음 → UNAUTHORIZED', () => {
    expect(() => authGuard(reqWith(undefined), res, vi.fn())).toThrow(AppError);
    expect(() => authGuard(reqWith(undefined), res, vi.fn())).toThrow('missing or malformed');
  });

  it('Bearer 스킴 아님 → UNAUTHORIZED', () => {
    const token = signSessionToken({ sub: 'u', ver: 0 });
    expect(() => authGuard(reqWith(`Basic ${token}`), res, vi.fn())).toThrow(
      'missing or malformed',
    );
  });

  it('토큰 부분 없음(스킴만) → UNAUTHORIZED', () => {
    expect(() => authGuard(reqWith('Bearer'), res, vi.fn())).toThrow('missing or malformed');
  });

  it('유효 토큰 → req.auth 세팅 + next() 호출', () => {
    const req = reqWith(`Bearer ${signSessionToken({ sub: 'user-42', ver: 7 })}`);
    const next = vi.fn();
    authGuard(req, res, next);
    expect(req.auth).toEqual({ userId: 'user-42', ver: 7 });
    expect(next).toHaveBeenCalledOnce();
  });

  it('깨진/위조 토큰 → invalid or expired token', () => {
    const req = reqWith('Bearer not.a.real.token');
    expect(() => authGuard(req, res, vi.fn())).toThrow('invalid or expired token');
  });
});
