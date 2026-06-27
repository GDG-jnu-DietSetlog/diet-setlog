import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/env.dart';
import '../../core/providers.dart';
import '../../data/models/enums.dart';
import '../../data/models/feed.dart';

class FeedState {
  const FeedState({
    this.posts = const [],
    this.nextCursor,
    this.filter,
    this.loading = true,
    this.loadingMore = false,
    this.error,
  });

  final List<FeedPost> posts;
  final String? nextCursor;
  final MealType? filter;
  final bool loading;
  final bool loadingMore;
  final String? error;

  bool get hasMore => nextCursor != null;

  FeedState copyWith({
    List<FeedPost>? posts,
    String? nextCursor,
    bool clearCursor = false,
    MealType? filter,
    bool clearFilter = false,
    bool? loading,
    bool? loadingMore,
    String? error,
    bool clearError = false,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      filter: clearFilter ? null : (filter ?? this.filter),
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class FeedController extends Notifier<FeedState> {
  @override
  FeedState build() {
    Future.microtask(refresh);
    return const FeedState();
  }

  Future<void> setFilter(MealType? meal) async {
    state = FeedState(filter: meal, loading: true);
    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await ref.read(feedApiProvider).getFeed(
            limit: Env.defaultLimit,
            mealType: state.filter,
          );
      state = state.copyWith(
        posts: res.posts,
        nextCursor: res.nextCursor,
        clearCursor: res.nextCursor == null,
        loading: false,
      );
    } catch (_) {
      state = state.copyWith(loading: false, error: '피드를 불러오지 못했어요.');
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final res = await ref.read(feedApiProvider).getFeed(
            cursor: state.nextCursor,
            limit: Env.defaultLimit,
            mealType: state.filter,
          );
      state = state.copyWith(
        posts: [...state.posts, ...res.posts],
        nextCursor: res.nextCursor,
        clearCursor: res.nextCursor == null,
        loadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(loadingMore: false);
    }
  }

  /// 좋아요 토글(낙관적). 실패 시 롤백.
  Future<void> toggleLike(FeedPost post) async {
    final liked = !post.likedByMe;
    _patch(post.recordId,
        liked: liked, likeCount: post.likeCount + (liked ? 1 : -1));
    try {
      final api = ref.read(feedApiProvider);
      final res = liked
          ? await api.like(post.recordId)
          : await api.unlike(post.recordId);
      _patch(post.recordId, liked: res.liked, likeCount: res.likeCount);
    } catch (_) {
      _patch(post.recordId, liked: post.likedByMe, likeCount: post.likeCount);
    }
  }

  /// 상세 화면에서 좋아요가 바뀌었을 때 목록 상태만 동기화(API 재호출 없음).
  void syncLike(String recordId, {required bool liked, required int likeCount}) {
    if (state.posts.every((p) => p.recordId != recordId)) return;
    _patch(recordId, liked: liked, likeCount: likeCount);
  }

  /// 댓글 작성 후 카운트 +1(미리보기 갱신은 다음 새로고침에 반영).
  void bumpCommentCount(String recordId) {
    state = state.copyWith(
      posts: [
        for (final p in state.posts)
          if (p.recordId == recordId)
            p.copyWith(commentCount: p.commentCount + 1)
          else
            p,
      ],
    );
  }

  void _patch(String recordId, {required bool liked, required int likeCount}) {
    state = state.copyWith(
      posts: [
        for (final p in state.posts)
          if (p.recordId == recordId)
            p.copyWith(likedByMe: liked, likeCount: likeCount)
          else
            p,
      ],
    );
  }
}

final feedControllerProvider =
    NotifierProvider<FeedController, FeedState>(FeedController.new);
