import 'package:flutter/material.dart';

import '../screens/activity_page.dart';
import '../screens/feed_page.dart';
import '../screens/inbox_page.dart';
import '../screens/workouts/workouts_page.dart';

enum MainTab {
  feed,
  activity,
  workouts,
  inbox;

  static const int workoutsTabIndex = 2;
}

class MainTabItem {
  const MainTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
}

abstract final class MainTabs {
  MainTabs._();

  static const Map<MainTab, MainTabItem> items = {
    MainTab.feed: MainTabItem(
      label: 'Feed',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      page: FeedPage(),
    ),
    MainTab.activity: MainTabItem(
      label: 'Activity',
      icon: Icons.show_chart_outlined,
      activeIcon: Icons.show_chart,
      page: ActivityPage(),
    ),
    MainTab.workouts: MainTabItem(
      label: 'Workouts',
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center,
      page: WorkoutsPage(),
    ),
    MainTab.inbox: MainTabItem(
      label: 'Inbox',
      icon: Icons.mail_outline,
      activeIcon: Icons.mail,
      page: InboxPage(),
    ),
  };

  static List<Widget> get pages =>
      MainTab.values.map((tab) => items[tab]!.page).toList();

  static List<BottomNavigationBarItem> get navigationItems =>
      MainTab.values.map((tab) {
        final item = items[tab]!;
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: item.label,
        );
      }).toList();
}
