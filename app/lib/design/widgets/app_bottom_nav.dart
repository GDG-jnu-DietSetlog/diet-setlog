import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../app_colors.dart';
import '../app_icons.dart';
import '../app_spacing.dart';

/// 탭 식별자. 프로필 탭은 v1에서 no-op(spec-lock §2-8).
enum NavTab { home, camera, calendar, profile }

/// Bottom Navigation — design-system §4.7. 흰 배경, radius52, 탭 4개(각 50×50).
/// 활성 = 파란 원 채움/흰 아이콘, 비활성 = bgNavInactive/회색 아이콘.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current, required this.onTap});

  final NavTab current;
  final ValueChanged<NavTab> onTap;

  static const _items = <(NavTab, String)>[
    (NavTab.home, AppIcons.navHome),
    (NavTab.camera, AppIcons.navCamera),
    (NavTab.calendar, AppIcons.navCalendar),
    (NavTab.profile, AppIcons.navProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.r52.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4.851,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _items.length; i++) ...[
              if (i > 0) SizedBox(width: 15.w),
              _tab(_items[i].$1, _items[i].$2),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tab(NavTab tab, String icon) {
    final active = tab == current;
    return GestureDetector(
      onTap: () => onTap(tab),
      child: Container(
        width: 50.r,
        height: 50.r,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.bgNavInactive,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Iconify(
            icon,
            size: 24.r,
            color: active ? AppColors.onPrimary : AppColors.text82,
          ),
        ),
      ),
    );
  }
}
