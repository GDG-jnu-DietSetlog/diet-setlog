import { describe, it, expect } from 'vitest';
import { normalizeAnalysis } from './normalize.js';

const ok = {
  dishName: '닭가슴살 샐러드',
  totalCalories: 420,
  macros: { proteinG: 38, carbsG: 32, fatG: 14 },
  items: [{ name: '닭가슴살', calories: 180, proteinG: 35, carbsG: 0, fatG: 4 }],
  confidence: 0.82,
};

describe('normalizeAnalysis (spec-lock §9)', () => {
  it('정상 → completed, needsReview false', () => {
    const r = normalizeAnalysis(ok);
    expect(r.status).toBe('completed');
    if (r.status === 'completed') expect(r.needsReview).toBe(false);
  });

  it('confidence<0.6 → needsReview true', () => {
    const r = normalizeAnalysis({ ...ok, confidence: 0.4 });
    expect(r.status === 'completed' && r.needsReview).toBe(true);
  });

  it('items 비어있음 → needsReview true', () => {
    const r = normalizeAnalysis({ ...ok, items: [] });
    expect(r.status === 'completed' && r.needsReview).toBe(true);
  });

  it('dishName="" && items=[] → failed NO_FOOD_DETECTED', () => {
    const r = normalizeAnalysis({
      ...ok,
      dishName: '',
      items: [],
      totalCalories: 0,
      confidence: 0,
    });
    expect(r.status).toBe('failed');
    if (r.status === 'failed') expect(r.errorCode).toBe('NO_FOOD_DETECTED');
  });

  it('스키마 불일치 → failed MODEL_ERROR', () => {
    const r = normalizeAnalysis({ dishName: '밥' });
    expect(r.status).toBe('failed');
    if (r.status === 'failed') expect(r.errorCode).toBe('MODEL_ERROR');
  });
});
