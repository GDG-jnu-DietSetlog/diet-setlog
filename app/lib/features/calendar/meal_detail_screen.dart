import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/common.dart';
import '../../data/models/enums.dart';
import '../../data/models/food_record.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/primary_button.dart';
import 'meal_detail_args.dart';

/// 끼니별 기록 자세히보기 — Figma 2차 `56:2254`.
class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key, required this.args});
  final MealDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final record = args.record;
    final meal = args.meal;
    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20.r, color: AppColors.black),
        ),
        title: _MealTitle(meal: meal),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _HeroImage(record: record),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleRow(record: record),
                  SizedBox(height: 14.h),
                  _DetailCard(
                      record: record, dayTarget: args.day.calorieTarget),
                  SizedBox(height: 24.h),
                  PrimaryButton(label: '닫기', onPressed: () => context.pop()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealTitle extends StatelessWidget {
  const _MealTitle({required this.meal});
  final MealType meal;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppType.appBar(color: AppColors.black),
        children: [
          const TextSpan(text: '끼니별 기록 '),
          TextSpan(
            text: '(${meal.labelKo})',
            style: AppType.appBar(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.record});
  final FoodRecordCard record;

  @override
  Widget build(BuildContext context) {
    if (record.imageUrl == null || record.imageUrl!.isEmpty) {
      return Container(
        height: 232.h,
        width: double.infinity,
        color: AppColors.skeleton,
        child: Icon(Icons.restaurant, size: 52.r, color: AppColors.textC5),
      );
    }
    return CachedNetworkImage(
      imageUrl: record.imageUrl!,
      height: 232.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(
        height: 232.h,
        color: AppColors.skeleton,
        child: Icon(Icons.restaurant, size: 52.r, color: AppColors.textC5),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.record});
  final FoodRecordCard record;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            record.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppType.appBar().copyWith(fontSize: 18.sp),
          ),
        ),
        SizedBox(width: 12.w),
        Text('저장하기',
            style:
                AppType.caption(color: AppColors.text4D, w: FontWeight.w700)),
        SizedBox(width: 4.w),
        Icon(Icons.bookmark_border, size: 22.r, color: AppColors.text4D),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.record, required this.dayTarget});
  final FoodRecordCard record;
  final int dayTarget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemsWrap(items: record.items),
          SizedBox(height: 18.h),
          _MacroTargetBox(macros: record.macros, calorieTarget: dayTarget),
          SizedBox(height: 18.h),
          _CalorieProgress(record: record, dayTarget: dayTarget),
        ],
      ),
    );
  }
}

class _ItemsWrap extends StatelessWidget {
  const _ItemsWrap({required this.items});
  final List<FoodItem> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.isEmpty
        ? [
            const FoodItem(
                id: 'title',
                name: '음식 정보',
                calories: 0,
                proteinG: 0,
                carbsG: 0,
                fatG: 0,
                sortOrder: 0)
          ]
        : items;
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final item in visibleItems)
          Container(
            constraints: BoxConstraints(minWidth: 95.w),
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.successText2),
              borderRadius: BorderRadius.circular(AppSpacing.r12.r),
            ),
            child: Text(
              _itemLabel(item),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppType.label(color: AppColors.text4D, w: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  String _itemLabel(FoodItem item) {
    if (item.amount != null && item.amount!.isNotEmpty) {
      return '${item.name} ${item.amount}';
    }
    return item.name;
  }
}

class _MacroTargetBox extends StatelessWidget {
  const _MacroTargetBox({required this.macros, required this.calorieTarget});
  final Macros macros;
  final int calorieTarget;

  @override
  Widget build(BuildContext context) {
    final targets = _MacroTargets.fromCalories(calorieTarget);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Column(
        children: [
          _MacroRow(
            label: '단백질',
            value: macros.proteinG,
            target: targets.proteinG,
            color: AppColors.proteinText,
          ),
          SizedBox(height: 10.h),
          _MacroRow(
            label: '탄수화물',
            value: macros.carbsG,
            target: targets.carbsG,
            color: AppColors.carbsText,
          ),
          SizedBox(height: 10.h),
          _MacroRow(
            label: '지방',
            value: macros.fatG,
            target: targets.fatG,
            color: AppColors.fatText,
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  final String label;
  final double value;
  final int target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 76.w,
          child: Text(label,
              style: AppType.body(color: AppColors.black, w: FontWeight.w600)),
        ),
        Expanded(
          child: Text(
            '${_formatGram(value)} / ${target}g',
            textAlign: TextAlign.right,
            style: AppType.value(color: color),
          ),
        ),
      ],
    );
  }
}

class _CalorieProgress extends StatelessWidget {
  const _CalorieProgress({required this.record, required this.dayTarget});
  final FoodRecordCard record;
  final int dayTarget;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();
    final ratio = dayTarget == 0 ? 0.0 : record.totalCalories / dayTarget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${record.mealType.labelKo} 칼로리',
            style: AppType.body(color: AppColors.black, w: FontWeight.w600)),
        SizedBox(height: 8.h),
        RichText(
          text: TextSpan(
            style: AppType.display(color: AppColors.primary),
            children: [
              TextSpan(text: formatter.format(record.totalCalories)),
              TextSpan(
                text: ' / ${formatter.format(dayTarget)} kcal',
                style: AppType.body(color: AppColors.text6B),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: LinearProgressIndicator(
            minHeight: 8.h,
            value: ratio.clamp(0.0, 1.0),
            backgroundColor: AppColors.primaryTint,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _MacroTargets {
  const _MacroTargets({
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final int proteinG;
  final int carbsG;
  final int fatG;

  /// API에는 macro target이 없어, 상세 화면 보조값으로만 30/40/30 kcal 비율을 환산한다.
  factory _MacroTargets.fromCalories(int calories) {
    if (calories <= 0) {
      return const _MacroTargets(proteinG: 0, carbsG: 0, fatG: 0);
    }
    return _MacroTargets(
      proteinG: (calories * 0.30 / 4).round(),
      carbsG: (calories * 0.40 / 4).round(),
      fatG: (calories * 0.30 / 9).round(),
    );
  }
}

String _formatGram(double value) {
  if (value % 1 == 0) return value.toInt().toString();
  return value.toStringAsFixed(1);
}
