import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_typography.dart';
import '../app_spacing.dart';

/// Primary CTA 버튼 — design-system §4.1. 342×56, fill primary, radius 12.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.width = AppSpacing.contentW,
    this.height = 56,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final double width;
  final double height;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final active = enabled && !loading && onPressed != null;
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Material(
        color: active
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          onTap: active ? onPressed : null,
          child: Center(
            child: loading
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: AppColors.onPrimary, size: 20.r),
                        SizedBox(width: 8.w),
                      ],
                      Text(label,
                          style: AppType.appBar(color: AppColors.onPrimary)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
