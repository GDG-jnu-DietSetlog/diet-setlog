import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/widgets/app_top_bar.dart';
import 'steps/step1_name.dart';
import 'steps/step2_basics.dart';
import 'steps/step3_goal.dart';

/// 온보딩 3 STEP 플로우(`1:643`/`1:36`/`1:74`). 진행바 + 페이지 전환.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _step = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
      _controller.animateToPage(_step,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _controller.animateToPage(_step,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppTopBar(
        title: '프로필 설정',
        showBack: _step > 0,
        onBack: _back,
      ),
      body: Column(
        children: [
          _ProgressBar(step: _step),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Step1Name(onNext: _next),
                Step2Basics(onNext: _next),
                const Step3Goal(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 온보딩 진행바 — design-system §4.9. STEP1=⅓, STEP2=⅔, STEP3=전체.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) SizedBox(width: 6.w),
            Expanded(
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color:
                      i <= step ? AppColors.primary : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(AppSpacing.r9.r),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
