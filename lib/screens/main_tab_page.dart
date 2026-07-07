import 'package:flutter/material.dart';

import '../navigation/main_tab.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key, this.initialTab = MainTab.workoutsTabIndex});

  static const int workoutsTabIndex = MainTab.workoutsTabIndex;
  static const int inboxTabIndex = MainTab.inboxTabIndex;

  final int initialTab;

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: MainTabs.pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: MainTabs.navigationItems,
      ),
    );
  }
}
