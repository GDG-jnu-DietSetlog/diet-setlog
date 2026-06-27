import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// POST /v1/sessions/guest 응답.
@freezed
class GuestSession with _$GuestSession {
  const factory GuestSession({
    required String userId,
    required String sessionToken,
    required bool isNewUser,
  }) = _GuestSession;

  factory GuestSession.fromJson(Map<String, dynamic> json) =>
      _$GuestSessionFromJson(json);
}
