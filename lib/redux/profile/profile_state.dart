import '../../models/user_profile.dart';

class ProfileState {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.blockedFriendIds = const {},
  });

  final UserProfile? profile;
  final bool isLoading;
  final Set<String> blockedFriendIds;

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    Set<String>? blockedFriendIds,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      blockedFriendIds: blockedFriendIds ?? this.blockedFriendIds,
    );
  }
}
