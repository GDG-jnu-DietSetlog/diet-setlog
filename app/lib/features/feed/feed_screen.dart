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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _FeedHeader(onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(Routes.home);
              }
            }),
            const Divider(height: 1, color: AppColors.borderField),
            _StoryStrip(
              posts: state.posts,
              title: '오늘 인증한 친구',
              onStoryTap: () => context.push(Routes.feedStory),
            ),
            Expanded(
              child: Container(
                color: AppColors.bgSheet,
                child: Column(
                  children: [
                    _filterChips(state.filter, ctrl),
                    Expanded(child: _body(state, ctrl)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChips(MealType? selected, FeedController ctrl) {
    return SizedBox(
      height: 58.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 12.h),
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
        height: 32.h,
        width: 56.w,
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
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 118.h),
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
            onOpen: () =>
                context.push(Routes.feedDetail, extra: state.posts[i]),
          );
        },
      ),
    );
  }
}

class FeedStoryScreen extends ConsumerStatefulWidget {
  const FeedStoryScreen({super.key, required this.date});
  final DateTime date;

  @override
  ConsumerState<FeedStoryScreen> createState() => _FeedStoryScreenState();
}

class _FeedStoryScreenState extends ConsumerState<FeedStoryScreen> {
  final _scroll = ScrollController();
  bool _friendRecords = true;

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedControllerProvider);
    final ctrl = ref.read(feedControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _StoryHeader(
              title: _formatStoryDate(widget.date),
              onBack: () =>
                  context.canPop() ? context.pop() : context.go(Routes.feed),
            ),
            const Divider(height: 1, color: AppColors.borderField),
            _StoryStrip(
              posts: state.posts,
              title: '스토리 다시보기',
              dashed: true,
              showMeAddBadge: false,
            ),
            Expanded(
              child: Container(
                color: AppColors.bgSheet,
                child: Column(
                  children: [
                    _StoryModeChips(
                      friendRecords: _friendRecords,
                      onChanged: (value) =>
                          setState(() => _friendRecords = value),
                    ),
                    Expanded(child: _storyBody(state, ctrl)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storyBody(FeedState state, FeedController ctrl) {
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
        child: Text(
          _friendRecords ? '친구 기록이 없어요.' : '나의 기록이 없어요.',
          style: AppType.body(color: AppColors.text82),
        ),
      );
    }
    final posts = _friendRecords ? state.posts : const <FeedPost>[];
    if (posts.isEmpty) {
      return Center(
        child:
            Text('나의 기록이 없어요.', style: AppType.body(color: AppColors.text82)),
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: ctrl.refresh,
      child: ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 118.h),
        itemCount: posts.length + (state.hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= posts.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primary)),
              ),
            );
          }
          return _FeedCard(
            post: posts[i],
            onLike: () => ctrl.toggleLike(posts[i]),
            onComment: () => showCommentsSheet(
              context,
              recordId: posts[i].recordId,
              onAdded: () => ctrl.bumpCommentCount(posts[i].recordId),
            ),
            onOpen: () => context.push(Routes.feedDetail, extra: posts[i]),
          );
        },
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 24.w,
            top: 8.h,
            child: SizedBox(
              width: 44.r,
              height: 44.r,
              child: IconButton(
                onPressed: onBack,
                icon:
                    Iconify(AppIcons.back, size: 28.r, color: AppColors.black),
              ),
            ),
          ),
          Text(title, style: AppType.appBar()),
        ],
      ),
    );
  }
}

class _StoryModeChips extends StatelessWidget {
  const _StoryModeChips({
    required this.friendRecords,
    required this.onChanged,
  });

