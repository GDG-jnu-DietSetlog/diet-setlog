# 04. 자동화 / 모노레포 / 릴리스

> 인덱스: [README.md](README.md) · 상위 카탈로그: [../README.md](../README.md)

이슈/PR을 사람 손 없이 굴리는 자동화, 모노레포에서 변경분만 검사하는 최적화, 그리고 컨벤션([01 문서](01-commit-and-pr-conventions.md))을 버전/CHANGELOG로 연결하는 릴리스 자동화.

---

## A. 라벨 / 이슈·PR 자동화

### (1) 무엇을 검사하는가
변경된 파일 경로 기반 **자동 라벨링**(`area/app`, `area/server`), **PR 크기 라벨**(XS/S/M/L/XL),
필수 라벨(예: `type/*`)이 붙었는지 검사, **오래 방치된 이슈/PR(stale)** 자동 정리.

### (2) 왜 도입했는가
대량의 이슈/PR을 **사람 손 없이 분류·트리아지**. 너무 큰 PR을 라벨로 가시화해 작게 쪼개도록 유도. 백로그 위생 유지.

### (3) 어떻게 동작하는가
- `actions/labeler`: `.github/labeler.yml`의 경로 글롭으로 라벨 자동 부여(`pull_request_target`).
- PR size labeler: 변경 라인/파일 수로 size 라벨(`codelytv/pr-size-labeler` 등).
- `actions/stale`: `schedule`(cron)로 N일 무활동 시 `stale` 라벨·코멘트, 추가 N일 후 자동 close.

```yaml
# 자동 라벨 (.github/labeler.yml 매핑)
on: [pull_request_target]
jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/labeler@v5
# .github/labeler.yml
"area/app":    [ "app/**" ]
"area/server": [ "server/**" ]
```
```yaml
# Stale bot
on:
  schedule: [ { cron: "0 1 * * *" } ]
jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v9
        with:
          days-before-stale: 30
          days-before-close: 7
          stale-issue-label: "stale"
```

### (4) 실제 사용하는 프로젝트 예시
- **Kubernetes** — `area/*`, `kind/*`, `size/*` 라벨 자동화(Prow + Actions 계열 도구).
- **VS Code** — 대량 이슈를 라벨/봇으로 트리아지(자체 GitHub Action 봇).
- **React, Home Assistant** — labeler + stale bot.
- 대표 액션: `actions/labeler`, `actions/stale`, `codelytv/pr-size-labeler`.

