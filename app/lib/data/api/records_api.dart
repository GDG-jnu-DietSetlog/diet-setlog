import '../../core/api/dio_client.dart';
import '../models/record_create.dart';

class RecordsApi {
  RecordsApi(this._client);
  final ApiClient _client;

  /// POST /v1/food-records — 기록 저장("피드에 올리기").
  Future<RecordCreateResponse> create(RecordCreateRequest req) async {
    final data = await _client.send((dio) => dio.post(
          '/food-records',
          data: req.toJson(),
        ));
    return RecordCreateResponse.fromJson(data as Map<String, dynamic>);
  }
}
