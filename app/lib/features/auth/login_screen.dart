import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_exception.dart';
import '../../design/app_colors.dart';
import '../../routing/route_paths.dart';
import '../session/session_providers.dart';
import 'login_controller.dart';

// 온보딩2 로그인 화면 전용 색(Figma 측정값).
const _kKakaoYellow = Color(0xFFFEE500);
const _kKakaoLabel = Color(0xFF241D00);
const _kTitleFrom = Color(0xFF2447F5);
const _kTitleTo = Color(0xFF6CB2FF);
const _kSubtitle = Color(0xFF797979);
const _kDisclaimer = Color(0xFFB3B3B3);
const _kDisclaimerEmphasis = Color(0xFF939393);

/// 온보딩2 — 카카오 로그인. screens: `51:424`.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;

  Future<void> _onKakaoTap() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final dest = await ref.read(loginControllerProvider).signInWithKakao();
      if (!mounted) return;
      context.go(
        dest == BootDestination.home ? Routes.home : Routes.onboarding,
      );
    } on KakaoAuthCancelled {
      // 사용자가 취소 — 조용히 무시.
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException ? e.userMessage : '로그인에 실패했어요. 다시 시도해주세요.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 히어로 이미지(상단, 전체 폭) — 하단은 흰색으로 페이드.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 560.h,
            child: Image.asset(
              'assets/images/login_hero.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned(
            top: 437.h,
            left: 0,
            right: 0,
            height: 130.h,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00FFFFFF),
                    Color(0xA3FFFFFF),
                    AppColors.white
                  ],
                  stops: [0.0, 0.34, 0.70],
                ),
              ),
            ),
          ),
          // 타이틀 + 서브카피
          Positioned(
            top: 550.h,
            left: 28.w,
            right: 28.w,
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    colors: [_kTitleFrom, _kTitleTo],
                  ).createShader(rect),
                  child: Text(
                    '다이어트? 친구와 함께',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                      height: 36 / 22,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  '오늘 뭐 먹었는지 냠-인증하고,\n친구들과 실시간으로 식단을 공유하며 즐겁게 관리해요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    height: 20 / 14,
                    color: _kSubtitle,
                  ),
                ),
              ],
            ),
          ),
          // 카카오 로그인 버튼
          Positioned(
            top: 659.h,
            left: 24.w,
            right: 24.w,
            child: _KakaoButton(loading: _loading, onTap: _onKakaoTap),
          ),
          // 약관/개인정보 동의 간주 문구
          Positioned(
            top: 791.h,
            left: 33.w,
            right: 33.w,
            child: _Disclaimer(
              onPrivacy: () => context.push(Routes.privacy),
              onTerms: () => context.push(Routes.terms),
            ),
          ),
        ],
      ),
    );
  }
}

class _KakaoButton extends StatelessWidget {
  const _KakaoButton({required this.loading, required this.onTap});
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _kKakaoYellow,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          height: 56.h,
          child: Center(
            child: loading
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(_kKakaoLabel),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/kakao_logo.png',
                          width: 19.w, height: 18.h),
                      SizedBox(width: 8.w),
                      Text(
                        '카카오톡 로그인',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 15.6.sp,
                          color: _kKakaoLabel,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.onPrivacy, required this.onTerms});
  final VoidCallback onPrivacy;
  final VoidCallback onTerms;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      height: 18 / 12,
      color: _kDisclaimer,
    );
    final emphasis = base.copyWith(
      fontWeight: FontWeight.w700,
      color: _kDisclaimerEmphasis,
    );
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: '회원가입 시 오늘냠의 필수 동의 항목인\n'),
          TextSpan(
            text: '개인정보처리방침',
            style: emphasis,
            recognizer: _tap(onPrivacy),
          ),
          const TextSpan(text: '과 '),
          TextSpan(
            text: '서비스 이용약관',
            style: emphasis,
            recognizer: _tap(onTerms),
          ),
          const TextSpan(text: '에 동의한 것으로 간주합니다'),
        ],
      ),
      textAlign: TextAlign.center,
      style: base,
    );
  }

  TapGestureRecognizer _tap(VoidCallback cb) =>
      TapGestureRecognizer()..onTap = cb;
}
