import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../data/models/friends.dart';
import '../../design/app_colors.dart';
import '../../design/app_icons.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/app_search_bar.dart';
import '../../design/widgets/app_top_bar.dart';
import '../../design/widgets/initial_avatar.dart';
import '../../design/widgets/primary_button.dart';
import 'friend_search_controller.dart';

/// 친구 추가/검색(`1:556` 외). screens.md §5.
class FriendSearchScreen extends ConsumerStatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  ConsumerState<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends ConsumerState<FriendSearchScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(friendSearchControllerProvider);
    final ctrl = ref.read(friendSearchControllerProvider.notifier);
    final count = state.selectedCount;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppTopBar(title: '친구 추가'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
              child:
                  AppSearchBar(controller: _search, onChanged: ctrl.setQuery),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const _KakaoFriendsCard(),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(state.query.isEmpty ? '추천 친구' : '검색 결과',
                    style: AppType.bodyBold()),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(child: _list(state, ctrl)),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 18.h),
              child: PrimaryButton(
                label: count > 0 ? '$count명 추가하고 시작하기' : '친구 추가하고 시작하기',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(FriendSearchState state, FriendSearchController ctrl) {
    if (state.loading && state.users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary)),
      );
    }
    if (state.error != null && state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: AppType.body(color: AppColors.text82)),
            SizedBox(height: 12.h),
            TextButton(onPressed: ctrl.retry, child: const Text('다시 시도')),
          ],
        ),
      );
    }
    if (state.users.isEmpty) {
      return Center(
        child:
            Text('검색 결과가 없어요.', style: AppType.body(color: AppColors.text82)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: state.users.length,
      itemBuilder: (_, i) => _FriendRow(
          user: state.users[i], onToggle: () => ctrl.toggle(state.users[i])),
    );
  }
}

class _KakaoFriendsCard extends StatelessWidget {
  const _KakaoFriendsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBD8),
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Row(
        children: [
          const _KakaoTalkIcon(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('카카오톡으로 친구 찾기', style: AppType.body(w: FontWeight.w800)),
                Text('아는 친구를 빠르게 추가해요',
                    style: AppType.label(color: AppColors.text82)),
              ],
            ),
          ),
          Iconify(AppIcons.chevronRight, size: 20.r, color: AppColors.text82),
        ],
      ),
    );
  }
}

class _KakaoTalkIcon extends StatelessWidget {
  const _KakaoTalkIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.r,
      height: 38.r,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFAE300),
        shape: BoxShape.circle,
      ),
      child: Text(
        'TALK',
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
          height: 1,
        ),
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.user, required this.onToggle});
  final SearchUser user;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66.h,
      child: Row(
        children: [
          InitialAvatar(
              name: user.displayName,
              avatarUrl: user.avatarUrl,
              seedId: user.id,
              size: 46),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName, style: AppType.bodyBold()),
                SizedBox(height: 2.h),
                Text('함께 아는 친구 ${user.mutualFriendCount}명',
                    style: AppType.label(color: AppColors.textC7)),
              ],
            ),
          ),
          _ToggleButton(selected: user.selected, onTap: onToggle),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        width: selected ? 81.w : 65.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          border: selected ? Border.all(color: AppColors.borderField) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? Icons.check : Icons.add,
                size: selected ? 18.r : 16.r,
                color: selected ? AppColors.black : AppColors.onPrimary),
            SizedBox(width: selected ? 2.w : 4.w),
            Text(selected ? '추가됨' : '추가',
                style: AppType.bodyBold(
                    color: selected ? AppColors.black : AppColors.onPrimary)),
          ],
        ),
      ),
    );
  }
}
