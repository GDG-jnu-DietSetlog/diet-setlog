# GitHub Actions CI 도입 — 결정

- **현재 상태**: 🟡 검토 중(미확정) — **아직 아무것도 결정 안 함. 공간만 잡아둠.**
- **최종 갱신**: 2026-06
- **관련**: [리서치](../../research/github-actions-ci/README.md) · [설계](../../api-db-design.md) · [CLAUDE.md](../../../CLAUDE.md)
- **상위 카탈로그**: [../README.md](../README.md)

> 이 폴더는 "GitHub Actions CI 도입" 결정 주제 하나를 담는 **빈 자리**다.
> 리서치를 읽고 무엇을 어디까지 도입할지 정해지면 아래 "결정"을 채운다.

## 맥락 (Context)

diet-setlog는 `app/`(Flutter) + `server/`(Node/TS) 모노레포이고, 방금 Angular 커밋 컨벤션 + 제목 끝 `(#이슈번호)` + 브랜치 보호를 도입했다. 이어서 PR 머지 전 자동 검사(CI)를 도입할지, 한다면 어디까지를 지금 도입할지 정해야 한다.

- **근거 자료**: [GitHub Actions CI 리서치](../../research/github-actions-ci/README.md) — 검사 패턴 + diet-setlog 도입안(우선순위·단계).

## 결정 (Decision)

_미정 — 결정 안 함. 리서치 검토 후 작성._

## 열린 질문 (정할 것)

- [ ] 1차 도입 범위 (어떤 검사부터)
- [ ] 커밋 검사 방식 (PR 제목만 vs 모든 커밋 commitlint) — 머지 전략과 함께
- [ ] 테스트/커버리지 게이트 적용 여부·강도
- [ ] 보안 스캔 범위 (Dependabot / secret scanning / CodeQL)
- [ ] 모노레포 paths-filter + required status check 구성
- [ ] 릴리스 자동화 도입 여부·시점

## 근거 (Rationale)

_확정 시 작성 — research 근거 링크와 함께._

## 영향 (Consequences)

_확정 시 작성 — `.github/workflows/` 등 무엇이 바뀌는지._

## 재검토 트리거 (Revisit when)

_확정 시 작성 — 어떤 규모/조건이 되면 다시 연다._

## 변경 이력 (Revision log)

| 날짜 | 변경 | 상태 |
|------|------|------|
| 2026-06 | 빈 자리 생성(결정 없음) | 🟡 검토 중 |
