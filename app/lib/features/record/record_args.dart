import 'dart:typed_data';
import '../../data/models/analysis.dart';

/// Analyzing → RecordEdit 인자. analysis(completed) + 로컬 이미지 바이트(미리보기).
class RecordEditArgs {
  const RecordEditArgs({required this.analysis, this.imageBytes});
  final AnalysisResponse analysis;
  final Uint8List? imageBytes;
}
