import 'package:freezed_annotation/freezed_annotation.dart';

part 'friends.freezed.dart';
part 'friends.g.dart';

/// 친구 목록 행 — openapi FriendsResponse.friends[].
@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String displayName,
    String? avatarUrl,
    required int mutualFriendCount,
    required bool certifiedToday,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}

@freezed
class FriendsResponse with _$FriendsResponse {
  const factory FriendsResponse({
    @Default(<Friend>[]) List<Friend> friends,
    String? nextCursor,
  }) = _FriendsResponse;

  factory FriendsResponse.fromJson(Map<String, dynamic> json) =>
      _$FriendsResponseFromJson(json);
}

/// 친구 검색/추천 행 — openapi FriendSearchResponse.users[].
@freezed
class SearchUser with _$SearchUser {
  const factory SearchUser({
    required String id,
    required String displayName,
    String? avatarUrl,
    required int followerCount,
    required int postCount,
    required int mutualFriendCount,
    required bool selected,
  }) = _SearchUser;

  factory SearchUser.fromJson(Map<String, dynamic> json) =>
      _$SearchUserFromJson(json);
}

@freezed
class FriendSearchResponse with _$FriendSearchResponse {
  const factory FriendSearchResponse({
    @Default(<SearchUser>[]) List<SearchUser> users,
    String? nextCursor,
  }) = _FriendSearchResponse;

  factory FriendSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$FriendSearchResponseFromJson(json);
}

/// openapi FollowResult.
@freezed
class FollowResult with _$FollowResult {
  const factory FollowResult({
    required String friendUserId,
    required bool selected,
  }) = _FollowResult;

  factory FollowResult.fromJson(Map<String, dynamic> json) =>
      _$FollowResultFromJson(json);
}
