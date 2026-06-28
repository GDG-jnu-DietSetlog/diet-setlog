import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/data/api/friends_api.dart';
import 'package:diet_setlog/data/models/friends.dart';
import 'package:diet_setlog/features/friends/friend_search_controller.dart';

SearchUser _user(String id, {bool selected = false}) => SearchUser(
      id: id,
      displayName: 'u$id',
      followerCount: 0,
      postCount: 0,
      mutualFriendCount: 2,
      selected: selected,
    );

class FakeFriendsApi implements FriendsApi {
  FriendSearchResponse searchResult = const FriendSearchResponse();
  bool throwOnSearch = false;
  bool throwOnFollow = false;
  bool throwOnUnfollow = false;

  int searchCalls = 0;
  String? lastSearchQ;
  Completer<void>? searchGate;

  final List<String> followed = [];
  final List<String> unfollowed = [];

  @override
  Future<FriendSearchResponse> search(
      {String? q, String? cursor, int? limit}) async {
    searchCalls++;
    lastSearchQ = q;
    if (searchGate != null) await searchGate!.future;
    if (throwOnSearch) throw Exception('boom');
    return searchResult;
  }

  @override
  Future<FollowResult> follow(String friendUserId) async {
    if (throwOnFollow) throw Exception('boom');
    followed.add(friendUserId);
    return FollowResult(friendUserId: friendUserId, selected: true);
  }

  @override
  Future<FollowResult> unfollow(String friendUserId) async {
    if (throwOnUnfollow) throw Exception('boom');
    unfollowed.add(friendUserId);
    return FollowResult(friendUserId: friendUserId, selected: false);
  }

  @override
  Future<FriendsResponse> getFriends({String? cursor, int? limit}) async =>
      throw UnimplementedError();
}

Future<void> _settle() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

