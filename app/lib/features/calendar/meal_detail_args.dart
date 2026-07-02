import '../../data/models/calendar.dart';
import '../../data/models/enums.dart';
import '../../data/models/food_record.dart';

class MealDetailArgs {
  const MealDetailArgs({
    required this.meal,
    required this.record,
    required this.day,
  });

  final MealType meal;
  final FoodRecordCard record;
  final CalendarDayResponse day;
}
