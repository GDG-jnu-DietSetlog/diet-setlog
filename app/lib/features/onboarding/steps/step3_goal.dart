import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/calorie.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_typography.dart';
import '../../../design/app_spacing.dart';
import '../../../design/widgets/primary_button.dart';
import '../../../routing/route_paths.dart';
import '../onboarding_controller.dart';

/// ProfileSetup STEP3 — 목표(`1:74`). 목표 몸무게·목표 날짜 + AI 권장칼로리.
class Step3Goal extends ConsumerStatefulWidget {
  const Step3Goal({super.key});

  @override
  ConsumerState<Step3Goal> createState() => _Step3GoalState();
}

class _Step3GoalState extends ConsumerState<Step3Goal> {
  late final TextEditingController _weight;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final d = ref.read(onboardingDraftProvider);
    _weight = TextEditingController(
        text: d.targetWeightKg == null ? '' : _fmt(d.targetWeightKg!));
  }

  static String _fmt(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final init = ref.read(onboardingDraftProvider).targetDate ??
        now.add(const Duration(days: 90));
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: now.add(const Duration(days: 1)),
      lastDate: DateTime(now.year + 2, now.month, now.day),
    );
    if (picked != null) {
      ref.read(onboardingDraftProvider.notifier).setTargetDate(picked);
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref.read(onboardingDraftProvider.notifier).submit();
      if (!mounted) return;
      context.go(Routes.home);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.userMessage)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(onboardingDraftProvider);
    final notifier = ref.read(onboardingDraftProvider.notifier);

    final diff = (d.targetWeightKg != null && d.currentWeightKg != null)
        ? d.targetWeightKg! - d.currentWeightKg!
        : null;

    final estimate = d.step2Valid && d.step3Valid
        ? estimateCalories(
            gender: d.gender!,
            birthYear: d.birthYear!,
            heightCm: d.heightCm!,
            currentWeightKg: d.currentWeightKg!,
            targetWeightKg: d.targetWeightKg!,
            targetDate: d.targetDate!,
          )
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 36.h),
          Text('STEP 3/3', style: AppType.bodyBold(color: AppColors.primary)),
          SizedBox(height: 12.h),
          Text('목표를\n설정해주세요', style: AppType.title()),
          SizedBox(height: 8.h),
          Text('무리하지 않는 목표가 오래가요.',
              style: AppType.body(color: AppColors.text87)),
          SizedBox(height: 28.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('목표 몸무게',
                          style: AppType.bodyBold(color: AppColors.text4D)),
                      if (diff != null && diff != 0) ...[
                        SizedBox(width: 8.w),
                        _diffBadge(diff),
                      ],
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _field(
                    controller: _weight,
                    unit: 'kg',
                    hint: '예: 62',
                    onChanged: (v) =>
                        notifier.setTargetWeight(double.tryParse(v)),
                  ),
                  SizedBox(height: 28.h),
                  Text('목표 날짜',
                      style: AppType.bodyBold(color: AppColors.text4D)),
                  SizedBox(height: 8.h),
                  _dateField(d.targetDate),
                  SizedBox(height: 8.h),
                  if (d.targetDate != null)
                    Text(_weeksHelper(d.targetDate!),
                        style: AppType.body(color: AppColors.textCA)),
                  SizedBox(height: 24.h),
                  _aiCard(estimate),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: '시작하기',
            loading: _submitting,
            enabled: d.step3Valid,
            onPressed: d.step3Valid ? _submit : null,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _diffBadge(double diff) {
    final sign = diff < 0 ? '-' : '+';
    final abs = diff.abs();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD0FFE4),
        borderRadius: BorderRadius.circular(AppSpacing.r26.r),
      ),
      child: Text('현재보다 $sign${_fmt(abs)}kg',
          style:
              AppType.label(color: AppColors.successText, w: FontWeight.w600)),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String unit,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        border: Border.all(color: AppColors.borderField),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: AppType.value(),
              cursorColor: AppColors.primary,
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppType.body(color: AppColors.textC5),
              ),
            ),
          ),
          Text(unit, style: AppType.caption(color: const Color(0xFFC9C9CA))),
        ],
      ),
    );
  }

  Widget _dateField(DateTime? date) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          border: Border.all(color: AppColors.borderField),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date == null ? '날짜 선택' : DateFormat('yyyy.MM.dd').format(date),
                style: date == null
                    ? AppType.body(color: AppColors.textC5)
                    : AppType.value(),
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 20.r, color: AppColors.text87),
          ],
        ),
      ),
    );
  }

  Widget _aiCard(CalorieEstimate? est) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18.r, color: AppColors.primary),
              SizedBox(width: 6.w),
              Text('AI가 계산한 맞춤 목표',
                  style: AppType.body(
                      color: AppColors.primary, w: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                  est == null
                      ? '----'
                      : NumberFormat.decimalPattern()
                          .format(est.dailyCalorieTarget),
                  style: AppType.display()),
              SizedBox(width: 6.w),
              Text('kcal / 일', style: AppType.body(color: AppColors.text6B)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            est == null
                ? '목표를 입력하면 권장 칼로리를 계산해드려요.'
                : '입력하신 정보로 계산한 하루 권장 섭취량이에요.\n저장 후에도 언제든 확인할 수 있어요.',
            style: AppType.label(color: AppColors.text4D, w: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _weeksHelper(DateTime target) {
    final days = target.difference(DateTime.now()).inDays;
    final weeks = (days / 7).ceil().clamp(1, 999);
    return '오늘부터 약 $weeks주 후예요.';
  }
}
