import { Router } from 'express';
import { z } from 'zod';
import type { MealType } from '@prisma/client';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { recordCard, sumRecords } from '../../lib/serialize.js';
import { isStrictYmd } from '../../lib/kst.js';

export const calendarRouter = Router();

const querySchema = z.object({
  date: z.string().refine(isStrictYmd, 'expected valid YYYY-MM-DD'),
});

// GET /v1/calendar/daily-summary?date=YYYY-MM-DD — 끼니 4종 그룹.
calendarRouter.get(
  '/daily-summary',
  authGuard,
  asyncHandler(async (req, res) => {
    const userId = req.auth!.userId;
    const { date } = querySchema.parse(req.query);
    const localDate = new Date(`${date}T00:00:00Z`); // @db.Date 비교용 UTC 자정

    const [profile, records] = await Promise.all([
      prisma.profile.findUnique({ where: { userId } }),
      prisma.foodRecord.findMany({
        where: { userId, eatenLocalDate: localDate },
        orderBy: { eatenAt: 'asc' },
        include: { items: true },
      }),
    ]);

    const calorieTarget = profile?.dailyCalorieTarget ?? 0;
    const sum = sumRecords(records);

    // recordsByMeal: 4 키 항상 존재(없으면 []) — spec-lock §6.
    const recordsByMeal: Record<MealType, ReturnType<typeof recordCard>[]> = {
      breakfast: [],
      lunch: [],
      dinner: [],
      snack: [],
    };
    for (const r of records) recordsByMeal[r.mealType].push(recordCard(r));

    res.json({
      date,
      calorieTarget,
      totalCalories: sum.totalCalories,
      macros: { proteinG: sum.proteinG, carbsG: sum.carbsG, fatG: sum.fatG },
      progressPercent:
        calorieTarget > 0 ? Math.round((sum.totalCalories / calorieTarget) * 100) : 0,
      recordsByMeal,
    });
  }),
);
