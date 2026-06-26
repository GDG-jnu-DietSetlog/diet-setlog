# GitHub Actions CI 검사 패턴 리서치 — 인덱스

> 주제: **유명 오픈소스 프로젝트(Angular·React·Kubernetes·Node.js·Next.js·Vue·VS Code·Flutter/Dart SDK 등)는
> GitHub Actions로 PR을 머지하기 전에 무엇을, 왜, 어떻게 자동 검사하는가**, 그리고 그것이
> diet-setlog(Flutter + Node/TS 모노레포)의 CI 설계에 주는 시사점.
> 상위 조사 카탈로그: [../README.md](../README.md)
> 작성 기준: 2026-06. 각 문서는 공식 문서·엔지니어링 블로그·마켓플레이스 액션을 직접 조사해 출처를 달았다.
> ⚠️ 주의: 각 프로젝트의 **정확한 내부 워크플로우는 수시로 바뀐다**. 일부 서술은 공개 자료 기반 일반화이며, 추정·권고 부분은 본문에 명시했다.
> 배경: 우리 팀이 방금 도입한 **Angular 커밋 컨벤션 + 제목 끝 `(#이슈번호)` 규칙 + 브랜치 보호 룰**과
> 이를 검사하는 Actions(commitlint, PR 제목 검사) 작업의 근거 자료다.

## 문서 목록 (읽는 순서 권장)

| # | 문서 | 한 줄 요약 |
|---|------|-----------|
| 01 | [커밋/PR 제목 컨벤션 검사](01-commit-and-pr-conventions.md) | commitlint·semantic-pull-request, 우리 `(#이슈번호)` 규칙을 정규식으로 강제하는 법 |
| 02 | [Lint / 빌드 / 테스트 / 커버리지](02-lint-build-test-coverage.md) | format·analyze·tsc·매트릭스 빌드·Codecov project/patch 커버리지 게이트 |
| 03 | [보안 / 라이선스(DCO·CLA)](03-security-and-compliance.md) | CodeQL·Dependabot·secret scanning·Trivy, DCO sign-off·CLA 봇 |
| 04 | [자동화 / 모노레포 / 릴리스](04-automation-monorepo-release.md) | labeler·stale·size, paths-filter 부분 실행(+required 함정), release-please/semantic-release/changesets |

## 검사 패턴을 보는 공통 렌즈 (TL;DR)

대형 프로젝트는 대부분 동일한 골격을 공유한다.

1. **게이트의 본질은 Actions가 아니라 "브랜치 보호 + required status checks"다.** 워크플로우가 만든 status check를
   브랜치 보호 룰의 *required*로 지정해야 통과 못 한 PR의 머지 버튼이 비활성화된다. Actions 자체는 막지 않는다.
2. **트리거 선택이 보안·정확성을 가른다.** `pull_request`(외부 기여자 안전), `pull_request_target`(라벨/PR 제목 등 토큰 권한 필요 시, 권한 최소화 필수),
   `push`(main/release), `schedule`(보안 스캔·stale), `workflow_dispatch`(수동).
3. **컨벤션 검사(01)와 릴리스 자동화(04)는 한 쌍이다.** `feat`/`fix`/`BREAKING CHANGE`를 파싱해 SemVer·CHANGELOG를 만들기 때문에,
   컨벤션이 깨지면 릴리스가 깨진다. 컨벤션을 강제하는 1차 이유가 바로 이것.
4. **모노레포는 paths-filter로 부분 실행**하되, **스킵된 잡을 required check로 직접 걸면 머지가 영원히 대기**한다 →
   "항상 도는 집계(status gate) 잡"으로 우회하는 게 정석.
5. **fail-fast·캐시·`concurrency`(중복 실행 취소)** 로 CI 시간·비용을 줄인다(우리 비용/트래픽 의식과 결).

## diet-setlog 추천 도입안

**컨텍스트:** Flutter(`app/`) + Node/TS(`server/`) 모노레포, 소규모 팀, 트래픽 스파이크 대응이 목표.
방금 **Angular 컨벤션 + 제목 끝 `(#이슈번호)` + 브랜치 보호**를 도입했으므로, 그 흐름을 그대로 이어 단계별로 쌓길 권한다.

