import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/data/api/feed_api.dart';
import 'package:diet_setlog/data/models/common.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/feed.dart';
import 'package:diet_setlog/data/models/food_record.dart';
import 'package:diet_setlog/data/models/home.dart';
import 'package:diet_setlog/features/feed/feed_screen.dart';
import 'package:diet_setlog/features/home/home_providers.dart';
import 'package:diet_setlog/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomeScreen renders Figma v2 empty shared-post state',
      (tester) async {
    await _setPhoneSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        overrides: [
          homeProvider.overrideWith((ref) async => HomeResponse(
                currentUser: const UserRef(id: 'me', displayName: '재현'),
                todaySummary: const DailySummary(
                  date: '2026-07-02',
                  calorieTarget: 1800,
                  totalCalories: 0,
                  macros: Macros(proteinG: 0, carbsG: 0, fatG: 0),
                  remainingCalories: 1800,
                ),
                friendsCertifiedToday: [
                  CertifiedFriend(
                    id: 'u1',
                    displayName: '김서진',
                    certifiedAt: DateTime(2026, 7, 2, 12, 30),
                  ),
                ],
                recentRecords: const <FoodRecordCard>[],
              )),
        ],
        child: const HomeScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('오늘 인증한 친구'), findsOneWidget);
    expect(find.text('김서진'), findsOneWidget);
    expect(find.text('최근 공유된 게시물이 없어요.'), findsOneWidget);
  });

  testWidgets('FeedScreen renders Figma v2 story strip and calorie chip',
      (tester) async {
    await _setPhoneSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        overrides: [
          feedApiProvider.overrideWithValue(_FakeFeedApi(
            FeedResponse(posts: [_feedPost()]),
          )),
        ],
        child: const FeedScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('오늘 인증한 친구'), findsOneWidget);
    expect(find.text('전체'), findsOneWidget);
    expect(find.text('AI 분석 완료'), findsOneWidget);
    expect(find.text('스테이크 버섯 볶음'), findsOneWidget);
  });

  testWidgets('FeedStoryScreen renders Figma v2 dated story replay',
      (tester) async {
    await _setPhoneSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        overrides: [
          feedApiProvider.overrideWithValue(_FakeFeedApi(
            FeedResponse(posts: [_feedPost()]),
          )),
        ],
        child: FeedStoryScreen(date: DateTime(2026, 5, 24)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('2026년 5월 24일(일)'), findsOneWidget);
    expect(find.text('스토리 다시보기'), findsOneWidget);
    expect(find.text('나의 기록'), findsOneWidget);
    expect(find.text('친구 기록'), findsOneWidget);
    expect(find.text('스테이크 버섯 볶음'), findsOneWidget);
  });
}

Future<void> _setPhoneSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  return Future<void>.value();
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, required this.overrides});

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(home: child),
      ),
    );
  }
}

class _FakeFeedApi implements FeedApi {
  _FakeFeedApi(this.response);

  final FeedResponse response;
  DateTime? lastDate;
  FeedScope? lastScope;

  @override
  Future<FeedResponse> getFeed({
    String? cursor,
    int? limit,
    MealType? mealType,
    DateTime? date,
    FeedScope scope = FeedScope.all,
  }) async {
    lastDate = date;
    lastScope = scope;
    return response;
  }

  @override
  Future<LikeResult> like(String recordId) async =>
      LikeResult(recordId: recordId, liked: true, likeCount: 25);

  @override
  Future<LikeResult> unlike(String recordId) async =>
      LikeResult(recordId: recordId, liked: false, likeCount: 23);

  @override
  Future<CommentListResponse> comments(String recordId,
          {String? cursor, int? limit}) async =>
      const CommentListResponse();

  @override
  Future<Comment> addComment(String recordId, String body) async => Comment(
        id: 'c2',
        author: const UserRef(id: 'me', displayName: '나'),
        body: body,
        createdAt: DateTime(2026, 7, 2),
      );
}

FeedPost _feedPost() => FeedPost(
      recordId: 'r1',
      author: const UserRef(id: 'u1', displayName: '김서연'),
      title: '스테이크 버섯 볶음',
      mealType: MealType.lunch,
      eatenAt: DateTime.now().subtract(const Duration(minutes: 32)),
      totalCalories: 420,
      macros: const Macros(proteinG: 38, carbsG: 32, fatG: 14),
      memo: '운동 끝나고 단백질 듬뿍 채웠어요.',
      likeCount: 24,
      commentCount: 5,
      likedByMe: true,
      previewComments: [
        Comment(
          id: 'c1',
          author: const UserRef(id: 'u2', displayName: '이도윤'),
          body: '비주얼 미쳤다 진짜 맛있겠다',
          createdAt: DateTime.now(),
        ),
      ],
    );
