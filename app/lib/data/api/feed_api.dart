import '../../core/api/dio_client.dart';
import '../models/enums.dart';
import '../models/feed.dart';

enum FeedScope { all, mine, friends }

class FeedApi {
  FeedApi(this._client);
  final ApiClient _client;

  /// GET /v1/feed — 나∪팔로위 공개 글(keyset).
  /// mealType/date/scope 필터 옵션.
  Future<FeedResponse> getFeed({
    String? cursor,
    int? limit,
    MealType? mealType,
    DateTime? date,
    FeedScope scope = FeedScope.all,
  }) async {
    final data = await _client.send((dio) => dio.get('/feed', queryParameters: {
          if (cursor != null) 'cursor': cursor,
          if (limit != null) 'limit': limit,
          if (mealType != null) 'mealType': mealType.wire,
          if (date != null) 'date': _ymd(date),
          if (scope != FeedScope.all) 'scope': scope.name,
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

String _ymd(DateTime date) {
  return [
    date.year.toString().padLeft(4, '0'),
    date.month.toString().padLeft(2, '0'),
    date.day.toString().padLeft(2, '0'),
  ].join('-');
}
