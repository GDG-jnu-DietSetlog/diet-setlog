import express from 'express';
import { env } from './env.js';
import { routeGroups } from './routes.js';
import { startAnalysisWorker } from './modules/analyses/analysis.queue.js';
import { ensureBucket } from './lib/storage.js';
import { usingMockGemini } from './lib/gemini.js';
import { errorHandler } from './middleware/errorHandler.js';

const app = express();
app.use(express.json());

// CORS — Flutter web 클라이언트가 다른 오리진에서 API 를 호출할 수 있게 허용.
// 요청 Origin 을 반영(쿠키 미사용). 운영 시 허용 오리진 화이트리스트로 좁힐 수 있음.
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', req.headers.origin ?? '*');
  res.header('Access-Control-Allow-Headers', 'Authorization, Content-Type');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') {
    res.sendStatus(204);
    return;
  }
  next();
});

// 헬스체크
app.get('/health', (_req, res) => res.json({ ok: true }));

// v1 라우트. 미들웨어 순서: (rateLimit →) authGuard → handler. rateLimit/Redis 는 후속 wave.
// 마운트 목록은 routes.ts(단일 진실원) — 계약 가드 테스트가 openapi.yaml 동기화를 강제한다.
for (const [mount, router] of routeGroups) app.use(mount, router);

// 중앙 에러 핸들러는 마지막.
app.use(errorHandler);

async function bootstrap() {
  await ensureBucket(); // GCS 버킷 보장
  startAnalysisWorker(); // 분석 큐 워커 기동
  app.listen(env.PORT, () => {
    console.log(
      `diet-setlog server listening on :${env.PORT} (TZ=${env.APP_TZ}, gemini=${usingMockGemini ? 'mock' : 'live'})`,
    );
  });
}

bootstrap().catch((e) => {
  console.error('bootstrap failed', e);
  process.exit(1);
});
