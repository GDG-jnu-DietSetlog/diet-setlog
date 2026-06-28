import { describe, it, expect } from 'vitest';
import { encodeCursor, decodeCursor, parseLimit } from './cursor.js';

describe('encode/decodeCursor (spec-lock §7)', () => {
  it('인코딩→디코딩 라운드트립', () => {
    const obj = { id: 'abc', score: 1.5, createdAt: '2026-06-28T00:00:00.000Z' };
    const decoded = decodeCursor(encodeCursor(obj));
    expect(decoded).toEqual(obj);
  });

  it('base64url 형태(=,+,/ 없음)', () => {
    const cursor = encodeCursor({ k: 'a'.repeat(20) });
    expect(cursor).not.toMatch(/[+/=]/);
  });

  it('cursor undefined → null (첫 페이지)', () => {
    expect(decodeCursor(undefined)).toBeNull();
  });

  it('빈 문자열 → null', () => {
    expect(decodeCursor('')).toBeNull();
  });

  it('깨진 base64/JSON → null (throw 안 함)', () => {
    expect(decodeCursor('!!!not-valid!!!')).toBeNull();
  });
});

describe('parseLimit (기본 20, 최대 50)', () => {
  it('미지정/비숫자 → 20', () => {
    expect(parseLimit(undefined)).toBe(20);
    expect(parseLimit('abc')).toBe(20);
  });

  it('정상 범위 값은 그대로', () => {
    expect(parseLimit('10')).toBe(10);
    expect(parseLimit(30)).toBe(30);
  });

  it('50 초과 → 50 으로 클램프', () => {
    expect(parseLimit('100')).toBe(50);
  });

  it('1 미만 → 1 로 클램프', () => {
    expect(parseLimit('0')).toBe(1);
    expect(parseLimit('-5')).toBe(1);
  });

  it('소수 → 내림', () => {
    expect(parseLimit('20.9')).toBe(20);
  });
});
