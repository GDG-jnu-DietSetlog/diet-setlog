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

/// 앱 부트스트랩: 토큰 복구/게스트 발급 → 홀더 주입 → 프로필 조회.
/// 반환값 = 프로필 존재 여부(true=홈, false=온보딩).
final bootstrapProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(tokenStorageProvider);
  final holder = ref.read(tokenHolderProvider);

  var token = await storage.readToken();
  var userId = await storage.readUserId();

  if (token == null || token.isEmpty) {
    final session = await ref.read(sessionApiProvider).createGuest();
    await storage.save(token: session.sessionToken, userId: session.userId);
    token = session.sessionToken;
    userId = session.userId;
  }
  holder.token = token;
  ref.read(currentUserIdProvider.notifier).state = userId;

  final profile = await ref.read(profileApiProvider).getProfile();
  ref.read(profileStateProvider.notifier).set(profile);
  return profile.profile != null;
});
