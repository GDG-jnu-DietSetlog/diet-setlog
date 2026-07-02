import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:diet_setlog/core/api/dio_client.dart';
import 'package:diet_setlog/core/date_utils.dart';
import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/data/api/calendar_api.dart';
import 'package:diet_setlog/data/models/common.dart';
import 'package:diet_setlog/data/models/calendar.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/food_record.dart';
import 'package:diet_setlog/features/calendar/calendar_screen.dart';
import 'package:diet_setlog/features/calendar/meal_detail_args.dart';
import 'package:diet_setlog/features/calendar/meal_detail_screen.dart';

CalendarDayResponse _day() => CalendarDayResponse(
      date: '2026-06-27',
      calorieTarget: 1650,
      totalCalories: 1210,
      macros: const Macros(proteinG: 38, carbsG: 32, fatG: 14),
      progressPercent: 73,
      recordsByMeal: RecordsByMeal(
        breakfast: [_record(meal: MealType.breakfast)],
        lunch: const [],
        dinner: const [],
        snack: const [],
      ),
    );

FoodRecordCard _record({required MealType meal}) => FoodRecordCard(
      id: 'record-1',
      title: '블루베리 오트밀 시리얼',
      imageUrl: null,
      mealType: meal,
      eatenAt: DateTime(2026, 6, 27, 8, 12),
      totalCalories: 318,
      macros: const Macros(proteinG: 18, carbsG: 51, fatG: 18),
      publishedToFeed: true,
      likeCount: 0,
      commentCount: 0,
      items: const [
        FoodItem(
          id: 'item-1',
          name: '블루베리',
          amount: '50g',
          calories: 40,
          proteinG: 0.5,
          carbsG: 10,
          fatG: 0.2,
          sortOrder: 0,
        ),
      ],
    );

class FakeCalendarApi extends CalendarApi {
  FakeCalendarApi(this.response)
      : super(ApiClient(dio: Dio(), tokenHolder: SessionTokenHolder()));

  final CalendarDayResponse response;
  String? requestedDate;

  @override
  Future<CalendarDayResponse> dailySummary(String date) async {
    requestedDate = date;
    return response;
  }
}

Future<void> _pumpWithScreenUtil(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(home: child),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ko_KR');
  });

  test('ymd pads month/day', () {
    expect(ymd(DateTime(2026, 6, 7)), '2026-06-07');
    expect(ymd(DateTime(2026, 12, 31)), '2026-12-31');
  });

  test('CalendarDayResponse.fromJson keeps all 4 meal keys', () {
    final res = CalendarDayResponse.fromJson({
      'date': '2026-06-27',
      'calorieTarget': 1650,
      'totalCalories': 1210,
      'macros': {'proteinG': 38, 'carbsG': 32, 'fatG': 14},
      'progressPercent': 73,
      'recordsByMeal': {
        'breakfast': [],
        'lunch': [],
        'dinner': [],
        'snack': [],
      },
    });
    expect(res.progressPercent, 73);
    expect(res.recordsByMeal.breakfast, isEmpty);
    expect(res.recordsByMeal.snack, isEmpty);
  });

  testWidgets('CalendarScreen renders selected day summary and meal detail CTA',
      (tester) async {
    final fake = FakeCalendarApi(_day());
    await _pumpWithScreenUtil(
      tester,
      const CalendarScreen(),
      overrides: [calendarApiProvider.overrideWithValue(fake)],
    );

    await tester.pumpAndSettle();

    expect(find.text('캘린더'), findsOneWidget);
    expect(find.text('끼니별 기록'), findsOneWidget);
    expect(find.text('블루베리 오트밀 시리얼'), findsOneWidget);
    expect(find.text('자세히 보기'), findsOneWidget);
    expect(fake.requestedDate, isNotNull);
  });

  testWidgets('MealDetailScreen renders record items and nutrition summary',
      (tester) async {
    final day = _day();
    final record = day.recordsByMeal.breakfast.single;
    await _pumpWithScreenUtil(
      tester,
      MealDetailScreen(
        args: MealDetailArgs(
          meal: MealType.breakfast,
          record: record,
          day: day,
        ),
      ),
    );

    expect(find.text('블루베리 오트밀 시리얼'), findsOneWidget);
    expect(find.text('블루베리 50g'), findsOneWidget);
    expect(find.text('단백질'), findsOneWidget);
    expect(find.text('아침 칼로리'), findsOneWidget);
    expect(find.text('닫기'), findsOneWidget);
  });
}
