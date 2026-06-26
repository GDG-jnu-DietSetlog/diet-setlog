import type { FoodRecord, FoodItem } from '@prisma/client';

// 응답 직렬화 공통 — home/records/calendar/feed 가 동일 형태를 쓰도록 단일화(일관성).
// 형태 기준: openapi.yaml / spec-lock §6.

export function macros(r: { proteinG: number; carbsG: number; fatG: number }) {
  return { proteinG: r.proteinG, carbsG: r.carbsG, fatG: r.fatG };
}

export function foodItemCard(it: FoodItem) {
  return {
    id: it.id,
    name: it.name,
    amount: it.amount,
    calories: it.calories,
    proteinG: it.proteinG,
    carbsG: it.carbsG,
    fatG: it.fatG,
    sortOrder: it.sortOrder,
  };
}

// FoodRecordCard (홈/캘린더 공용).
export function recordCard(r: FoodRecord & { items: FoodItem[] }) {
  return {
    id: r.id,
    title: r.title,
    imageUrl: r.imageUrl,
    mealType: r.mealType,
    eatenAt: r.eatenAt.toISOString(),
    totalCalories: r.totalCalories,
    macros: macros(r),
    memo: r.memo,
    publishedToFeed: r.publishedToFeed,
    likeCount: r.likeCount,
    commentCount: r.commentCount,
    items: [...r.items].sort((a, b) => a.sortOrder - b.sortOrder).map(foodItemCard),
  };
}

// 일별 합계(칼로리/매크로).
export function sumRecords(records: Array<Pick<FoodRecord, 'totalCalories' | 'proteinG' | 'carbsG' | 'fatG'>>) {
  return records.reduce(
    (acc, r) => ({
      totalCalories: acc.totalCalories + r.totalCalories,
      proteinG: acc.proteinG + r.proteinG,
      carbsG: acc.carbsG + r.carbsG,
      fatG: acc.fatG + r.fatG,
    }),
    { totalCalories: 0, proteinG: 0, carbsG: 0, fatG: 0 },
  );
}

// DailySummary (POST /v1/food-records 응답 등) — spec-lock §6.
export function dailySummary(
  dateIso: string,
  calorieTarget: number,
  records: Array<Pick<FoodRecord, 'totalCalories' | 'proteinG' | 'carbsG' | 'fatG'>>,
) {
  const s = sumRecords(records);
  return {
    date: dateIso,
    calorieTarget,
    totalCalories: s.totalCalories,
    macros: { proteinG: s.proteinG, carbsG: s.carbsG, fatG: s.fatG },
    remainingCalories: calorieTarget - s.totalCalories,
  };
}
