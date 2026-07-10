import '../../models/activity_item.dart';

abstract final class ActivityMockData {
  ActivityMockData._();

  static const activityTypes = [
    'American Football',
    'Baseball/Softball',
    'Basketball',
    'Boxing/Martial Arts',
    'Cricket',
    'Cycling',
    'Dance',
    'Golf',
    'Gym',
    'Hiking',
    'Running',
    'Soccer',
    'Swimming',
    'Tennis',
    'Yoga',
  ];

  static const filterOptions = [
    'All Activity',
    ...activityTypes,
  ];

  static final List<ActivityItem> seedActivities = [
    ActivityItem(
      id: '1',
      type: 'Basketball',
      dateTime: DateTime(2021, 2, 2, 5, 0),
      duration: const Duration(minutes: 30),
    ),
  ];
}
