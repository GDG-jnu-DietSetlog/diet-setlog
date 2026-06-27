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
}
