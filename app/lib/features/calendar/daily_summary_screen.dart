import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/api/api_exception.dart';
import '../../core/date_utils.dart';
import '../../data/models/calendar.dart';
import '../../data/models/enums.dart';
import '../../data/models/food_record.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/app_top_bar.dart';
import 'calendar_providers.dart';

/// 캘린더 일별 섭취 요약(`19:1562`). screens.md §12.
/// 끼니 row 클릭 → 상세 이동은 범위 밖(api-db-design §6).
class DailySummaryScreen extends ConsumerWidget {
  const DailySummaryScreen({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider(ymd(date)));
    final dateLabel = DateFormat('yyyy년 M월 d일 EEEE', 'ko_KR').format(date);

    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      appBar: const AppTopBar(title: '오늘 섭취 요약'),
      body: SafeArea(
        child: summary.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary)),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e is ApiException ? e.userMessage : '불러오지 못했어요.',
                    style: AppType.body(color: AppColors.text82)),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(dailySummaryProvider(ymd(date))),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
          data: (data) => _Body(dateLabel: dateLabel, data: data),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.dateLabel, required this.data});
  final String dateLabel;
  final CalendarDayResponse data;

  @override
  Widget build(BuildContext context) {
    final meals = <(MealType, List<FoodRecordCard>)>[
      (MealType.breakfast, data.recordsByMeal.breakfast),
      (MealType.lunch, data.recordsByMeal.lunch),
      (MealType.dinner, data.recordsByMeal.dinner),
      (MealType.snack, data.recordsByMeal.snack),
    ];
    final hasAny = meals.any((m) => m.$2.isNotEmpty);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      children: [
        SizedBox(height: 8.h),
        Center(
            child: Text(dateLabel,
                style: AppType.appBar(color: AppColors.black)
                    .copyWith(fontWeight: FontWeight.w600))),
        SizedBox(height: 20.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DonutCard(percent: data.progressPercent),
              SizedBox(width: 12.w),
              Expanded(child: _SummaryCard(data: data)),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text('끼니별 기록',
            style: AppType.appBar().copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        if (!hasAny)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Center(
              child: Text('이 날의 기록이 없어요.',
                  style: AppType.body(color: AppColors.text82)),
            ),
          )
        else
          for (final (meal, records) in meals)
            for (final r in records) _MealRow(meal: meal, record: r),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.r,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r10.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Center(
        child: SizedBox(
          width: 96.r,
          height: 96.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 96.r,
                height: 96.r,
                child: CircularProgressIndicator(
                  value: (percent / 100).clamp(0, 1),
                  strokeWidth: 10,
                  backgroundColor: AppColors.primaryTint,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              Text('$percent %',
                  style: AppType.value(color: AppColors.primary)
                      .copyWith(fontSize: 22.sp)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});
  final CalendarDayResponse data;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r10.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('섭취 ${fmt.format(data.totalCalories)}kcal',
              style: AppType.bodyBold(color: AppColors.primary)),
          SizedBox(height: 2.h),
          Text('목표 ${fmt.format(data.calorieTarget)}kcal',
              style: AppType.label(color: AppColors.text87)),
          const Divider(height: 16, color: AppColors.borderField),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _macroChip('단백질', data.macros.proteinG, AppColors.proteinChip),
              _macroChip('탄수', data.macros.carbsG, AppColors.carbsBar),
              _macroChip('지방', data.macros.fatG, AppColors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroChip(String label, double g, Color color) {
    final v = g % 1 == 0 ? g.toInt().toString() : g.toStringAsFixed(1);
    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppType.label(color: AppColors.text85)),
          SizedBox(height: 2.h),
          Text('${v}g', style: AppType.bodyBold(color: color)),
        ],
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({required this.meal, required this.record});
  final MealType meal;
  final FoodRecordCard record;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(record.eatenAt.toLocal());
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: 4.h),
              Container(
                width: 18.r,
                height: 18.r,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
              ),
              SizedBox(height: 4.h),
              Text(time,
                  style: AppType.micro(
                      color: AppColors.text85, w: FontWeight.w500)),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: BorderRadius.circular(AppSpacing.r12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(meal.labelKo,
                          style: AppType.label(
                              color: AppColors.primary, w: FontWeight.w700)),
                      Text('${record.totalCalories}kcal',
                          style: AppType.label(
                              color: AppColors.text4D, w: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(record.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.body().copyWith(fontSize: 15.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
