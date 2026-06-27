import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';
import '../../data/models/analysis.dart';
import '../../data/models/enums.dart';
import '../../design/app_colors.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/primary_button.dart';
import '../../routing/route_paths.dart';
import '../record/record_args.dart';
import 'analysis_flow.dart';

/// Analyzing — AI 분석 로딩(`1:198`). 업로드+폴링 후 결과/실패 분기. screens.md §7.
class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key, required this.args});
  final AnalyzeArgs args;

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen> {
  double _progress = 0.05;
  AnalysisResponse? _failed;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _running = true;
      _failed = null;
      _progress = 0.05;
    });
    try {
      final res = await runAnalysis(
        ref.read(analysisApiProvider),
        bytes: widget.args.bytes,
        filename: widget.args.filename,
        source: widget.args.source,
        onTick: (attempt, max) {
          if (mounted) {
            setState(() => _progress = (attempt / max).clamp(0.05, 0.95));
          }
        },
      );
      if (!mounted) return;
      if (res.status == AnalysisStatus.completed) {
        context.pushReplacement(
          Routes.recordEdit,
          extra: RecordEditArgs(analysis: res, imageBytes: widget.args.bytes),
        );
      } else {
        setState(() => _failed = res);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = null); // 네트워크 등 → 일반 실패 UI
      _showGenericError();
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  void _showGenericError() {
    setState(() {
      _failed = const AnalysisResponse(
        analysisId: '',
        status: AnalysisStatus.failed,
        imageUrl: '',
        errorCode: 'MODEL_ERROR',
        message: '분석에 실패했어요. 다시 시도해주세요.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _background(),
          Container(color: const Color(0x6E000000)),
          SafeArea(
            child: _failed != null ? _failedView(_failed!) : _loadingView(),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Image.memory(widget.args.bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const ColoredBox(color: AppColors.darkBg)),
    );
  }

  Widget _loadingView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(60.r),
              ),
              child: Center(
                child: Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    gradient: AppColors.aiGradient,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Icon(Icons.auto_awesome,
                      size: 40.r, color: AppColors.white),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text('AI가 음식을 분석하고 있어요',
                style: AppType.title(color: AppColors.white)),
            SizedBox(height: 8.h),
            Text('칼로리와 영양 성분을\n자동으로 계산하는 중이에요.',
                textAlign: TextAlign.center,
                style: AppType.body(color: const Color(0xFFC2C2C2))),
            SizedBox(height: 24.h),
            SizedBox(
              width: 200.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6.h,
                  backgroundColor: const Color(0x33FFFFFF),
                  valueColor: const AlwaysStoppedAnimation(AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _failedView(AnalysisResponse res) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56.r, color: AppColors.white),
            SizedBox(height: 16.h),
            Text(res.message ?? '분석에 실패했어요.',
                textAlign: TextAlign.center,
                style: AppType.body(color: AppColors.white)),
            SizedBox(height: 24.h),
            PrimaryButton(
              label: '다시 시도',
              loading: _running,
              onPressed: _start,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go(Routes.home),
              child: Text('닫기', style: AppType.body(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
