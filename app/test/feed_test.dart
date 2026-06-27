import 'package:flutter_test/flutter_test.dart';
import 'package:diet_setlog/data/models/common.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/feed.dart';
import 'package:diet_setlog/features/feed/feed_controller.dart';

FeedPost _post({bool liked = false, int likes = 0, int comments = 0}) =>
    FeedPost(
      recordId: 'r1',
      author: const UserRef(id: 'u1', displayName: '서진'),
      title: '닭가슴살 샐러드',
      imageUrl: null,
      mealType: MealType.lunch,
      eatenAt: DateTime(2026, 6, 27, 12),
      totalCalories: 420,
      macros: const Macros(proteinG: 38, carbsG: 32, fatG: 14),
      likeCount: likes,
      commentCount: comments,
      likedByMe: liked,
      previewComments: const [],
    );

void main() {
  test('FeedState.hasMore reflects nextCursor', () {
    const a = FeedState();
    expect(a.hasMore, isFalse);
    expect(a.copyWith(nextCursor: 'abc').hasMore, isTrue);
    expect(a.copyWith(nextCursor: 'abc').copyWith(clearCursor: true).hasMore,
        isFalse);
  });

  test('FeedPost.copyWith toggles like fields (optimistic)', () {
    final p = _post(liked: false, likes: 2);
    final liked = p.copyWith(likedByMe: true, likeCount: 3);
    expect(liked.likedByMe, isTrue);
    expect(liked.likeCount, 3);
  });

  test('FeedPost tolerates null imageUrl and parses meal/macros', () {
    final p = _post(comments: 5);
    expect(p.imageUrl, isNull);
    expect(p.mealType, MealType.lunch);
    expect(p.commentCount, 5);
  });
}
