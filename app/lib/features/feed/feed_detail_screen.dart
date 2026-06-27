import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/env.dart';
import '../../core/providers.dart';
import '../../data/models/feed.dart';
import '../../design/app_colors.dart';
import '../../design/app_icons.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/initial_avatar.dart';
import '../../design/widgets/nutrition.dart';
import '../../routing/route_paths.dart';
import 'feed_controller.dart';

/// 피드 상세("자세히 보기"). 카드에서 [FeedPost] 를 받아 큰 사진·전체 메모·영양(그램)·
/// 전체 댓글/작성을 한 화면에서 보여준다. (Figma 미설계 → 디자인 시스템 기준 신규 구성)
class FeedDetailScreen extends ConsumerStatefulWidget {
  const FeedDetailScreen({super.key, required this.post});
  final FeedPost post;

  @override
  ConsumerState<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends ConsumerState<FeedDetailScreen> {
  late FeedPost _post = widget.post;
  final _comments = <Comment>[];
  final _scroll = ScrollController();
  final _input = TextEditingController();
  final _inputFocus = FocusNode();

  bool _loadingComments = true;
  bool _loadingMore = false;
  bool _sending = false;
  String? _commentsError;
  String? _nextCursor;

  bool get _hasMore => _nextCursor != null;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _loadingComments = true;
      _commentsError = null;
    });
    try {
      final res = await ref
          .read(feedApiProvider)
          .comments(_post.recordId, limit: Env.defaultLimit);
      if (!mounted) return;
      setState(() {
        _comments
          ..clear()
          ..addAll(res.comments);
        _nextCursor = res.nextCursor;
        _loadingComments = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingComments = false;
        _commentsError = '댓글을 불러오지 못했어요.';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final res = await ref.read(feedApiProvider).comments(
            _post.recordId,
            cursor: _nextCursor,
            limit: Env.defaultLimit,
          );
      if (!mounted) return;
      setState(() {
        _comments.addAll(res.comments);
        _nextCursor = res.nextCursor;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _toggleLike() async {
    final liked = !_post.likedByMe;
    setState(() => _post = _post.copyWith(
          likedByMe: liked,
          likeCount: _post.likeCount + (liked ? 1 : -1),
        ));
    try {
      final api = ref.read(feedApiProvider);
      final res =
          liked ? await api.like(_post.recordId) : await api.unlike(_post.recordId);
      if (!mounted) return;
      setState(() =>
          _post = _post.copyWith(likedByMe: res.liked, likeCount: res.likeCount));
      ref
          .read(feedControllerProvider.notifier)
          .syncLike(_post.recordId, liked: res.liked, likeCount: res.likeCount);
    } catch (_) {
      if (!mounted) return;
      setState(() => _post = _post.copyWith(
            likedByMe: !liked,
            likeCount: _post.likeCount + (liked ? -1 : 1),
          ));
    }
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final c = await ref.read(feedApiProvider).addComment(_post.recordId, body);
      if (!mounted) return;
      setState(() {
        _comments.add(c);
        _post = _post.copyWith(commentCount: _post.commentCount + 1);
        _input.clear();
        _sending = false;
      });
      ref.read(feedControllerProvider.notifier).bumpCommentCount(_post.recordId);
    } catch (_) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 작성에 실패했어요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.feed),
          icon: Iconify(AppIcons.back, size: 26.r),
        ),
        title: Text('게시물', style: AppType.appBar()),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: EdgeInsets.zero,
                children: [
                  _header(),
                  _photo(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_post.title, style: AppType.value()),
                        if (_post.memo != null && _post.memo!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(_post.memo!,
                              style: AppType.body(color: AppColors.text51)),
                        ],
                        SizedBox(height: 16.h),
                        _nutrition(),
                        SizedBox(height: 16.h),
                        _actions(),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderField),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
                    child: Text('댓글 ${_post.commentCount}',
                        style: AppType.bodyBold()),
                  ),
                  _commentsBody(),
                ],
              ),
            ),
            _composer(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
      child: Row(
        children: [
          InitialAvatar(
              name: _post.author.displayName,
              avatarUrl: _post.author.avatarUrl,
              seedId: _post.author.id,
              size: 40),
          SizedBox(width: 10.w),
          Text(_post.author.displayName,
              style: AppType.body(w: FontWeight.w600)),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Text(_post.mealType.labelKo,
                style:
                    AppType.micro(color: AppColors.primary, w: FontWeight.w600)),
          ),
          const Spacer(),
          Text(_timeAgo(_post.eatenAt),
              style: AppType.label(color: AppColors.textC7, w: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _photo() {
    return Stack(
      children: [
        _post.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: _post.imageUrl!,
                width: double.infinity,
                height: 360.h,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(height: 360.h, color: AppColors.skeleton),
              )
            : Container(
                height: 360.h, width: double.infinity, color: AppColors.skeleton),
        Positioned(
          left: 24.w,
          bottom: 12.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.r46.r),
            ),
            child: Text('${_post.totalCalories} kcal',
                style: AppType.body(w: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _nutrition() {
    return Row(
      children: [
        Expanded(
            child: NutritionBox(
                macro: Macro.protein, grams: _post.macros.proteinG)),
        SizedBox(width: 8.w),
        Expanded(
            child:
                NutritionBox(macro: Macro.carbs, grams: _post.macros.carbsG)),
        SizedBox(width: 8.w),
        Expanded(
            child: NutritionBox(macro: Macro.fat, grams: _post.macros.fatG)),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: Iconify(
            _post.likedByMe ? AppIcons.heart : AppIcons.heartOutline,
            size: 24.r,
            color: _post.likedByMe ? const Color(0xFFFF3B5C) : AppColors.text171,
          ),
        ),
        SizedBox(width: 6.w),
        Text('${_post.likeCount}',
            style: AppType.body(color: AppColors.text171, w: FontWeight.w600)),
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: () => _inputFocus.requestFocus(),
          child: Iconify(AppIcons.comment, size: 24.r, color: AppColors.text171),
        ),
        SizedBox(width: 6.w),
        Text('${_post.commentCount}',
            style: AppType.body(color: AppColors.text171, w: FontWeight.w600)),
        SizedBox(width: 16.w),
        Iconify(AppIcons.send, size: 22.r, color: AppColors.text171),
        const Spacer(),
        Iconify(AppIcons.bookmark, size: 22.r, color: AppColors.text171),
      ],
    );
  }

  Widget _commentsBody() {
    if (_loadingComments) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary)),
        ),
      );
    }
    if (_commentsError != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_commentsError!, style: AppType.body(color: AppColors.text82)),
              TextButton(onPressed: _loadComments, child: const Text('다시 시도')),
            ],
          ),
        ),
      );
    }
    if (_comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
            child: Text('첫 댓글을 남겨보세요.',
                style: AppType.body(color: AppColors.text82))),
      );
    }
    return Column(
      children: [
        for (final c in _comments) _CommentTile(comment: c),
        if (_loadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primary)),
            ),
          ),
      ],
    );
  }

  Widget _composer() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderField)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 8.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                focusNode: _inputFocus,
                maxLength: 300,
                style: AppType.body(),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: '댓글 달기...',
                  hintStyle: AppType.body(color: AppColors.textC5),
                  counterText: '',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.r12.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.r12.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _send,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
                child: _sending
                    ? Padding(
                        padding: EdgeInsets.all(12.r),
                        child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(AppColors.onPrimary)),
                      )
                    : Icon(Icons.send, size: 20.r, color: AppColors.onPrimary),
              ),
            ),
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

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InitialAvatar(
              name: comment.author.displayName,
              avatarUrl: comment.author.avatarUrl,
              seedId: comment.author.id,
              size: 36),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.author.displayName,
                        style: AppType.label(w: FontWeight.w700)),
                    SizedBox(width: 6.w),
                    Text(
                        DateFormat('M.d HH:mm').format(comment.createdAt.toLocal()),
                        style: AppType.micro(
                            color: AppColors.textC7, w: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(comment.body, style: AppType.body()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
