import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activity/activity_bloc.dart';
import '../bloc/activity/activity_event.dart';
import '../navigation/main_tab.dart';
import '../services/inbox_persistence_service.dart';
import '../widgets/inbox/inbox_permissions_dialog.dart';

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
  bool _inboxOpenRegisteredThisSession = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == MainTab.inboxTabIndex) {
        _handleInboxTabSelected();
      }
    });
  }

  Future<void> _handleInboxTabSelected() async {
    if (_inboxOpenRegisteredThisSession) {
      return;
    }
    _inboxOpenRegisteredThisSession = true;

    final openCount = await InboxPersistenceService.incrementOpenCount();
    if (!InboxPersistenceService.shouldShowPermissions(openCount) || !mounted) {
      return;
    }

    await InboxPermissionsDialog.show(context);
  }

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);

    if (index == MainTab.inboxTabIndex) {
      _handleInboxTabSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityBloc()..add(const ActivityStarted()),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: MainTabs.pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: MainTabs.navigationItems,
        ),
      ),
    );
  }
}
