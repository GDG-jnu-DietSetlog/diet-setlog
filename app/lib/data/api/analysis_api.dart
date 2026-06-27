import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';
import '../models/analysis.dart';

class AnalysisApi {
  AnalysisApi(this._client);
  final ApiClient _client;

  /// POST /v1/food-analyses (multipart, 필드명 `image`). 항상 202 processing.
  Future<AnalysisResponse> upload({
    required String filePath,
    String? source, // camera | gallery
  }) async {
    final ext = filePath.split('.').last.toLowerCase();
    final mime = switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final form = FormData.fromMap({
      if (source != null) 'source': source,
      'image': await MultipartFile.fromFile(
        filePath,
        filename: 'upload.$ext',
        contentType: DioMediaType.parse(mime),
      ),
    });
    final data =
        await _client.send((dio) => dio.post('/food-analyses', data: form));
    return AnalysisResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /v1/food-analyses/{id} — 폴링.
  Future<AnalysisResponse> get(String analysisId) async {
    final data =
        await _client.send((dio) => dio.get('/food-analyses/$analysisId'));
    return AnalysisResponse.fromJson(data as Map<String, dynamic>);
  }
}
