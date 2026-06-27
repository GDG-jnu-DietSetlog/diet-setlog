import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// 디자인 토큰 — 타이포그래피(Pretendard). 출처: design-system.md §2.
/// 크기는 .sp 로 스케일(designSize 390×844, spec-lock §11).
abstract final class AppType {
  static const _family = 'Pretendard';

  static TextStyle _s(double size, FontWeight w,
          {Color color = AppColors.black, double? height}) =>
      TextStyle(
        fontFamily: _family,
        fontSize: size.sp,
        fontWeight: w,
        color: color,
        height: height,
      );

  // Display 34 Bold — 대형 kcal 수치
  static TextStyle display({Color color = AppColors.black}) =>
      _s(34, FontWeight.w700, color: color);
  // Title 20 Bold — 화면 제목·칼로리칩
  static TextStyle title({Color color = AppColors.black}) =>
      _s(20, FontWeight.w700, color: color);
  // Value 18 Bold — 입력값·영양소 값
  static TextStyle value({Color color = AppColors.black}) =>
      _s(18, FontWeight.w700, color: color);
  // AppBar 16 Bold — 앱바·CTA·음식명
  static TextStyle appBar({Color color = AppColors.black}) =>
      _s(16, FontWeight.w700, color: color);
  // Body 14 — 본문·카드 제목·라벨
  static TextStyle body(
          {Color color = AppColors.black, FontWeight w = FontWeight.w500}) =>
      _s(14, w, color: color);
  static TextStyle bodyBold({Color color = AppColors.black}) =>
      _s(14, FontWeight.w700, color: color);
  // Caption 13 SemiBold — 단위·"수정" 링크
  static TextStyle caption(
          {Color color = AppColors.black, FontWeight w = FontWeight.w600}) =>
      _s(13, w, color: color);
  // Label 12 — 보조 라벨·메타·뱃지
  static TextStyle label(
          {Color color = AppColors.black, FontWeight w = FontWeight.w500}) =>
      _s(12, w, color: color);
  // Micro 11 SemiBold — 피드 영양 라벨·끼니 뱃지
  static TextStyle micro(
          {Color color = AppColors.black, FontWeight w = FontWeight.w600}) =>
      _s(11, w, color: color);
}
