import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_typography.dart';
import '../app_spacing.dart';

/// 토글/세그먼트(택1) — design-system §4.3. 선택 primaryTint/primary, 미선택 bgInput/회색.
class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.gap = 10,
  });

  final List<({T value, String label})> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) SizedBox(width: gap.w),
          Expanded(child: _chip(options[i])),
        ],
      ],
    );
  }

  Widget _chip(({T value, String label}) o) {
    final selected = o.value == value;
    return GestureDetector(
      onTap: () => onChanged(o.value),
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryTint : AppColors.bgInput,
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        ),
        child: Text(
          o.label,
          style: selected
              ? AppType.body(color: AppColors.primary, w: FontWeight.w700)
              : AppType.body(color: AppColors.textC5),
        ),
      ),
    );
  }
}
