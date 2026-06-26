import type { Request, Response, NextFunction, RequestHandler } from 'express';

// async 핸들러의 reject를 errorHandler로 전달.
export const asyncHandler =
  (fn: (req: Request, res: Response, next: NextFunction) => Promise<unknown>): RequestHandler =>
  (req, res, next) => {
    fn(req, res, next).catch(next);
  };
