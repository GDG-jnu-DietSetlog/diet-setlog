import { readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { PGlite } from '@electric-sql/pglite';
import { PrismaPGlite } from 'pglite-prisma-adapter';
import { PrismaClient } from '@prisma/client';
import express, { type Express, type Router } from 'express';
import { signSessionToken } from '../lib/jwt.js';
import { errorHandler } from '../middleware/errorHandler.js';

// 라우트 통합 테스트용 인메모리 Postgres 하니스 (H2 스타일, Docker 불필요).
// pglite = WASM 로 컴파일된 진짜 Postgres → enum/트랜잭션/관계 그대로 동작.
// 라우터들이 import 하는 prisma 싱글톤은 src/test/prismaMock.ts 프록시가
// globalThis.__TEST_PRISMA__ 로 위임한다(각 라우트 테스트 파일에서 vi.mock).

const here = path.dirname(fileURLToPath(import.meta.url));
const MIGRATION_SQL = readFileSync(
  path.join(here, '../../prisma/migrations/20260626105019_init/migration.sql'),
  'utf8',
);

export interface TestDb {
  prisma: PrismaClient;
  reset: () => Promise<void>;
  close: () => Promise<void>;
}

export async function createTestDb(): Promise<TestDb> {
  const pglite = new PGlite();
  await pglite.exec(MIGRATION_SQL);
  const prisma = new PrismaClient({ adapter: new PrismaPGlite(pglite) });
  (globalThis as Record<string, unknown>).__TEST_PRISMA__ = prisma;

  const reset = async () => {
    // 테스트 간 격리 — public 의 모든 테이블 비우기(FK 때문에 CASCADE).
    await pglite.exec(`DO $$ DECLARE r RECORD; BEGIN
      FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname='public') LOOP
        EXECUTE 'TRUNCATE TABLE "' || r.tablename || '" RESTART IDENTITY CASCADE';
      END LOOP; END $$;`);
  };
  const close = async () => {
    await prisma.$disconnect();
    await pglite.close();
  };
  return { prisma, reset, close };
}

// 라우터를 마운트한 최소 express 앱(프로덕션 index.ts 와 동일한 미들웨어 순서).
// mounts: [마운트경로, 라우터] 쌍. feed 처럼 한 모듈이 여러 라우터를 노출하면 여러 쌍.
export function makeApp(...mounts: Array<[string, Router]>): Express {
  const app = express();
  app.use(express.json());
  for (const [mount, router] of mounts) app.use(mount, router);
  app.use(errorHandler);
  return app;
}

// 실제 authGuard 를 통과하는 Bearer 토큰(서명 검증 경로까지 실제로 탄다).
export function authHeader(userId: string, ver = 0): string {
  return `Bearer ${signSessionToken({ sub: userId, ver })}`;
}
