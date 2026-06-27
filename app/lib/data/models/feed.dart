import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';
import 'enums.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

/// openapi Comment.
@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required UserRef author,
    required String body,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

/// openapi FeedPost. ⚠️ imageUrl 은 스펙상 required지만 서버 구현상 null 가능 → nullable.
@freezed
class FeedPost with _$FeedPost {
  const factory FeedPost({
    required String recordId,
    required UserRef author,
    required String title,
    String? imageUrl,
    required MealType mealType,
    required DateTime eatenAt,
    required int totalCalories,
    required Macros macros,
    String? memo,
    required int likeCount,
    required int commentCount,
    required bool likedByMe,
    @Default(<Comment>[]) List<Comment> previewComments,
  }) = _FeedPost;

  factory FeedPost.fromJson(Map<String, dynamic> json) =>
      _$FeedPostFromJson(json);
}

@freezed
class FeedResponse with _$FeedResponse {
  const factory FeedResponse({
    @Default(<FeedPost>[]) List<FeedPost> posts,
    String? nextCursor,
  }) = _FeedResponse;

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);
}

/// openapi LikeResult.
@freezed
class LikeResult with _$LikeResult {
  const factory LikeResult({
    required String recordId,
    required bool liked,
    required int likeCount,
  }) = _LikeResult;

  factory LikeResult.fromJson(Map<String, dynamic> json) =>
      _$LikeResultFromJson(json);
}

@freezed
class CommentListResponse with _$CommentListResponse {
  const factory CommentListResponse({
    @Default(<Comment>[]) List<Comment> comments,
    String? nextCursor,
  }) = _CommentListResponse;

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);
}
