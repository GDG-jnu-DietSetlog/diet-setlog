import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/date_utils.dart';
import '../../data/models/calendar.dart';
import '../../data/models/enums.dart';
import '../../data/models/food_record.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../routing/route_paths.dart';
import 'calendar_providers.dart';
import 'meal_detail_args.dart';

/// 캘린더 2차 통합 화면(`56:3309`, `56:1879`).
/// 월간 달력 아래에 선택일 섭취 요약과 끼니별 기록을 한 화면에서 보여준다.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focused = dateOnly(DateTime.now());
  CalendarFormat _format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedDateProvider);
    final summary = ref.watch(dailySummaryProvider(ymd(selected)));
    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async =>
              ref.refresh(dailySummaryProvider(ymd(selected)).future),
          child: ListView(
            padding: EdgeInsets.only(bottom: 96.h),
            children: [
              SizedBox(height: 12.h),
              Text('캘린더', textAlign: TextAlign.center, style: AppType.appBar()),
              SizedBox(height: 16.h),
              _CalendarCard(
                focused: _focused,
                selected: selected,
                format: _format,
                onFormatChanged: (format) => setState(() => _format = format),
                onPageChanged: (focused) => setState(() => _focused = focused),
                onDaySelected: (selectedDay, focusedDay) {
                  ref.read(selectedDateProvider.notifier).state =
                      dateOnly(selectedDay);
                  setState(() => _focused = focusedDay);
                },
              ),
              SizedBox(height: 24.h),
              summary.when(
                loading: () => Padding(
                  padding: EdgeInsets.symmetric(vertical: 72.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                error: (e, _) => _SummaryError(
                  onRetry: () =>
                      ref.invalidate(dailySummaryProvider(ymd(selected))),
                ),
                data: (data) => _SelectedDaySummary(
                  selected: selected,
                  data: data,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.focused,
    required this.selected,
    required this.format,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.onDaySelected,
  });

  final DateTime focused;
  final DateTime selected;
  final CalendarFormat format;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final ValueChanged<DateTime> onPageChanged;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focused,
        currentDay: dateOnly(DateTime.now()),
        selectedDayPredicate: (d) => isSameDay(d, selected),
        calendarFormat: format,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.horizontalSwipe,
        onFormatChanged: onFormatChanged,
        onPageChanged: onPageChanged,
        onDaySelected: onDaySelected,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
          titleTextFormatter: (date, locale) =>
              DateFormat('yyyy년   M월', locale).format(date),
          titleTextStyle: AppType.value(color: AppColors.primary),
          headerPadding: EdgeInsets.fromLTRB(0, 4.h, 0, 12.h),
          headerMargin: EdgeInsets.only(left: 2.w, right: 190.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          ),
        ),
        daysOfWeekHeight: 32.h,
        rowHeight: 51.h,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppType.bodyBold(color: AppColors.black),
          weekendStyle: AppType.bodyBold(color: AppColors.black),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          markerDecoration: const BoxDecoration(
            color: AppColors.calendarDotActive,
            shape: BoxShape.circle,
          ),
          todayDecoration: const BoxDecoration(
            color: AppColors.primaryTint,
            shape: BoxShape.circle,
          ),
          todayTextStyle:
              AppType.body(color: AppColors.primary, w: FontWeight.w700),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle:
              AppType.body(color: AppColors.onPrimary, w: FontWeight.w700),
          defaultTextStyle: AppType.bodyBold(),
          weekendTextStyle: AppType.bodyBold(),
          outsideTextStyle: AppType.body(color: const Color(0xFF686C72)),
        ),
      ),
    );
  }
}

