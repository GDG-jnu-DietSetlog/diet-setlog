import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../data/models/profile.dart';

/// 현재 프로필 응답(권장칼로리·주간델타 포함). 부트스트랩/PUT 후 갱신.
class ProfileNotifier extends Notifier<ProfileResponse?> {
  @override
  ProfileResponse? build() => null;

  void set(ProfileResponse value) => state = value;
}

final profileStateProvider =
    NotifierProvider<ProfileNotifier, ProfileResponse?>(ProfileNotifier.new);

/// 현재 userId(secure storage).
final currentUserIdProvider = StateProvider<String?>((ref) => null);

/// 부트스트랩 분기 결과.
/// - [login]      : 저장된 세션 없음 → 카카오 로그인 화면(온보딩2)
/// - [onboarding] : 세션 있음 + 프로필 없음 → 프로필 설정
/// - [home]       : 세션 있음 + 프로필 있음 → 홈
enum BootDestination { login, onboarding, home }

/// 저장된 세션을 복구해 프로필을 조회하고, 로그인된 상태를 메모리에 반영한다.
/// 프로필 응답까지 세팅한 뒤 다음 목적지를 반환한다. (session_providers 공용)
Future<BootDestination> resolveSession(Ref ref) async {
  final profile = await ref.read(profileApiProvider).getProfile();
  ref.read(profileStateProvider.notifier).set(profile);
  return profile.profile != null
      ? BootDestination.home
      : BootDestination.onboarding;
}

/// 앱 부트스트랩: 저장된 토큰 복구 → 홀더 주입 → 프로필 조회.
/// 토큰이 없으면 게스트를 만들지 않고 로그인 화면으로 보낸다(2차 시안: 카카오 우선).
final bootstrapProvider = FutureProvider<BootDestination>((ref) async {
  final storage = ref.read(tokenStorageProvider);
  final holder = ref.read(tokenHolderProvider);

  final token = await storage.readToken();
  final userId = await storage.readUserId();

  if (token == null || token.isEmpty) {
    return BootDestination.login;
  }
  holder.token = token;
  ref.read(currentUserIdProvider.notifier).state = userId;

  return resolveSession(ref);
});
