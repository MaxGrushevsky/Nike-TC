import 'package:flutter/material.dart';

import '../data/mock/activity_mock_data.dart';
import '../models/activity_item.dart';
import 'activity/activity_filter_page.dart';
import 'activity/add_activity_page.dart';

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
  late List<ActivityItem> _activities;
  String _selectedFilter = ActivityMockData.filterOptions.first;

  @override
  void initState() {
    super.initState();
    _activities = List<ActivityItem>.from(ActivityMockData.seedActivities);
    _tabController = TabController(length: ActivityTab.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ActivityItem> get _filteredActivities {
    if (_selectedFilter == 'All Activity') {
      return _sortedActivities;
    }

    return _sortedActivities
        .where((activity) => activity.type == _selectedFilter)
        .toList();
  }

  List<ActivityItem> get _sortedActivities {
    final activities = List<ActivityItem>.from(_activities)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return activities;
  }

  int get _totalActivities => _filteredActivities.length;

  int get _totalMinutes => _filteredActivities.fold<int>(
        0,
        (sum, activity) => sum + activity.durationInMinutes,
      );

  Future<void> _openAddActivity() async {
    final activity = await Navigator.of(context).push<ActivityItem>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const AddActivityPage(),
      ),
    );

    if (activity == null || !mounted) return;
    setState(() => _activities = [..._activities, activity]);
  }

  Future<void> _openFilter() async {
    final filter = await ActivityFilterPage.show(
      context,
      selectedFilter: _selectedFilter,
    );

    if (filter == null || !mounted) return;
    setState(() => _selectedFilter = filter);
  }

  Map<String, List<ActivityItem>> _groupActivitiesByMonth(
    List<ActivityItem> activities,
  ) {
    final grouped = <String, List<ActivityItem>>{};

    for (final activity in activities) {
      final key = _monthYearLabel(activity.dateTime);
      grouped.putIfAbsent(key, () => []).add(activity);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final aDate = grouped[a]!.first.dateTime;
        final bDate = grouped[b]!.first.dateTime;
        return bDate.compareTo(aDate);
      });

    return {for (final key in sortedKeys) key: grouped[key]!};
  }

  String _monthYearLabel(DateTime dateTime) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
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
                    totalActivities: _totalActivities,
                    totalMinutes: _totalMinutes,
                    selectedFilter: _selectedFilter,
                    groupedActivities: _groupActivitiesByMonth(_filteredActivities),
                    onFilterTap: _openFilter,
                  ),
                  const Center(child: Text('Achievements coming soon')),
                ],
              ),
            ),
          ],
        ),
      ),
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
    required this.totalActivities,
    required this.totalMinutes,
    required this.selectedFilter,
    required this.groupedActivities,
    required this.onFilterTap,
  });

  final int totalActivities;
  final int totalMinutes;
  final String selectedFilter;
  final Map<String, List<ActivityItem>> groupedActivities;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 500;

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
                          value: '$totalActivities',
                          label: 'Total Activities',
                        ),
                        _StatBlock(
                          value: '$totalMinutes',
                          label: 'Total Minutes',
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _StatBlock(
                          value: '$totalActivities',
                          label: 'Total Activities',
                        ),
                        const SizedBox(height: 20),
                        _StatBlock(
                          value: '$totalMinutes',
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
                        selectedFilter,
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
                    ...entry.value.map((activity) => _ActivityListItem(activity: activity)),
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
    final dateLabel = _formatActivityDate(activity.dateTime);
    final durationLabel = _formatDuration(activity.duration);

    return Column(
      children: [
        Padding(
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
        const Divider(height: 1),
      ],
    );
  }

  String _formatActivityDate(DateTime dateTime) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[dateTime.weekday - 1];
    final month = months[dateTime.month - 1];
    return '$weekday, ${dateTime.day} $month';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
