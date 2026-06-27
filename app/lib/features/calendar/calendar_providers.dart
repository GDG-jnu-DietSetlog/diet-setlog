import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/date_utils.dart';
import '../../core/providers.dart';
import '../../data/models/calendar.dart';

/// 캘린더에서 선택된 날짜(기본 오늘).
final selectedDateProvider =
    StateProvider<DateTime>((ref) => dateOnly(DateTime.now()));

/// 일별 요약(GET /v1/calendar/daily-summary?date=). 키 = YYYY-MM-DD.
final dailySummaryProvider =
    FutureProvider.family<CalendarDayResponse, String>((ref, date) async {
  return ref.read(calendarApiProvider).dailySummary(date);
});
