// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendImpl _$$FriendImplFromJson(Map<String, dynamic> json) => _$FriendImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      mutualFriendCount: (json['mutualFriendCount'] as num).toInt(),
      certifiedToday: json['certifiedToday'] as bool,
    );

Map<String, dynamic> _$$FriendImplToJson(_$FriendImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'mutualFriendCount': instance.mutualFriendCount,
      'certifiedToday': instance.certifiedToday,
    };

_$FriendsResponseImpl _$$FriendsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendsResponseImpl(
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => Friend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Friend>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$$FriendsResponseImplToJson(
        _$FriendsResponseImpl instance) =>
    <String, dynamic>{
      'friends': instance.friends,
      'nextCursor': instance.nextCursor,
    };

_$SearchUserImpl _$$SearchUserImplFromJson(Map<String, dynamic> json) =>
    _$SearchUserImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      followerCount: (json['followerCount'] as num).toInt(),
      postCount: (json['postCount'] as num).toInt(),
      mutualFriendCount: (json['mutualFriendCount'] as num).toInt(),
      selected: json['selected'] as bool,
    );

Map<String, dynamic> _$$SearchUserImplToJson(_$SearchUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'followerCount': instance.followerCount,
      'postCount': instance.postCount,
      'mutualFriendCount': instance.mutualFriendCount,
      'selected': instance.selected,
    };

_$FriendSearchResponseImpl _$$FriendSearchResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendSearchResponseImpl(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => SearchUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SearchUser>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$$FriendSearchResponseImplToJson(
        _$FriendSearchResponseImpl instance) =>
    <String, dynamic>{
      'users': instance.users,
      'nextCursor': instance.nextCursor,
    };

_$FollowResultImpl _$$FollowResultImplFromJson(Map<String, dynamic> json) =>
    _$FollowResultImpl(
      friendUserId: json['friendUserId'] as String,
      selected: json['selected'] as bool,
    );

Map<String, dynamic> _$$FollowResultImplToJson(_$FollowResultImpl instance) =>
    <String, dynamic>{
      'friendUserId': instance.friendUserId,
      'selected': instance.selected,
    };
