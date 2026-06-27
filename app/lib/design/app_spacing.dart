/// 디자인 토큰 — 간격/모서리. 출처: design-system.md §3.
abstract final class AppSpacing {
  /// 공통 좌우 마진(콘텐츠 폭 342).
  static const double pageH = 24;
  static const double contentW = 342;

  // radius 스케일
  static const double r4 = 4; // "자세히 보기" 미니 칩
  static const double r10 = 10; // 캘린더 요약 카드
  static const double r12 = 12; // 버튼·카드·입력 필드·칩 표준
  static const double r20 = 20; // 뱃지(끼니)
  static const double r26 = 26; // 뱃지(현재대비)·검색 토스트
  static const double r46 = 46; // 칼로리칩
  static const double r52 = 52; // bottom nav 바
  static const double r9 = 9; // 진행바

  // 공통 gap
  static const double gapLabelField = 8;
  static const double gapInputGroup = 36;
}
