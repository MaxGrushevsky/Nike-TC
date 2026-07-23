import 'profile/profile_state.dart';

class AppState {
  const AppState({
    this.profile = const ProfileState(),
  });

  final ProfileState profile;

  AppState copyWith({ProfileState? profile}) {
    return AppState(profile: profile ?? this.profile);
  }
}
