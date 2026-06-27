import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'app.dart';
import 'core/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR'); // 캘린더/날짜 한국어 포맷
  // 카카오 SDK 초기화 — 키는 빌드 시 --dart-define 주입(Env). 미설정 시 빈 문자열.
  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeAppKey,
    javaScriptAppKey: Env.kakaoJsKey,
  );
  runApp(const ProviderScope(child: DietSetlogApp()));
}
