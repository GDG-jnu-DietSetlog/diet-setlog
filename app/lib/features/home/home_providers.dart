import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../data/models/home.dart';

/// 홈 데이터(GET /v1/home). 친구 추가/기록 저장 후 invalidate 로 갱신.
final homeProvider = FutureProvider<HomeResponse>((ref) async {
  return ref.read(homeApiProvider).getHome();
});
