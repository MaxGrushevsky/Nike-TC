import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api/exercises_api.dart';
import 'core/dio_client.dart';
import 'navigation/app_route_observer.dart';
import 'providers/workouts_provider.dart';
import 'router.dart';

final AppRouteObserver appRouteObserver = AppRouteObserver();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          WorkoutsProvider(ExercisesApi(createDio()))..loadWorkouts(),
      child: const MainApp(),
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
      navigatorObservers: [appRouteObserver],
    );
  }
}
