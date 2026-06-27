import '../../core/api/dio_client.dart';
import '../models/enums.dart';
import '../models/feed.dart';

class FeedApi {
  FeedApi(this._client);
  final ApiClient _client;

  /// GET /v1/feed — 나∪팔로위 공개 글(keyset). mealType 필터 옵션.
  Future<FeedResponse> getFeed(
      {String? cursor, int? limit, MealType? mealType}) async {
    final data = await _client.send((dio) => dio.get('/feed', queryParameters: {
          if (cursor != null) 'cursor': cursor,
          if (limit != null) 'limit': limit,
          if (mealType != null) 'mealType': mealType.wire,
        }));
    return FeedResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /v1/posts/{recordId}/like (멱등).
  Future<LikeResult> like(String recordId) async {
    final data = await _client.send((dio) => dio.post('/posts/$recordId/like'));
    return LikeResult.fromJson(data as Map<String, dynamic>);
  }

  /// DELETE /v1/posts/{recordId}/like (멱등).
  Future<LikeResult> unlike(String recordId) async {
    final data =
        await _client.send((dio) => dio.delete('/posts/$recordId/like'));
    return LikeResult.fromJson(data as Map<String, dynamic>);
  }

  /// GET /v1/posts/{recordId}/comments (createdAt asc keyset).
  Future<CommentListResponse> comments(String recordId,
      {String? cursor, int? limit}) async {
    final data = await _client.send((dio) => dio.get(
          '/posts/$recordId/comments',
          queryParameters: {
            if (cursor != null) 'cursor': cursor,
            if (limit != null) 'limit': limit,
          },
        ));
    return CommentListResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /v1/posts/{recordId}/comments — body 1~300자.
  Future<Comment> addComment(String recordId, String body) async {
    final data = await _client.send((dio) => dio.post(
          '/posts/$recordId/comments',
          data: {'body': body},
        ));
    return Comment.fromJson(
        (data as Map<String, dynamic>)['comment'] as Map<String, dynamic>);
  }
}
