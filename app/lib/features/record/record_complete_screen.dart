import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/record_create.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/gradient_progress_bar.dart';
import '../../design/widgets/primary_button.dart';
import '../../routing/route_paths.dart';

/// Upload 완료 — 저장 성공(`1:295`). screens.md §9.
class RecordCompleteScreen extends StatelessWidget {
  const RecordCompleteScreen({super.key, required this.result});
  final RecordCreateResponse result;

  @override
  Widget build(BuildContext context) {
    final s = result.dailySummary;
    final record = result.record;
    final ratio =
        s.calorieTarget == 0 ? 0.0 : s.totalCalories / s.calorieTarget;
    final fmt = NumberFormat.decimalPattern();

    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                  SizedBox(height: 60.h),
                  Center(
                    child: Container(
                      width: 92.r,
                      height: 92.r,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 60.r,
                          height: 60.r,
                          decoration: const BoxDecoration(
                              color: AppColors.success, shape: BoxShape.circle),
                          child: Icon(Icons.check,
                              size: 34.r, color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Center(child: Text('피드에 기록했어요!', style: AppType.title())),
                  SizedBox(height: 8.h),
                  Center(
                    child: Text('친구들이 좋아요와 응원을\n남길 수 있어요.',
                        textAlign: TextAlign.center,
                        style: AppType.body(color: AppColors.text87)),
                  ),
                  SizedBox(height: 32.h),
                  _intakeCard(s.calorieTarget, s.totalCalories,
                      s.remainingCalories, ratio, fmt),
                  SizedBox(height: 16.h),
                  _postCard(
                      record.title, record.imageUrl, record.mealType.labelKo),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 8.h),
              child: PrimaryButton(
                label: '피드에서 보기',
                icon: Icons.home_outlined,
                onPressed: () => context.go(Routes.feed),
              ),
            ),
            TextButton(
              onPressed: () => context.go(Routes.home),
              child: Text('닫기',
                  style: AppType.appBar(color: const Color(0xFF4B4C4F))),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _intakeCard(
      int target, int total, int remaining, double ratio, NumberFormat fmt) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        border: Border.all(color: AppColors.borderField),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('오늘 섭취 칼로리', style: AppType.body(color: AppColors.text4D)),
              Text('목표 ${fmt.format(target)} kcal',
                  style: AppType.label(color: AppColors.text87)),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(fmt.format(total), style: AppType.display()),
              SizedBox(width: 6.w),
              Text('kcal / 일', style: AppType.body(color: AppColors.text6B)),
              const Spacer(),
              if (remaining >= 0)
                Text('${fmt.format(remaining)} kcal 남음',
                    style: AppType.label(
                        color: AppColors.successText, w: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 12.h),
          GradientProgressBar(ratio: ratio),
        ],
      ),
    );
  }

  Widget _postCard(String title, String? imageUrl, String mealLabel) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        border: Border.all(color: AppColors.borderField),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 54.r,
                    height: 54.r,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                        width: 54.r, height: 54.r, color: AppColors.skeleton),
                  )
                : Container(
                    width: 54.r, height: 54.r, color: AppColors.skeleton),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body(w: FontWeight.w600)),
                SizedBox(height: 4.h),
                Text('방금 · $mealLabel',
                    style: AppType.label(
                        color: AppColors.textC7, w: FontWeight.w600)),
              ],
            ),
          ),
          Icon(Icons.favorite_border, size: 18.r, color: AppColors.textC7),
          SizedBox(width: 8.w),
          Icon(Icons.chat_bubble_outline, size: 18.r, color: AppColors.textC7),
        ],
      ),
    );
  }
}
