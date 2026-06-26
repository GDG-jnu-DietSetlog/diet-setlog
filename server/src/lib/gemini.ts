import { GoogleGenerativeAI, type ResponseSchema, SchemaType } from '@google/generative-ai';
import { env } from '../env.js';

// 음식 이미지 분석 — spec-lock §9. 키 없으면 목(mock)으로 동작(구조 동일).
// 반환값은 모델 원본 JSON(정규화/검증은 normalize.ts).

const MODEL = 'gemini-2.5-flash';

// spec-lock §9 프롬프트 원문(재현성 핵심).
const PROMPT = `You are a Korean nutrition analysis assistant. Analyze the food in the image and
return ONLY a JSON object. Estimate per-100g-realistic values for a single served
portion shown. Use Korean dish/ingredient names (한글). All macro/calorie numbers
are grams/kcal as integers except confidence. If the image has no recognizable
food, return dishName:"", totalCalories:0, empty items, confidence:0.
Do not include any text outside the JSON.`;

const RESPONSE_SCHEMA: ResponseSchema = {
  type: SchemaType.OBJECT,
  properties: {
    dishName: { type: SchemaType.STRING },
    totalCalories: { type: SchemaType.INTEGER },
    macros: {
      type: SchemaType.OBJECT,
      properties: {
        proteinG: { type: SchemaType.NUMBER },
        carbsG: { type: SchemaType.NUMBER },
        fatG: { type: SchemaType.NUMBER },
      },
      required: ['proteinG', 'carbsG', 'fatG'],
    },
    items: {
      type: SchemaType.ARRAY,
      items: {
        type: SchemaType.OBJECT,
        properties: {
          name: { type: SchemaType.STRING },
          amount: { type: SchemaType.STRING },
          calories: { type: SchemaType.INTEGER },
          proteinG: { type: SchemaType.NUMBER },
          carbsG: { type: SchemaType.NUMBER },
          fatG: { type: SchemaType.NUMBER },
        },
        required: ['name', 'calories', 'proteinG', 'carbsG', 'fatG'],
      },
    },
    confidence: { type: SchemaType.NUMBER },
    notes: { type: SchemaType.STRING },
  },
  required: ['dishName', 'totalCalories', 'macros', 'items', 'confidence'],
};

export const usingMockGemini = !env.GEMINI_API_KEY;

// 목 결과(키 없을 때). 결정론적 — 골격/E2E 검증용.
function mockResult(): unknown {
  return {
    dishName: '닭가슴살 샐러드볼',
    totalCalories: 420,
    macros: { proteinG: 38, carbsG: 32, fatG: 14 },
    items: [
      { name: '닭가슴살', amount: '120g', calories: 180, proteinG: 35, carbsG: 0, fatG: 4 },
      { name: '샐러드', amount: '1접시', calories: 240, proteinG: 3, carbsG: 32, fatG: 10 },
    ],
    confidence: 0.82,
    notes: 'mock(GEMINI_API_KEY 미설정)',
  };
}

export async function analyzeFoodImage(imageBuffer: Buffer, mime: string): Promise<unknown> {
  if (!env.GEMINI_API_KEY) return mockResult();

  const genAI = new GoogleGenerativeAI(env.GEMINI_API_KEY);
  const model = genAI.getGenerativeModel({
    model: MODEL,
    generationConfig: { responseMimeType: 'application/json', responseSchema: RESPONSE_SCHEMA },
  });
  const result = await model.generateContent([
    PROMPT,
    { inlineData: { data: imageBuffer.toString('base64'), mimeType: mime } },
  ]);
  return JSON.parse(result.response.text());
}
