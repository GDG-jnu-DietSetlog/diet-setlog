import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_exception.dart';
import '../../data/models/common.dart';
import '../../data/models/home.dart';
import '../../design/app_colors.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/initial_avatar.dart';
import '../../design/widgets/primary_button.dart';
import '../../routing/route_paths.dart';
import 'home_providers.dart';

/// 홈 — 빈 친구 상태(`1:121`). screens.md §4.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: home.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary)),
          ),
          error: (e, _) => _ErrorView(
            message: e is ApiException ? e.userMessage : '문제가 발생했어요.',
            onRetry: () => ref.invalidate(homeProvider),
          ),
          data: (data) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.refresh(homeProvider.future),
            child: _HomeBody(data: data),
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.data});
  final HomeResponse data;

  Future<void> _openFriendSearch(BuildContext context, WidgetRef ref) async {
    await context.push(Routes.friendSearch);
    ref.invalidate(homeProvider); // 친구 추가 반영
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friends = data.friendsCertifiedToday;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text('오늘 인증한 친구', style: AppType.bodyBold()),
        ),
        const Divider(height: 1, color: AppColors.borderField),
        SizedBox(height: 16.h),
        _FriendsRow(me: data.currentUser, friends: friends),
        if (friends.isEmpty)
          _EmptyFriends(onAdd: () => _openFriendSearch(context, ref))
        else
          SizedBox(height: 300.h),
      ],
    );
  }
}

class _FriendsRow extends StatelessWidget {
  const _FriendsRow({required this.me, required this.friends});
  final UserRef me;
  final List<CertifiedFriend> friends;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          _avatar(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                InitialAvatar(
                    name: me.displayName,
                    avatarUrl: me.avatarUrl,
                    seedId: me.id,
                    size: 54),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child:
                        Icon(Icons.add, size: 14.r, color: AppColors.onPrimary),
                  ),
                ),
              ],
            ),
            label: '나',
            labelColor: AppColors.textD5,
          ),
          if (friends.isEmpty) ...[
            _skeleton(),
            _skeleton(),
          ] else
            for (final f in friends)
              _avatar(
                child: InitialAvatar(
                    name: f.displayName,
                    avatarUrl: f.avatarUrl,
                    seedId: f.id,
                    size: 54),
                label: f.displayName,
                labelColor: AppColors.text48,
              ),
        ],
      ),
    );
  }

  Widget _avatar(
      {required Widget child,
      required String label,
      required Color labelColor}) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          child,
          SizedBox(height: 6.h),
          SizedBox(
            width: 54.r,
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppType.label(color: labelColor)),
          ),
        ],
      ),
    );
  }

  Widget _skeleton() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          Container(
            width: 54.r,
            height: 54.r,
            decoration: const BoxDecoration(
                color: AppColors.skeleton, shape: BoxShape.circle),
          ),
          SizedBox(height: 6.h),
          Container(width: 32.r, height: 10.h, color: AppColors.skeleton),
        ],
      ),
    );
  }
}

class _EmptyFriends extends StatelessWidget {
  const _EmptyFriends({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSheet,
      padding: EdgeInsets.only(top: 80.h, bottom: 40.h),
      margin: EdgeInsets.only(top: 24.h),
      child: Column(
        children: [
          Container(
            width: 98.r,
            height: 98.r,
            decoration: const BoxDecoration(
                color: AppColors.primaryTint, shape: BoxShape.circle),
            child: Icon(Icons.group_outlined,
                size: 44.r, color: AppColors.primary),
          ),
          SizedBox(height: 24.h),
          Text('함께할 친구를 찾아보세요', style: AppType.title()),
          SizedBox(height: 8.h),
          Text('친구와 함께 식단을 인증하고\n서로 응원하며 목표를 이뤄가요.',
              textAlign: TextAlign.center,
              style: AppType.body(color: AppColors.text87)),
          SizedBox(height: 28.h),
          PrimaryButton(
              label: '친구 추가하기',
              icon: Icons.add,
              width: 158,
              height: 50,
              onPressed: onAdd),
          SizedBox(height: 16.h),
          Text('나중에 할게요.',
              style: AppType.body(
                  color: const Color(0xFFC2C2C4), w: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppType.body(color: AppColors.text82)),
          SizedBox(height: 16.h),
          PrimaryButton(
              label: '다시 시도', width: 158, height: 50, onPressed: onRetry),
        ],
      ),
    );
  }
}
