class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.duration,
  });

  final String id;
  final String type;
  final DateTime dateTime;
  final Duration duration;

  int get durationInMinutes => duration.inMinutes;
}
