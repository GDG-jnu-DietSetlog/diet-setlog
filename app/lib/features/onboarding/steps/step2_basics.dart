import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/enums.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_typography.dart';
import '../../../design/widgets/app_input_field.dart';
import '../../../design/widgets/primary_button.dart';
import '../../../design/widgets/segmented_toggle.dart';
import '../onboarding_controller.dart';

/// ProfileSetup STEP2 — 기본 정보(`1:36`). 성별·출생연도(추가 슬롯)·키·몸무게.
class Step2Basics extends ConsumerStatefulWidget {
  const Step2Basics({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<Step2Basics> createState() => _Step2BasicsState();
}

class _Step2BasicsState extends ConsumerState<Step2Basics> {
  late final TextEditingController _birth;
  late final TextEditingController _height;
  late final TextEditingController _weight;

  @override
  void initState() {
    super.initState();
    final d = ref.read(onboardingDraftProvider);
    _birth = TextEditingController(text: d.birthYear?.toString() ?? '');
    _height = TextEditingController(text: _fmt(d.heightCm));
    _weight = TextEditingController(text: _fmt(d.currentWeightKg));
  }

  static String _fmt(double? v) =>
      v == null ? '' : (v % 1 == 0 ? v.toInt().toString() : v.toString());

  @override
  void dispose() {
    _birth.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingDraftProvider);
    final notifier = ref.read(onboardingDraftProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 36.h),
          Text('STEP 2/3', style: AppType.bodyBold(color: AppColors.primary)),
          SizedBox(height: 12.h),
          Text('기본 정보를\n알려주세요', style: AppType.title()),
          SizedBox(height: 8.h),
          Text('키와 몸무게로 하루 권장 칼로리를 계산해드릴게요',
              style: AppType.body(color: AppColors.text87)),
          SizedBox(height: 28.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('성별'),
                  SizedBox(height: 8.h),
                  SegmentedToggle<Gender>(
                    value: draft.gender,
                    onChanged: notifier.setGender,
                    options: const [
                      (value: Gender.male, label: '남성'),
                      (value: Gender.female, label: '여성'),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  _label('출생연도'),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: _birth,
                    hintText: '예: 1995',
                    unit: '년',
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => notifier.setBirthYear(int.tryParse(v)),
                  ),
                  SizedBox(height: 36.h),
                  _label('키'),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: _height,
                    hintText: '예: 170',
                    unit: 'cm',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => notifier.setHeight(double.tryParse(v)),
                  ),
                  SizedBox(height: 36.h),
                  _label('현재 몸무게'),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: _weight,
                    hintText: '예: 68',
                    unit: 'kg',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) =>
                        notifier.setCurrentWeight(double.tryParse(v)),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: '다음',
            enabled: draft.step2Valid,
            onPressed: draft.step2Valid ? widget.onNext : null,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _label(String t) =>
      Text(t, style: AppType.bodyBold(color: AppColors.text4D));
}
