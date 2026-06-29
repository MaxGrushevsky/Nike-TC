import 'package:flutter/material.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logTransition('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logTransition('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
      '[AppRouteObserver] REPLACE: '
      '${oldRoute?.settings.name ?? 'unknown'} -> '
      '${newRoute?.settings.name ?? 'unknown'}',
    );
  }

  void _logTransition(
    String action,
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    debugPrint(
      '[AppRouteObserver] $action: '
      '${previousRoute?.settings.name ?? 'none'} -> '
      '${route.settings.name ?? 'unknown'}',
    );
  }
}
