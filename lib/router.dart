import 'package:flutter/material.dart';

import 'custom_animation_route.dart';
import 'screens/activity/activity_detail_page.dart';
import 'screens/inbox/inbox_detail_page.dart';
import 'models/activity_item.dart';
import 'models/inbox_message.dart';
import 'screens/profile/edit_profile_page.dart';
import 'screens/profile/profile_page.dart';
import 'screens/profile/find_friends_page.dart';
import 'screens/profile/profile_pass_page.dart';
import 'screens/profile/settings_page.dart';
import 'models/user_profile.dart';
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
  static const inboxDetail = '/inbox-detail';
  static const activityDetail = '/activity-detail';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';

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
      case inboxDetail:
        final message = settings.arguments! as InboxMessage;
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => InboxDetailPage(message: message),
        );
      case activityDetail:
        final activity = settings.arguments! as ActivityItem;
        return CustomAnimationRoute(
          settings: settings,
          builder: (_) => ActivityDetailPage(activity: activity),
        );
      case profile:
        return CustomAnimationRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => const ProfilePage(),
        );
      case editProfile:
        final profile = settings.arguments! as UserProfile;
        return CustomAnimationRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => EditProfilePage(profile: profile),
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

  static Future<void> openInboxDetail(
    BuildContext context,
    InboxMessage message,
  ) {
    return Navigator.of(context).pushNamed(inboxDetail, arguments: message);
  }

  static Future<void> openActivityDetail(
    BuildContext context,
    ActivityItem activity,
  ) {
    return Navigator.of(context).pushNamed(activityDetail, arguments: activity);
  }

  static Future<void> openProfile(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );
  }

  static Future<UserProfile?> openEditProfile(
    BuildContext context,
    UserProfile profile,
  ) {
    return Navigator.of(context).push<UserProfile>(
      MaterialPageRoute(
        builder: (_) => EditProfilePage(profile: profile),
      ),
    );
  }

  static Future<void> openProfilePass(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfilePassPage(),
      ),
    );
  }

  static Future<void> openSettings(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SettingsPage(),
      ),
    );
  }

  static Future<void> openFindFriends(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FindFriendsPage(),
      ),
    );
  }
}
