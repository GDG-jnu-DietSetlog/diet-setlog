# 02. Lint / 빌드 / 테스트 / 커버리지

> 인덱스: [README.md](README.md) · 상위 카탈로그: [../README.md](../README.md)

코드 품질을 머지 전에 보장하는 핵심 게이트들. 우리 모노레포 기준 `app`(Flutter/Dart)·`server`(Node/TS) 양쪽 명령을 함께 정리한다.

---

## A. Lint / Format 검사

### (1) 무엇을 검사하는가
코드 스타일·정적 규칙 위반(ESLint), 포맷팅 일관성(Prettier / `dart format`), Dart 분석 경고(`flutter analyze` / `dart analyze`).

### (2) 왜 도입했는가
- **포맷 diff 노이즈 제거** → 리뷰가 로직에 집중. 사람이 손으로 스타일 지적하는 비용 제거.
- 미사용 변수, 잘못된 await, null 안전성 위반 등 **버그성 패턴을 머지 전에 차단**.

### (3) 어떻게 동작하는가
- `pull_request`/`push`에서 `--check`(변경 없으면 통과) 모드로 실행해 **수정이 필요하면 비0 종료**로 실패시킨다.
- Flutter: `dart format --output=none --set-exit-if-changed .` + `flutter analyze`(경고도 실패시키려면 `--fatal-infos`/`--fatal-warnings`).
- 대형 프로젝트는 **변경된 파일만 린트**(reviewdog, lint-staged 패턴)로 시간을 줄이기도 한다.

```yaml
# server(TS)
- run: npm ci
- run: npm run lint          # eslint
- run: npx prettier --check .

# app(Flutter/Dart)
- run: dart format --output=none --set-exit-if-changed .
- run: flutter analyze --fatal-infos
```

### (4) 실제 사용하는 프로젝트 예시
- **React, Next.js, Vue** — ESLint + Prettier를 PR 필수 체크로 운영.
- **Flutter/Dart SDK 및 공식 패키지** — `dart format`/`dart analyze`를 CI 필수 게이트로 사용.
- 대표 액션: `dart-lang/setup-dart`, `subosito/flutter-action`, `zgosalvez/github-actions-analyze-dart`, `reviewdog/action-eslint`.

> 출처: [zgosalvez/github-actions-analyze-dart](https://github.com/zgosalvez/github-actions-analyze-dart),
> [Invertase: GitHub Actions로 Flutter 코드 품질 보장](https://invertase.io/blog/github-actions-ensuring-quality-in-our-flutter-codebase),
> [Dart 공식 — Continuous integration](https://dart.dev/tools/continuous-integration).

---

## B. 타입체크 / 빌드 검사

### (1) 무엇을 검사하는가
타입 안정성(`tsc --noEmit`), 컴파일/번들이 깨지지 않는지(`next build`, `flutter build`), 여러 OS/런타임 버전 매트릭스에서의 빌드 성공.

### (2) 왜 도입했는가
- 린트만으로는 못 잡는 **타입 회귀**를 차단. "내 로컬에선 됐는데"를 막는 **재현 가능한 빌드** 보장.
- 멀티 플랫폼 앱은 Android/iOS, 멀티 Node 버전 등에서 **한쪽만 깨지는 회귀**를 매트릭스로 잡는다.

### (3) 어떻게 동작하는가
- `strategy.matrix`로 OS/버전 조합 빌드. 캐시(`actions/cache`, `setup-node` 내장 캐시, pub 캐시)로 가속.
- 빌드 산출물은 `actions/upload-artifact`로 올려 후속 잡(테스트/배포)에서 재사용.

```yaml
strategy:
  matrix:
    node: [18, 20, 22]
steps:
  - uses: actions/setup-node@v4
    with: { node-version: ${{ matrix.node }}, cache: npm }
  - run: npm ci
  - run: npx tsc --noEmit
  - run: npm run build
```

### (4) 실제 사용하는 프로젝트 예시
- **Node.js** — 다양한 OS/컴파일러 매트릭스로 빌드 검증.
- **VS Code, Electron** — Linux/macOS/Windows 매트릭스 빌드.
- **Next.js** — `next build` 및 타입체크를 CI에서 강제.

> 출처: [GitHub Actions: setup-node](https://github.com/actions/setup-node),
> [Node.js 저장소 .github/workflows](https://github.com/nodejs/node/tree/main/.github/workflows). (대형 프로젝트의 매트릭스 빌드는 널리 알려진 관행)

---

## C. 테스트 / 커버리지 게이트

### (1) 무엇을 검사하는가
유닛/통합/E2E 테스트 통과 여부, 그리고 **커버리지가 일정 기준 아래로 떨어지지 않는지(coverage drop 차단)**.

### (2) 왜 도입했는가
회귀 방지의 핵심. 커버리지 게이트는 "새 코드는 테스트와 함께"라는 문화를 **자동으로 강제**한다.

### (3) 어떻게 동작하는가
- 테스트 실행 후 커버리지 리포트 생성(JS: `jest --coverage`, Flutter: `flutter test --coverage` → `coverage/lcov.info`).
- `codecov/codecov-action`으로 업로드 → Codecov가 두 가지 status check를 생성:
  - **`codecov/project`**: 전체 프로젝트 커버리지를 base와 비교(전체 하락 차단).
  - **`codecov/patch`**: PR이 바꾼 **변경 라인**의 커버리지(새 코드 테스트 강제).
- `codecov.yml`의 `target`/`threshold`로 허용 하락폭 설정. 이 두 체크를 **required check**로 지정하면 하락 PR이 막힌다.

```yaml
- run: flutter test --coverage           # app/coverage/lcov.info
- uses: codecov/codecov-action@v4
  with:
    files: app/coverage/lcov.info
    token: ${{ secrets.CODECOV_TOKEN }}
```
```yaml
# codecov.yml
coverage:
  status:
    project: { default: { target: auto, threshold: 1% } }   # 1%p 초과 하락이면 실패
    patch:   { default: { target: 80% } }                    # 변경 라인 80% 이상
```

### (4) 실제 사용하는 프로젝트 예시
- **Codecov를 쓰는 다수 OSS**(Sentry, 다수 Python/JS 라이브러리). 대표 액션: `codecov/codecov-action`.

> 출처: [codecov/codecov-action](https://github.com/codecov/codecov-action),
> [Codecov Commit Status 문서](https://docs.codecov.com/docs/commit-status),
> [Flutter 테스트 커버리지](https://docs.flutter.dev/cookbook/testing/unit/introduction).
