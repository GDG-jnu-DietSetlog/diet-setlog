import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_typography.dart';
import '../app_spacing.dart';

/// 영양소(탄단지) 표시 — design-system §4.5. 박스형/막대형/칩형 3종.

enum Macro { protein, carbs, fat }

extension MacroStyle on Macro {
  String get label => switch (this) {
        Macro.protein => '단백질',
        Macro.carbs => '탄수화물',
        Macro.fat => '지방',
      };
  Color get textColor => switch (this) {
        Macro.protein => AppColors.proteinText,
        Macro.carbs => AppColors.carbsText,
        Macro.fat => AppColors.fatText,
      };
  Color get chipColor => switch (this) {
        Macro.protein => AppColors.proteinChip,
        Macro.carbs => AppColors.carbsText,
        Macro.fat => AppColors.fatText,
      };
  Color get barColor => switch (this) {
        Macro.protein => AppColors.proteinBar,
        Macro.carbs => AppColors.carbsBar,
        Macro.fat => AppColors.fatBar,
      };
}

/// 박스형(기록 작성) — 103×56, border, radius12, 라벨+값.
class NutritionBox extends StatelessWidget {
  const NutritionBox({super.key, required this.macro, required this.grams});
  final Macro macro;
  final num grams;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(macro.label,
              style:
                  AppType.label(color: AppColors.text85, w: FontWeight.w600)),
          SizedBox(height: 2.h),
          Text('${_fmt(grams)}g',
              style: AppType.value(color: macro.textColor)
                  .copyWith(fontSize: 17.sp)),
        ],
      ),
    );
  }
}

/// 막대형(피드/캘린더) — 막대 h5~6, radius9, 트랙 회색.
class NutritionBar extends StatelessWidget {
  const NutritionBar({super.key, required this.macro, required this.ratio});
  final Macro macro;
  final double ratio; // 0~1

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.r9.r),
      child: LinearProgressIndicator(
        value: ratio.clamp(0, 1),
        minHeight: 5.h,
        backgroundColor: const Color(0xFFD9D9D9),
        valueColor: AlwaysStoppedAnimation(macro.barColor),
      ),
    );
  }
}

String _fmt(num n) => n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);
