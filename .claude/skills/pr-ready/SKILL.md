---
name: pr-ready
description: 커밋/푸시 전 점검 체크리스트를 실행한다. "PR 준비", "올리기 전에 확인", "릴리스 점검" 시 사용.
disable-model-invocation: true
---

푸시 전 다음을 순서대로 실행하고, 실패하면 멈추고 원인을 보고하라:

1. 변경 범위 파악: `git status --short` + `git diff HEAD`
2. 린트: 해당 패키지에서 `npm run lint`
3. 타입체크: `npx tsc --noEmit`
4. 테스트: 변경된 영역 위주로 `npm test`
5. 시크릿이 staged 되지 않았는지 확인(`.env`, 키 파일)
6. 앱↔서버 API 계약 변경이 있으면 양쪽 모두 반영됐는지 확인

모두 통과하면 명확한 커밋 메시지를 제안하라(아직 커밋하지는 말 것).
