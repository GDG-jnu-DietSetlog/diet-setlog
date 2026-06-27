import '../../core/api/dio_client.dart';
import '../models/friends.dart';

class FriendsApi {
  FriendsApi(this._client);
  final ApiClient _client;

  /// GET /v1/friends — 내가 follow 한 사람(keyset).
  Future<FriendsResponse> getFriends({String? cursor, int? limit}) async {
    final data =
        await _client.send((dio) => dio.get('/friends', queryParameters: {
              if (cursor != null) 'cursor': cursor,
              if (limit != null) 'limit': limit,
            }));
    return FriendsResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /v1/friends/search — q 빈값=추천, 있으면 이름 검색.
  Future<FriendSearchResponse> search(
      {String? q, String? cursor, int? limit}) async {
    final data = await _client
        .send((dio) => dio.get('/friends/search', queryParameters: {
              if (q != null && q.isNotEmpty) 'q': q,
              if (cursor != null) 'cursor': cursor,
              if (limit != null) 'limit': limit,
            }));
    return FriendSearchResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /v1/friends/{id}/follow (멱등).
  Future<FollowResult> follow(String friendUserId) async {
    final data =
        await _client.send((dio) => dio.post('/friends/$friendUserId/follow'));
    return FollowResult.fromJson(data as Map<String, dynamic>);
  }

  /// DELETE /v1/friends/{id}/follow (멱등).
  Future<FollowResult> unfollow(String friendUserId) async {
    final data = await _client
        .send((dio) => dio.delete('/friends/$friendUserId/follow'));
    return FollowResult.fromJson(data as Map<String, dynamic>);
  }
}
