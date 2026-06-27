import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_spacing.dart';

/// 진행바 — design-system §4.9. 채움은 그라데이션 또는 단색.
class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar({
    super.key,
    required this.ratio,
    this.height = 8,
    this.gradient = AppColors.progressGradient,
    this.track = const Color(0xFFD9D9D9),
  });

  final double ratio; // 0~1
  final double height;
  final Gradient gradient;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return Container(
        height: height.h,
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(AppSpacing.r9.r),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: c.maxWidth * ratio.clamp(0, 1),
            height: height.h,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppSpacing.r9.r),
            ),
          ),
        ),
      );
    });
  }
}
