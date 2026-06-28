# GitHub Actions CI 도입 — 결정

- **현재 상태**: ✅ 확정 · 묶음 1·2·3 **전부 활성화 완료** (2026-06-28)
- **최종 갱신**: 2026-06-28
- **관련**: [리서치](../../research/github-actions-ci/README.md) · [설계](../../plans/api-db-design.md) · [CLAUDE.md](../../../CLAUDE.md)
- **상위 카탈로그**: [../README.md](../README.md)

> 이 폴더는 "GitHub Actions CI 도입" 결정 주제를 담는다. 아래는 **현재 유효한 결정 요약**이고,
> 상세 근거·영향은 세부 ADR에 있다.

## 맥락 (Context)

diet-setlog는 `app/`(Flutter) + `server/`(Node/TS) 모노레포이고, Angular 커밋 컨벤션 + 제목 끝 `(#이슈번호)` + 브랜치 보호를 도입했다. 이어서 PR 머지 전 자동 검사(CI)를 **어디까지 지금 도입할지** 정해야 한다.

- **근거 자료**: [GitHub Actions CI 리서치](../../research/github-actions-ci/README.md) — 검사 패턴 + diet-setlog 도입안(우선순위·단계).

## 결정 (Decision)

→ 상세: [0001. CI 도입 범위 — 스캐폴딩 단계별 활성화](0001-ci-adoption-scope.md)

**핵심**: "대상 코드가 없는 검사는 넣지 않는다." 검사를 그 대상이 생기는 시점에 활성화한다.

- **묶음 1 — 지금**: 커밋/PR 컨벤션(적용됨) · Secret scanning + push protection · Dependabot(github-actions) · 문서 링크 체크. 
  비코드(문서·제목·컨벤션) 검사는 **워크플로 1개(`docs-and-conventions.yml`) 아래 하위 잡**으로 통합.
- **묶음 2 — `server/` (✅ 2026-06-28 활성화)**: eslint·`tsc --noEmit`·test·Dependabot(npm). prettier·CodeQL은 보류/후속.
- **묶음 3 — `app/` (✅ 2026-06-28 활성화)**: `dart format`·`flutter analyze`·`flutter test`·Dependabot(pub).
- 코드 검사는 단일 `ci.yml`(`server`/`app` 잡 분리) + **paths-filter + 집계 status gate `CI Gate`**(스킵-잡 required 함정 회피). 브랜치 보호에는 `CI Gate`만 required 등록.
- **보류**: 커버리지 게이트(테스트 없음)·릴리스 자동화·라벨러/stale·DCO/CLA.

## 열린 질문 (정할 것)

- [x] 1차 도입 범위 → 묶음 1만 지금, 코드 검사는 스캐폴딩 트리거 ([0001](0001-ci-adoption-scope.md))
- [x] 커밋 검사 방식 → PR 제목(semantic) + 모든 커밋 commitlint, 비코드 검사로 통합
- [x] 보안 스캔 범위(1차) → secret scanning + push protection + Dependabot(actions); CodeQL은 server 생길 때
- [x] 모노레포 paths-filter + required status check 세부 구성 → `ci.yml` + `CI Gate` ([0001](0001-ci-adoption-scope.md))
- [ ] 테스트/커버리지 게이트 강도 (테스트 존재 — 커버리지 게이트 재검토 가능)
- [ ] prettier 포맷 게이트 도입 여부·시점
- [ ] CodeQL(`javascript-typescript`) 도입
- [ ] 릴리스 자동화 도입 여부·시점

## 근거 (Rationale)

헛도는 required check는 머지를 막거나 항상 초록이라 신호를 죽인다. 보안(시크릿·의존성)은 코드보다 먼저 유효하고 되돌리기 어렵다. 현재 주력 산출물이 `docs/`라 링크 체크 ROI가 높다. 상세: [0001 §근거](0001-ci-adoption-scope.md).

## 영향 (Consequences)

- 비코드 검사 통합: `commitlint.yml` + `pr-title.yml` → `docs-and-conventions.yml`(하위 잡 `pr-title`/`commitlint`/`docs-links`).
- 저장소 설정: Secret scanning + push protection 활성화, `.github/dependabot.yml`(github-actions).
- `server/`·`app/` 스캐폴딩 PR 정의에 해당 묶음 CI 추가를 포함. 상세: [0001 §영향](0001-ci-adoption-scope.md).

## 재검토 트리거 (Revisit when)

`server/`/`app/` 스캐폴딩 · 테스트 성숙 · 첫 배포 파이프라인 · 이슈/PR 급증·외부 기여 시작. 상세: [0001 §재검토 트리거](0001-ci-adoption-scope.md).

## 변경 이력 (Revision log)

| 날짜 | 변경 | 상태 |
|------|------|------|
| 2026-06 | 빈 자리 생성(결정 없음) | 🟡 검토 중 |
| 2026-06-26 | 도입 범위 확정([0001](0001-ci-adoption-scope.md)) — 단계별 활성화, 비코드 검사 워크플로 통합 | ✅ 확정 |
| 2026-06-28 | 묶음 2·3 활성화 — `ci.yml`·dependabot(npm/pub)·eslint 셋업 ([0001](0001-ci-adoption-scope.md)) | ✅ 적용 |
