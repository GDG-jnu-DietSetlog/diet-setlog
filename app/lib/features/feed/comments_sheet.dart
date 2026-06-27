import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/providers.dart';
import '../../data/models/feed.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/initial_avatar.dart';

/// 댓글 목록/작성 바텀시트. GET/POST /v1/posts/{recordId}/comments.
Future<void> showCommentsSheet(
  BuildContext context, {
  required String recordId,
  required VoidCallback onAdded,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => _CommentsSheet(recordId: recordId, onAdded: onAdded),
  );
}

class _CommentsSheet extends ConsumerStatefulWidget {
  const _CommentsSheet({required this.recordId, required this.onAdded});
  final String recordId;
  final VoidCallback onAdded;

  @override
  ConsumerState<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<_CommentsSheet> {
  final _input = TextEditingController();
  final _comments = <Comment>[];
  bool _loading = true;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ref.read(feedApiProvider).comments(widget.recordId);
      setState(() {
        _comments
          ..clear()
          ..addAll(res.comments);
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = '댓글을 불러오지 못했어요.';
      });
    }
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final c =
          await ref.read(feedApiProvider).addComment(widget.recordId, body);
      setState(() {
        _comments.add(c);
        _input.clear();
        _sending = false;
      });
      widget.onAdded();
    } catch (_) {
      setState(() => _sending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글 작성에 실패했어요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 0.7.sh,
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r))),
            SizedBox(height: 12.h),
            Text('댓글', style: AppType.appBar()),
            const Divider(height: 24, color: AppColors.borderField),
            Expanded(child: _list()),
            _composer(),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary)),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: AppType.body(color: AppColors.text82)),
            TextButton(onPressed: _load, child: const Text('다시 시도')),
          ],
        ),
      );
    }
    if (_comments.isEmpty) {
      return Center(
          child: Text('첫 댓글을 남겨보세요.',
              style: AppType.body(color: AppColors.text82)));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: _comments.length,
      itemBuilder: (_, i) {
        final c = _comments[i];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InitialAvatar(
                  name: c.author.displayName,
                  avatarUrl: c.author.avatarUrl,
                  seedId: c.author.id,
                  size: 36),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c.author.displayName,
                            style: AppType.label(w: FontWeight.w700)),
                        SizedBox(width: 6.w),
                        Text(
                            DateFormat('M.d HH:mm')
                                .format(c.createdAt.toLocal()),
                            style: AppType.micro(
                                color: AppColors.textC7, w: FontWeight.w500)),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(c.body, style: AppType.body()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _composer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 8.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
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
}