class _SelectedDaySummary extends StatelessWidget {
  const _SelectedDaySummary({required this.selected, required this.data});
  final DateTime selected;
  final CalendarDayResponse data;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('yyyy년 M월 d일(E) 섭취 요약', 'ko_KR').format(selected);
    final meals = <(MealType, List<FoodRecordCard>)>[
      (MealType.breakfast, data.recordsByMeal.breakfast),
      (MealType.lunch, data.recordsByMeal.lunch),
      (MealType.snack, data.recordsByMeal.snack),
      (MealType.dinner, data.recordsByMeal.dinner),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 32.h),
          child: Column(
            children: [
              Text(dateLabel, style: AppType.appBar()),
              SizedBox(height: 18.h),
              Center(child: _DonutCard(percent: data.progressPercent)),
              SizedBox(height: 12.h),
              _SummaryCard(data: data),
            ],
          ),
        ),
        Container(
          color: AppColors.white,
          margin: EdgeInsets.only(top: 24.h),
          padding: EdgeInsets.fromLTRB(15.w, 28.h, 22.w, 28.h),
          child: Column(
            children: [
              Text('끼니별 기록', style: AppType.appBar()),
              SizedBox(height: 20.h),
              if (meals.every((m) => m.$2.isEmpty))
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Text('이 날의 기록이 없어요.',
                      style: AppType.body(color: AppColors.text82)),
                )
              else
                _MealTimeline(meals: meals, day: data),
            ],
          ),
        ),
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
      width: 100.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r10.r),
        border: Border.all(color: const Color(0xFFA6A8AC)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 84.r,
            height: 84.r,
            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0, 1),
              strokeWidth: 12,
              backgroundColor: const Color(0xFFE1E1E1),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Text('$percent %',
              style: AppType.value(color: AppColors.primary)
                  .copyWith(fontSize: 20.sp)),
        ],
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
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r10.r),
        border: Border.all(color: const Color(0xFFA6A8AC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryLine('섭취', '${fmt.format(data.totalCalories)}kcal',
              valueColor: AppColors.primary),
          SizedBox(height: 8.h),
          _summaryLine('목표', '${fmt.format(data.calorieTarget)}kcal'),
          const Divider(height: 16, color: AppColors.borderField),
          Row(
            children: [
              _macroChip('단백질', data.macros.proteinG, AppColors.proteinChip),
              SizedBox(width: 6.w),
              _macroChip('탄수화물', data.macros.carbsG, AppColors.carbsBar),
              SizedBox(width: 6.w),
              _macroChip('지방', data.macros.fatG, AppColors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryLine(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label, style: AppType.body(color: AppColors.black)),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(value,
                style: AppType.bodyBold(color: valueColor ?? AppColors.black)),
          ),
        ),
      ],
    );
  }

  Widget _macroChip(String label, double g, Color color) {
    final value = g % 1 == 0 ? g.toInt().toString() : g.toStringAsFixed(1);
    return Expanded(
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.primaryTint.withValues(alpha: 0.53),
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child:
                    Text(label, style: AppType.micro(color: AppColors.black)),
              ),
            ),
            SizedBox(height: 2.h),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${value}g', style: AppType.bodyBold(color: color)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealTimeline extends StatelessWidget {
  const _MealTimeline({required this.meals, required this.day});
  final List<(MealType, List<FoodRecordCard>)> meals;
  final CalendarDayResponse day;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final (meal, records) in meals)
        for (final record in records) (meal, record),
    ];
    return Stack(
      children: [
        Positioned(
          left: 3.w,
          top: 10.h,
          bottom: 10.h,
          child: Container(width: 1, color: AppColors.border),
        ),
        Column(
          children: [
            for (final row in rows) ...[
              _MealRecordRow(meal: row.$1, record: row.$2, day: day),
              SizedBox(height: 16.h),
            ],
          ],
        ),
      ],
    );
  }
}

class _MealRecordRow extends StatelessWidget {
  const _MealRecordRow({
    required this.meal,
    required this.record,
    required this.day,
  });

  final MealType meal;
  final FoodRecordCard record;
  final CalendarDayResponse day;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('H:mm').format(record.eatenAt.toLocal());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryTint, width: 2.r),
          ),
        ),
        SizedBox(width: 4.w),
        SizedBox(
          width: 32.w,
          child: Text(time,
              textAlign: TextAlign.center,
              style: AppType.micro(color: AppColors.black, w: FontWeight.w500)
                  .copyWith(fontSize: 10.sp)),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.r12.r),
            onTap: () => context.push(
              Routes.mealDetail,
              extra: MealDetailArgs(meal: meal, record: record, day: day),
            ),
            child: Container(
              constraints: BoxConstraints(minHeight: 65.h),
              padding: EdgeInsets.fromLTRB(13.w, 9.h, 10.w, 9.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.r12.r),
                border: Border.all(color: AppColors.primary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(meal.labelKo,
                          style: AppType.label(
                              color: AppColors.black, w: FontWeight.w700)),
                      Text('(${record.totalCalories} kcal)',
                          style: AppType.label(
                              color: AppColors.primary, w: FontWeight.w700)),
                      Container(
                        height: 18.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.text85, width: 0.5.w),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('자세히 보기',
                              style: AppType.micro(color: AppColors.text85)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    record.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body(color: AppColors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 72.h),
      child: Column(
        children: [
          Text('섭취 요약을 불러오지 못했어요.',
              style: AppType.body(color: AppColors.text82)),
          SizedBox(height: 12.h),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
