# Plans — 구현 계획 & 설계

diet-setlog의 **구현 계획·API/DB 설계** 문서를 모아둔 디렉터리.
"무엇을 어떤 순서로, 어떤 계약/스키마로 만들지"의 단일 기준이 되는 문서들이다.

- **조사·근거**는 [`../research/`](../research/README.md), **확정 결정(ADR)**은 [`../decisions/`](../decisions/README.md), **계획·설계**는 여기 `plans/`.
- 설계 문서의 "열린 질문"이 결정되면 그 결과를 [`../decisions/`](../decisions/README.md)에 ADR로 남기고, 이 폴더의 설계 문서를 갱신한다.

## 문서 목록

| 문서 | 한 줄 요약 |
|------|-----------|
| **[spec-lock.md](spec-lock.md)** | ⭐ **재현성 잠금 — 충돌 시 최우선.** 문서 간 모순 해소·매직넘버·응답 스키마·추천 상수·Gemini 프롬프트·툴링/버전 확정 |
| **[openapi.yaml](openapi.yaml)** | ⭐ **API 계약 단일 진실원(Swagger/OpenAPI 3.1).** 전 엔드포인트 요청·응답 기계 판독본 (Dart 모델 생성·서버 검증 기준) |
| [dietsetlog-wireframe-plan.md](dietsetlog-wireframe-plan.md) | 1차 구현 범위(익명 세션→프로필→홈→촬영/분석→기록→캘린더→친구→피드) 와이어프레임 구현 계획 (이슈 [#1](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/1)) |
| [api-db-design.md](api-db-design.md) | 위 계획의 API 흐름·계약·DB 스키마 설계 (Express + TS + Prisma + PostgreSQL) |
| [design-system.md](design-system.md) | Figma 추출 디자인 토큰(색·타이포·간격·radius)·공통 컴포넌트·디자인↔API 정합 |
| [screens.md](screens.md) | 화면 12개 레이아웃 스펙(Figma 노드 매핑·좌표·치수) |

> **읽는 순서**: 빌드 전 [spec-lock.md](spec-lock.md)를 먼저 읽어 확정값을 잡고, 계약은 [openapi.yaml](openapi.yaml), 화면은 screens/design-system, 플로우는 wireframe-plan으로 본다.

> 디자인 출처: Figma "프롭 팀" 파일(`WgmQmy0thsZO3mJ5gcO5zH`). **읽기 전용 — 절대 수정 금지.**
