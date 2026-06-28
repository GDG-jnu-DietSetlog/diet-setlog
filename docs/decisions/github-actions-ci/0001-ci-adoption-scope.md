# 0001. GitHub Actions CI 도입 범위 — 스캐폴딩 단계별 활성화

- **상태**: ✅ 확정 · 묶음 1·2·3 **전부 활성화 완료** (2026-06-28, app·server 스캐폴딩됨)
- **날짜**: 2026-06-26 (활성화: 2026-06-28)
- **관련**: [리서치](../../research/github-actions-ci/README.md) (문서 01~04) · [README](./README.md) · [CONTRIBUTING.md](../../../CONTRIBUTING.md) · [CLAUDE.md](../../../CLAUDE.md)

## 맥락 (Context)

[리서치](../../research/github-actions-ci/README.md)에서 유명 OSS의 CI 검사 패턴과 diet-setlog 도입안(P0~P3)을 정리했다. 이제 **무엇을 지금 적용할지** 확정한다.

결정을 가르는 것은 "이상적 CI"가 아니라 **저장소의 실제 현 상태**다.

### 가용 상태 인벤토리 (현 저장소 기준)

| 대상 | 현 상태 | CI 적용 가능성 |
|---|---|---|
| 커밋/PR 컨벤션 검사 | **이미 구현·적용됨** (`.github/workflows/commitlint.yml`, `pr-title.yml`, `commitlint.config.js`) | ✅ 가동 중 |
| 브랜치 보호 | **적용됨** (PR 리뷰 1·linear history·force-push 금지) | ✅ 가동 중 |
| `server/` (Node/TS) | **스캐폴딩 전** — `package.json`·소스 없음 | ❌ lint/tsc/test 돌릴 대상 없음 |
| `app/` (Flutter) | **스캐폴딩 전** — `pubspec.yaml`·`lib/` 없음 | ❌ analyze/test/build 대상 없음 |
| 테스트 | 없음 | ❌ 커버리지 게이트 불가 |
| 문서(`docs/`, `CONTRIBUTING` 등) | **다수 존재** — 상대경로 상호링크 많음 | 🟡 링크 체크 유효 |
| 시크릿 | `.env.example` 존재, 실제 키는 커밋 금지 원칙([CLAUDE.md](../../../CLAUDE.md)) | 🟡 secret scanning 즉시 유효 |
| GitHub Actions 워크플로 | 2개 존재 | 🟡 Dependabot(actions) 즉시 유효 |

> 핵심: **앱·서버 코드가 아직 없다.** lint·타입체크·빌드·테스트·커버리지·CodeQL은 **검사 대상이 존재해야** 의미가 있다. 지금 넣으면 항상 통과(no-op)하거나 헛도는 워크플로가 되어 신뢰도만 떨어뜨린다. 따라서 **각 검사를 그 대상 코드가 스캐폴딩되는 시점에 켠다**(friend-rec ADR이 "그래프가 자라며 신호 가중치가 이동"한 것과 같은 구조 — 여기선 "코드가 생기며 검사가 활성화").

## 선택지 (Options)

- **(A) 리서치 P0 전체를 지금 다 넣는다** — lint/tsc/build 워크플로까지 선반영. 기각: 대상 코드가 없어 **헛도는 잡 + required check 함정**([리서치 04 §B](../../research/github-actions-ci/04-automation-monorepo-release.md))만 생긴다.
- **(B) 코드 생길 때까지 아무것도 안 한다** — 기각: 지금도 유효한 검사(secret scanning·Dependabot·docs 링크)가 있고, 시크릿 유출은 **첫 코드 전에도** 위험.
- **(C, 채택) 지금 유효한 것만 켜고, 코드 검사는 스캐폴딩 트리거에 묶는다** — 대상이 존재하는 검사만 활성화, 나머지는 활성화 조건을 명시해 대기.

## 결정 (Decision)

검사를 **3개 묶음**으로 나눠 활성화 시점을 고정한다.

### 묶음 1 — 지금 적용 (대상이 이미 존재)

| 검사 | 적용 | 비고 |
|---|---|---|
| **커밋/PR 컨벤션 + `(#이슈번호)`** | ✅ 이미 적용됨 | 유지. 변경 없음 |
| **브랜치 보호(PR 리뷰·linear·force-push 금지)** | ✅ 이미 적용됨 | 유지 |
| **Secret scanning + push protection** | ▶ **지금 켠다** | 저장소 설정(Actions 불필요). `.env`·키 커밋 차단([CLAUDE.md](../../../CLAUDE.md) 보안 원칙 강제) |
| **Dependabot — `github-actions` 생태계만** | ▶ **지금 켠다** | `.github/dependabot.yml`. npm/pub은 매니페스트 생기면 추가 |
| **문서 링크 체크 (lychee)** | ▶ **권장(선택)** | `docs/`·`CONTRIBUTING`에 상대링크 多, 깨진 링크 잦음 |

