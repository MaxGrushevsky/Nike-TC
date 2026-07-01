import 'package:flutter/material.dart';

import '../../widgets/workouts_tab_bar_delegate.dart';
import 'workouts_tab_content.dart';

enum WorkoutsTab {
  forYou('For You'),
  browse('Browse'),
  collections('Collections'),
  plans('Plans');

  const WorkoutsTab(this.label);

  final String label;
}

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: WorkoutsTab.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSavedWorkoutsTap() {}

  void _onProfileTap() {}

  Widget _buildProfileButton() {
    return TextButton(
      onPressed: _onProfileTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSavedWorkoutsButton() {
    return TextButton(
      onPressed: _onSavedWorkoutsTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Saved Workouts',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildProfileButton(),
                const Spacer(),
                _buildSavedWorkoutsButton(),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Text(
                'Workouts',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      dividerColor: Colors.transparent,
      tabs: WorkoutsTab.values.map((tab) => Tab(text: tab.label)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPersistentHeader(
              pinned: true,
              delegate: WorkoutsTabBarDelegate(_buildTabBar()),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: WorkoutsTab.values
              .map((tab) => WorkoutsTabContent(title: tab.label))
              .toList(),
        ),
      ),
    );
  }
}
