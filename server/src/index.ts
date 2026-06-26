import express from 'express';
import { env } from './env.js';
import { sessionRouter } from './modules/session/session.routes.js';
import { profileRouter } from './modules/profile/profile.routes.js';
import { homeRouter } from './modules/home/home.routes.js';
import { recordsRouter } from './modules/records/records.routes.js';
import { calendarRouter } from './modules/calendar/calendar.routes.js';
import { errorHandler } from './middleware/errorHandler.js';

const app = express();
app.use(express.json());

// 헬스체크
app.get('/health', (_req, res) => res.json({ ok: true }));

// v1 라우트. 미들웨어 순서: (rateLimit →) authGuard → handler. rateLimit/Redis 는 후속 wave.
app.use('/v1/sessions', sessionRouter);
app.use('/v1/me', profileRouter);
app.use('/v1/home', homeRouter);
app.use('/v1/food-records', recordsRouter);
app.use('/v1/calendar', calendarRouter);

// 중앙 에러 핸들러는 마지막.
app.use(errorHandler);

app.listen(env.PORT, () => {
  console.log(`diet-setlog server listening on :${env.PORT} (TZ=${env.APP_TZ})`);
});
