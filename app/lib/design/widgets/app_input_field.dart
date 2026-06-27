import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_typography.dart';
import '../app_spacing.dart';

/// 입력 필드 — design-system §4.2. 342×48, radius12, 값(좌)+단위(우).
/// 포커스 시 테두리 primary.
class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.unit,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.counter, // "0/50자" 우측 카운터 직접 그리려면 사용 안 함; 내부 표시 옵션
  });

  final TextEditingController controller;
  final String? hintText;
  final String? unit;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final String? counter;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        border: Border.all(
          color: focused ? AppColors.borderFocus : AppColors.borderField,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
              style: AppType.value(),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                counterText: '',
                hintText: widget.hintText,
                hintStyle: AppType.body(color: AppColors.textC5),
              ),
            ),
          ),
          if (widget.unit != null)
            Text(widget.unit!,
                style: AppType.caption(color: const Color(0xFFC9C9CA))),
        ],
      ),
    );
  }
}
