import { Router } from 'express';
import { prisma } from '../../prisma.js';
import { authGuard } from '../../middleware/auth.js';
import { asyncHandler } from '../../http/asyncHandler.js';
import { AppError } from '../../http/errors.js';
import { kstToday } from '../../lib/kst.js';
import { recordCard, sumRecords } from '../../lib/serialize.js';

export const homeRouter = Router();

const RECENT_LIMIT = 10; // spec-lock §6: recentRecords N=10

// GET /v1/home — todaySummary / friendsCertifiedToday / currentUser / recentRecords.
// ⚠️ 계약 구멍: profile 미존재 시 home 동작? 부트스트랩이 profile 보장하지만 방어 필요.
//    파일럿 결정 = profile 없으면 404(NOT_FOUND). spec-lock 보강 필요.
homeRouter.get(
  '/',
  authGuard,
  asyncHandler(async (req, res) => {
    const userId = req.auth!.userId;
    const today = kstToday();

    const [user, profile, todayRecords, recentRecords, following] = await Promise.all([
      prisma.user.findUnique({ where: { id: userId } }),
      prisma.profile.findUnique({ where: { userId } }),
      prisma.foodRecord.findMany({ where: { userId, eatenLocalDate: today.date } }),
      prisma.foodRecord.findMany({
        where: { userId },
        orderBy: { eatenAt: 'desc' },
        take: RECENT_LIMIT,
        include: { items: true },
      }),
      prisma.friendRelation.findMany({
        where: { followerId: userId },
        select: { followingId: true },
      }),
    ]);

    if (!user) throw new AppError('UNAUTHORIZED', 'user not found');
    if (!profile) throw new AppError('NOT_FOUND', 'profile required before home');

    // todaySummary
    const sum = sumRecords(todayRecords);
    const totalCalories = sum.totalCalories;
    const sumMacros = { proteinG: sum.proteinG, carbsG: sum.carbsG, fatG: sum.fatG };
    const calorieTarget = profile.dailyCalorieTarget;

    // friendsCertifiedToday: 내가 follow한 사람 중 오늘 기록 1건+
    const followingIds = following.map((f) => f.followingId);
    const friendsCertifiedToday: Array<{
      id: string;
      displayName: string;
      avatarUrl: string | null;
      certifiedAt: string;
    }> = [];
    if (followingIds.length > 0) {
      const certs = await prisma.foodRecord.findMany({
        where: { userId: { in: followingIds }, eatenLocalDate: today.date },
        orderBy: { createdAt: 'asc' },
        include: { user: { select: { id: true, displayName: true, avatarUrl: true } } },
      });
      const seen = new Set<string>();
      for (const c of certs) {
        if (seen.has(c.userId)) continue;
        seen.add(c.userId);
        friendsCertifiedToday.push({
          id: c.user.id,
          displayName: c.user.displayName,
          avatarUrl: c.user.avatarUrl,
          certifiedAt: c.createdAt.toISOString(),
        });
      }
    }

    res.json({
      currentUser: { id: user.id, displayName: user.displayName, avatarUrl: user.avatarUrl },
      todaySummary: {
        date: today.iso,
        calorieTarget,
        totalCalories,
        macros: sumMacros,
        remainingCalories: calorieTarget - totalCalories,
        progressRatio: calorieTarget > 0 ? totalCalories / calorieTarget : 0,
      },
      friendsCertifiedToday,
      recentRecords: recentRecords.map(recordCard),
    });
  }),
);
