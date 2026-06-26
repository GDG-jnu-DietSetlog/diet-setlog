import { describe, it, expect } from 'vitest';
import { kstLocalDate, isStrictYmd } from './kst.js';

describe('isStrictYmd', () => {
  it('유효 날짜 통과', () => {
    expect(isStrictYmd('2026-06-26')).toBe(true);
  });
  it('월 13 / 일 99 거부', () => {
    expect(isStrictYmd('2026-13-99')).toBe(false);
  });
  it('롤오버(2026-02-30) 거부', () => {
    expect(isStrictYmd('2026-02-30')).toBe(false);
  });
  it('형식 불일치 거부', () => {
    expect(isStrictYmd('2026-6-9')).toBe(false);
    expect(isStrictYmd('not-a-date')).toBe(false);
  });
});

describe('kstLocalDate (Asia/Seoul, spec-lock §5.1)', () => {
  it('UTC 14:00 → 같은 날 KST 23:00', () => {
    expect(kstLocalDate(new Date('2026-06-26T14:00:00Z')).iso).toBe('2026-06-26');
  });

  it('UTC 15:30 → 다음 날 KST 00:30 (날짜 경계 넘김)', () => {
    expect(kstLocalDate(new Date('2026-06-26T15:30:00Z')).iso).toBe('2026-06-27');
  });

  it('UTC 자정 → KST 오전 9시, 같은 날', () => {
    expect(kstLocalDate(new Date('2026-06-26T00:00:00Z')).iso).toBe('2026-06-26');
  });

  it('date 는 UTC 자정', () => {
    const d = kstLocalDate(new Date('2026-06-26T15:30:00Z')).date;
    expect(d.toISOString()).toBe('2026-06-27T00:00:00.000Z');
  });
});
