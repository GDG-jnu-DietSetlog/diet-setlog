import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../design/widgets/placeholder_screen.dart';
import '../features/session/bootstrap_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/friends/friend_search_screen.dart';
import '../features/analysis/analysis_flow.dart';
import '../features/analysis/capture_screen.dart';
import '../features/analysis/analyzing_screen.dart';
import '../features/record/record_args.dart';
import '../features/record/record_edit_screen.dart';
import '../features/record/record_complete_screen.dart';
import '../data/models/record_create.dart';
import 'root_shell.dart';
import 'route_paths.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// 앱 라우터. '/' 부트스트랩에서 세션·프로필 확인 후 홈/온보딩 분기.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.bootstrap,
    routes: [
      GoRoute(
        path: Routes.bootstrap,
        builder: (c, s) => const BootstrapScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (c, s) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => RootShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (c, s) => const HomeScreen(),
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
        path: Routes.friendSearch,
        builder: (c, s) => const FriendSearchScreen(),
      ),
      GoRoute(
        path: Routes.capture,
        builder: (c, s) => const CaptureScreen(),
      ),
      GoRoute(
        path: Routes.analyzing,
        builder: (c, s) => AnalyzingScreen(args: s.extra as AnalyzeArgs),
      ),
      GoRoute(
        path: Routes.recordEdit,
        builder: (c, s) => RecordEditScreen(args: s.extra as RecordEditArgs),
      ),
      GoRoute(
        path: Routes.uploadComplete,
        builder: (c, s) =>
            RecordCompleteScreen(result: s.extra as RecordCreateResponse),
      ),
      GoRoute(
        path: Routes.feed,
        builder: (c, s) => const PlaceholderScreen('피드'),
      ),
    ],
  );
});
