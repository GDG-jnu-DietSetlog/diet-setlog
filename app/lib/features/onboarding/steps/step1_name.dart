import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_typography.dart';
import '../../../design/widgets/app_input_field.dart';
import '../../../design/widgets/primary_button.dart';
import '../onboarding_controller.dart';

/// ProfileSetup STEP1 — 이름(`1:643`). screens.md §1.
class Step1Name extends ConsumerStatefulWidget {
  const Step1Name({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<Step1Name> createState() => _Step1NameState();
}

class _Step1NameState extends ConsumerState<Step1Name> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: ref.read(onboardingDraftProvider).displayName);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingDraftProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 36.h),
          Text('STEP 1/3', style: AppType.bodyBold(color: AppColors.primary)),
          SizedBox(height: 12.h),
          Text('이름을 설정해주세요', style: AppType.title()),
          SizedBox(height: 33.h),
          AppInputField(
            controller: _ctrl,
            hintText: '이름',
            maxLength: 50,
            onChanged: ref.read(onboardingDraftProvider.notifier).setName,
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${draft.displayName.characters.length}/50자',
                style: AppType.body(color: AppColors.textCA)),
          ),
          const Spacer(),
          PrimaryButton(
            label: '다음',
            enabled: draft.step1Valid,
            onPressed: draft.step1Valid ? widget.onNext : null,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
