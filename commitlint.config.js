// Angular(Conventional) 커밋 컨벤션 검사 설정.
// 검사 규칙: CONTRIBUTING.md 참고.
// CI에서 wagoid/commitlint-github-action 이 이 파일을 읽어 PR의 커밋들을 검사한다.
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // 허용 type 목록 (Angular)
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'perf',
        'test',
        'build',
        'ci',
        'chore',
        'revert',
      ],
    ],
    // 제목(subject) 끝에 마침표 금지
    'subject-full-stop': [2, 'never', '.'],
    // 제목 비어있으면 안 됨
    'subject-empty': [2, 'never'],
    // type 비어있으면 안 됨
    'type-empty': [2, 'never'],
    // header 최대 길이 (이슈번호 (#N) 포함 고려해 100자)
    'header-max-length': [2, 'always', 100],
    // 이슈번호 참조(#N)를 최소 1개 요구 — 제목의 (#12) 또는 footer의 Closes #12 가 있으면 통과.
    // 'revert' 커밋 등 예외가 필요하면 이 규칙을 조정한다.
    'references-empty': [2, 'never'],
  },
};
