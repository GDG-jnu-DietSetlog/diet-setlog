import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import '../../data/models/enums.dart';
import '../../data/models/feed.dart';
import '../../design/app_colors.dart';
import '../../design/app_icons.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/initial_avatar.dart';
import '../../design/widgets/nutrition.dart';
import '../../routing/route_paths.dart';
import 'comments_sheet.dart';
import 'feed_controller.dart';

/// Feed — 친구 피드(`1:343`). screens.md §10.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
        ref.read(feedControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  static const _filters = <(String, MealType?)>[
    ('전체', null),
    ('아침', MealType.breakfast),
    ('점심', MealType.lunch),
    ('저녁', MealType.dinner),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedControllerProvider);
    final ctrl = ref.read(feedControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
          icon: Iconify(AppIcons.back, size: 26.r),
        ),
        title: Text('피드', style: AppType.appBar()),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Iconify(AppIcons.bell, size: 24.r),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _filterChips(state.filter, ctrl),
            Expanded(child: _body(state, ctrl)),
          ],
        ),
      ),
    );
  }

  Widget _filterChips(MealType? selected, FeedController ctrl) {
    return SizedBox(
      height: 56.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        children: [
          for (final (label, meal) in _filters) ...[
            _chip(label, meal == selected, () => ctrl.setFilter(meal)),
            SizedBox(width: 8.w),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(38.r),
          border: active ? null : Border.all(color: AppColors.border),
        ),
        child: Text(label,
            style: AppType.body(
                color: active ? AppColors.onPrimary : AppColors.text4D,
                w: active ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _body(FeedState state, FeedController ctrl) {
    if (state.loading && state.posts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary)),
      );
    }
    if (state.error != null && state.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: AppType.body(color: AppColors.text82)),
            TextButton(onPressed: ctrl.refresh, child: const Text('다시 시도')),
          ],
        ),
      );
    }
    if (state.posts.isEmpty) {
      return Center(
          child: Text('아직 피드가 없어요.',
              style: AppType.body(color: AppColors.text82)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: ctrl.refresh,
      child: ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
        itemCount: state.posts.length + (state.hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= state.posts.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primary)),
              ),
            );
          }
          return _FeedCard(
            post: state.posts[i],
            onLike: () => ctrl.toggleLike(state.posts[i]),
            onComment: () => showCommentsSheet(
              context,
              recordId: state.posts[i].recordId,
              onAdded: () => ctrl.bumpCommentCount(state.posts[i].recordId),
            ),
            onOpen: () => context.push(Routes.feedDetail, extra: state.posts[i]),
          );
        },
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard(
      {required this.post,
      required this.onLike,
      required this.onComment,
      required this.onOpen});
  final FeedPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final total = (post.macros.proteinG + post.macros.carbsG + post.macros.fatG)
        .clamp(1, double.infinity);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          GestureDetector(onTap: onOpen, child: _photo()),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: NutritionBar(
                            macro: Macro.protein,
                            ratio: post.macros.proteinG / total)),
                    SizedBox(width: 6.w),
                    Expanded(
                        child: NutritionBar(
                            macro: Macro.carbs,
                            ratio: post.macros.carbsG / total)),
                    SizedBox(width: 6.w),
                    Expanded(
                        child: NutritionBar(
                            macro: Macro.fat, ratio: post.macros.fatG / total)),
                  ],
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: onOpen,
                  child: Text(post.title, style: AppType.bodyBold()),
                ),
                if (post.memo != null && post.memo!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(post.memo!,
                      style: AppType.label(color: AppColors.text51)),
                ],
                SizedBox(height: 12.h),
                _actions(),
                if (post.previewComments.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  for (final c in post.previewComments) _previewComment(c),
                ],
                if (post.commentCount > post.previewComments.length) ...[
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: onOpen,
                    child: Text('댓글 ${post.commentCount}개 모두 보기',
                        style: AppType.label(color: AppColors.textC7)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          InitialAvatar(
              name: post.author.displayName,
              avatarUrl: post.author.avatarUrl,
              seedId: post.author.id,
              size: 40),
          SizedBox(width: 10.w),
          Text(post.author.displayName,
              style: AppType.body(w: FontWeight.w600)),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Text(post.mealType.labelKo,
                style: AppType.micro(
                    color: AppColors.primary, w: FontWeight.w600)),
          ),
          const Spacer(),
          Text(_timeAgo(post.eatenAt),
              style:
                  AppType.label(color: AppColors.textC7, w: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _photo() {
    return Stack(
      children: [
        post.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: post.imageUrl!,
                width: double.infinity,
                height: 280.h,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(height: 280.h, color: AppColors.skeleton),
              )
            : Container(
                height: 280.h,
                width: double.infinity,
                color: AppColors.skeleton),
        Positioned(
          left: 12.w,
          bottom: 12.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.r46.r),
            ),
            child: Text('${post.totalCalories} kcal',
                style: AppType.label(w: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        GestureDetector(
          onTap: onLike,
          child: Iconify(
            post.likedByMe ? AppIcons.heart : AppIcons.heartOutline,
            size: 24.r,
            color: post.likedByMe ? const Color(0xFFFF3B5C) : AppColors.text171,
          ),
        ),
        SizedBox(width: 6.w),
        Text('${post.likeCount}',
            style: AppType.body(color: AppColors.text171, w: FontWeight.w600)),
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: onComment,
          child:
              Iconify(AppIcons.comment, size: 24.r, color: AppColors.text171),
        ),
        SizedBox(width: 6.w),
        Text('${post.commentCount}',
            style: AppType.body(color: AppColors.text171, w: FontWeight.w600)),
        SizedBox(width: 16.w),
        Iconify(AppIcons.send, size: 22.r, color: AppColors.text171),
        const Spacer(),
        Iconify(AppIcons.bookmark, size: 22.r, color: AppColors.text171),
      ],
    );
  }

  Widget _previewComment(Comment c) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: AppType.label(color: AppColors.text51),
          children: [
            TextSpan(
                text: '${c.author.displayName} ',
                style: AppType.label(w: FontWeight.w700)),
            TextSpan(text: c.body),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t.toLocal());
    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return DateFormat('M.d').format(t.toLocal());
  }
}
