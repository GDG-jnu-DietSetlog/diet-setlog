# Decisions — 결정 기록 (ADR)

diet-setlog의 **설계·제품 결정**을 주제별로 모아둔 디렉터리.
결정은 **고정된 게 아니다** — 서비스 규모가 커지거나, 제품 방향이 바뀌면 같은 주제의 결정도 달라진다.
그래서 결정 1건을 단일 파일로 끝내지 않고, **결정 주제 = 폴더 1개**(research와 동일 패턴)로 두어 그 안에서 현재 결정 + 변경 이력 + 하위 결정을 함께 관리한다.

- **research vs decisions**: [`../research/`](../research/README.md)는 *조사·근거*, 여기 `decisions/`는 *그 근거로 내린 결론*.
- **설계 문서**([`../api-db-design.md`](../api-db-design.md))의 "열린 질문"이 확정되면, 그 결과를 해당 결정 폴더에 남기고 설계 문서를 갱신한다.

## 결정 목록

| 결정 주제 | 폴더 | 한 줄 요약 | 상태 |
|-----------|------|-----------|------|
| 친구 추천 | [`friend-recommendation/`](friend-recommendation/README.md) | 추천 소스(카카오친구/친구의친구)·정렬·친구 관계 모델·로그인 의존 | 🟡 검토 중(미확정) |
| GitHub Actions CI 도입 | [`github-actions-ci/`](github-actions-ci/README.md) | CI 검사(컨벤션·lint·빌드·커버리지·보안·모노레포·릴리스) 단계별 도입 | 🟡 검토 중(미확정) |

> 상태 범례: 🟡 검토 중(Proposed) · ✅ 확정(Accepted) · ♻️ 대체됨(Superseded) · ❌ 폐기(Rejected)
> 새 결정 주제가 생기면 위 표에 한 줄 추가하고 `<주제-kebab-case>/` 폴더를 만든다.

## 폴더 구조 규칙

```
docs/decisions/
├── README.md                       # ← 이 파일(결정 카탈로그)
└── <결정-주제-kebab-case>/          # 결정 주제 1개 = 폴더 1개
    ├── README.md                   # 그 주제의 "현재 결정" + 상태 + 변경 이력
    ├── 0001-<세부결정>.md           # (선택) 개별 결정/개정 기록 — 시간순
    └── 0002-<세부결정>.md
```

규칙:
- **폴더명**: 결정 주제를 kebab-case로 (예: `friend-recommendation`, `github-actions-ci`, `caching`).
- **폴더 README.md**: 그 주제의 **현재 유효한 결정**을 한눈에 보이게 유지(상태·요약·열린 질문·변경 이력). 항상 최신 상태를 반영.
- **세부/개정 기록**: 결정이 바뀌면 옛 결정을 지우지 말고 `NNNN-` 번호 문서로 남기고(또는 README 변경 이력에 기록), README의 "현재 결정"만 갱신한다. → 왜 바뀌었는지 추적 가능.
- **규모/서비스 변화 가정**: 각 결정에는 "어떤 규모/조건에서 유효한가, 무엇이 바뀌면 재검토하는가"를 적어, 나중에 다시 열어볼 트리거를 남긴다.
- **근거 링크**: 결정은 [`../research/`](../research/README.md)의 조사 문서를 근거로 링크한다.

## ADR 템플릿 (세부 결정 문서용)

```markdown
# NNNN. <결정 제목>

- **상태**: 🟡 검토 중 | ✅ 확정 | ♻️ 대체됨 | ❌ 폐기
- **날짜**: YYYY-MM-DD
- **관련**: ../../api-db-design.md §X, ../../research/<주제>/README.md, 이슈 #N

## 맥락 (Context)
무엇을 정해야 하는가, 왜 지금 결정이 필요한가, 제약·규모 가정은 무엇인가.

## 선택지 (Options)
검토한 대안들과 장단점.

## 결정 (Decision)
무엇으로 정했는가.

## 근거 (Rationale)
그 선택의 이유. research 문서/데이터 근거를 링크.

## 영향 (Consequences)
바뀌는 것(스키마·API·UI·워크플로), 후속 작업, 트레이드오프.

## 재검토 트리거 (Revisit when)
어떤 규모/조건/지표가 되면 이 결정을 다시 연다.
```
