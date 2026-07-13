import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activity/activity_bloc.dart';
import '../bloc/activity/activity_event.dart';
import '../bloc/activity/activity_state.dart';
import '../models/activity_item.dart';
import '../router.dart';
import '../utils/activity_formatters.dart';
import 'activity/add_activity_page.dart';
import 'activity/activity_filter_page.dart';

enum ActivityTab {
  history('History'),
  achievements('Achievements');

  const ActivityTab(this.label);

  final String label;
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ActivityTab.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openAddActivity() async {
    final activity = await Navigator.of(context).push<ActivityItem>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const AddActivityPage(),
      ),
    );

    if (activity == null || !mounted) return;
    context.read<ActivityBloc>().add(ActivityAdded(activity));
  }

  Future<void> _openFilter(String selectedFilter) async {
    final filter = await ActivityFilterPage.show(
      context,
      selectedFilter: selectedFilter,
    );

    if (filter == null || !mounted) return;
    context.read<ActivityBloc>().add(ActivityFilterChanged(filter));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    'Activity',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  dividerColor: Colors.transparent,
                  tabs: ActivityTab.values
                      .map((tab) => Tab(text: tab.label))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _HistoryTab(
                        state: state,
                        onFilterTap: () => _openFilter(state.selectedFilter),
                      ),
                      const Center(child: Text('Achievements coming soon')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined, size: 30),
          ),
          const Spacer(),
          IconButton(
            onPressed: _openAddActivity,
            icon: const Icon(Icons.add, size: 30),
            tooltip: 'New Activity',
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.state,
    required this.onFilterTap,
  });

  final ActivityState state;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 500;
        final groupedActivities = state.groupedActivities;

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatBlock(
                          value: '${state.totalActivities}',
                          label: 'Total Activities',
                        ),
                        _StatBlock(
                          value: '${state.totalMinutes}',
                          label: 'Total Minutes',
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _StatBlock(
                          value: '${state.totalActivities}',
                          label: 'Total Activities',
                        ),
                        const SizedBox(height: 20),
                        _StatBlock(
                          value: '${state.totalMinutes}',
                          label: 'Total Minutes',
                        ),
                      ],
                    ),
            ),
            const Divider(height: 1),
            InkWell(
              onTap: onFilterTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedFilter,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.tune, size: 22),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            if (groupedActivities.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No activities found')),
              )
            else
              ...groupedActivities.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ...entry.value.map(
                      (activity) => _ActivityListItem(activity: activity),
                    ),
                  ],
                );
              }),
          ],
        );
      },
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _ActivityListItem extends StatelessWidget {
  const _ActivityListItem({required this.activity});

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    final dateLabel = ActivityFormatters.listDateLabel(activity.dateTime);
    final durationLabel = ActivityFormatters.durationLabel(activity.duration);

    return Column(
      children: [
        InkWell(
          onTap: () => AppRouter.openActivityDetail(context, activity),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bar_chart, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dateLabel $durationLabel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
