import 'package:dio/dio.dart';
import '../env.dart';
import 'api_exception.dart';

/// 현재 sessionToken 을 메모리에 들고 있는 홀더. 세션 컨트롤러가 부트스트랩/로그인 시 갱신.
class SessionTokenHolder {
  String? token;
}

/// 모든 요청에 `Authorization: Bearer <token>` 주입.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._holder);
  final SessionTokenHolder _holder;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final t = _holder.token;
    if (t != null && t.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $t';
    }
    handler.next(options);
  }
}

/// DioException → ApiException 매핑(`{ error: { code, message, fields? } }`).
ApiException mapDioException(Object e) {
  if (e is ApiException) return e;
  if (e is! DioException) {
    return ApiException(code: ApiErrorCode.unknown, message: e.toString());
  }
  final res = e.response;
  if (res == null) {
    return ApiException(
      code: ApiErrorCode.network,
      message: '네트워크 연결을 확인해주세요.',
    );
  }
  final data = res.data;
  if (data is Map && data['error'] is Map) {
    final err = data['error'] as Map;
    Map<String, String>? fields;
    if (err['fields'] is Map) {
      fields = (err['fields'] as Map)
          .map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return ApiException(
      code: ApiErrorCode.fromString(err['code'] as String?),
      message: (err['message'] as String?) ?? '',
      statusCode: res.statusCode,
      fields: fields,
    );
  }
  return ApiException(
    code: ApiErrorCode.unknown,
    message: 'HTTP ${res.statusCode}',
    statusCode: res.statusCode,
  );
}

/// Dio 래퍼. send() 는 응답 data 를 반환하거나 ApiException 을 throw.
class ApiClient {
  ApiClient({required this.dio, required this.tokenHolder});

  final Dio dio;
  final SessionTokenHolder tokenHolder;

  factory ApiClient.create(SessionTokenHolder holder) {
    final dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      // 4xx/5xx 는 DioException 으로 받아 매핑한다.
      validateStatus: (s) => s != null && s >= 200 && s < 300,
      contentType: Headers.jsonContentType,
    ));
    dio.interceptors.add(AuthInterceptor(holder));
    return ApiClient(dio: dio, tokenHolder: holder);
  }

  Future<dynamic> send(Future<Response> Function(Dio dio) fn) async {
    try {
      final res = await fn(dio);
      return res.data;
    } catch (e) {
      throw mapDioException(e);
    }
  }
}
