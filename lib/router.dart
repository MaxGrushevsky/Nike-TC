import 'package:flutter/material.dart';

import 'custom_animation_route.dart';
import 'screens/dashboard.dart';
import 'screens/join.dart';
import 'screens/login.dart';
import 'screens/welcome.dart';

class AppRouter {
  AppRouter._();

  static const welcome = '/';
  static const login = '/login';
  static const join = '/join';
  static const dashboard = '/dashboard';

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
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => const DashboardPage(),
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
    Navigator.of(context).pushReplacementNamed(dashboard);
  }
}
