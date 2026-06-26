# 친구 추천 (friend recommendation) — 결정

- **현재 상태**: ✅ 확정 — [0001 알고리즘 ADR](./0001-recommendation-algorithm.md) (가중치 수치는 데이터 쌓이며 튜닝)
- **최종 갱신**: 2026-06-26
- **관련**: [0001 ADR](./0001-recommendation-algorithm.md) · [설계](../../api-db-design.md) §1.5, §4.5~4.8, §9 · [리서치](../../research/friend-recommendation/README.md) · 이슈 [#1](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/1), [#2](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/2)
- **상위 카탈로그**: [../README.md](../README.md)

> 이 폴더는 "친구 추천" 결정 주제 하나를 담는다. 이 README는 **현재 유효한 결정**을 한눈에 보여주고,
> 결정이 규모/서비스 변화로 바뀌면 옛 결정은 `NNNN-*.md`로 남기고 여기 "현재 결정"과 "변경 이력"만 갱신한다.

## 현재 결정

상세·근거는 [0001 알고리즘 ADR](./0001-recommendation-algorithm.md). 요지:

- **골격**: 2단계 깔때기(후보 생성 → 결정론적 랭킹), v1은 ML 없음.
- **후보 소스(union + 우선순위)**: ① 친구의 친구(FoF) · ② 카카오 친구(검수 후) · ③ 활동/목표 유사도 폴백. (초안의 0명/1명+ 하드스위치 폐기)
- **랭킹 점수**: `w1·공통친구수 + w2·목표유사도 + w3·활동최근성 + w4·followerCount − w5·이미본디스카운트`, tie-break `id`.
- **네트워크 성숙도별 가중치 이동**: P0 런칭(목표유사도·활동 주력, mutual≈0) → P3 성숙(공통친구 지배).
- **관계 모델**: 단방향 follow. 카운터 `followerCount`(인기 정렬)/`followingCount`(FoF 탐색) 분리.
- **로그인**: 게스트 폴백 유지, 카카오는 선택(검수 의존성을 v1 출시 경로에서 분리).

리서치 근거 요지: 업계 1순위 신호는 friends-of-friends/공통친구 수지만 **런칭기엔 그래프가 비어 inert** → 우리가 이미 가진 `Profile`(필수 입력) 기반 **목표 유사도**가 콜드스타트 주력. 외부소스→그래프 전환은 가중치 블렌딩으로. → [리서치 인덱스](../../research/friend-recommendation/README.md).

## 확정된 질문 (← 0001 ADR에서 결론)

- [x] **(1) 친구 관계 모델** → **단방향 follow**. `followerCount`/`followingCount` 분리. (ADR §5)
- [x] **(2) 카카오 미연동/미동의 시 폴백** → **활동 + 목표 유사도**로 채워 빈 화면 방지. (ADR §6)
- [x] **(3) 카카오 로그인 vs 게스트** → **게스트 폴백 유지, 카카오 선택**. (ADR §7)
- [x] **(4) 추천 노출 디테일** → 이미 본/거절 디스카운트 + 슈퍼노드 degree cap/timeout. (ADR §3·§8)

## 후속 작업

- [x] `api-db-design.md` §2.2 스키마(`followerCount`/`followingCount`/`lastPostedAt`/`goalDirection`/`ageBucket` + `FriendRecFeedback`)·§4.3·§4.6~4.8·§4.11·§8·§9 동기화 (2026-06-26).
- [ ] `goalSimilarity` 정규화 상수(`NORM_w`/`NORM_cal`)·나이 버킷 경계 확정, 슈퍼노드 degree cap 임계값 결정.
- [ ] 가중치 `w1..w5` 초기값 결정(P0 런칭 프리셋: goalSimilarity·activity 우위).
- [ ] `prisma/seed.ts` — 다양한 목표/활동 분포로 폴백 검증.

## 재검토 트리거 (Revisit when)

- 사용자/친구 그래프가 커져 on-demand friends-of-friends 쿼리가 핫 경로 지연을 유발할 때 → precompute 전환 검토([05-아키텍처](../../research/friend-recommendation/05-architecture-and-scale.md) 단계 3).
- 카카오 외 로그인(구글 등)이나 연락처 매칭을 도입할 때 → 추천 소스·프라이버시 재검토.
- 친구 추천 수락률이 낮을 때 → 정렬 신호(공통친구 수 등) 추가 검토.

## 변경 이력 (Revision log)

| 날짜 | 변경 | 상태 |
|------|------|------|
| 2026-06 | 초안 — 잠정 결정 + 열린 질문 정리 | 🟡 검토 중 |
| 2026-06-26 | [0001 ADR](./0001-recommendation-algorithm.md) — 데이터 기반 단계별 알고리즘 확정(공통친구 1순위 + 목표유사도 콜드스타트 + 단방향 follow + 게스트 폴백) | ✅ 확정 |
