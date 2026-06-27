import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:diet_setlog/core/api/dio_client.dart';
import 'package:diet_setlog/data/api/analysis_api.dart';
import 'package:diet_setlog/data/models/analysis.dart';
import 'package:diet_setlog/data/models/common.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/features/analysis/analysis_flow.dart';

/// 폴링 시퀀스를 흉내내는 가짜 API. upload→processing, get 은 N회 processing 후 completed.
class _FakeAnalysisApi extends AnalysisApi {
  _FakeAnalysisApi(this.processingTimes)
      : super(ApiClient(dio: Dio(), tokenHolder: SessionTokenHolder()));

  final int processingTimes;
  int _calls = 0;

  @override
  Future<AnalysisResponse> upload(
      {required String filePath, String? source}) async {
    return const AnalysisResponse(
      analysisId: 'a1',
      status: AnalysisStatus.processing,
      imageUrl: 'http://x/a.jpg',
    );
  }

  @override
  Future<AnalysisResponse> get(String analysisId) async {
    _calls++;
    if (_calls <= processingTimes) {
      return const AnalysisResponse(
        analysisId: 'a1',
        status: AnalysisStatus.processing,
        imageUrl: 'http://x/a.jpg',
      );
    }
    return const AnalysisResponse(
      analysisId: 'a1',
      status: AnalysisStatus.completed,
      imageUrl: 'http://x/a.jpg',
      needsReview: false,
      result: AnalysisResult(
        dishName: '닭가슴살 샐러드',
        totalCalories: 420,
        macros: Macros(proteinG: 38, carbsG: 32, fatG: 14),
        items: [],
        confidence: 0.9,
      ),
    );
  }
}

void main() {
  test('runAnalysis polls until completed (upload→processing×2→completed)',
      () async {
    final api = _FakeAnalysisApi(2); // 2회 processing 후 completed
    final res = await runAnalysis(api, filePath: '/tmp/x.jpg');
    expect(res.status, AnalysisStatus.completed);
    expect(res.result?.dishName, '닭가슴살 샐러드');
  }, timeout: const Timeout(Duration(seconds: 30)));
}
