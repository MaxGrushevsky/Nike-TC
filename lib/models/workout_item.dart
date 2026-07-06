class WorkoutItem {
  const WorkoutItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageAsset;
}

class CollectionItem {
  const CollectionItem({
    required this.id,
    required this.title,
    required this.workoutCount,
    required this.imageAsset,
  });

  final String id;
  final String title;
  final int workoutCount;
  final String imageAsset;
}
