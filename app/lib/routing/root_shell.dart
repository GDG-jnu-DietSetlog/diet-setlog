import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design/app_colors.dart';
import '../design/widgets/app_bottom_nav.dart';
import 'route_paths.dart';

/// 하단 탭 4개를 가진 루트 셸. home/calendar 만 브랜치(IndexedStack),
/// camera 는 촬영 플로우 push, profile 은 v1 no-op(spec-lock §2-8).
class RootShell extends StatelessWidget {
  const RootShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  NavTab get _currentTab => switch (shell.currentIndex) {
        0 => NavTab.home,
        1 => NavTab.calendar,
        _ => NavTab.home,
      };

  void _onTap(BuildContext context, NavTab tab) {
    switch (tab) {
      case NavTab.home:
        shell.goBranch(0, initialLocation: shell.currentIndex == 0);
      case NavTab.calendar:
        shell.goBranch(1, initialLocation: shell.currentIndex == 1);
      case NavTab.camera:
        context.push(Routes.capture);
      case NavTab.profile:
        break; // no-op
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      body: shell,
      extendBody: true,
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        child: AppBottomNav(
            current: _currentTab, onTap: (t) => _onTap(context, t)),
      ),
    );
  }
}
