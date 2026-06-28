// ESLint flat config (ESLint v9). 서버는 TypeScript + ESM.
// CLAUDE.md 백엔드 규약: any 지양, async/await, ES 모듈.
// 점진 도입 — 타입-aware(느린) 규칙은 쓰지 않고 recommended 수준만.
// 포맷팅은 prettier가 담당하므로 eslint-config-prettier로 스타일 충돌 규칙을 끈다.
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default tseslint.config(
  { ignores: ['dist/**', 'node_modules/**', 'prisma/**'] },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['src/**/*.ts'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: { ...globals.node },
    },
    rules: {
      // 점진 도입: 빡센 규칙은 초기엔 경고로 표면화(빌드는 막지 않음)
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-unused-vars': [
        'warn',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
      ],
      // req.auth! 등 광범위 사용 → 초기엔 off
      '@typescript-eslint/no-non-null-assertion': 'off',
      // 재할당 없는 let 차단 — 실제 위반 강제
      'prefer-const': 'error',
    },
  },
  prettier,
);