> 출처: [actions/labeler](https://github.com/actions/labeler),
> [actions/stale](https://github.com/actions/stale),
> [PR Size Labeler](https://github.com/marketplace/actions/pr-size-labeler-action). (Kubernetes/VS Code의 라벨 트리아지는 널리 알려진 관행)

---

## B. 의존성 / 락파일 / paths filter / 모노레포 부분 실행

### (1) 무엇을 검사하는가
- **락파일 동기화**: `package-lock.json`/`pubspec.lock`이 manifest와 일치하는지(`npm ci`가 실패하면 불일치).
- **변경 영향 범위**: 어떤 경로가 바뀌었는지 감지해 **영향받는 부분만 CI 실행**(모노레포 부분 실행).
- 의존성 리뷰(추가된 패키지의 취약점/라이선스, `actions/dependency-review-action`).

### (2) 왜 도입했는가
- 모노레포에서 **app만 바뀌었는데 server 전체 테스트를 도는 낭비**를 제거 → CI 시간·비용 절감(CLAUDE.md의 트래픽/비용 의식과 결).
- 락파일을 검증해 "내 머신에서만 되는" 의존성 표류 방지.

### (3) 어떻게 동작하는가
- `dorny/paths-filter`로 변경 경로를 필터 → 각 필터의 boolean output으로 **후속 잡을 조건 실행**(`if:`).
- 또는 워크플로우 레벨 `on.push.paths`/`paths-ignore`로 거름. JS 모노레포는 Turborepo `--affected`/Nx로 의존 그래프 기반 부분 실행.
- 락파일: `npm ci`(lock 불일치 시 실패), `flutter pub get`은 lock을 기준으로 해석.

```yaml
on: [pull_request]
jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      app: ${{ steps.f.outputs.app }}
      server: ${{ steps.f.outputs.server }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: f
        with:
          filters: |
            app: [ 'app/**' ]
            server: [ 'server/**' ]
  app-ci:
    needs: changes
    if: ${{ needs.changes.outputs.app == 'true' }}
    runs-on: ubuntu-latest
    steps: [ { run: "echo flutter analyze/test ..." } ]
  server-ci:
    needs: changes
    if: ${{ needs.changes.outputs.server == 'true' }}
    runs-on: ubuntu-latest
    steps: [ { run: "echo tsc/test ..." } ]
```

> ⚠️ **required check + paths filter 주의:** 조건 때문에 스킵된 잡은 "성공"이 아니라 "실행 안 됨"이라
> required check가 영원히 대기할 수 있다. 해결책은 **항상 도는 "status gate" 잡**을 두어 하위 잡 결과를 집계해 통과시키는 패턴이다.

### (4) 실제 사용하는 프로젝트 예시
- **Next.js / Turborepo, 다수 pnpm 모노레포** — Turborepo `--affected` + paths filter.
- **Babel, 대형 JS 모노레포** — `dorny/paths-filter`로 패키지별 부분 실행.
- 대표 액션: `dorny/paths-filter`, `actions/dependency-review-action`, Turborepo/Nx.

> 출처: [dorny/paths-filter](https://github.com/dorny/paths-filter),
> [Turborepo 모노레포 CI 가이드](https://turbo.build/repo/docs/guides/ci-vendors/github-actions),
> [dependency-review-action](https://github.com/actions/dependency-review-action).

---

## C. 릴리스 자동화

### (1) 무엇을 자동화하는가
- 커밋/PR 컨벤션을 입력으로 **SemVer 버전 bump + CHANGELOG 생성 + GitHub Release/태그 + 패키지 publish**를 자동화.
- 즉 [01 문서(컨벤션 검사)](01-commit-and-pr-conventions.md)가 **이 단계의 데이터 소스**다 — 둘은 한 쌍이다.

### (2) 왜 도입했는가
수동 릴리스의 휴먼 에러(버전 누락, CHANGELOG 망각) 제거. "무엇이 릴리스되는가"를 커밋 의도로부터 **결정론적으로** 도출.

### (3) 어떻게 동작하는가 (세 가지 접근)
| 도구 | 방식 | 특징 |
| --- | --- | --- |
| **release-please** (Google) | Conventional Commits를 파싱해 **Release PR**을 만들어 둠 → 머지하면 태그/릴리스 | "릴리스 시점을 사람이 PR 머지로 결정", 모노레포 지원 |
| **semantic-release** | main에 머지되면 커밋 분석 → **즉시** 버전 결정·publish | 완전 자동, 사람 개입 없음 |
| **changesets** | 기여자가 `changeset add`로 **의도를 명시**한 파일을 PR에 포함 → 봇이 changeset 없으면 코멘트 | 모노레포 라이브러리(여러 패키지 동시 버전) 강점 |

```yaml
# release-please
on:
  push: { branches: [main] }
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: googleapis/release-please-action@v4
        with: { release-type: node }
```

### (4) 실제 사용하는 프로젝트 예시
- **release-please**: Google 계열 다수 라이브러리.
- **semantic-release**: 수많은 npm 패키지의 표준 릴리스 도구.
- **changesets**: pnpm/Turborepo 모노레포(예: 다수 디자인 시스템/SDK).

> 출처: [release-please-action](https://github.com/marketplace/actions/release-please-action),
> [semantic-release](https://github.com/semantic-release/semantic-release),
> [changesets](https://github.com/changesets/changesets).

---

## D. 그 외 유명 패턴

| 패턴 | 무엇을 / 왜 | 대표 도구 |
| --- | --- | --- |
| **PR 설명/스크린샷 강제** | UI 변경 PR에 스크린샷·체크리스트 강제 → 시각 회귀 리뷰 용이 | PR template + 본문 검사 액션 |
| **번들/바이너리 사이즈 제한** | 번들 크기 회귀를 PR 코멘트로 보고·임계 초과 차단 | `andresz1/size-limit-action`, `preactjs/compressed-size-action` |
| **문서 빌드/링크 체크** | 문서 사이트 빌드 깨짐·죽은 링크 차단 | `lycheeverse/lychee-action`, MkDocs/Docusaurus 빌드 |
| **머지 충돌·base 최신화 검사** | conflict 라벨 자동 부여, "needs rebase" 표시 | `eps1lon/actions-label-merge-conflict` |
| **Visual regression / E2E** | Playwright/Cypress 스냅샷으로 UI 회귀 차단 | `playwright`, Chromatic |
| **i18n / 번역 키 검증** | 누락 번역 키 차단 | 커스텀 스크립트 |
| **PR당 미리보기 배포(Preview)** | PR마다 프리뷰 URL 코멘트 | Vercel/Netlify, `nwtgck/actions-netlify` |

> 출처: [size-limit-action](https://github.com/andresz1/size-limit-action),
> [compressed-size-action](https://github.com/preactjs/compressed-size-action),
> [lychee-action(링크 체크)](https://github.com/lycheeverse/lychee-action),
> [actions-label-merge-conflict](https://github.com/eps1lon/actions-label-merge-conflict).
