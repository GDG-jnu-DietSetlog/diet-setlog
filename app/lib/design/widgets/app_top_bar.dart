import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../app_colors.dart';
import '../app_icons.dart';
import '../app_typography.dart';

/// 공통 앱바 — design-system §5. 390×60, 타이틀 중앙, 뒤로가기 좌측 44×44.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.trailing,
    this.backgroundColor = AppColors.white,
    this.foregroundColor = AppColors.black,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      toolbarHeight: 60.h,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: Iconify(AppIcons.back, size: 28.r, color: foregroundColor),
            )
          : null,
      title: Text(title, style: AppType.appBar(color: foregroundColor)),
      actions: trailing != null ? [trailing!] : null,
    );
  }
}
