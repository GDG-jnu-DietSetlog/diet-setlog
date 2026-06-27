import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'design/app_theme.dart';
import 'routing/app_router.dart';

/// 앱 루트. designSize 390×844(spec-lock §11) 로 screenutil 초기화 후
/// MaterialApp.router 구동.
class DietSetlogApp extends ConsumerWidget {
  const DietSetlogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: 'diet-setlog',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          routerConfig: router,
        );
      },
    );
  }
}
