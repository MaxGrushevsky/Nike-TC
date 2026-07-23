import 'package:redux/redux.dart';

import 'app_reducer.dart';
import 'app_state.dart';
import 'profile/profile_actions.dart';
import 'profile/profile_middleware.dart';

Store<AppState> createAppStore() {
  final store = Store<AppState>(
    appReducer,
    initialState: const AppState(),
    middleware: createProfileMiddleware(),
  );

  store
    ..dispatch(const LoadProfileAction())
    ..dispatch(const LoadBlockedFriendsAction());

  return store;
}
