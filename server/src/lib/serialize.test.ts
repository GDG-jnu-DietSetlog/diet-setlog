import { describe, it, expect } from 'vitest';
import { macros, foodItemCard, recordCard, sumRecords, dailySummary } from './serialize.js';
import type { FoodRecord, FoodItem } from '@prisma/client';

// Prisma 타입을 런타임에선 평범한 객체로 취급(직렬화 함수는 형태만 본다).
function item(over: Partial<FoodItem> = {}): FoodItem {
  return {
    id: 'item-1',
    recordId: 'rec-1',
    name: '닭가슴살',
    amount: '100g',
    calories: 180,
    proteinG: 35,
    carbsG: 0,
    fatG: 4,
    sortOrder: 0,
    ...over,
  } as FoodItem;
}

function record(
  over: Partial<FoodRecord & { items: FoodItem[] }> = {},
): FoodRecord & { items: FoodItem[] } {
  return {
    id: 'rec-1',
    userId: 'user-1',
    analysisId: null,
    mealType: 'lunch',
    title: '점심',
    imageUrl: null,
    eatenAt: new Date('2026-06-28T03:00:00.000Z'),
    eatenLocalDate: '2026-06-28',
    totalCalories: 500,
    proteinG: 40,
    carbsG: 30,
    fatG: 15,
    memo: null,
    publishedToFeed: false,
    likeCount: 0,
    commentCount: 0,
    createdAt: new Date(),
    updatedAt: new Date(),
    items: [],
    ...over,
  } as FoodRecord & { items: FoodItem[] };
}

describe('macros', () => {
  it('매크로 3필드만 추출', () => {
    expect(macros({ proteinG: 1, carbsG: 2, fatG: 3 })).toEqual({
      proteinG: 1,
      carbsG: 2,
      fatG: 3,
    });
  });
});

describe('foodItemCard', () => {
  it('카드 필드 매핑', () => {
    const card = foodItemCard(item({ id: 'x', name: '밥', amount: null }));
    expect(card).toEqual({
      id: 'x',
      name: '밥',
      amount: null,
      calories: 180,
      proteinG: 35,
      carbsG: 0,
      fatG: 4,
      sortOrder: 0,
    });
  });
});

describe('recordCard', () => {
  it('eatenAt 은 ISO 문자열, macros 중첩', () => {
    const card = recordCard(record());
    expect(card.eatenAt).toBe('2026-06-28T03:00:00.000Z');
    expect(card.macros).toEqual({ proteinG: 40, carbsG: 30, fatG: 15 });
  });

  it('items 는 sortOrder 오름차순 정렬', () => {
    const card = recordCard(
      record({
        items: [
          item({ id: 'b', sortOrder: 2 }),
          item({ id: 'a', sortOrder: 0 }),
          item({ id: 'c', sortOrder: 1 }),
        ],
      }),
    );
    expect(card.items.map((i) => i.id)).toEqual(['a', 'c', 'b']);
  });

  it('원본 items 배열을 변형하지 않음(비파괴 정렬)', () => {
    const items = [item({ id: 'b', sortOrder: 1 }), item({ id: 'a', sortOrder: 0 })];
    recordCard(record({ items }));
    expect(items.map((i) => i.id)).toEqual(['b', 'a']);
  });
});

describe('sumRecords', () => {
  it('빈 배열 → 0 합계', () => {
    expect(sumRecords([])).toEqual({ totalCalories: 0, proteinG: 0, carbsG: 0, fatG: 0 });
  });

  it('여러 기록 합산', () => {
    expect(
      sumRecords([
        { totalCalories: 300, proteinG: 10, carbsG: 20, fatG: 5 },
        { totalCalories: 200, proteinG: 15, carbsG: 10, fatG: 8 },
      ]),
    ).toEqual({ totalCalories: 500, proteinG: 25, carbsG: 30, fatG: 13 });
  });
});

describe('dailySummary', () => {
  it('remainingCalories = 목표 - 섭취', () => {
    const s = dailySummary('2026-06-28', 1800, [
      { totalCalories: 500, proteinG: 40, carbsG: 30, fatG: 15 },
    ]);
    expect(s.totalCalories).toBe(500);
    expect(s.remainingCalories).toBe(1300);
    expect(s.macros).toEqual({ proteinG: 40, carbsG: 30, fatG: 15 });
    expect(s.date).toBe('2026-06-28');
    expect(s.calorieTarget).toBe(1800);
  });

  it('목표 초과 시 remaining 음수 허용', () => {
    const s = dailySummary('2026-06-28', 1000, [
      { totalCalories: 1200, proteinG: 0, carbsG: 0, fatG: 0 },
    ]);
    expect(s.remainingCalories).toBe(-200);
  });
});
