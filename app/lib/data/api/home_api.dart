import '../../core/api/dio_client.dart';
import '../models/home.dart';

class HomeApi {
  HomeApi(this._client);
  final ApiClient _client;

  /// GET /v1/home.
  Future<HomeResponse> getHome() async {
    final data = await _client.send((dio) => dio.get('/home'));
    return HomeResponse.fromJson(data as Map<String, dynamic>);
  }
}
