import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/env.dart';
import '../../core/providers.dart';
import '../../data/models/friends.dart';

class FriendSearchState {
  const FriendSearchState({
    this.query = '',
    this.users = const [],
    this.loading = true,
    this.error,
  });

  final String query;
  final List<SearchUser> users;
  final bool loading;
  final String? error;

  int get selectedCount => users.where((u) => u.selected).length;

  FriendSearchState copyWith({
    String? query,
    List<SearchUser>? users,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return FriendSearchState(
      query: query ?? this.query,
      users: users ?? this.users,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class FriendSearchController extends Notifier<FriendSearchState> {
  Timer? _debounce;

  @override
  FriendSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(() => _fetch(''));
    return const FriendSearchState();
  }

  void setQuery(String q) {
    state = state.copyWith(query: q);
    _debounce?.cancel();
    _debounce = Timer(Env.searchDebounce, () => _fetch(q));
  }

  Future<void> retry() => _fetch(state.query);

  Future<void> _fetch(String q) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await ref.read(friendsApiProvider).search(q: q);
      // 검색어가 그새 바뀌었으면 무시
      if (q != state.query) return;
      state = state.copyWith(users: res.users, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: '목록을 불러오지 못했어요.');
    }
  }

  /// 추가/추가됨 토글(낙관적). 실패 시 롤백.
  Future<void> toggle(SearchUser user) async {
    final wantFollow = !user.selected;
    _patch(user.id, wantFollow);
    try {
      final api = ref.read(friendsApiProvider);
      if (wantFollow) {
        await api.follow(user.id);
      } else {
        await api.unfollow(user.id);
      }
    } catch (_) {
      _patch(user.id, !wantFollow); // 롤백
      state = state.copyWith(error: '잠시 후 다시 시도해주세요.');
    }
  }

  void _patch(String id, bool selected) {
    state = state.copyWith(
      users: [
        for (final u in state.users)
          if (u.id == id) u.copyWith(selected: selected) else u,
      ],
    );
  }
}

final friendSearchControllerProvider =
    NotifierProvider<FriendSearchController, FriendSearchState>(
        FriendSearchController.new);
