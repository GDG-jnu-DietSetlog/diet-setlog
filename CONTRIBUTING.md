# 기여 가이드 (Contributing)

diet-setlog 협업 규칙입니다. 브랜치 전략, 커밋 컨벤션, PR 절차를 정의합니다.

---

## 브랜치 규칙

### 기본 브랜치
- `main` — 항상 배포 가능한 상태. 직접 push 금지, **PR로만** 병합.
- (선택) `develop` — 통합 브랜치를 둘 경우 기능 브랜치는 여기서 분기.

### 브랜치 네이밍
```
<type>/<이슈번호>-<짧은-설명>
```
- 예시
  - `feat/12-set-log-screen`
  - `fix/34-token-refresh`
  - `chore/5-ci-setup`
- 규칙
  - 소문자 + 하이픈(kebab-case) 사용, 한글 X.
  - `<type>`은 커밋 타입과 동일(아래 표 참고): `feat`, `fix`, `docs`, `refactor`, `chore` 등.
  - 이슈가 있으면 번호를 포함한다.

### 작업 흐름
1. `main`(또는 `develop`)에서 최신 상태로 브랜치 생성.
2. 작은 단위로 커밋(컨벤션 준수).
3. PR 생성 → 리뷰 → 승인 후 병합.
4. 병합은 **Squash and merge** 권장(히스토리를 깔끔하게).
5. 병합된 브랜치는 삭제.

---

## 커밋 컨벤션 (Angular)

[Angular Commit Convention](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)을 따릅니다.

### 형식
```
<type>(<scope>): <subject>

<body>

<footer>
```

- **header(`<type>(<scope>): <subject>`)는 필수**, body·footer는 선택.
- 한 줄 요약(subject)은 50자 이내 권장, 마침표(.) 없이.
- subject는 명령형 현재시제로: "추가한다"보다 "추가" / "add" 형태.

### type 목록
| type | 설명 |
|------|------|
| `feat` | 새로운 기능 |
| `fix` | 버그 수정 |
| `docs` | 문서 변경 |
| `style` | 코드 포맷팅, 세미콜론 등 (동작 변화 없음) |
| `refactor` | 리팩터링 (기능 변화 없는 코드 개선) |
| `perf` | 성능 개선 |
| `test` | 테스트 추가/수정 |
| `build` | 빌드 시스템, 의존성 변경 (pub, npm 등) |
| `ci` | CI 설정 변경 |
| `chore` | 그 외 잡일 (설정, 스크립트 등) |
| `revert` | 이전 커밋 되돌리기 |

### scope (선택)
변경 영역을 표기. 모노레포이므로 다음을 권장:
- `app` — Flutter 앱
- `server` — 백엔드 API
- `api` — 앱↔서버 계약(스키마/OpenAPI)
- `infra`, `ci`, `deps` 등

### subject 작성
- 무엇을 했는지 간결하게. 예) `feat(app): 세트 기록 화면 추가`

### body (선택)
- 무엇을·왜 바꿨는지 설명(어떻게는 코드가 말함). 한 줄 72자 내외로 줄바꿈.

### footer (선택)
- 이슈 참조: `Closes #12`, `Refs #34`
- Breaking change:
  ```
  BREAKING CHANGE: 세션 저장 방식을 JWT로 변경. 기존 세션 무효화됨.
  ```

### 예시
```
feat(app): 세트 기록 화면 추가

운동별 무게/횟수를 입력하고 저장하는 화면 구현.
Riverpod로 상태 관리, 서버 계약에 맞춘 불변 모델 사용.

Closes #12
```
```
fix(server): 토큰 갱신 시 만료 검증 누락 수정

Refs #34
```

---

## 커밋 메시지 템플릿 적용 (선택)

저장소에 포함된 `.gitmessage` 템플릿을 사용하려면:
```bash
git config commit.template .gitmessage
```

---

## PR 규칙

- 제목은 커밋 컨벤션과 동일: `type(scope): subject`
- PR 템플릿의 체크리스트를 채운다.
- 변경 전 셀프 검증으로 루프를 닫는다:
  - app: `flutter analyze`, `flutter test`
  - server: `npm run lint`, `npm test`, `npx tsc --noEmit`
- 시크릿을 커밋하지 않았는지 확인한다.
