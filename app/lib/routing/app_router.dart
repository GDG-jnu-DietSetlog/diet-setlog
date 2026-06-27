import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../design/widgets/placeholder_screen.dart';
import 'root_shell.dart';
import 'route_paths.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// 앱 라우터. Wave 1 은 골격(홈/캘린더 셸 + 임시 화면).
/// 부트스트랩 리다이렉트와 실제 화면은 후속 wave 에서 연결한다.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => RootShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (c, s) => const PlaceholderScreen('홈'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.calendar,
              builder: (c, s) => const PlaceholderScreen('캘린더'),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (c, s) => const PlaceholderScreen('온보딩'),
      ),
      GoRoute(
        path: Routes.friendSearch,
        builder: (c, s) => const PlaceholderScreen('친구 검색'),
      ),
      GoRoute(
        path: Routes.capture,
        builder: (c, s) => const PlaceholderScreen('음식 촬영'),
      ),
      GoRoute(
        path: Routes.feed,
        builder: (c, s) => const PlaceholderScreen('피드'),
      ),
    ],
  );
});
