import { PrismaClient } from '@prisma/client';

// 단일 인스턴스(커넥션 풀링) — 요청마다 새 커넥션 금지(CLAUDE.md 스파이크 대응).
export const prisma = new PrismaClient();
