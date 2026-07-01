import 'package:flutter/material.dart';

import 'custom_animation_route.dart';
import 'screens/join.dart';
import 'screens/login.dart';
import 'screens/main_tab_page.dart';
import 'screens/workouts/saved_workouts_page.dart';
import 'screens/welcome.dart';

class AppRouter {
  AppRouter._();

  static const welcome = '/';
  static const login = '/login';
  static const join = '/join';
  static const dashboard = '/dashboard';
  static const savedWorkouts = '/saved-workouts';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );
      case login:
        return CustomAnimationRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => const LoginScreen(),
        );
      case join:
        return CustomAnimationRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => const JoinScreen(),
        );
      case dashboard:
        final initialTab =
            settings.arguments as int? ?? MainTabPage.workoutsTabIndex;
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => MainTabPage(initialTab: initialTab),
        );
      case savedWorkouts:
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => const SavedWorkoutsPage(),
        );
      default:
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );
    }
  }

  static Future<void> openLogin(BuildContext context) {
    return Navigator.of(context).pushNamed(login);
  }

  static Future<void> openJoin(BuildContext context) {
    return Navigator.of(context).pushNamed(join);
  }

  static void replaceWithDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacementNamed(dashboard, arguments: MainTabPage.workoutsTabIndex);
  }

  static Future<void> openSavedWorkouts(BuildContext context) {
    return Navigator.of(context).pushNamed(savedWorkouts);
  }
}
