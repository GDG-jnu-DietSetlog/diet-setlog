import '../../core/api/dio_client.dart';
import '../models/session.dart';

class SessionApi {
  SessionApi(this._client);
  final ApiClient _client;

  /// POST /v1/sessions/guest (무인증). 게스트 토큰 발급.
  Future<GuestSession> createGuest({String? deviceHint}) async {
    final data = await _client.send((dio) => dio.post(
          '/sessions/guest',
          data: deviceHint == null ? null : {'deviceHint': deviceHint},
        ));
    return GuestSession.fromJson(data as Map<String, dynamic>);
  }

  /// POST /v1/sessions/kakao. 카카오 SDK accessToken → 세션 토큰.
  /// 현재 게스트 Bearer 가 있으면 인터셉터가 함께 보내 게스트→카카오 승격된다.
  Future<GuestSession> loginWithKakao(String accessToken) async {
    final data = await _client.send((dio) => dio.post(
          '/sessions/kakao',
          data: {'accessToken': accessToken},
        ));
    return GuestSession.fromJson(data as Map<String, dynamic>);
  }
}
