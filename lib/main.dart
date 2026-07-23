import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

import 'api/exercises_api.dart';
import 'core/dio_client.dart';
import 'core/firebase_bootstrap.dart';
import 'core/webview_bootstrap.dart';
import 'navigation/app_route_observer.dart';
import 'providers/workouts_provider.dart';
import 'redux/app_state.dart';
import 'redux/store.dart';
import 'router.dart';

final AppRouteObserver appRouteObserver = AppRouteObserver();
final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ensureWebViewPlatform();
  await bootstrapFirebase();

  final store = createAppStore();

  runApp(
    StoreProvider<AppState>(
      store: store,
      child: ChangeNotifierProvider(
        create: (_) =>
            WorkoutsProvider(ExercisesApi(createDio()))..loadWorkouts(),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Typography.blackMountainView.apply(fontFamily: 'Oswald'),
        primaryTextTheme: Typography.blackMountainView.apply(
          fontFamily: 'Oswald',
        ),
      ),
      initialRoute: AppRouter.welcome,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [
        appRouteObserver,
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
    );
  }
}
