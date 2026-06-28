import type { Router } from 'express';
import { sessionRouter } from './modules/session/session.routes.js';
import { profileRouter } from './modules/profile/profile.routes.js';
import { homeRouter } from './modules/home/home.routes.js';
import { recordsRouter } from './modules/records/records.routes.js';
import { calendarRouter } from './modules/calendar/calendar.routes.js';
import { friendsRouter } from './modules/friends/friends.routes.js';
import { feedRouter, postsRouter } from './modules/feed/feed.routes.js';
import { analysesRouter } from './modules/analyses/analyses.routes.js';

// 마운트 경로 ↔ 라우터 단일 진실원.
// index.ts(실제 마운트)와 계약 가드 테스트(routes.contract.test.ts)가 공유한다.
// 새 라우터를 추가하면 여기에만 등록 → index.ts 가 순회 마운트하고, 가드가 openapi.yaml 동기화를 강제한다.
export const routeGroups: ReadonlyArray<readonly [string, Router]> = [
  ['/v1/sessions', sessionRouter],
  ['/v1/me', profileRouter],
  ['/v1/home', homeRouter],
  ['/v1/food-records', recordsRouter],
  ['/v1/calendar', calendarRouter],
  ['/v1/friends', friendsRouter],
  ['/v1/feed', feedRouter],
  ['/v1/posts', postsRouter],
  ['/v1/food-analyses', analysesRouter],
];
