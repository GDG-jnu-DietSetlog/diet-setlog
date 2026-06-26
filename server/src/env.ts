import { z } from 'zod';

// 입력(환경변수)도 검증한다 — 누락 시 부팅 실패가 런타임 폭발보다 낫다.
const schema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(8),
  PORT: z.coerce.number().default(3000),
  APP_TZ: z.string().default('Asia/Seoul'),

  // ── 인프라(analyses wave) ──
  REDIS_URL: z.string().default('redis://localhost:6379'),

  // Google Cloud Storage. 로컬은 fake-gcs-server 에뮬레이터.
  GCS_BUCKET: z.string().default('dietsetlog'),
  GCS_PROJECT_ID: z.string().default('dietsetlog-local'),
  // 에뮬레이터 API 엔드포인트(설정 시 에뮬레이터 모드). 실제 GCS면 비워둔다.
  GCS_API_ENDPOINT: z.string().optional(),
  GCS_PUBLIC_URL: z.string().default('http://localhost:4443'), // imageUrl 구성용

  // Gemini 키 없으면 목(mock)으로 동작(spec-lock §9 구조는 동일).
  GEMINI_API_KEY: z.string().optional(),
});

export const env = schema.parse(process.env);
