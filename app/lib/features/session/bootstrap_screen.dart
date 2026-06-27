import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_exception.dart';
import '../../design/app_colors.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/primary_button.dart';
import '../../routing/route_paths.dart';
import 'session_providers.dart';

/// 스플래시/부트스트랩. 세션·프로필 확인 후 홈 또는 온보딩으로 이동.
class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(bootstrapProvider);

    ref.listen(bootstrapProvider, (prev, next) {
      next.whenOrNull(data: (hasProfile) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          context.go(hasProfile ? Routes.home : Routes.onboarding);
        });
      });
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: boot.when(
          loading: () => const _Loading(),
          data: (_) => const _Loading(),
          error: (e, _) {
            final msg = e is ApiException ? e.userMessage : '문제가 발생했어요.';
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(msg,
                      textAlign: TextAlign.center,
                      style: AppType.body(color: AppColors.text82)),
                  SizedBox(height: 20.h),
                  PrimaryButton(
                    label: '다시 시도',
                    width: 158,
                    height: 50,
                    onPressed: () => ref.invalidate(bootstrapProvider),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('diet-setlog', style: AppType.title(color: AppColors.primary)),
        SizedBox(height: 24.h),
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      ],
    );
  }
}
