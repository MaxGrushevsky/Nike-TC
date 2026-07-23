import '../../models/user_profile.dart';

class LoadProfileAction {
  const LoadProfileAction();
}

class ProfileLoadedAction {
  const ProfileLoadedAction(this.profile);

  final UserProfile profile;
}

class SaveProfileAction {
  const SaveProfileAction(this.profile);

  final UserProfile profile;
}

class ProfileSavedAction {
  const ProfileSavedAction(this.profile);

  final UserProfile profile;
}

class LoadBlockedFriendsAction {
  const LoadBlockedFriendsAction();
}

class BlockedFriendsLoadedAction {
  const BlockedFriendsLoadedAction(this.blockedIds);

  final Set<String> blockedIds;
}

class BlockFriendAction {
  const BlockFriendAction(this.friendId);

  final String friendId;
}

class FriendBlockedAction {
  const FriendBlockedAction(this.friendId);

  final String friendId;
}
