# 01. 커밋 메시지 / PR 제목 컨벤션 검사

> 인덱스: [README.md](README.md) · 상위 카탈로그: [../README.md](../README.md)

우리 팀이 방금 도입한 규칙(**Angular 컨벤션 + 제목 끝 `(#이슈번호)`**)을 CI에서 강제하는 카테고리. 이 검사가
릴리스 자동화([04 문서](04-automation-monorepo-release.md))의 입력 데이터가 되므로 가장 먼저 다룬다.

## (1) 무엇을 검사하는가
- 커밋 메시지 또는 PR 제목이 **Conventional Commits**(`feat:`, `fix:`, `chore:` …) / Angular 컨벤션을 따르는지.
- 허용된 `type`/`scope`, 제목 길이, 마침표 금지, (우리 팀 규칙처럼) **제목 끝 `(#123)`** 같은 커스텀 규칙.

## (2) 왜 도입했는가
- **릴리스 자동화의 입력값**이기 때문이다. `feat`/`fix`/`BREAKING CHANGE`를 파싱해 SemVer 버전 bump와 CHANGELOG를 생성하므로,
  컨벤션이 깨지면 릴리스 도구가 잘못 동작한다.
- 커밋 히스토리/변경 로그의 **일관성·검색성**을 확보하고, 리뷰어가 PR 의도를 제목만으로 파악하게 한다.

## (3) 어떻게 동작하는가
- **Squash merge** 전략을 쓰면 머지 시 **PR 제목**이 최종 커밋이 되므로 *PR 제목*을 검사한다(`amannn/action-semantic-pull-request`).
- 모든 커밋을 보존하면 *커밋 메시지*를 검사한다(`wagoid/commitlint-github-action` + `@commitlint/config-conventional`).
- 트리거는 PR 제목용으로 `[opened, edited, synchronize, reopened]`.
  required check로 쓰려면 `synchronize`도 포함해 **최신 푸시 기준**으로 재실행되게 해야 한다.

```yaml
# .github/workflows/pr-title.yml — PR 제목 컨벤션 검사
name: "PR Title Check"
on:
  pull_request:
    types: [opened, edited, synchronize, reopened]
permissions:
  pull-requests: read
jobs:
  lint-title:
    runs-on: ubuntu-latest
    steps:
      - uses: amannn/action-semantic-pull-request@v5
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          types: |
            feat
            fix
            chore
            docs
            refactor
            test
          # 우리 팀 규칙: 제목 끝 (#이슈번호) 강제 → subjectPattern 으로 정규식 검사
          subjectPattern: '^.+\s\(#\d+\)$'
          subjectPatternError: 'PR 제목은 끝에 (#이슈번호) 형식이어야 합니다. 예: feat: 세트 기록 저장 (#42)'
```

```yaml
# .github/workflows/commitlint.yml — 커밋 메시지 검사(모든 커밋 보존 시)
on: [pull_request]
jobs:
  commitlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: wagoid/commitlint-github-action@v6
```

> 💡 우리 저장소는 이미 `commitlint.config.js`에서 `references-empty: [2, 'never']`로 **이슈번호 참조(#N)를 필수**로 두고,
> `pr-title.yml`에서 제목 끝 `(#N)`을 정규식으로 검사한다. 위 스니펫은 그 일반형이다.

## (4) 실제 사용하는 프로젝트 예시
- **Angular** — Conventional Commits의 원조 격(`feat(scope): ...`), 커밋 메시지 형식을 CI에서 강제.
- **Next.js / Vercel 계열, 다수 npm 라이브러리** — `amannn/action-semantic-pull-request`로 squash 머지 제목 검사.
- 대표 액션: `amannn/action-semantic-pull-request`, `wagoid/commitlint-github-action`, `CondeNast/conventional-pull-request-action`.

> 출처: [amannn/action-semantic-pull-request](https://github.com/amannn/action-semantic-pull-request),
> [wagoid/commitlint-github-action](https://github.com/wagoid/commitlint-github-action),
> [CondeNast/conventional-pull-request-action](https://github.com/CondeNast/conventional-pull-request-action),
> [Conventional Commits 사양](https://www.conventionalcommits.org/).
> (참고: `subjectPattern`을 우리 `(#이슈번호)` 규칙에 맞춘 부분은 액션 옵션을 응용한 예시 구성이다.)