### 검사 구성 — 비(非)코드 검사는 워크플로 1개 아래 하위 잡으로

문서·제목·컨벤션처럼 **사람이 읽는 산출물을 검사하는 항목은 워크플로를 여러 개로 쪼개지 않는다.** **단일 워크플로 `문서·컨벤션 검사`(`docs-and-conventions.yml`) 아래 하위 잡(sub-test)**으로 묶는다.

```
문서·컨벤션 검사 (워크플로 1개 = PR 체크 1묶음)
├─ pr-title      PR 제목: Angular type + 끝 (#이슈번호)
├─ commitlint    커밋 메시지: Angular 컨벤션 + #이슈 참조
└─ docs-links    문서 상대링크 깨짐 검사 (lychee)
```

- **이유**: 이들은 모두 "비코드 규약" 한 묶음이라 개념적으로 1개 검사다. 워크플로를 쪼개면 PR 체크 목록만 길어지고 관리 지점이 흩어진다. 하위 잡은 GitHub 체크 UI에서 **하나의 워크플로 아래 개별 체크**로 표시돼 어디서 실패했는지도 명확하다.
- **반대로 코드 검사(묶음 2·3)는 이 워크플로에 넣지 않는다.** 언어·툴체인·트리거(paths-filter)가 다르고 무거우므로 `app`/`server`별 워크플로로 분리한다. → "비코드=1워크플로 다잡", "코드=대상별 워크플로".
- 기존 `commitlint.yml` + `pr-title.yml` 2개 워크플로는 **이 통합 워크플로로 대체**(아래 [영향](#영향-consequences)).

### 묶음 2 — `server/` 스캐폴딩 시 활성화

`server/package.json` 이 생기는 PR에서 함께 켠다. **(2026-06-28 활성화)**

- `npm ci`(락파일 동기화) → `npm run prisma:generate`(타입) → `npm run lint`(eslint) → `npm run typecheck`(`tsc --noEmit`) → `npm test`(vitest)
- Dependabot `npm`(`/server`) 추가
- **eslint 셋업**: 활성화 시점에 eslint 설정·의존성이 없어 flat config(`eslint.config.js`, `@eslint/js` + `typescript-eslint`)와 devDeps를 추가했다. 발견된 실제 위반 1건(`prefer-const`)은 함께 수정.
- **prettier `--check`는 보류**: prettier 미설치 상태였고, 전체 코드베이스 일괄 재포맷 churn을 피하기 위해 1차에선 eslint만 적용. 포맷 강제는 추후 도입(재검토 트리거에 추가).
- CodeQL(`javascript-typescript`)은 후속(이 PR엔 미포함).
- zod 입력 검증은 코드 규약이므로 CI 항목 아님(리뷰에서 확인)

### 묶음 3 — `app/` 스캐폴딩 시 활성화

`app/pubspec.yaml` 이 생기는 PR에서 함께 켠다.

- `dart format --output=none --set-exit-if-changed .` → `flutter analyze --fatal-infos` → `flutter test`
- (릴리스 임박 시) `flutter build apk`
- Dependabot `pub`(`/app`) 추가
- **(2026-06-28 활성화)** Flutter 3.24.5 고정. 활성화 시 미포맷 1건(`record_edit_screen.dart`) 발견·수정.

### 공통 운영 규칙 (묶음 2·3이 켜질 때 함께)

- **모노레포 paths-filter** ([리서치 04 §B](../../research/github-actions-ci/04-automation-monorepo-release.md)): `app/**`·`server/**` 변경분만 해당 잡 실행.
- **required status check 함정 회피**: paths-filter로 **스킵된 잡을 직접 required로 걸지 않는다.** 항상 도는 **집계(status gate) 잡** 하나만 required로 등록한다.
- **트리거**: `pull_request` `[opened, synchronize, reopened]` (외부 기여자 토큰 안전). PR 제목 검사처럼 권한이 필요한 것만 `pull_request_target` + 권한 최소화.
- **비용 절감**: `concurrency`로 중복 실행 취소 + `setup-node`/pub 캐시.

### 지금은 보류 (도입 안 함)

| 항목 | 보류 이유 | 다시 여는 트리거 |
|---|---|---|
| 커버리지 게이트(Codecov) | 테스트가 없어 baseline 불가 | 테스트 스위트 + 의미있는 커버리지 생긴 뒤 |
| 릴리스 자동화(release-please 등) | 배포 대상·버전 정책 미정 | 첫 배포 파이프라인 논의 시([리서치 04 §C](../../research/github-actions-ci/04-automation-monorepo-release.md)) |
| 라벨러/stale 봇 | 소규모·초기엔 효용 낮음 | 이슈/PR 양이 트리아지를 요구할 때 |
| DCO/CLA | 외부 기여자 없음 | 외부 기여가 늘 때([리서치 03 §B](../../research/github-actions-ci/03-security-and-compliance.md)) |
| Trivy/컨테이너 스캔 | 컨테이너·IaC 없음 | Docker/배포 인프라 도입 시 |

## 근거 (Rationale)

- **"대상 없는 검사는 넣지 않는다"**: 헛도는 required check는 머지를 막거나([리서치 04 §B] 스킵-잡 함정) 항상 초록이라 **신호를 죽인다**. 검사는 처음 켜질 때부터 실제로 무언가를 막아야 신뢰된다.
- **보안은 코드보다 먼저**: secret scanning·push protection·Dependabot(actions)은 **앱/서버가 없어도 지금 유효**하고, 시크릿 유출은 되돌리기 어렵다([CLAUDE.md](../../../CLAUDE.md)). → 묶음 1에 포함.
- **문서가 현재의 주력 산출물**: 지금 저장소 내용 대부분이 `docs/`다. 상대링크가 많아 **링크 체크가 지금 가장 ROI 높은 코드성 검사**다(이 결정 과정에서도 dangling link 위험을 겪음).
- **스캐폴딩에 묶기**: 검사를 PR로 함께 켜면, 그 코드의 첫 커밋부터 규칙이 강제되어 부채가 쌓이지 않는다.

## 영향 (Consequences)

**묶음 1 (완료)**
- [x] **비코드 검사 통합**: `commitlint.yml` + `pr-title.yml` 삭제 → `.github/workflows/docs-and-conventions.yml` 1개로 통합(하위 잡 `pr-title`/`commitlint`/`docs-links`)
- [ ] 저장소 설정: **Secret scanning + Push protection 활성화** (Settings → Code security) — *저장소 관리자 수동 작업, 코드 변경 아님*
- [x] `.github/dependabot.yml` 추가 — `github-actions`(+ 묶음 2·3로 `npm`/`pub` 함께)
- [x] `docs/decisions/github-actions-ci/README.md` "현재 결정"을 이 ADR 요지로 갱신

**묶음 2·3 (2026-06-28 활성화 — app·server 스캐폴딩 + 테스트 존재 확인)**
- [x] `.github/workflows/ci.yml` 추가 — `changes`(paths-filter) → `server`/`app` 잡 → 집계 `ci-gate`.
- [x] server eslint flat config + devDeps 추가, `prefer-const` 위반 1건 수정.
- [x] app 미포맷 1건 수정. 로컬 검증: server lint·tsc·test(23) / app format·analyze·test(17) 모두 통과.
- [ ] **브랜치 보호**: required status checks에 **`CI Gate`만** 등록(스킵-잡 직접 등록 금지) — *저장소 관리자 수동 작업*.

**정제 — 코드 검사는 "대상별 워크플로" 대신 단일 `ci.yml` 내 잡 분리**
- 당초 "코드=대상별 워크플로 분리"였으나, GitHub Actions는 **워크플로를 가로질러 한 잡이 다른 워크플로 잡을 `needs`로 집계할 수 없다.** 묶음 2·3 요구사항인 "**항상 도는 집계 status gate 1개만 required**"를 만족하려면 server·app 잡과 게이트가 한 워크플로 안에 있어야 한다.
- 따라서 코드 검사는 `ci.yml` **단일 워크플로 안에서 `server`/`app` 잡으로 분리**한다(비코드 `docs-and-conventions.yml` 과는 여전히 분리). 원래 의도("언어·툴체인·트리거가 다르므로 분리")는 잡 수준 분리 + `paths-filter`로 충족.

**트레이드오프**
- prettier 포맷 게이트는 1차 보류(eslint만) → 포맷 일관성은 추후 도입 시 강제.

## 재검토 트리거 (Revisit when)

- **`server/` 스캐폴딩** → 묶음 2 활성화.
- **`app/` 스캐폴딩** → 묶음 3 활성화.
- **두 묶음 다 가동** → paths-filter + required status gate 구성, 보호 룰에 status check 등록.
- **테스트 스위트 성숙** → 커버리지 게이트(Codecov project/patch) 재검토.
- **첫 배포 파이프라인 논의** → 릴리스 자동화 재검토.
- **이슈/PR 급증 또는 외부 기여 시작** → 라벨러/stale·DCO/CLA 재검토.

## 변경 이력 (Revision log)

| 날짜 | 변경 | 상태 |
|------|------|------|
| 2026-06 | 빈 자리 생성(결정 없음) | 🟡 검토 중 |
| 2026-06-26 | 도입 범위 확정 — 스캐폴딩 단계별 활성화(묶음 1 지금/2·3 코드 생길 때) | ✅ 확정 |
| 2026-06-28 | app·server 스캐폴딩으로 재검토 트리거 발동 → **묶음 2·3 활성화**: `ci.yml`(paths-filter + `ci-gate`)·dependabot(npm/pub) 추가, eslint 셋업. 정제: 코드 검사 단일 워크플로 잡 분리, prettier 보류 | ✅ 적용 |