  final bool friendRecords;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 12.h),
        children: [
          _StoryModeChip(
            label: '나의 기록',
            active: !friendRecords,
            onTap: () => onChanged(false),
          ),
          SizedBox(width: 8.w),
          _StoryModeChip(
            label: '친구 기록',
            active: friendRecords,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _StoryModeChip extends StatelessWidget {
  const _StoryModeChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        width: 67.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(38.r),
          border: active ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: AppType.body(
            color: active ? AppColors.onPrimary : AppColors.text4D,
            w: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return SizedBox(
      height: 78.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 10.h, 24.w, 10.h),
        child: Row(
          children: [
            if (canPop)
              IconButton(
                onPressed: onBack,
                icon:
                    Iconify(AppIcons.back, size: 28.r, color: AppColors.black),
              )
            else
              Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: const _FeedLogoMark(),
              ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Iconify(AppIcons.bell, size: 24.r, color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedLogoMark extends StatelessWidget {
  const _FeedLogoMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38.w,
      height: 31.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 1.w,
            top: 5.h,
            child: Container(
              width: 16.r,
              height: 21.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
          Positioned(
            right: 1.w,
            top: 5.h,
            child: Container(
              width: 16.r,
              height: 21.r,
              decoration: BoxDecoration(
                color: const Color(0xFF69B7FF),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 25.r,
              height: 13.r,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF5F9EFF), width: 6.r),
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryStrip extends StatelessWidget {
  const _StoryStrip({
    required this.posts,
    required this.title,
    this.dashed = false,
    this.showMeAddBadge = true,
    this.onStoryTap,
  });

  final List<FeedPost> posts;
  final String title;
  final bool dashed;
  final bool showMeAddBadge;
  final VoidCallback? onStoryTap;

  @override
  Widget build(BuildContext context) {
    final authors = <String, FeedPost>{};
    for (final post in posts) {
      authors.putIfAbsent(post.author.id, () => post);
    }
    return SizedBox(
      height: 136.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 0),
            child: Text(title, style: AppType.bodyBold()),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 84.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              children: [
                _StoryAvatar.me(
                  dashed: dashed,
                  showAddBadge: showMeAddBadge,
                  onTap: onStoryTap,
                ),
                for (final post in authors.values.take(8))
                  _StoryAvatar(
                    post: post,
                    dashed: dashed,
                    onTap: onStoryTap,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({
    required this.post,
    this.dashed = false,
    this.onTap,
  })  : isMe = false,
        showAddBadge = false;
  const _StoryAvatar.me({
    this.dashed = false,
    this.showAddBadge = true,
    this.onTap,
  })  : post = null,
        isMe = true;

  final FeedPost? post;
  final bool isMe;
  final bool dashed;
  final bool showAddBadge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = isMe ? '나' : post!.author.displayName;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _StoryRing(
                  dashed: dashed,
                  active: !isMe,
                  child: isMe
                      ? Container(
                          width: 50.r,
                          height: 50.r,
                          decoration: const BoxDecoration(
                            color: AppColors.bgInput,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_outline,
                              size: 25.r, color: AppColors.text82),
                        )
                      : InitialAvatar(
                          name: name,
                          avatarUrl: post!.author.avatarUrl,
                          seedId: post!.author.id,
                          size: 50,
                        ),
                ),
                if (isMe && showAddBadge)
                  Positioned(
                    right: -2.w,
                    bottom: -2.h,
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add,
                          size: 15.r, color: AppColors.onPrimary),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5.h),
            SizedBox(
              width: 54.r,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppType.label(
                  color: isMe ? AppColors.textD5 : AppColors.text85,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryRing extends StatelessWidget {
  const _StoryRing({
    required this.child,
    required this.dashed,
    required this.active,
  });

  final Widget child;
  final bool dashed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active || dashed ? AppColors.verifyRing : AppColors.border;
    final width = active || dashed ? 2.r : 1.r;
    final content = Padding(padding: EdgeInsets.all(2.r), child: child);

    if (!dashed) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: width),
        ),
        child: content,
      );
    }
    return CustomPaint(
      painter: _DashedCirclePainter(color: color, strokeWidth: width),
      child: content,
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color, required this.strokeWidth});
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    const dashCount = 22;
    const gapRadians = 0.11;
    const tau = 2 * 3.141592653589793;
    const sweep = (tau / dashCount) - gapRadians;
    for (var i = 0; i < dashCount; i++) {
      final start = i * tau / dashCount;
      canvas.drawArc(rect.deflate(strokeWidth / 2), start, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
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
            padding: EdgeInsets.fromLTRB(11.w, 12.h, 11.w, 11.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nutritionSummary(),
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
      padding: EdgeInsets.fromLTRB(11.w, 8.h, 11.w, 8.h),
      child: Row(
        children: [
          InitialAvatar(
              name: post.author.displayName,
              avatarUrl: post.author.avatarUrl,
              seedId: post.author.id,
              size: 40),
          SizedBox(width: 11.w),
          Expanded(
            child: SizedBox(
              height: 43.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      post.author.displayName,
                      style: AppType.body(w: FontWeight.w600),
                    ),
                  ),
                  Positioned(
                    left: 42.w,
                    top: 6.h,
                    child: _MealBadge(mealType: post.mealType),
                  ),
                  Positioned(
                    left: 0,
                    top: 20.h,
                    child: Text(
                      _timeMeta(post.eatenAt),
                      style: AppType.label(
                        color: AppColors.textC7,
                        w: FontWeight.w600,
                      ).copyWith(height: 32 / 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Iconify(AppIcons.more, size: 24.r, color: AppColors.textC7),
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
          left: 16.w,
          bottom: 11.h,
          child: _AiCalorieChip(calories: post.totalCalories),
        ),
      ],
    );
  }

  Widget _nutritionSummary() {
    final total = (post.macros.proteinG + post.macros.carbsG + post.macros.fatG)
        .clamp(1, double.infinity);
    return Row(
      children: [
        Expanded(
          child: _MacroStat(
            macro: Macro.protein,
            grams: post.macros.proteinG,
            ratio: post.macros.proteinG / total,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _MacroStat(
            macro: Macro.carbs,
            grams: post.macros.carbsG,
            ratio: post.macros.carbsG / total,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _MacroStat(
            macro: Macro.fat,
            grams: post.macros.fatG,
            ratio: post.macros.fatG / total,
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

  String _timeMeta(DateTime t) {
    final local = t.toLocal();
    final hour = local.hour;
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '$period $displayHour:$minute  |  ${_timeAgo(t)}';
  }
}

class _MealBadge extends StatelessWidget {
  const _MealBadge({required this.mealType});
  final MealType mealType;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (mealType) {
      MealType.breakfast => (const Color(0xFFFFF1DA), const Color(0xFFA45600)),
      MealType.lunch => (const Color(0xFFD0FFE4), const Color(0xFF00741E)),
      MealType.dinner => (AppColors.primaryTint, AppColors.primary),
      MealType.snack => (const Color(0xFFE7DCFF), const Color(0xFF7959BD)),
    };
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Text(
        mealType.labelKo,
        style: AppType.micro(color: fg, w: FontWeight.w600)
            .copyWith(fontSize: 10.sp),
      ),
    );
  }
}

class _AiCalorieChip extends StatelessWidget {
  const _AiCalorieChip({required this.calories});
  final int calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.r46.r),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: const BoxDecoration(
              gradient: AppColors.aiGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome,
                size: 16.r, color: AppColors.onPrimary),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$calories',
                          style: AppType.bodyBold().copyWith(fontSize: 17.sp),
                        ),
                        TextSpan(
                          text: ' kcal',
                          style: AppType.micro(
                            color: AppColors.text6B,
                            w: FontWeight.w600,
                          ).copyWith(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.check,
                          size: 12.r, color: AppColors.successText2),
                      SizedBox(width: 2.w),
                      Text(
                        'AI 분석 완료',
                        style: AppType.micro(
                          color: AppColors.successText2,
                          w: FontWeight.w600,
                        ).copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  const _MacroStat({
    required this.macro,
    required this.grams,
    required this.ratio,
  });

  final Macro macro;
  final num grams;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98.w,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                macro.label,
                style: AppType.micro(
                  color: const Color(0xFF8F9092),
                  w: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${_formatGram(grams)}g',
                style: AppType.micro(
                  color: const Color(0xFF2C2C2C),
                  w: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          NutritionBar(macro: macro, ratio: ratio),
        ],
      ),
    );
  }
}

String _formatGram(num n) =>
    n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);

String _formatStoryDate(DateTime date) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final local = date.toLocal();
  return '${local.year}년 ${local.month}월 ${local.day}일(${weekdays[local.weekday - 1]})';
}
