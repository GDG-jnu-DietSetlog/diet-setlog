import 'package:flutter_test/flutter_test.dart';
import 'package:diet_setlog/core/date_utils.dart';
import 'package:diet_setlog/data/models/calendar.dart';

void main() {
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
}
