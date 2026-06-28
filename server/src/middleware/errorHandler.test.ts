import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import type { Request, Response } from 'express';
import { z, ZodError } from 'zod';
import { MulterError } from 'multer';
import { errorHandler } from './errorHandler.js';
import { AppError } from '../http/errors.js';

interface ErrorBody {
  error: { code: string; message: string; fields?: Record<string, string> };
}

// status().json() 체인을 기록하는 Response 목.
function mockRes() {
  const captured = { statusCode: 0, body: undefined as ErrorBody | undefined };
  const res = {
    status(code: number) {
      captured.statusCode = code;
      return res;
    },
    json(payload: unknown) {
      captured.body = payload as ErrorBody;
      return res;
    },
  } as unknown as Response;
  return { res, captured };
}

const req = {} as Request;
const next = vi.fn();

describe('errorHandler (공통 에러 봉투)', () => {
  it('AppError → 해당 status + toBody', () => {
    const { res, captured } = mockRes();
    errorHandler(new AppError('NOT_FOUND', '없음'), req, res, next);
    expect(captured.statusCode).toBe(404);
    expect(captured.body).toEqual({ error: { code: 'NOT_FOUND', message: '없음' } });
  });

  it('MulterError LIMIT_FILE_SIZE → 413 PAYLOAD_TOO_LARGE', () => {
    const { res, captured } = mockRes();
    errorHandler(new MulterError('LIMIT_FILE_SIZE'), req, res, next);
    expect(captured.statusCode).toBe(413);
    expect(captured.body!.error.code).toBe('PAYLOAD_TOO_LARGE');
  });

  it('MulterError 그 외 → 400 VALIDATION_FAILED', () => {
    const { res, captured } = mockRes();
    errorHandler(new MulterError('LIMIT_UNEXPECTED_FILE'), req, res, next);
    expect(captured.statusCode).toBe(400);
    expect(captured.body!.error.code).toBe('VALIDATION_FAILED');
  });

  it('ZodError → 400 + fields 매핑', () => {
    const { res, captured } = mockRes();
    let zerr!: ZodError;
    try {
      z.object({ name: z.string() }).parse({ name: 123 });
    } catch (e) {
      zerr = e as ZodError;
    }
    errorHandler(zerr, req, res, next);
    expect(captured.statusCode).toBe(400);
    expect(captured.body!.error.code).toBe('VALIDATION_FAILED');
    expect(captured.body!.error.fields).toHaveProperty('name');
  });

  describe('알 수 없는 에러', () => {
    beforeEach(() => vi.spyOn(console, 'error').mockImplementation(() => {}));
    afterEach(() => vi.restoreAllMocks());

    it('→ 500 INTERNAL, 내부 메시지 노출 안 함', () => {
      const { res, captured } = mockRes();
      errorHandler(new Error('민감한 스택 세부정보'), req, res, next);
      expect(captured.statusCode).toBe(500);
      expect(captured.body).toEqual({
        error: { code: 'INTERNAL', message: 'internal server error' },
      });
      expect(JSON.stringify(captured.body)).not.toContain('민감한');
    });
  });
});
