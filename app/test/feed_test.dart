import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/data/api/feed_api.dart';
import 'package:diet_setlog/data/models/common.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/feed.dart';
import 'package:diet_setlog/features/feed/feed_controller.dart';

FeedPost _post({
  String id = 'r1',
  bool liked = false,
  int likes = 0,
  int comments = 0,
}) =>
    FeedPost(
      recordId: id,
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

/// 호출별 응답을 큐로 돌려주는 FeedApi 페이크.
class FakeFeedApi implements FeedApi {
  FeedResponse feedResponse = const FeedResponse();
  LikeResult? likeResult;
  bool throwOnGetFeed = false;
  bool throwOnLike = false;

  int getFeedCalls = 0;
  String? lastCursor;
  MealType? lastMealType;

  /// getFeed 를 잠시 붙잡아 in-flight 상태를 만들기 위한 게이트.
  Completer<void>? gate;

  @override
  Future<FeedResponse> getFeed(
      {String? cursor, int? limit, MealType? mealType}) async {
    getFeedCalls++;
    lastCursor = cursor;
    lastMealType = mealType;
    if (gate != null) await gate!.future;
    if (throwOnGetFeed) throw Exception('boom');
    return feedResponse;
  }

  @override
  Future<LikeResult> like(String recordId) async {
    if (throwOnLike) throw Exception('boom');
    return likeResult ??
        LikeResult(recordId: recordId, liked: true, likeCount: 1);
  }

  @override
  Future<LikeResult> unlike(String recordId) async {
    if (throwOnLike) throw Exception('boom');
    return likeResult ??
        LikeResult(recordId: recordId, liked: false, likeCount: 0);
  }

  @override
  Future<CommentListResponse> comments(String recordId,
          {String? cursor, int? limit}) async =>
      throw UnimplementedError();

  @override
  Future<Comment> addComment(String recordId, String body) async =>
      throw UnimplementedError();
}

/// 마이크로태스크/이벤트 큐를 충분히 비운다(페이크는 실제 타이머를 쓰지 않음).
Future<void> _settle() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

ProviderContainer _container(FakeFeedApi fake) {
  final c = ProviderContainer(
    overrides: [feedApiProvider.overrideWithValue(fake)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  // ── 기존 테스트(모델/상태) — 그대로 유지 ──
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

  // ── refresh ──
  group('FeedController.refresh', () {
    test('성공 시 posts/nextCursor 채우고 loading 해제', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1')], nextCursor: 'c1');
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle(); // build() 의 자동 refresh 가 끝나길 기다림

      final s = ctrl.state;
      expect(s.loading, isFalse);
      expect(s.error, isNull);
      expect(s.posts.single.recordId, 'r1');
      expect(s.nextCursor, 'c1');
      expect(s.hasMore, isTrue);
    });

    test('nextCursor 가 null 이면 hasMore=false (clearCursor)', () async {
      final fake = FakeFeedApi()
        ..feedResponse = FeedResponse(posts: [_post()], nextCursor: null);
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      expect(ctrl.state.nextCursor, isNull);
      expect(ctrl.state.hasMore, isFalse);
    });

    test('실패 시 error 메시지 설정, loading 해제', () async {
      final fake = FakeFeedApi()..throwOnGetFeed = true;
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      expect(ctrl.state.loading, isFalse);
      expect(ctrl.state.error, '피드를 불러오지 못했어요.');
      expect(ctrl.state.posts, isEmpty);
    });
  });

  // ── loadMore ──
  group('FeedController.loadMore', () {
    test('다음 페이지를 append 하고 cursor 갱신', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1')], nextCursor: 'c1');
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.getFeedCalls = 0;
      fake.feedResponse =
          FeedResponse(posts: [_post(id: 'r2')], nextCursor: null);
      await ctrl.loadMore();

      expect(fake.getFeedCalls, 1);
      expect(fake.lastCursor, 'c1'); // 직전 nextCursor 로 요청
      expect(ctrl.state.posts.map((p) => p.recordId), ['r1', 'r2']);
      expect(ctrl.state.hasMore, isFalse);
      expect(ctrl.state.loadingMore, isFalse);
    });

    test('hasMore=false 이면 no-op (요청하지 않음)', () async {
      final fake = FakeFeedApi()
        ..feedResponse = FeedResponse(posts: [_post()], nextCursor: null);
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.getFeedCalls = 0;
      await ctrl.loadMore();
      expect(fake.getFeedCalls, 0);
    });

    test('이미 loadingMore 중이면 두 번째 호출은 no-op', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1')], nextCursor: 'c1');
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.getFeedCalls = 0;
      fake.feedResponse =
          FeedResponse(posts: [_post(id: 'r2')], nextCursor: null);
      fake.gate = Completer<void>();

      final f1 = ctrl.loadMore(); // in-flight (게이트 대기)
      expect(ctrl.state.loadingMore, isTrue);
      final f2 = ctrl.loadMore(); // 가드로 즉시 반환

      fake.gate!.complete();
      await Future.wait([f1, f2]);

      expect(fake.getFeedCalls, 1); // 실제 요청은 1회뿐
      expect(ctrl.state.posts.map((p) => p.recordId), ['r1', 'r2']);
    });

    test('실패 시 loadingMore 만 해제하고 목록 유지', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1')], nextCursor: 'c1');
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.throwOnGetFeed = true;
      await ctrl.loadMore();

      expect(ctrl.state.loadingMore, isFalse);
      expect(ctrl.state.posts.map((p) => p.recordId), ['r1']); // 변화 없음
    });
  });

  // ── toggleLike ──
  group('FeedController.toggleLike', () {
    test('낙관적 +1 후 서버 값으로 reconcile', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1', liked: false, likes: 2)]);
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.likeResult =
          const LikeResult(recordId: 'r1', liked: true, likeCount: 5);

      final post = ctrl.state.posts.first;
      final f = ctrl.toggleLike(post);

      // 낙관적: 즉시 2→3, liked=true
      expect(ctrl.state.posts.first.likeCount, 3);
      expect(ctrl.state.posts.first.likedByMe, isTrue);

      await f;
      // reconcile: 서버 값 5
      expect(ctrl.state.posts.first.likeCount, 5);
      expect(ctrl.state.posts.first.likedByMe, isTrue);
    });

    test('unlike 경로: 낙관적 -1 후 reconcile', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1', liked: true, likes: 5)]);
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.likeResult =
          const LikeResult(recordId: 'r1', liked: false, likeCount: 4);

      final post = ctrl.state.posts.first;
      final f = ctrl.toggleLike(post);
      expect(ctrl.state.posts.first.likeCount, 4);
      expect(ctrl.state.posts.first.likedByMe, isFalse);

      await f;
      expect(ctrl.state.posts.first.likeCount, 4);
      expect(ctrl.state.posts.first.likedByMe, isFalse);
    });

    test('실패 시 원래 값으로 롤백', () async {
      final fake = FakeFeedApi()
        ..feedResponse =
            FeedResponse(posts: [_post(id: 'r1', liked: false, likes: 2)]);
      final c = _container(fake);
      final ctrl = c.read(feedControllerProvider.notifier);
      await _settle();

      fake.throwOnLike = true;
      final post = ctrl.state.posts.first;
      final f = ctrl.toggleLike(post);
      expect(ctrl.state.posts.first.likeCount, 3); // 낙관적 적용
      expect(ctrl.state.posts.first.likedByMe, isTrue);

      await f;
      expect(ctrl.state.posts.first.likeCount, 2); // 롤백
      expect(ctrl.state.posts.first.likedByMe, isFalse);
    });
  });

  // ── syncLike / bumpCommentCount ──
  test('syncLike 는 일치하는 글만 패치, 없으면 no-op', () async {
    final fake = FakeFeedApi()
      ..feedResponse = FeedResponse(posts: [
        _post(id: 'r1', liked: false, likes: 1),
        _post(id: 'r2', liked: false, likes: 7),
      ]);
    final c = _container(fake);
    final ctrl = c.read(feedControllerProvider.notifier);
    await _settle();

    ctrl.syncLike('r1', liked: true, likeCount: 9);
    expect(ctrl.state.posts[0].likedByMe, isTrue);
    expect(ctrl.state.posts[0].likeCount, 9);
    expect(ctrl.state.posts[1].likeCount, 7); // r2 그대로

    final before = ctrl.state;
    ctrl.syncLike('does-not-exist', liked: true, likeCount: 100);
    expect(identical(ctrl.state, before), isTrue); // 상태 객체 자체가 그대로
  });

  test('bumpCommentCount 는 일치하는 글의 카운트만 +1', () async {
    final fake = FakeFeedApi()
      ..feedResponse = FeedResponse(posts: [
        _post(id: 'r1', comments: 0),
        _post(id: 'r2', comments: 4),
      ]);
    final c = _container(fake);
    final ctrl = c.read(feedControllerProvider.notifier);
    await _settle();

    ctrl.bumpCommentCount('r1');
    expect(ctrl.state.posts[0].commentCount, 1);
    expect(ctrl.state.posts[1].commentCount, 4);
  });

  test('setFilter 는 필터를 반영해 다시 조회한다', () async {
    final fake = FakeFeedApi()..feedResponse = const FeedResponse();
    final c = _container(fake);
    final ctrl = c.read(feedControllerProvider.notifier);
    await _settle();

    fake.feedResponse = FeedResponse(posts: [_post(id: 'r9')]);
    await ctrl.setFilter(MealType.dinner);

    expect(ctrl.state.filter, MealType.dinner);
    expect(fake.lastMealType, MealType.dinner);
    expect(ctrl.state.posts.single.recordId, 'r9');
  });
}
