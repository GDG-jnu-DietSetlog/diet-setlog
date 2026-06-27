import '../../core/api/dio_client.dart';
import '../models/profile.dart';

class ProfileApi {
  ProfileApi(this._client);
  final ApiClient _client;

  /// GET /v1/me/profile — 없으면 profile:null (200).
  Future<ProfileResponse> getProfile() async {
    final data = await _client.send((dio) => dio.get('/me/profile'));
    return ProfileResponse.fromJson(data as Map<String, dynamic>);
  }

  /// PUT /v1/me/profile — 온보딩 STEP3 저장(권장칼로리 계산 포함).
  Future<ProfileResponse> putProfile(ProfileUpsertRequest req) async {
    final data = await _client.send((dio) => dio.put(
          '/me/profile',
          data: req.toJson(),
        ));
    return ProfileResponse.fromJson(data as Map<String, dynamic>);
  }
}
