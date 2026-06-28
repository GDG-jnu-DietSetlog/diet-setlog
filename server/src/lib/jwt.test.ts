import { describe, it, expect } from 'vitest';
import jwt from 'jsonwebtoken';
import { signSessionToken, verifySessionToken } from './jwt.js';

describe('sign/verifySessionToken (spec-lock §7, HS256)', () => {
  it('서명→검증 라운드트립으로 sub/ver 복원', () => {
    const token = signSessionToken({ sub: 'user-1', ver: 3 });
    expect(verifySessionToken(token)).toEqual({ sub: 'user-1', ver: 3 });
  });

  it('변조된 토큰 → throw', () => {
    const token = signSessionToken({ sub: 'user-1', ver: 0 });
    const tampered = token.slice(0, -2) + (token.endsWith('a') ? 'bb' : 'aa');
    expect(() => verifySessionToken(tampered)).toThrow();
  });

  it('다른 시크릿으로 서명된 토큰 → throw', () => {
    const foreign = jwt.sign({ sub: 'x', ver: 0 }, 'some-other-secret', { algorithm: 'HS256' });
    expect(() => verifySessionToken(foreign)).toThrow();
  });

  it('만료된 토큰 → throw', () => {
    const expired = jwt.sign({ sub: 'x', ver: 0 }, 'test-secret-key-1234', {
      algorithm: 'HS256',
      expiresIn: '-1s',
    });
    expect(() => verifySessionToken(expired)).toThrow();
  });

  it('payload 가 문자열이면 throw (invalid token payload)', () => {
    // jwt.sign 에 문자열 payload → decoded 가 string → 가드가 throw 해야 함.
    const stringPayload = jwt.sign('plain-string', 'test-secret-key-1234', { algorithm: 'HS256' });
    expect(() => verifySessionToken(stringPayload)).toThrow('invalid token payload');
  });
});
