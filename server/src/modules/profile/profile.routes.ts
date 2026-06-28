import { Router } from 'express';
import { z } from 'zod';
import type { Profile } from '@prisma/client';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { calcProfile } from '../../lib/calorie.js';
import { kstToday, isStrictYmd } from '../../lib/kst.js';

export const profileRouter = Router();

const CURRENT_YEAR = new Date().getUTCFullYear();
const MS_PER_DAY = 24 * 60 * 60 * 1000;

// spec-lock §7 검증 범위.
const upsertSchema = z.object({
  displayName: z.string().min(1).max(50),
  gender: z.enum(['male', 'female', 'other']),
  birthYear: z
    .number()
    .int()
    .min(1920)
    .max(CURRENT_YEAR - 14),
  heightCm: z.number().min(80).max(250),
  currentWeightKg: z.number().min(20).max(400),
  targetWeightKg: z.number().min(20).max(400),
  targetDate: z
    .string()
    .refine(isStrictYmd, 'expected valid YYYY-MM-DD')
    .refine((s) => {
      const t = new Date(`${s}T00:00:00Z`).getTime();
      const now = Date.now();
      return t > now && t <= now + 730 * MS_PER_DAY; // 미래 & ≤2년
    }, 'targetDate must be in the future and within 2 years'),
});

function ymd(d: Date): string {
  return d.toISOString().slice(0, 10);
}

function serializeProfile(p: Profile) {
  return {
    displayName: '', // overwritten by caller (User.displayName)
    gender: p.gender,
    birthYear: p.birthYear,
    heightCm: p.heightCm,
    currentWeightKg: p.currentWeightKg,
    targetWeightKg: p.targetWeightKg,
    targetDate: ymd(p.targetDate),
  };
}

// GET /v1/me/profile — 없으면 200 + profile:null (spec-lock §5.1).
profileRouter.get(
  '/profile',
  authGuard,
  asyncHandler(async (req, res) => {
    const userId = req.auth!.userId;
    const [user, profile] = await Promise.all([
      prisma.user.findUnique({ where: { id: userId } }),
      prisma.profile.findUnique({ where: { userId } }),
    ]);
    if (!profile) {
      res.json({ profile: null, dailyCalorieTarget: 0, weeklyWeightDelta: 0 });
      return;
    }
    res.json({
      profile: { ...serializeProfile(profile), displayName: user?.displayName ?? '' },
      dailyCalorieTarget: profile.dailyCalorieTarget,
      weeklyWeightDelta: profile.weeklyWeightDelta,
    });
  }),
);

// PUT /v1/me/profile — STEP3 "시작하기". displayName 포함, 서버가 권장칼로리 계산.
profileRouter.put(
  '/profile',
  authGuard,
  asyncHandler(async (req, res) => {
    const userId = req.auth!.userId;
    const body = upsertSchema.parse(req.body);
    const today = kstToday().date;
    const calc = calcProfile({
      gender: body.gender,
      birthYear: body.birthYear,
      heightCm: body.heightCm,
      currentWeightKg: body.currentWeightKg,
      targetWeightKg: body.targetWeightKg,
      targetDate: new Date(`${body.targetDate}T00:00:00Z`),
      today,
    });

    const profile = await prisma.$transaction(async (tx) => {
      await tx.user.update({
        where: { id: userId },
        data: {
          displayName: body.displayName,
          goalDirection: calc.goalDirection,
          ageBucket: calc.ageBucket,
        },
      });
      return tx.profile.upsert({
        where: { userId },
        create: {
          userId,
          gender: body.gender,
          birthYear: body.birthYear,
          heightCm: body.heightCm,
          currentWeightKg: body.currentWeightKg,
          targetWeightKg: body.targetWeightKg,
          targetDate: new Date(`${body.targetDate}T00:00:00Z`),
          dailyCalorieTarget: calc.dailyCalorieTarget,
          weeklyWeightDelta: calc.weeklyWeightDelta,
        },
        update: {
          gender: body.gender,
          birthYear: body.birthYear,
          heightCm: body.heightCm,
          currentWeightKg: body.currentWeightKg,
          targetWeightKg: body.targetWeightKg,
          targetDate: new Date(`${body.targetDate}T00:00:00Z`),
          dailyCalorieTarget: calc.dailyCalorieTarget,
          weeklyWeightDelta: calc.weeklyWeightDelta,
        },
      });
    });

    res.json({
      profile: { ...serializeProfile(profile), displayName: body.displayName },
      dailyCalorieTarget: profile.dailyCalorieTarget,
      weeklyWeightDelta: profile.weeklyWeightDelta,
    });
  }),
);
