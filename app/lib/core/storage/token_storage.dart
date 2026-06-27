import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// sessionToken(HS256 JWT) 보안 저장 — spec-lock §10.1.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _kToken = 'session_token';
  static const _kUserId = 'user_id';

  Future<String?> readToken() => _storage.read(key: _kToken);
  Future<String?> readUserId() => _storage.read(key: _kUserId);

  Future<void> save({required String token, required String userId}) async {
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kUserId, value: userId);
  }

  Future<void> clear() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kUserId);
  }
}
