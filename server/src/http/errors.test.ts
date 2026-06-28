import { describe, it, expect } from 'vitest';
import { AppError, type ErrorCode } from './errors.js';

describe('AppError 상태코드 매핑 (api-db-design §1.2)', () => {
  const cases: Array<[ErrorCode, number]> = [
    ['VALIDATION_FAILED', 400],
    ['UNAUTHORIZED', 401],
    ['FORBIDDEN', 403],
    ['NOT_FOUND', 404],
    ['CONFLICT', 409],
    ['PAYLOAD_TOO_LARGE', 413],
    ['ANALYSIS_FAILED', 422],
    ['RATE_LIMITED', 429],
    ['INTERNAL', 500],
  ];

  it.each(cases)('%s → %d', (code, status) => {
    expect(new AppError(code, 'msg').status).toBe(status);
  });
});

describe('AppError.toBody', () => {
  it('fields 없으면 봉투에 fields 키 없음', () => {
    const body = new AppError('NOT_FOUND', '없음').toBody();
    expect(body).toEqual({ error: { code: 'NOT_FOUND', message: '없음' } });
    expect('fields' in body.error).toBe(false);
  });

  it('fields 있으면 봉투에 포함', () => {
    const body = new AppError('VALIDATION_FAILED', '검증 실패', { name: '필수' }).toBody();
    expect(body).toEqual({
      error: { code: 'VALIDATION_FAILED', message: '검증 실패', fields: { name: '필수' } },
    });
  });

  it('Error 상속 — message 접근 가능', () => {
    const e = new AppError('CONFLICT', '중복');
    expect(e).toBeInstanceOf(Error);
    expect(e.message).toBe('중복');
  });
});
