import 'package:json_annotation/json_annotation.dart';

/// 끼니 — openapi MealType.
enum MealType {
  @JsonValue('breakfast')
  breakfast,
  @JsonValue('lunch')
  lunch,
  @JsonValue('dinner')
  dinner,
  @JsonValue('snack')
  snack;

  String get wire => switch (this) {
        MealType.breakfast => 'breakfast',
        MealType.lunch => 'lunch',
        MealType.dinner => 'dinner',
        MealType.snack => 'snack',
      };

  String get labelKo => switch (this) {
        MealType.breakfast => '아침',
        MealType.lunch => '점심',
        MealType.dinner => '저녁',
        MealType.snack => '간식',
      };
}

/// 성별 — openapi Gender.
enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other;

  String get wire => switch (this) {
        Gender.male => 'male',
        Gender.female => 'female',
        Gender.other => 'other',
      };

  String get labelKo => switch (this) {
        Gender.male => '남성',
        Gender.female => '여성',
        Gender.other => '기타',
      };
}

/// 분석 상태 — openapi AnalysisStatus.
enum AnalysisStatus {
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed;
}
