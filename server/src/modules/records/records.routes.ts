import { Router } from 'express';
import { z } from 'zod';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { AppError } from '../../http/errors.js';
import { kstLocalDate } from '../../lib/kst.js';
import { recordCard, dailySummary } from '../../lib/serialize.js';

export const recordsRouter = Router();

// spec-lock §7 검증. openapi RecordCreateRequest.
const macrosSchema = z.object({
  proteinG: z.number().min(0),
  carbsG: z.number().min(0),
  fatG: z.number().min(0),
});

const itemSchema = z.object({
  name: z.string().min(1),
  amount: z.string().nullish(),
  calories: z.number().int().min(0),
  proteinG: z.number().min(0),
  carbsG: z.number().min(0),
  fatG: z.number().min(0),
});

const createSchema = z.object({
  analysisId: z.string().uuid().nullish(),
  mealType: z.enum(['breakfast', 'lunch', 'dinner', 'snack']),
  eatenAt: z.string().datetime({ offset: true }),
  title: z.string().min(1).max(50),
  totalCalories: z.number().int().min(0),
  macros: macrosSchema,
  memo: z.string().max(200).nullish(),
  items: z.array(itemSchema),
  publishToFeed: z.boolean(),
});

// POST /v1/food-records — 기록 저장("피드에 올리기"). 트랜잭션.
recordsRouter.post(
  '/',
  authGuard,
  asyncHandler(async (req, res) => {
    const userId = req.auth!.userId;
    const body = createSchema.parse(req.body);
    const eatenAt = new Date(body.eatenAt);
    const eatenLocalDate = kstLocalDate(eatenAt).date;

    // analysisId 가 있으면 소유권 확인 + imageUrl 승계.
    // ⚠️ 계약 디테일(파일럿 발견): record.imageUrl 은 요청 바디에 없고 연결된 분석에서 승계한다.
    let imageUrl: string | null = null;
    if (body.analysisId) {
      const analysis = await prisma.foodAnalysis.findUnique({ where: { id: body.analysisId } });
      if (!analysis || analysis.userId !== userId)
        throw new AppError('NOT_FOUND', 'analysis not found');
      imageUrl = analysis.imageUrl;
    }

    const created = await prisma.$transaction(async (tx) => {
      const record = await tx.foodRecord.create({
        data: {
          userId,
          analysisId: body.analysisId ?? null,
          mealType: body.mealType,
          title: body.title,
          imageUrl,
          eatenAt,
          eatenLocalDate,
          totalCalories: body.totalCalories,
          proteinG: body.macros.proteinG,
          carbsG: body.macros.carbsG,
          fatG: body.macros.fatG,
          memo: body.memo ?? null,
          publishedToFeed: body.publishToFeed,
          items: {
            create: body.items.map((it, i) => ({
              name: it.name,
              amount: it.amount ?? null,
              calories: it.calories,
              proteinG: it.proteinG,
              carbsG: it.carbsG,
              fatG: it.fatG,
              sortOrder: i,
            })),
          },
        },
        include: { items: true },
      });

      // publishToFeed 시 활동 신호 갱신(추천 정렬용) — spec-lock §8.
      if (body.publishToFeed) {
        await tx.user.update({
          where: { id: userId },
          data: { postCount: { increment: 1 }, lastPostedAt: new Date() },
        });
      }
      return record;
    });

    // dailySummary: 저장 후 그날 합계.
    const local = kstLocalDate(eatenAt);
    const [profile, dayRecords] = await Promise.all([
      prisma.profile.findUnique({ where: { userId } }),
      prisma.foodRecord.findMany({ where: { userId, eatenLocalDate: local.date } }),
    ]);
    const calorieTarget = profile?.dailyCalorieTarget ?? 0;

    res.status(201).json({
      recordId: created.id,
      record: recordCard(created),
      dailySummary: dailySummary(local.iso, calorieTarget, dayRecords),
    });
  }),
);
