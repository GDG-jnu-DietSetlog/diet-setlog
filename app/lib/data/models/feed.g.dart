// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      author: UserRef.fromJson(json['author'] as Map<String, dynamic>),
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$FeedPostImpl _$$FeedPostImplFromJson(Map<String, dynamic> json) =>
    _$FeedPostImpl(
      recordId: json['recordId'] as String,
      author: UserRef.fromJson(json['author'] as Map<String, dynamic>),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
      eatenAt: DateTime.parse(json['eatenAt'] as String),
      totalCalories: (json['totalCalories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      memo: json['memo'] as String?,
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
      previewComments: (json['previewComments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Comment>[],
    );

Map<String, dynamic> _$$FeedPostImplToJson(_$FeedPostImpl instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'author': instance.author,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'eatenAt': instance.eatenAt.toIso8601String(),
      'totalCalories': instance.totalCalories,
      'macros': instance.macros,
      'memo': instance.memo,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'likedByMe': instance.likedByMe,
      'previewComments': instance.previewComments,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};

_$FeedResponseImpl _$$FeedResponseImplFromJson(Map<String, dynamic> json) =>
    _$FeedResponseImpl(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => FeedPost.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FeedPost>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$$FeedResponseImplToJson(_$FeedResponseImpl instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'nextCursor': instance.nextCursor,
    };

_$LikeResultImpl _$$LikeResultImplFromJson(Map<String, dynamic> json) =>
    _$LikeResultImpl(
      recordId: json['recordId'] as String,
      liked: json['liked'] as bool,
      likeCount: (json['likeCount'] as num).toInt(),
    );

Map<String, dynamic> _$$LikeResultImplToJson(_$LikeResultImpl instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'liked': instance.liked,
      'likeCount': instance.likeCount,
    };

_$CommentListResponseImpl _$$CommentListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CommentListResponseImpl(
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Comment>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$$CommentListResponseImplToJson(
        _$CommentListResponseImpl instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'nextCursor': instance.nextCursor,
    };
