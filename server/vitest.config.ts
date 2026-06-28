import { defineConfig } from 'vitest/config';

// 커버리지 게이트(전체 하락 차단). v8 프로바이더.
// thresholds 미만이면 vitest 가 비0 종료 → CI 의 server 잡 실패.
// floor 는 도입 시점 실측치(라인 ~7.97%) 바로 아래로 잡았다.
// 테스트가 늘면 이 값을 함께 올려(ratchet) 회귀를 좁힌다.
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov'],
      include: ['src/**/*.ts'],
      exclude: ['src/**/*.test.ts', 'src/**/*.d.ts'],
      thresholds: {
        lines: 7,
        statements: 7,
      },
    },
  },
});
