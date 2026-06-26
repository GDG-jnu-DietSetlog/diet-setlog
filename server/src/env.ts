import { z } from 'zod';

// 입력(환경변수)도 검증한다 — 누락 시 부팅 실패가 런타임 폭발보다 낫다.
const schema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(8),
  PORT: z.coerce.number().default(3000),
  APP_TZ: z.string().default('Asia/Seoul'),
});

export const env = schema.parse(process.env);