### 우선순위 표

| 우선순위 | 검사 | 이유(우리 맥락) | 도구 |
| --- | --- | --- | --- |
| **P0 (지금)** | PR 제목 컨벤션 + `(#이슈번호)` | 이미 도입한 규칙을 기계로 강제. 릴리스 자동화의 토대 | `amannn/action-semantic-pull-request` (`subjectPattern`) |
| **P0** | commitlint(모든 커밋 보존 시) | Angular 컨벤션 일관성 | `wagoid/commitlint-github-action` |
| **P0** | Lint/Format | 리뷰 노이즈 제거 | `dart format --set-exit-if-changed`, `flutter analyze`, eslint+prettier |
| **P0** | 타입체크/빌드 | 회귀 차단(앱·서버 둘 다) | `tsc --noEmit`, `flutter build`, `subosito/flutter-action` |
| **P1** | 모노레포 paths filter | app/server 변경분만 CI → 시간·비용 절감 | `dorny/paths-filter` (+ 집계 status gate 잡) |
| **P1** | 테스트 + 커버리지 게이트 | 새 코드 테스트 강제 | `flutter test --coverage`, `jest`, `codecov/codecov-action` |
| **P1** | 보안: Dependabot + secret scanning + CodeQL(TS) | 시크릿 유출·취약 의존성 차단 | `dependabot.yml`(npm+pub+actions), push protection, `github/codeql-action` |
| **P2** | 라벨 자동화 + stale | `area/app`·`area/server` 자동 분류, 백로그 위생 | `actions/labeler`, `actions/stale`, PR size labeler |
| **P2** | 릴리스 자동화 | 컨벤션을 버전/CHANGELOG로 연결 | `release-please`(모노레포 모드) |
| **P3** | 번들/링크/프리뷰 등 | 여유 시 품질 향상 | size-limit, lychee, 프리뷰 배포 |
| **(보류)** | DCO/CLA | 외부 기여자가 늘기 전엔 과함 | 필요 시 `dcoapp/app` |

### 단계별 도입 순서

1. **1단계 — 게이트 골격(P0):** 브랜치 보호의 *required status checks*에 넣을 잡을 먼저 만든다.
   `pr-title.yml`(제목 + `(#이슈번호)` 정규식, 이미 진행 중) + `ci.yml`의 `app`/`server` 두 잡(포맷·analyze·`tsc`·빌드).
2. **2단계 — 모노레포 최적화 + 테스트(P1):** `dorny/paths-filter`로 경로별 분기 + **항상 도는 집계 잡**만 required로 등록.
   여기에 `flutter test --coverage` + Codecov `project`/`patch` 게이트.
3. **3단계 — 보안(P1):** `dependabot.yml`에 `npm`(/server)·`pub`(/app)·`github-actions`(/) 등록 + secret scanning/push protection + 서버 TS에 CodeQL.
4. **4단계 — 자동화/위생(P2):** labeler(`area/app`,`area/server`) + stale bot + (선택) PR size 라벨.
5. **5단계 — 릴리스(P2):** 컨벤션 안정화 후 `release-please`로 버전/CHANGELOG 자동화.

### 주의/체크리스트
- [ ] required check에 **스킵 가능한 잡을 직접 등록하지 말 것** → 항상 도는 집계 잡 사용.
- [ ] PR 제목 검사 트리거에 `synchronize` 포함(최신 푸시 기준 재검사).
- [ ] 외부 PR에서 시크릿이 필요한 잡은 `pull_request_target` 권한 범위 최소화.
- [ ] `.env`/키스토어/서명 키 커밋 금지 — secret scanning + push protection 이중 방어(CLAUDE.md 보안 원칙).
- [ ] 캐시(`setup-node` cache, pub-cache) + `concurrency`로 중복 실행 취소 → 비용 절감.

> 출처(종합): 각 세부 문서의 출처 + [GitHub — 보호된 브랜치/required status checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches).
> 우선순위·순서는 diet-setlog 맥락에 맞춘 **권고(판단)** 이며 절대적 기준은 아니다.
