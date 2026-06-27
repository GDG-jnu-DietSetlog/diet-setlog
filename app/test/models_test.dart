import 'package:flutter_test/flutter_test.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/food_record.dart';
import 'package:diet_setlog/data/models/feed.dart';
import 'package:diet_setlog/data/models/profile.dart';

void main() {
  test('FoodRecordCard.fromJson maps all fields', () {
    final card = FoodRecordCard.fromJson({
      'id': 'r1',
      'title': '닭가슴살 샐러드볼',
      'imageUrl': 'http://localhost:4443/dietsetlog/analyses/a.jpg',
      'mealType': 'lunch',
      'eatenAt': '2026-06-27T03:30:00.000Z',
      'totalCalories': 420,
      'macros': {'proteinG': 38, 'carbsG': 32, 'fatG': 14},
      'memo': '맛있었다',
      'publishedToFeed': true,
      'likeCount': 3,
      'commentCount': 1,
      'items': [
        {
          'id': 'i1',
          'name': '닭가슴살',
          'amount': '100g',
          'calories': 165,
          'proteinG': 31,
          'carbsG': 0,
          'fatG': 3.6,
          'sortOrder': 0,
        }
      ],
    });
    expect(card.mealType, MealType.lunch);
    expect(card.macros.proteinG, 38.0);
    expect(card.items.single.name, '닭가슴살');
    expect(card.publishedToFeed, isTrue);
  });

  test('FeedPost tolerates null imageUrl (server deviation)', () {
    final post = FeedPost.fromJson({
      'recordId': 'r1',
      'author': {'id': 'u1', 'displayName': '서진'},
      'title': '점심',
      'imageUrl': null,
      'mealType': 'dinner',
      'eatenAt': '2026-06-27T10:00:00.000Z',
      'totalCalories': 500,
      'macros': {'proteinG': 30, 'carbsG': 40, 'fatG': 12},
      'likeCount': 0,
      'commentCount': 0,
      'likedByMe': false,
      'previewComments': [],
    });
    expect(post.imageUrl, isNull);
    expect(post.author.displayName, '서진');
  });

  test('ProfileResponse handles profile:null', () {
    final res = ProfileResponse.fromJson({
      'profile': null,
      'dailyCalorieTarget': 0,
      'weeklyWeightDelta': 0,
    });
    expect(res.profile, isNull);
    expect(res.dailyCalorieTarget, 0);
  });
}
