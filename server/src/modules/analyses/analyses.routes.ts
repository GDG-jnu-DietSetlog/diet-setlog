import { Router } from 'express';
import multer from 'multer';
import { z } from 'zod';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { AppError } from '../../http/errors.js';
import { uploadImage } from '../../lib/storage.js';
import { enqueueAnalysis } from './analysis.queue.js';

export const analysesRouter = Router();

const MAX_BYTES = 10 * 1024 * 1024; // 10MB (spec-lock §7)
const MIN_BYTES = 1024; // 1KB
const ALLOWED = new Set(['image/jpeg', 'image/png', 'image/webp']);

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: MAX_BYTES } });
const sourceSchema = z.enum(['camera', 'gallery']).optional();

// POST /v1/food-analyses — 업로드 + 분석 시작(비동기 큐). 항상 202.
analysesRouter.post(
  '/',
  authGuard,
  upload.single('image'),
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const file = req.file;
    if (!file) throw new AppError('VALIDATION_FAILED', 'image file required', { image: 'required' });
    if (!ALLOWED.has(file.mimetype)) {
      throw new AppError('VALIDATION_FAILED', 'unsupported image type', { image: 'jpeg|png|webp only' });
    }
    if (file.size < MIN_BYTES) throw new AppError('VALIDATION_FAILED', 'image too small', { image: 'min 1KB' });
    const source = sourceSchema.parse(req.body.source);

    const { key, url } = await uploadImage(file.buffer, file.mimetype);
    const analysis = await prisma.foodAnalysis.create({
      data: { userId: me, imageKey: key, imageUrl: url, source: source ?? null, status: 'processing' },
    });
    await enqueueAnalysis(analysis.id);

    res.status(202).json({ analysisId: analysis.id, status: 'processing', imageUrl: url });
  }),
);

// GET /v1/food-analyses/{id} — 폴링.
analysesRouter.get(
  '/:analysisId',
  authGuard,
  asyncHandler(async (req, res) => {
    const me = req.auth!.userId;
    const analysis = await prisma.foodAnalysis.findUnique({ where: { id: req.params.analysisId! } });
    if (!analysis || analysis.userId !== me) throw new AppError('NOT_FOUND', 'analysis not found');

    if (analysis.status === 'completed') {
      res.json({
        analysisId: analysis.id,
        status: 'completed',
        imageUrl: analysis.imageUrl,
        result: analysis.result,
        needsReview: analysis.needsReview,
      });
      return;
    }
    if (analysis.status === 'failed') {
      res.json({
        analysisId: analysis.id,
        status: 'failed',
        imageUrl: analysis.imageUrl,
        errorCode: analysis.errorCode,
        message: analysis.errorMsg,
      });
      return;
    }
    res.json({ analysisId: analysis.id, status: 'processing', imageUrl: analysis.imageUrl });
  }),
);
