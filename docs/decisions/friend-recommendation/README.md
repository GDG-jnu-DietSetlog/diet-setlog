# 친구 추천 (friend recommendation) — 결정

- **현재 상태**: 🟡 검토 중(미확정) — [리서치](../../research/friend-recommendation/README.md) 읽고 확정 예정
- **최종 갱신**: 2026-06
- **관련**: [설계](../../api-db-design.md) §1.5, §4.5~4.8, §9 · [리서치](../../research/friend-recommendation/README.md) · 이슈 [#1](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/1), [#2](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/2)
- **상위 카탈로그**: [../README.md](../README.md)

> 이 폴더는 "친구 추천" 결정 주제 하나를 담는다. 이 README는 **현재 유효한 결정**을 한눈에 보여주고,
> 결정이 규모/서비스 변화로 바뀌면 옛 결정은 `NNNN-*.md`로 남기고 여기 "현재 결정"과 "변경 이력"만 갱신한다.

## 현재 결정 (잠정)

확정된 부분 (설계 §4.6 기준, 변경 가능):

- 친구 0명 → **카카오톡 친구**(우리 앱 가입자) 기반 추천
- 친구 1명+ → **친구의 친구(friends-of-friends)** 기반 추천
- 공통 정렬: **친구수↓ → 활동수(postCount)↓**, tie-break `id`, cursor 무한스크롤

리서치 근거 요지: 업계 공통 1순위 신호는 friends-of-friends/공통친구 수, 콜드스타트는 외부 소스로 첫 엣지를 만든 뒤 그래프로 전환. → [리서치 인덱스](../../research/friend-recommendation/README.md).

## 열린 질문 (확정 필요)

리서치 검토 후 확정한다. 확정되면 각 항목을 `0001-*.md` 등 세부 결정 문서로 떼거나 여기에 결론을 적는다.

- [ ] **(1) 친구 관계 모델**: 단방향 follow vs 상호 친구(수락 필요) — friendCount 집계·"친구의 친구" 탐색 방향이 갈림.
  근거: [01-글로벌 서비스](../../research/friend-recommendation/01-global-services-pymk.md), [02-알고리즘](../../research/friend-recommendation/02-algorithms-and-signals.md)
- [ ] **(2) 카카오 친구목록 미연동/미동의 시 "친구 0명" 폴백**: seed·인기/활동 추천 vs 빈 상태+동의 유도.
  근거: [03-콜드스타트](../../research/friend-recommendation/03-cold-start.md), [04-연락처매칭/프라이버시](../../research/friend-recommendation/04-contacts-matching-and-privacy.md)
- [ ] **(3) 카카오 로그인 vs 익명 게스트**: 카카오 로그인 필수 vs 게스트 폴백 유지 (이슈 #1 "로그인 없이 v1"과 충돌 정리).
  근거: [03-콜드스타트](../../research/friend-recommendation/03-cold-start.md), [04-연락처매칭/프라이버시](../../research/friend-recommendation/04-contacts-matching-and-privacy.md)
- [ ] **(4) 추천 노출 디테일**(선택): 이미 본/거절한 추천 디스카운트, 슈퍼노드 fan-out 가드.
  근거: [05-아키텍처/스케일](../../research/friend-recommendation/05-architecture-and-scale.md)

## 재검토 트리거 (Revisit when)

- 사용자/친구 그래프가 커져 on-demand friends-of-friends 쿼리가 핫 경로 지연을 유발할 때 → precompute 전환 검토([05-아키텍처](../../research/friend-recommendation/05-architecture-and-scale.md) 단계 3).
- 카카오 외 로그인(구글 등)이나 연락처 매칭을 도입할 때 → 추천 소스·프라이버시 재검토.
- 친구 추천 수락률이 낮을 때 → 정렬 신호(공통친구 수 등) 추가 검토.

## 변경 이력 (Revision log)

| 날짜 | 변경 | 상태 |
|------|------|------|
| 2026-06 | 초안 — 잠정 결정 + 열린 질문 정리 | 🟡 검토 중 |
