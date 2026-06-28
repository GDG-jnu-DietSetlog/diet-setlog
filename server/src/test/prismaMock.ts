import type { PrismaClient } from '@prisma/client';

// 라우터들의 `import { prisma } from '../../prisma.js'` 를 대체하는 프록시.
// 실제 클라이언트는 createTestDb() 가 globalThis.__TEST_PRISMA__ 에 심는다.
// 메서드는 호출 시점에 위임하므로(this 바인딩 포함), 테스트별 클라이언트 교체가 그대로 반영된다.
export const prisma = new Proxy({} as PrismaClient, {
  get(_target, prop) {
    const client = (globalThis as Record<string, unknown>).__TEST_PRISMA__ as PrismaClient;
    if (!client)
      throw new Error('test prisma not initialized — createTestDb() 를 beforeAll 에서 호출하세요');
    const value = Reflect.get(client, prop);
    return typeof value === 'function' ? value.bind(client) : value;
  },
});
