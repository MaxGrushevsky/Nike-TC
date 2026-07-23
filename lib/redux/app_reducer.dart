import 'app_state.dart';
import 'profile/profile_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    profile: profileReducer(state.profile, action),
  );
}
