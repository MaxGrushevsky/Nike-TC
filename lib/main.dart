import 'package:flutter/material.dart';

import 'navigation/app_route_observer.dart';
import 'router.dart';

final AppRouteObserver appRouteObserver = AppRouteObserver();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Oswald'),
      initialRoute: AppRouter.welcome,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [appRouteObserver],
    );
  }
}
