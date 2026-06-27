import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/date_utils.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../routing/route_paths.dart';
import 'calendar_providers.dart';

/// 캘린더 월간(`19:675`). screens.md §11. 날짜 탭 → 일별 요약.
/// 친구추가 UI 는 제거 확정(spec-lock §2-7).
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focused = dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedDateProvider);
    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Text('캘린더', style: AppType.appBar()),
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.r12.r),
              ),
              child: TableCalendar(
                locale: 'ko_KR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focused,
                currentDay: dateOnly(DateTime.now()),
                selectedDayPredicate: (d) => isSameDay(d, selected),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                availableGestures: AvailableGestures.horizontalSwipe,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  todayDecoration: const BoxDecoration(
                    color: AppColors.primaryTint,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: AppType.body(
                      color: AppColors.primary, w: FontWeight.w700),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: AppType.body(
                      color: AppColors.onPrimary, w: FontWeight.w700),
                ),
                onPageChanged: (focused) => _focused = focused,
                onDaySelected: (selectedDay, focusedDay) {
                  final d = dateOnly(selectedDay);
                  ref.read(selectedDateProvider.notifier).state = d;
                  setState(() => _focused = focusedDay);
                  context.push(Routes.dailySummary, extra: d);
                },
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text('날짜를 선택하면 그날의 섭취 요약을 볼 수 있어요.',
                  style: AppType.body(color: AppColors.text87)),
            ),
          ],
        ),
      ),
    );
  }
}
