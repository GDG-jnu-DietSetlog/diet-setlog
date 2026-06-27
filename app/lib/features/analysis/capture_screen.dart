import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../design/app_colors.dart';
import '../../design/app_typography.dart';
import '../../routing/route_paths.dart';
import 'analysis_flow.dart';

/// FoodCapture — 카메라/갤러리(`1:177`). screens.md §6. 다크 UI.
class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  final _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      context.pushReplacement(
        Routes.analyzing,
        extra: AnalyzeArgs(
          bytes: bytes,
          filename: file.name,
          source: source == ImageSource.camera ? 'camera' : 'gallery',
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Stack(
          children: [
            // 앱바
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 56.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('음식 기록',
                        style: AppType.appBar(color: AppColors.white)),
                    Positioned(
                      left: 24.w,
                      child: GestureDetector(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go(Routes.home),
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: const BoxDecoration(
                              color: AppColors.darkBtn, shape: BoxShape.circle),
                          child: Icon(Icons.close,
                              size: 22.r, color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 초점 가이드
            Center(
              child: Container(
                width: 270.r,
                height: 270.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: AppColors.white, width: 2),
                ),
              ),
            ),
            // 안내 토스트
            Positioned(
              bottom: 160.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: const Color(0x961E1E1C),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  child: Text('접시 전체가 보이게 찍어주세요',
                      style: AppType.label(
                          color: AppColors.white, w: FontWeight.w600)),
                ),
              ),
            ),
            // 하단 컨트롤
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _circleButton(
                    size: 53,
                    bg: AppColors.darkBtn,
                    icon: Icons.photo_library_outlined,
                    onTap: () => _pick(ImageSource.gallery),
                  ),
                  _shutter(),
                  _circleButton(
                    size: 44,
                    bg: AppColors.darkBtn,
                    icon: Icons.cameraswitch_outlined,
                    onTap: () => _pick(ImageSource.camera),
                  ),
                ],
              ),
            ),
            if (_busy)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x66000000),
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _shutter() {
    return GestureDetector(
      onTap: () => _pick(ImageSource.camera),
      child: Container(
        width: 82.r,
        height: 82.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 5),
        ),
        child: Center(
          child: Container(
            width: 64.r,
            height: 64.r,
            decoration: const BoxDecoration(
                color: AppColors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required double size,
    required Color bg,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 24.r, color: AppColors.white),
      ),
    );
  }
}
