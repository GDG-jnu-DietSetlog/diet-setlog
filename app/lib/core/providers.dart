import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api/dio_client.dart';
import 'storage/token_storage.dart';
import '../data/api/session_api.dart';
import '../data/api/profile_api.dart';
import '../data/api/home_api.dart';
import '../data/api/friends_api.dart';
import '../data/api/analysis_api.dart';
import '../data/api/records_api.dart';
import '../data/api/calendar_api.dart';
import '../data/api/feed_api.dart';

/// 메모리 토큰 홀더(단일 인스턴스).
final tokenHolderProvider =
    Provider<SessionTokenHolder>((ref) => SessionTokenHolder());

/// secure storage 래퍼.
final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Dio 래퍼(인터셉터 포함).
final apiClientProvider = Provider<ApiClient>((ref) {
  final holder = ref.watch(tokenHolderProvider);
  return ApiClient.create(holder);
});

// ── 엔드포인트별 API 서비스 ──
final sessionApiProvider =
    Provider((ref) => SessionApi(ref.watch(apiClientProvider)));
final profileApiProvider =
    Provider((ref) => ProfileApi(ref.watch(apiClientProvider)));
final homeApiProvider =
    Provider((ref) => HomeApi(ref.watch(apiClientProvider)));
final friendsApiProvider =
    Provider((ref) => FriendsApi(ref.watch(apiClientProvider)));
final analysisApiProvider =
    Provider((ref) => AnalysisApi(ref.watch(apiClientProvider)));
final recordsApiProvider =
    Provider((ref) => RecordsApi(ref.watch(apiClientProvider)));
final calendarApiProvider =
    Provider((ref) => CalendarApi(ref.watch(apiClientProvider)));
final feedApiProvider =
    Provider((ref) => FeedApi(ref.watch(apiClientProvider)));