ProviderContainer _container(FakeFriendsApi fake) {
  final c = ProviderContainer(
    overrides: [friendsApiProvider.overrideWithValue(fake)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  // ── 기존 테스트(모델/상태) — 그대로 유지 ──
  test('selectedCount counts selected users', () {
    const state = FriendSearchState();
    final next = state.copyWith(users: [
      _user('1', selected: true),
      _user('2'),
      _user('3', selected: true),
    ]);
    expect(next.selectedCount, 2);
  });

  test('copyWith clearError resets error', () {
    const state = FriendSearchState(error: '에러');
    expect(state.copyWith(clearError: true).error, isNull);
  });

  test('SearchUser.copyWith toggles selected (optimistic patch)', () {
    final u = _user('1');
    expect(u.copyWith(selected: true).selected, isTrue);
  });

  // ── 초기 fetch / 에러 / retry ──
  test('build 시 추천 목록(q="") 을 불러온다', () async {
    final fake = FakeFriendsApi()
      ..searchResult = FriendSearchResponse(users: [_user('1'), _user('2')]);
    final c = _container(fake);
    final ctrl = c.read(friendSearchControllerProvider.notifier);
    await _settle();

    expect(ctrl.state.loading, isFalse);
    expect(ctrl.state.users.length, 2);
    expect(ctrl.state.query, '');
    expect(fake.lastSearchQ, ''); // 추천(빈 쿼리)
  });

  test('fetch 실패 시 error 설정', () async {
    final fake = FakeFriendsApi()..throwOnSearch = true;
    final c = _container(fake);
    final ctrl = c.read(friendSearchControllerProvider.notifier);
    await _settle();

    expect(ctrl.state.loading, isFalse);
    expect(ctrl.state.error, '목록을 불러오지 못했어요.');
  });

  test('retry 는 현재 쿼리로 재조회하고 error 를 해제', () async {
    final fake = FakeFriendsApi()..throwOnSearch = true;
    final c = _container(fake);
    final ctrl = c.read(friendSearchControllerProvider.notifier);
    await _settle();
    expect(ctrl.state.error, isNotNull);

    fake.throwOnSearch = false;
    fake.searchResult = FriendSearchResponse(users: [_user('1')]);
    await ctrl.retry();

    expect(ctrl.state.error, isNull);
    expect(ctrl.state.users.length, 1);
  });

  // ── toggle(follow/unfollow) ──
  test('toggle follow: 낙관적 selected=true 후 성공 유지', () async {
    final fake = FakeFriendsApi()
      ..searchResult =
          FriendSearchResponse(users: [_user('1', selected: false)]);
    final c = _container(fake);
    final ctrl = c.read(friendSearchControllerProvider.notifier);
    await _settle();

    final f = ctrl.toggle(ctrl.state.users.first);
    expect(ctrl.state.users.first.selected, isTrue); // 낙관적
    await f;
    expect(ctrl.state.users.first.selected, isTrue);
    expect(fake.followed, ['1']);
  });

  test('toggle unfollow: 낙관적 selected=false', () async {
    final fake = FakeFriendsApi()
      ..searchResult =
          FriendSearchResponse(users: [_user('1', selected: true)]);
    final c = _container(fake);
    final ctrl = c.read(friendSearchControllerProvider.notifier);
    await _settle();

    await ctrl.toggle(ctrl.state.users.first);
    expect(ctrl.state.users.first.selected, isFalse);
    expect(fake.unfollowed, ['1']);
  });

  test('toggle 실패 시 롤백 + 에러 메시지', () async {
    final fake = FakeFriendsApi()
      ..searchResult =
          FriendSearchResponse(users: [_user('1', selected: false)])
      ..throwOnFollow = true;
    final c = _container(fake);
    final ctrl = c.read(friendSearchControllerProvider.notifier);
    await _settle();

    final f = ctrl.toggle(ctrl.state.users.first);
    expect(ctrl.state.users.first.selected, isTrue); // 낙관적
    await f;
    expect(ctrl.state.users.first.selected, isFalse); // 롤백
    expect(ctrl.state.error, '잠시 후 다시 시도해주세요.');
  });

  // ── setQuery 디바운스 ──
  test('setQuery 는 즉시 query 갱신, 300ms 후 디바운스 fetch', () {
    fakeAsync((async) {
      final fake = FakeFriendsApi()
        ..searchResult = FriendSearchResponse(users: [_user('1')]);
      final c = ProviderContainer(
        overrides: [friendsApiProvider.overrideWithValue(fake)],
      );
      addTearDown(c.dispose);
      final ctrl = c.read(friendSearchControllerProvider.notifier);
      async.flushMicrotasks(); // build 의 _fetch('') 완료

      fake.searchCalls = 0;
      ctrl.setQuery('kim');
      expect(ctrl.state.query, 'kim'); // 즉시
      expect(fake.searchCalls, 0); // 아직 호출 안 함

      async.elapse(const Duration(milliseconds: 299));
      expect(fake.searchCalls, 0); // 디바운스 전

      async.elapse(const Duration(milliseconds: 1));
      async.flushMicrotasks();
      expect(fake.searchCalls, 1);
      expect(fake.lastSearchQ, 'kim');
    });
  });

  test('연속 setQuery 는 직전 타이머를 취소해 한 번만 fetch', () {
    fakeAsync((async) {
      final fake = FakeFriendsApi()
        ..searchResult = FriendSearchResponse(users: [_user('1')]);
      final c = ProviderContainer(
        overrides: [friendsApiProvider.overrideWithValue(fake)],
      );
      addTearDown(c.dispose);
      final ctrl = c.read(friendSearchControllerProvider.notifier);
      async.flushMicrotasks();

      fake.searchCalls = 0;
      ctrl.setQuery('a');
      async.elapse(const Duration(milliseconds: 100));
      ctrl.setQuery('ab'); // 'a' 타이머 취소
      async.elapse(const Duration(milliseconds: 300));
      async.flushMicrotasks();

      expect(fake.searchCalls, 1);
      expect(fake.lastSearchQ, 'ab');
    });
  });

  test('응답 도착 전 쿼리가 바뀌면 stale 결과는 버린다', () {
    fakeAsync((async) {
      final fake = FakeFriendsApi()
        ..searchResult = const FriendSearchResponse(); // build: 빈 목록
      final c = ProviderContainer(
        overrides: [friendsApiProvider.overrideWithValue(fake)],
      );
      addTearDown(c.dispose);
      final ctrl = c.read(friendSearchControllerProvider.notifier);
      async.flushMicrotasks();

      // 'a' 검색을 게이트로 붙잡아 in-flight 로 만든다.
      fake.searchGate = Completer<void>();
      fake.searchResult = FriendSearchResponse(users: [_user('A')]);
      ctrl.setQuery('a');
      async
          .elapse(const Duration(milliseconds: 300)); // _fetch('a') 시작 → 게이트 대기
      expect(fake.lastSearchQ, 'a');

      // 응답 도착 전에 쿼리를 'b' 로 변경
      ctrl.setQuery('b');

      // 이제 'a' 응답 도착 → q('a') != state.query('b') 이므로 무시되어야 함
      fake.searchGate!.complete();
      async.flushMicrotasks();

      expect(ctrl.state.users, isEmpty); // stale 'A' 결과 미반영
    });
  });
}
