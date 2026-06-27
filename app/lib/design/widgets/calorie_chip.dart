import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_typography.dart';
import '../app_spacing.dart';

/// 칼로리 칩(사진 위 오버레이) — design-system §4.6. 120×42, 흰 배경, radius46,
/// AI 그라데이션 배지 + 수치 + "kcal".
class CalorieChip extends StatelessWidget {
  const CalorieChip({super.key, required this.kcal});
  final int kcal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r46.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              gradient: AppColors.aiGradient,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.auto_awesome,
                size: 16.r, color: AppColors.onPrimary),
          ),
          SizedBox(width: 6.w),
          Text('$kcal', style: AppType.title()),
          SizedBox(width: 3.w),
          Text('kcal',
              style:
                  AppType.label(color: AppColors.text6B, w: FontWeight.w600)),
        ],
      ),
    );
  }
}
