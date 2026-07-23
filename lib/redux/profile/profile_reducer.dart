import 'profile_actions.dart';
import 'profile_state.dart';

ProfileState profileReducer(ProfileState state, dynamic action) {
  if (action is LoadProfileAction) {
    return state.copyWith(isLoading: true);
  }

  if (action is ProfileLoadedAction) {
    return state.copyWith(profile: action.profile, isLoading: false);
  }

  if (action is ProfileSavedAction) {
    return state.copyWith(profile: action.profile, isLoading: false);
  }

  if (action is BlockedFriendsLoadedAction) {
    return state.copyWith(blockedFriendIds: action.blockedIds);
  }

  if (action is BlockFriendAction || action is FriendBlockedAction) {
    final friendId = action is BlockFriendAction
        ? action.friendId
        : (action as FriendBlockedAction).friendId;
    return state.copyWith(
      blockedFriendIds: {...state.blockedFriendIds, friendId},
    );
  }

  return state;
}
