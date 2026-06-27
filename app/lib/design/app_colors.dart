import 'package:flutter/material.dart';

/// 디자인 토큰 — 색상. 출처: docs/plans/design-system.md §1.
/// Figma "프롭 팀" Dev Mode 측정값.
abstract final class AppColors {
  // ── Primary ──
  static const primary = Color(0xFF1B68FF); // 블루1
  static const primaryTint = Color(0xFFE9F2FF); // 블루2 — AI/연락처/끼니 카드·선택 토글 배경
  static const onPrimary = Color(0xFFFFFFFF);

  // ── 배경/표면 ──
  static const white = Color(0xFFFFFFFF);
  static const bgSheet = Color(0xFFF7F7F8); // 하단 시트/패널
  static const bgInput = Color(0xFFF4F4F5); // 입력칩·검색바·아바타 배경
  static const bgNavInactive = Color(0xFFEDEDED); // bottom nav 비활성 아이콘 배경
  static const skeleton = Color(0xFFF2F2F3);

  // ── 테두리 ──
  static const border = Color(0xFFE0E0E2); // 카드/박스 일반
  static const borderField = Color(0xFFEFF0F1); // 입력 필드 기본
  static const borderFocus = Color(0xFF1B68FF); // 입력 필드 포커스

  // ── 텍스트 그레이 스케일(강→약) — design-system §1.3 ──
  static const black = Color(0xFF000000);
  static const text171 = Color(0xFF171717);
  static const text48 = Color(0xFF48484C);
  static const text4D = Color(0xFF4D4E51);
  static const text51 = Color(0xFF515255);
  static const text6B = Color(0xFF6B6B6B);
  static const text85 = Color(0xFF858588);
  static const text87 = Color(0xFF878789);
  static const textC7 = Color(0xFFC7C8C9);
  static const textCA = Color(0xFFCACACB); // 캘린더 점(없음)·약한 회색·카운터
  static const textD5 = Color(0xFFD5D6E1); // "나" 라벨
  static const textC5 = Color(0xFFC5C5C6); // placeholder·미선택 토글 텍스트
  static const textBF = Color(0xFFBFC0C1); // 검색바 placeholder
  static const text82 = Color(0xFF82878F); // 보조 회색

  // ── 영양소 ──
  static const proteinText = Color(0xFF007D2F);
  static const proteinChip = Color(0xFF00741E);
  static const proteinBar = Color(0xFF01D225);
  static const carbsText = Color(0xFF1B68FF);
  static const carbsBar = Color(0xFF4583FF);
  static const fatText = Color(0xFF252525);
  static const fatBar = Color(0xFFFDDA08);

  // ── 상태 ──
  static const success = Color(0xFF00C321); // 저장 성공 체크
  static const successText = Color(0xFF007016); // "남음"
  static const successText2 = Color(0xFF00991B); // "AI 분석 완료"
  static const verifyRing = Color(0xFF00B31D); // 피드 인증 아바타 링
  static const calendarDotActive = Color(0xFF26CF51); // 기록 점(있음)

  // ── 다크 화면(카메라/분석) — design-system §6 ──
  static const darkBg = Color(0xFF0C0C0D);
  static const darkBtn = Color(0xFF2E2E2F);

  /// 이니셜 아바타 색 세트 — design-system §1.5. (bg, fg) 5종.
  static const avatarSets = <(Color, Color)>[
    (Color(0xFFFFE7C6), Color(0xFFBB6C2C)),
    (Color(0xFFD3E5FF), Color(0xFF305CB7)),
    (Color(0xFFFFDFEE), Color(0xFFD03A81)),
    (Color(0xFFC6F4DE), Color(0xFF008C4C)),
    (Color(0xFFE7DCFF), Color(0xFF7959BD)),
  ];

  // ── 그라데이션 — design-system §1.4 ──
  static const aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B68FF), Color(0xFF83FFC4)],
    stops: [0.186, 0.877],
  );
  static const progressGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1B68FF), Color(0xFF01D225)],
    stops: [0.402, 0.843],
  );
}
