// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get id => throw _privateConstructorUsedError;
  UserRef get author => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call({String id, UserRef author, String body, DateTime createdAt});

  $UserRefCopyWith<$Res> get author;
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? body = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserRef,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRefCopyWith<$Res> get author {
    return $UserRefCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, UserRef author, String body, DateTime createdAt});

  @override
  $UserRefCopyWith<$Res> get author;
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? body = null,
    Object? createdAt = null,
  }) {
    return _then(_$CommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserRef,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {required this.id,
      required this.author,
      required this.body,
      required this.createdAt});

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  final String id;
  @override
  final UserRef author;
  @override
  final String body;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Comment(id: $id, author: $author, body: $body, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, author, body, createdAt);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final String id,
      required final UserRef author,
      required final String body,
      required final DateTime createdAt}) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  String get id;
  @override
  UserRef get author;
  @override
  String get body;
  @override
  DateTime get createdAt;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedPost _$FeedPostFromJson(Map<String, dynamic> json) {
  return _FeedPost.fromJson(json);
}

/// @nodoc
mixin _$FeedPost {
  String get recordId => throw _privateConstructorUsedError;
  UserRef get author => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  MealType get mealType => throw _privateConstructorUsedError;
  DateTime get eatenAt => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Macros get macros => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  bool get likedByMe => throw _privateConstructorUsedError;
  List<Comment> get previewComments => throw _privateConstructorUsedError;

  /// Serializes this FeedPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedPostCopyWith<FeedPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedPostCopyWith<$Res> {
  factory $FeedPostCopyWith(FeedPost value, $Res Function(FeedPost) then) =
      _$FeedPostCopyWithImpl<$Res, FeedPost>;
  @useResult
  $Res call(
      {String recordId,
      UserRef author,
      String title,
      String? imageUrl,
      MealType mealType,
      DateTime eatenAt,
      int totalCalories,
      Macros macros,
      String? memo,
      int likeCount,
      int commentCount,
      bool likedByMe,
      List<Comment> previewComments});

  $UserRefCopyWith<$Res> get author;
  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class _$FeedPostCopyWithImpl<$Res, $Val extends FeedPost>
    implements $FeedPostCopyWith<$Res> {
  _$FeedPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordId = null,
    Object? author = null,
    Object? title = null,
    Object? imageUrl = freezed,
    Object? mealType = null,
    Object? eatenAt = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? memo = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? likedByMe = null,
    Object? previewComments = null,
  }) {
    return _then(_value.copyWith(
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserRef,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      likedByMe: null == likedByMe
          ? _value.likedByMe
          : likedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
      previewComments: null == previewComments
          ? _value.previewComments
          : previewComments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
    ) as $Val);
  }

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRefCopyWith<$Res> get author {
    return $UserRefCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacrosCopyWith<$Res> get macros {
    return $MacrosCopyWith<$Res>(_value.macros, (value) {
      return _then(_value.copyWith(macros: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeedPostImplCopyWith<$Res>
    implements $FeedPostCopyWith<$Res> {
  factory _$$FeedPostImplCopyWith(
          _$FeedPostImpl value, $Res Function(_$FeedPostImpl) then) =
      __$$FeedPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String recordId,
      UserRef author,
      String title,
      String? imageUrl,
      MealType mealType,
      DateTime eatenAt,
      int totalCalories,
      Macros macros,
      String? memo,
      int likeCount,
      int commentCount,
      bool likedByMe,
      List<Comment> previewComments});

  @override
  $UserRefCopyWith<$Res> get author;
  @override
  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class __$$FeedPostImplCopyWithImpl<$Res>
    extends _$FeedPostCopyWithImpl<$Res, _$FeedPostImpl>
    implements _$$FeedPostImplCopyWith<$Res> {
  __$$FeedPostImplCopyWithImpl(
      _$FeedPostImpl _value, $Res Function(_$FeedPostImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordId = null,
    Object? author = null,
    Object? title = null,
    Object? imageUrl = freezed,
    Object? mealType = null,
    Object? eatenAt = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? memo = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? likedByMe = null,
    Object? previewComments = null,
  }) {
    return _then(_$FeedPostImpl(
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserRef,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      likedByMe: null == likedByMe
          ? _value.likedByMe
          : likedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
      previewComments: null == previewComments
          ? _value._previewComments
          : previewComments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedPostImpl implements _FeedPost {
  const _$FeedPostImpl(
      {required this.recordId,
      required this.author,
      required this.title,
      this.imageUrl,
      required this.mealType,
      required this.eatenAt,
      required this.totalCalories,
      required this.macros,
      this.memo,
      required this.likeCount,
      required this.commentCount,
      required this.likedByMe,
      final List<Comment> previewComments = const <Comment>[]})
      : _previewComments = previewComments;

  factory _$FeedPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedPostImplFromJson(json);

  @override
  final String recordId;
  @override
  final UserRef author;
  @override
  final String title;
  @override
  final String? imageUrl;
  @override
  final MealType mealType;
  @override
  final DateTime eatenAt;
  @override
  final int totalCalories;
  @override
  final Macros macros;
  @override
  final String? memo;
  @override
  final int likeCount;
  @override
  final int commentCount;
  @override
  final bool likedByMe;
  final List<Comment> _previewComments;
  @override
  @JsonKey()
  List<Comment> get previewComments {
    if (_previewComments is EqualUnmodifiableListView) return _previewComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previewComments);
  }

  @override
  String toString() {
    return 'FeedPost(recordId: $recordId, author: $author, title: $title, imageUrl: $imageUrl, mealType: $mealType, eatenAt: $eatenAt, totalCalories: $totalCalories, macros: $macros, memo: $memo, likeCount: $likeCount, commentCount: $commentCount, likedByMe: $likedByMe, previewComments: $previewComments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedPostImpl &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.likedByMe, likedByMe) ||
                other.likedByMe == likedByMe) &&
            const DeepCollectionEquality()
                .equals(other._previewComments, _previewComments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      recordId,
      author,
      title,
      imageUrl,
      mealType,
      eatenAt,
      totalCalories,
      macros,
      memo,
      likeCount,
      commentCount,
      likedByMe,
      const DeepCollectionEquality().hash(_previewComments));

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedPostImplCopyWith<_$FeedPostImpl> get copyWith =>
      __$$FeedPostImplCopyWithImpl<_$FeedPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedPostImplToJson(
      this,
    );
  }
}

abstract class _FeedPost implements FeedPost {
  const factory _FeedPost(
      {required final String recordId,
      required final UserRef author,
      required final String title,
      final String? imageUrl,
      required final MealType mealType,
      required final DateTime eatenAt,
      required final int totalCalories,
      required final Macros macros,
      final String? memo,
      required final int likeCount,
      required final int commentCount,
      required final bool likedByMe,
      final List<Comment> previewComments}) = _$FeedPostImpl;

  factory _FeedPost.fromJson(Map<String, dynamic> json) =
      _$FeedPostImpl.fromJson;

  @override
  String get recordId;
  @override
  UserRef get author;
  @override
  String get title;
  @override
  String? get imageUrl;
  @override
  MealType get mealType;
  @override
  DateTime get eatenAt;
  @override
  int get totalCalories;
  @override
  Macros get macros;
  @override
  String? get memo;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  bool get likedByMe;
  @override
  List<Comment> get previewComments;

  /// Create a copy of FeedPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedPostImplCopyWith<_$FeedPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) {
  return _FeedResponse.fromJson(json);
}

/// @nodoc
mixin _$FeedResponse {
  List<FeedPost> get posts => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this FeedResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedResponseCopyWith<FeedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedResponseCopyWith<$Res> {
  factory $FeedResponseCopyWith(
          FeedResponse value, $Res Function(FeedResponse) then) =
      _$FeedResponseCopyWithImpl<$Res, FeedResponse>;
  @useResult
  $Res call({List<FeedPost> posts, String? nextCursor});
}

/// @nodoc
class _$FeedResponseCopyWithImpl<$Res, $Val extends FeedResponse>
    implements $FeedResponseCopyWith<$Res> {
  _$FeedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      posts: null == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<FeedPost>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedResponseImplCopyWith<$Res>
    implements $FeedResponseCopyWith<$Res> {
  factory _$$FeedResponseImplCopyWith(
          _$FeedResponseImpl value, $Res Function(_$FeedResponseImpl) then) =
      __$$FeedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FeedPost> posts, String? nextCursor});
}

/// @nodoc
class __$$FeedResponseImplCopyWithImpl<$Res>
    extends _$FeedResponseCopyWithImpl<$Res, _$FeedResponseImpl>
    implements _$$FeedResponseImplCopyWith<$Res> {
  __$$FeedResponseImplCopyWithImpl(
      _$FeedResponseImpl _value, $Res Function(_$FeedResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$FeedResponseImpl(
      posts: null == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<FeedPost>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedResponseImpl implements _FeedResponse {
  const _$FeedResponseImpl(
      {final List<FeedPost> posts = const <FeedPost>[], this.nextCursor})
      : _posts = posts;

  factory _$FeedResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedResponseImplFromJson(json);

  final List<FeedPost> _posts;
  @override
  @JsonKey()
  List<FeedPost> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'FeedResponse(posts: $posts, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedResponseImpl &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_posts), nextCursor);

  /// Create a copy of FeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedResponseImplCopyWith<_$FeedResponseImpl> get copyWith =>
      __$$FeedResponseImplCopyWithImpl<_$FeedResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedResponseImplToJson(
      this,
    );
  }
}

abstract class _FeedResponse implements FeedResponse {
  const factory _FeedResponse(
      {final List<FeedPost> posts,
      final String? nextCursor}) = _$FeedResponseImpl;

  factory _FeedResponse.fromJson(Map<String, dynamic> json) =
      _$FeedResponseImpl.fromJson;

  @override
  List<FeedPost> get posts;
  @override
  String? get nextCursor;

  /// Create a copy of FeedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedResponseImplCopyWith<_$FeedResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LikeResult _$LikeResultFromJson(Map<String, dynamic> json) {
  return _LikeResult.fromJson(json);
}

/// @nodoc
mixin _$LikeResult {
  String get recordId => throw _privateConstructorUsedError;
  bool get liked => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;

  /// Serializes this LikeResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LikeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LikeResultCopyWith<LikeResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeResultCopyWith<$Res> {
  factory $LikeResultCopyWith(
          LikeResult value, $Res Function(LikeResult) then) =
      _$LikeResultCopyWithImpl<$Res, LikeResult>;
  @useResult
  $Res call({String recordId, bool liked, int likeCount});
}

/// @nodoc
class _$LikeResultCopyWithImpl<$Res, $Val extends LikeResult>
    implements $LikeResultCopyWith<$Res> {
  _$LikeResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LikeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordId = null,
    Object? liked = null,
    Object? likeCount = null,
  }) {
    return _then(_value.copyWith(
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      liked: null == liked
          ? _value.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LikeResultImplCopyWith<$Res>
    implements $LikeResultCopyWith<$Res> {
  factory _$$LikeResultImplCopyWith(
          _$LikeResultImpl value, $Res Function(_$LikeResultImpl) then) =
      __$$LikeResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String recordId, bool liked, int likeCount});
}

/// @nodoc
class __$$LikeResultImplCopyWithImpl<$Res>
    extends _$LikeResultCopyWithImpl<$Res, _$LikeResultImpl>
    implements _$$LikeResultImplCopyWith<$Res> {
  __$$LikeResultImplCopyWithImpl(
      _$LikeResultImpl _value, $Res Function(_$LikeResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of LikeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordId = null,
    Object? liked = null,
    Object? likeCount = null,
  }) {
    return _then(_$LikeResultImpl(
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      liked: null == liked
          ? _value.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LikeResultImpl implements _LikeResult {
  const _$LikeResultImpl(
      {required this.recordId, required this.liked, required this.likeCount});

  factory _$LikeResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$LikeResultImplFromJson(json);

  @override
  final String recordId;
  @override
  final bool liked;
  @override
  final int likeCount;

  @override
  String toString() {
    return 'LikeResult(recordId: $recordId, liked: $liked, likeCount: $likeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikeResultImpl &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.liked, liked) || other.liked == liked) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recordId, liked, likeCount);

  /// Create a copy of LikeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LikeResultImplCopyWith<_$LikeResultImpl> get copyWith =>
      __$$LikeResultImplCopyWithImpl<_$LikeResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LikeResultImplToJson(
      this,
    );
  }
}

abstract class _LikeResult implements LikeResult {
  const factory _LikeResult(
      {required final String recordId,
      required final bool liked,
      required final int likeCount}) = _$LikeResultImpl;

  factory _LikeResult.fromJson(Map<String, dynamic> json) =
      _$LikeResultImpl.fromJson;

  @override
  String get recordId;
  @override
  bool get liked;
  @override
  int get likeCount;

  /// Create a copy of LikeResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LikeResultImplCopyWith<_$LikeResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) {
  return _CommentListResponse.fromJson(json);
}

/// @nodoc
mixin _$CommentListResponse {
  List<Comment> get comments => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this CommentListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentListResponseCopyWith<CommentListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentListResponseCopyWith<$Res> {
  factory $CommentListResponseCopyWith(
          CommentListResponse value, $Res Function(CommentListResponse) then) =
      _$CommentListResponseCopyWithImpl<$Res, CommentListResponse>;
  @useResult
  $Res call({List<Comment> comments, String? nextCursor});
}

/// @nodoc
class _$CommentListResponseCopyWithImpl<$Res, $Val extends CommentListResponse>
    implements $CommentListResponseCopyWith<$Res> {
  _$CommentListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comments = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentListResponseImplCopyWith<$Res>
    implements $CommentListResponseCopyWith<$Res> {
  factory _$$CommentListResponseImplCopyWith(_$CommentListResponseImpl value,
          $Res Function(_$CommentListResponseImpl) then) =
      __$$CommentListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Comment> comments, String? nextCursor});
}

/// @nodoc
class __$$CommentListResponseImplCopyWithImpl<$Res>
    extends _$CommentListResponseCopyWithImpl<$Res, _$CommentListResponseImpl>
    implements _$$CommentListResponseImplCopyWith<$Res> {
  __$$CommentListResponseImplCopyWithImpl(_$CommentListResponseImpl _value,
      $Res Function(_$CommentListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comments = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$CommentListResponseImpl(
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentListResponseImpl implements _CommentListResponse {
  const _$CommentListResponseImpl(
      {final List<Comment> comments = const <Comment>[], this.nextCursor})
      : _comments = comments;

  factory _$CommentListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentListResponseImplFromJson(json);

  final List<Comment> _comments;
  @override
  @JsonKey()
  List<Comment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'CommentListResponse(comments: $comments, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentListResponseImpl &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_comments), nextCursor);

  /// Create a copy of CommentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentListResponseImplCopyWith<_$CommentListResponseImpl> get copyWith =>
      __$$CommentListResponseImplCopyWithImpl<_$CommentListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentListResponseImplToJson(
      this,
    );
  }
}

abstract class _CommentListResponse implements CommentListResponse {
  const factory _CommentListResponse(
      {final List<Comment> comments,
      final String? nextCursor}) = _$CommentListResponseImpl;

  factory _CommentListResponse.fromJson(Map<String, dynamic> json) =
      _$CommentListResponseImpl.fromJson;

  @override
  List<Comment> get comments;
  @override
  String? get nextCursor;

  /// Create a copy of CommentListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentListResponseImplCopyWith<_$CommentListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
