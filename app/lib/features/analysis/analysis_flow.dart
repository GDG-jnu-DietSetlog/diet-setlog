import 'dart:math' as math;
import 'dart:typed_data';
import '../../core/env.dart';
import '../../data/api/analysis_api.dart';
import '../../data/models/analysis.dart';
import '../../data/models/enums.dart';

/// Analyzing 화면 → RecordEdit 로 넘기는 인자.
/// 이미지는 바이트로 전달(web/모바일 공용 — dart:io 미사용).
class AnalyzeArgs {
  const AnalyzeArgs({required this.bytes, required this.filename, this.source});
  final Uint8List bytes; // 로컬 이미지(미리보기 + 업로드)
  final String filename;
  final String? source; // camera | gallery
}

/// 업로드 + 폴링 진행 콜백.
typedef PollTick = void Function(int attempt, int maxAttempts);

/// `POST /v1/food-analyses` 업로드 후 `GET /v1/food-analyses/{id}` 를
/// 1.5s 간격(×1.5 백오프, 최대 6s)으로 최대 20회 폴링(spec-lock §7).
/// completed/failed 응답을 반환하고, 소진 시 MODEL_TIMEOUT 으로 합성한다.
Future<AnalysisResponse> runAnalysis(
  AnalysisApi api, {
  required Uint8List bytes,
  required String filename,
  String? source,
  PollTick? onTick,
}) async {
  final started =
      await api.upload(bytes: bytes, filename: filename, source: source);

  var intervalMs = Env.pollInitialInterval.inMilliseconds;
  for (var i = 0; i < Env.pollMaxAttempts; i++) {
    await Future<void>.delayed(Duration(milliseconds: intervalMs));
    onTick?.call(i + 1, Env.pollMaxAttempts);
    final res = await api.get(started.analysisId);
    if (res.status != AnalysisStatus.processing) return res;
    intervalMs = math.min(
      Env.pollMaxInterval.inMilliseconds,
      (intervalMs * Env.pollBackoff).round(),
    );
  }

  return started.copyWith(
    status: AnalysisStatus.failed,
    errorCode: 'MODEL_TIMEOUT',
    message: '분석 시간이 초과됐어요. 다시 시도해주세요.',
  );
}
