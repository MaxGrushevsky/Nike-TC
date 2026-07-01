class WorkoutItem {
  const WorkoutItem({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
}

class CollectionItem {
  const CollectionItem({
    required this.title,
    required this.workoutCount,
    required this.imageAsset,
  });

  final String title;
  final int workoutCount;
  final String imageAsset;
}

abstract final class WorkoutsMockData {
  WorkoutsMockData._();

  static const newWorkouts = [
    WorkoutItem(
      title: 'Full Body Burn',
      subtitle: '25 min · Intermediate',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Core Crusher',
      subtitle: '15 min · Beginner',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Leg Day Power',
      subtitle: '30 min · Advanced',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Morning Yoga Flow',
      subtitle: '20 min · All Levels',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'HIIT Express',
      subtitle: '12 min · Intermediate',
      imageAsset: 'assets/images/login_background.jpg',
    ),
  ];

  static const topPicks = [
    WorkoutItem(
      title: 'Abs & Arms',
      subtitle: '18 min · Intermediate',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Glute Builder',
      subtitle: '22 min · Advanced',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Cardio Kickstart',
      subtitle: '16 min · Beginner',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Strength Basics',
      subtitle: '28 min · All Levels',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Stretch & Recover',
      subtitle: '14 min · Beginner',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
  ];

  static const collections = [
    CollectionItem(
      title: 'Start Strong',
      workoutCount: 12,
      imageAsset: 'assets/images/login_background.jpg',
    ),
    CollectionItem(
      title: 'No Equipment',
      workoutCount: 18,
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    CollectionItem(
      title: 'Quick Sweat',
      workoutCount: 9,
      imageAsset: 'assets/images/login_background.jpg',
    ),
    CollectionItem(
      title: 'Build Muscle',
      workoutCount: 15,
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    CollectionItem(
      title: 'Mind & Body',
      workoutCount: 11,
      imageAsset: 'assets/images/login_background.jpg',
    ),
  ];

  static const savedWorkouts = [
    WorkoutItem(
      title: 'Full Body Burn',
      subtitle: '25 min · Intermediate',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Abs & Arms',
      subtitle: '18 min · Intermediate',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Stretch & Recover',
      subtitle: '14 min · Beginner',
      imageAsset: 'assets/images/login_background.jpg',
    ),
  ];

  static const browseWorkouts = [
    WorkoutItem(
      title: 'Total Body Tone',
      subtitle: '24 min · All Levels',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Power Intervals',
      subtitle: '20 min · Advanced',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Mobility Flow',
      subtitle: '18 min · Beginner',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Endurance Run Prep',
      subtitle: '26 min · Intermediate',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Athlete Core',
      subtitle: '16 min · Advanced',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
  ];

  static const browseMuscleGroup = [
    WorkoutItem(
      title: 'Upper Body Focus',
      subtitle: '22 min · Intermediate',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Lower Body Focus',
      subtitle: '28 min · Intermediate',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Core Focus',
      subtitle: '15 min · Beginner',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Back & Shoulders',
      subtitle: '19 min · Advanced',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Glutes & Hamstrings',
      subtitle: '21 min · Intermediate',
      imageAsset: 'assets/images/login_background.jpg',
    ),
  ];

  static const plansFourWeek = [
    WorkoutItem(
      title: 'Lean & Strong',
      subtitle: '4 weeks · Intermediate',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Run Ready',
      subtitle: '4 weeks · Beginner',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Muscle Up',
      subtitle: '4 weeks · Advanced',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Yoga Journey',
      subtitle: '4 weeks · All Levels',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Fat Burn Challenge',
      subtitle: '4 weeks · Intermediate',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
  ];

  static const plansBeginner = [
    WorkoutItem(
      title: 'First Steps',
      subtitle: '3 weeks · Beginner',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Move Every Day',
      subtitle: '2 weeks · Beginner',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Foundations',
      subtitle: '4 weeks · Beginner',
      imageAsset: 'assets/images/login_background.jpg',
    ),
    WorkoutItem(
      title: 'Home Starter',
      subtitle: '3 weeks · Beginner',
      imageAsset: 'assets/images/login_background_2.jpg',
    ),
    WorkoutItem(
      title: 'Easy Cardio',
      subtitle: '2 weeks · Beginner',
      imageAsset: 'assets/images/login_background.jpg',
    ),
  ];

  static const collectionWorkouts = {
    'Start Strong': [
      WorkoutItem(
        title: 'Day 1 Kickoff',
        subtitle: '20 min · Beginner',
        imageAsset: 'assets/images/login_background.jpg',
      ),
      WorkoutItem(
        title: 'Strength Intro',
        subtitle: '22 min · Beginner',
        imageAsset: 'assets/images/login_background_2.jpg',
      ),
      WorkoutItem(
        title: 'Active Recovery',
        subtitle: '15 min · All Levels',
        imageAsset: 'assets/images/login_background.jpg',
      ),
    ],
    'No Equipment': [
      WorkoutItem(
        title: 'Bodyweight Basics',
        subtitle: '18 min · Beginner',
        imageAsset: 'assets/images/login_background_2.jpg',
      ),
      WorkoutItem(
        title: 'Living Room HIIT',
        subtitle: '16 min · Intermediate',
        imageAsset: 'assets/images/login_background.jpg',
      ),
      WorkoutItem(
        title: 'Core Anywhere',
        subtitle: '14 min · All Levels',
        imageAsset: 'assets/images/login_background_2.jpg',
      ),
    ],
    'Quick Sweat': [
      WorkoutItem(
        title: '10-Min Blast',
        subtitle: '10 min · Intermediate',
        imageAsset: 'assets/images/login_background.jpg',
      ),
      WorkoutItem(
        title: 'Express Cardio',
        subtitle: '12 min · Advanced',
        imageAsset: 'assets/images/login_background_2.jpg',
      ),
      WorkoutItem(
        title: 'Fast Finisher',
        subtitle: '8 min · All Levels',
        imageAsset: 'assets/images/login_background.jpg',
      ),
    ],
  };
}
