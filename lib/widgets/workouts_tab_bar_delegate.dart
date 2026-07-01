import 'package:flutter/material.dart';

class WorkoutsTabBarDelegate extends SliverPersistentHeaderDelegate {
  WorkoutsTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant WorkoutsTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
