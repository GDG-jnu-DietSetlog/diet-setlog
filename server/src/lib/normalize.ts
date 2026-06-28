import { z } from 'zod';

// Gemini 원본 → 정규화 결과 + needsReview/failed 판정 (spec-lock §9).

const rawSchema = z.object({
  dishName: z.string(),
  totalCalories: z.number(),
  macros: z.object({ proteinG: z.number(), carbsG: z.number(), fatG: z.number() }),
  items: z.array(
    z.object({
      name: z.string(),
      amount: z.string().nullish(),
      calories: z.number(),
      proteinG: z.number(),
      carbsG: z.number(),
      fatG: z.number(),
    }),
  ),
  confidence: z.number(),
  notes: z.string().nullish(),
});

export interface AnalysisResult {
  dishName: string;
  totalCalories: number;
  macros: { proteinG: number; carbsG: number; fatG: number };
  items: Array<{
    name: string;
    amount: string | null;
    calories: number;
    proteinG: number;
    carbsG: number;
    fatG: number;
  }>;
  confidence: number;
  notes: string | null;
}

export type NormalizeOutcome =
  | { status: 'completed'; result: AnalysisResult; needsReview: boolean }
  | { status: 'failed'; errorCode: 'NO_FOOD_DETECTED' | 'MODEL_ERROR'; message: string };

export function normalizeAnalysis(raw: unknown): NormalizeOutcome {
  const parsed = rawSchema.safeParse(raw);
  if (!parsed.success) {
    return {
      status: 'failed',
      errorCode: 'MODEL_ERROR',
      message: 'model output failed schema validation',
    };
  }
  const r = parsed.data;

  // 음식 없음 → 실패(spec-lock §9).
  if (r.dishName === '' && r.items.length === 0) {
    return {
      status: 'failed',
      errorCode: 'NO_FOOD_DETECTED',
      message: 'no recognizable food in image',
    };
  }

  const result: AnalysisResult = {
    dishName: r.dishName,
    totalCalories: Math.round(r.totalCalories),
    macros: r.macros,
    items: r.items.map((it) => ({
      name: it.name,
      amount: it.amount ?? null,
      calories: Math.round(it.calories),
      proteinG: it.proteinG,
      carbsG: it.carbsG,
      fatG: it.fatG,
    })),
    confidence: r.confidence,
    notes: r.notes ?? null,
  };

  // needsReview: confidence<0.6 || items 비어있음 || (totalCalories==0 && dishName!="")
  const needsReview =
    r.confidence < 0.6 || r.items.length === 0 || (result.totalCalories === 0 && r.dishName !== '');
  return { status: 'completed', result, needsReview };
}
