import 'package:redux/redux.dart';

import '../../services/blocked_friends_service.dart';
import '../../services/profile_persistence_service.dart';
import '../app_state.dart';
import 'profile_actions.dart';

List<Middleware<AppState>> createProfileMiddleware() {
  return [
    TypedMiddleware<AppState, LoadProfileAction>(_loadProfile).call,
    TypedMiddleware<AppState, SaveProfileAction>(_saveProfile).call,
    TypedMiddleware<AppState, LoadBlockedFriendsAction>(_loadBlockedFriends).call,
    TypedMiddleware<AppState, BlockFriendAction>(_blockFriend).call,
  ];
}

void _loadProfile(
  Store<AppState> store,
  LoadProfileAction action,
  NextDispatcher next,
) {
  next(action);

  ProfilePersistenceService.loadProfile().then((profile) {
    store.dispatch(ProfileLoadedAction(profile));
  });
}

void _saveProfile(
  Store<AppState> store,
  SaveProfileAction action,
  NextDispatcher next,
) {
  next(action);

  ProfilePersistenceService.saveProfile(action.profile).then((_) {
    store.dispatch(ProfileSavedAction(action.profile));
  });
}

void _loadBlockedFriends(
  Store<AppState> store,
  LoadBlockedFriendsAction action,
  NextDispatcher next,
) {
  next(action);

  BlockedFriendsService.loadBlockedIds().then((blockedIds) {
    store.dispatch(BlockedFriendsLoadedAction(blockedIds));
  });
}

void _blockFriend(
  Store<AppState> store,
  BlockFriendAction action,
  NextDispatcher next,
) {
  next(action);

  BlockedFriendsService.blockFriend(action.friendId).then((_) {
    store.dispatch(FriendBlockedAction(action.friendId));
  });
}
