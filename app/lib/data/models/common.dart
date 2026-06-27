import 'package:freezed_annotation/freezed_annotation.dart';

part 'common.freezed.dart';
part 'common.g.dart';

/// 공통 매크로(탄단지) — openapi Macros.
@freezed
class Macros with _$Macros {
  const factory Macros({
    required double proteinG,
    required double carbsG,
    required double fatG,
  }) = _Macros;

  factory Macros.fromJson(Map<String, dynamic> json) => _$MacrosFromJson(json);
}

/// 사용자 참조 — openapi UserRef.
@freezed
class UserRef with _$UserRef {
  const factory UserRef({
    required String id,
    required String displayName,
    String? avatarUrl,
  }) = _UserRef;

  factory UserRef.fromJson(Map<String, dynamic> json) =>
      _$UserRefFromJson(json);
}
