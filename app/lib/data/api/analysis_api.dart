import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';
import '../models/analysis.dart';

class AnalysisApi {
  AnalysisApi(this._client);
  final ApiClient _client;

  /// POST /v1/food-analyses (multipart, 필드명 `image`). 항상 202 processing.
  /// 이미지는 바이트로 전송(web/모바일 공용).
  Future<AnalysisResponse> upload({
    required Uint8List bytes,
    required String filename,
    String? source, // camera | gallery
  }) async {
    final ext =
        filename.contains('.') ? filename.split('.').last.toLowerCase() : 'jpg';
    final mime = switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final form = FormData.fromMap({
      if (source != null) 'source': source,
      'image': MultipartFile.fromBytes(
        bytes,
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
