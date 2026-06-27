/// 서버 에러 코드 enum — spec-lock §7 / openapi ErrorResponse.
enum ApiErrorCode {
  validationFailed,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  payloadTooLarge,
  analysisFailed,
  rateLimited,
  internal,
  network, // 클라이언트측(연결 실패/타임아웃)
  unknown;

  static ApiErrorCode fromString(String? code) => switch (code) {
        'VALIDATION_FAILED' => validationFailed,
        'UNAUTHORIZED' => unauthorized,
        'FORBIDDEN' => forbidden,
        'NOT_FOUND' => notFound,
        'CONFLICT' => conflict,
        'PAYLOAD_TOO_LARGE' => payloadTooLarge,
        'ANALYSIS_FAILED' => analysisFailed,
        'RATE_LIMITED' => rateLimited,
        'INTERNAL' => internal,
        _ => unknown,
      };
}

/// API 호출 실패. `{ error: { code, message, fields? } }` 매핑.
class ApiException implements Exception {
  ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.fields,
  });

  final ApiErrorCode code;
  final String message;
  final int? statusCode;
  final Map<String, String>? fields;

  bool get isUnauthorized => code == ApiErrorCode.unauthorized;
  bool get isNetwork => code == ApiErrorCode.network;

  /// 사용자 노출용 한국어 메시지(서버 message 우선, 없으면 기본 문구).
  String get userMessage {
    if (message.isNotEmpty) return message;
    return switch (code) {
      ApiErrorCode.network => '네트워크 연결을 확인해주세요.',
      ApiErrorCode.rateLimited => '잠시 후 다시 시도해주세요.',
      ApiErrorCode.unauthorized => '세션이 만료되었어요. 다시 시도해주세요.',
      _ => '문제가 발생했어요. 다시 시도해주세요.',
    };
  }

  @override
  String toString() => 'ApiException($code, $statusCode): $message';
}
