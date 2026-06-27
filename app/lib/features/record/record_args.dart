import '../../data/models/analysis.dart';

/// Analyzing → RecordEdit 인자. analysis(completed) + 로컬 이미지 경로(미리보기).
class RecordEditArgs {
  const RecordEditArgs({required this.analysis, this.localPath});
  final AnalysisResponse analysis;
  final String? localPath;
}
