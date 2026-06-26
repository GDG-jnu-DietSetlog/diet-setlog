import type { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { AppError } from '../http/errors.js';

// 중앙 에러 핸들러 — 모든 에러를 공통 봉투로. 민감정보는 로그/응답에 남기지 않는다.
export function errorHandler(err: unknown, _req: Request, res: Response, _next: NextFunction): void {
  if (err instanceof AppError) {
    res.status(err.status).json(err.toBody());
    return;
  }
  if (err instanceof ZodError) {
    const fields: Record<string, string> = {};
    for (const issue of err.issues) fields[issue.path.join('.') || '_'] = issue.message;
    res.status(400).json({ error: { code: 'VALIDATION_FAILED', message: 'validation failed', fields } });
    return;
  }
  // 알 수 없는 에러: 내부 메시지 노출 금지.
  console.error('[INTERNAL]', err);
  res.status(500).json({ error: { code: 'INTERNAL', message: 'internal server error' } });
}
