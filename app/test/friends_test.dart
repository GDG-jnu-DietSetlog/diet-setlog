import 'package:flutter_test/flutter_test.dart';
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

void main() {
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
}
