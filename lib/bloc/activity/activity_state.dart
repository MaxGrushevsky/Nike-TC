import 'package:equatable/equatable.dart';

import '../../models/activity_item.dart';

class ActivityState extends Equatable {
  const ActivityState({
    this.activities = const [],
    this.selectedFilter = 'All Activity',
  });

  final List<ActivityItem> activities;
  final String selectedFilter;

  List<ActivityItem> get sortedActivities {
    final items = List<ActivityItem>.from(activities)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return items;
  }

  List<ActivityItem> get filteredActivities {
    if (selectedFilter == 'All Activity') {
      return sortedActivities;
    }

    return sortedActivities
        .where((activity) => activity.type == selectedFilter)
        .toList();
  }

  int get totalActivities => filteredActivities.length;

  int get totalMinutes => filteredActivities.fold<int>(
        0,
        (sum, activity) => sum + activity.durationInMinutes,
      );

  Map<String, List<ActivityItem>> get groupedActivities {
    final grouped = <String, List<ActivityItem>>{};

    for (final activity in filteredActivities) {
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

  ActivityState copyWith({
    List<ActivityItem>? activities,
    String? selectedFilter,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
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
  List<Object?> get props => [activities, selectedFilter];
}
