abstract final class WorkoutsMockData {
  WorkoutsMockData._();

  static const _exercises = [
    {
      'name': 'Barbell Bench Press',
      'type': 'strength',
      'muscle': 'chest',
      'difficulty': 'intermediate',
      'equipments': ['barbell'],
    },
    {
      'name': 'Push Ups',
      'type': 'strength',
      'muscle': 'chest',
      'difficulty': 'beginner',
      'equipments': ['body weight'],
    },
    {
      'name': 'Jump Rope',
      'type': 'cardio',
      'muscle': 'cardiovascular system',
      'difficulty': 'beginner',
      'equipments': ['rope'],
    },
    {
      'name': 'Arnold Press',
      'type': 'strength',
      'muscle': 'shoulders',
      'difficulty': 'intermediate',
      'equipments': ['dumbbell'],
    },
    {
      'name': 'Deadlift',
      'type': 'strength',
      'muscle': 'glutes',
      'difficulty': 'expert',
      'equipments': ['barbell'],
    },
    {
      'name': 'Hamstring Stretch',
      'type': 'stretching',
      'muscle': 'hamstrings',
      'difficulty': 'beginner',
      'equipments': ['body weight'],
    },
    {
      'name': 'Concentration Curl',
      'type': 'strength',
      'muscle': 'biceps',
      'difficulty': 'beginner',
      'equipments': ['dumbbell'],
    },
    {
      'name': 'Crunches',
      'type': 'strength',
      'muscle': 'abdominals',
      'difficulty': 'beginner',
      'equipments': ['body weight'],
    },
    {
      'name': 'Squat',
      'type': 'strength',
      'muscle': 'quadriceps',
      'difficulty': 'intermediate',
      'equipments': ['barbell'],
    },
  ];

  static List<Map<String, dynamic>> exercisesFor({
    String? muscle,
    String? type,
    String? difficulty,
  }) {
    return _exercises
        .where((exercise) {
          if (muscle != null && exercise['muscle'] != muscle) {
            return false;
          }
          if (type != null && exercise['type'] != type) {
            return false;
          }
          if (difficulty != null && exercise['difficulty'] != difficulty) {
            return false;
          }
          return true;
        })
        .map((exercise) => Map<String, dynamic>.from(exercise))
        .toList();
  }
}
