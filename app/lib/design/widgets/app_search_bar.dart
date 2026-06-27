import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../app_colors.dart';
import '../app_icons.dart';
import '../app_typography.dart';
import '../app_spacing.dart';

/// 검색 바 — design-system §4.4. 343×48, bgInput, radius12, 돋보기+placeholder.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    this.hintText = '이름 또는 아이디 검색',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Row(
        children: [
          Iconify(AppIcons.search, size: 24.r, color: AppColors.text82),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppType.body(),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle:
                    AppType.body(color: AppColors.textBF, w: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
