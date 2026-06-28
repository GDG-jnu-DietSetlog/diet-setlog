import { defineConfig } from 'vitest/config';

// 커버리지 게이트(전체 하락 차단). v8 프로바이더.
// thresholds 미만이면 vitest 가 비0 종료 → CI 의 server 잡 실패.
// floor 는 도입 시점 실측치(라인 ~7.97%) 바로 아래로 잡았다.
// 테스트가 늘면 이 값을 함께 올려(ratchet) 회귀를 좁힌다.
export default defineConfig({
  test: {
    // env.ts 는 import 시점에 process.env 를 파싱한다(누락 시 부팅 실패).
    // jwt/auth 등 env 를 끌어쓰는 모듈을 테스트에서 import 하려면 최소 env 가 필요.
    env: {
      DATABASE_URL: 'postgresql://test:test@localhost:5432/test?schema=public',
      JWT_SECRET: 'test-secret-key-1234',
    },
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov'],
      include: ['src/**/*.ts'],
      // 테스트 인프라(src/test) 와 타입선언은 분모에서 제외(프로덕션 코드 기준 측정).
      exclude: ['src/**/*.test.ts', 'src/**/*.d.ts', 'src/test/**'],
      thresholds: {
        lines: 78,
        statements: 78,
      },
    },
  },
});
