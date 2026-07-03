import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api/exercises_api.dart';
import '../api/models/exercise_dto.dart';
import '../models/workout_item.dart';

class WorkoutsProvider extends ChangeNotifier {
  WorkoutsProvider(this._api);

  final ExercisesApi _api;
  final Set<String> _favoriteIds = {};

  bool isLoading = false;
  String? errorMessage;

  List<WorkoutItem> newWorkouts = [];
  List<WorkoutItem> topPicks = [];
  List<WorkoutItem> browseWorkouts = [];
  List<WorkoutItem> browseMuscleGroup = [];
  List<WorkoutItem> plansFourWeek = [];
  List<WorkoutItem> plansBeginner = [];
  List<CollectionItem> collections = [];
  Map<String, List<WorkoutItem>> collectionWorkouts = {};

  static const _fallbackImages = [
    'assets/images/login_background.jpg',
    'assets/images/login_background_2.jpg',
  ];

  static const _collectionMuscles = {
    'Biceps Focus': 'biceps',
    'Chest Power': 'chest',
    'Core Strength': 'abdominals',
    'Leg Day': 'quadriceps',
    'Glute Builder': 'glutes',
  };

  bool isFavorite(String workoutId) => _favoriteIds.contains(workoutId);

  void toggleFavorite(String workoutId) {
    if (_favoriteIds.contains(workoutId)) {
      _favoriteIds.remove(workoutId);
    } else {
      _favoriteIds.add(workoutId);
    }
    notifyListeners();
  }

  List<WorkoutItem> get savedWorkouts =>
      allWorkouts.where((workout) => isFavorite(workout.id)).toList();

  Future<void> loadWorkouts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _fetch(type: 'strength', difficulty: 'intermediate'),
        _fetch(type: 'strength', difficulty: 'beginner'),
        _fetch(type: 'cardio'),
        _fetch(muscle: 'shoulders'),
        _fetch(type: 'strength', difficulty: 'expert'),
        _fetch(type: 'stretching', difficulty: 'beginner'),
        _fetchCollections(),
      ]);

      newWorkouts = results[0] as List<WorkoutItem>;
      topPicks = results[1] as List<WorkoutItem>;
      browseWorkouts = results[2] as List<WorkoutItem>;
      browseMuscleGroup = results[3] as List<WorkoutItem>;
      plansFourWeek = results[4] as List<WorkoutItem>;
      plansBeginner = results[5] as List<WorkoutItem>;
      collectionWorkouts = results[6] as Map<String, List<WorkoutItem>>;

      collections = _collectionMuscles.entries.toList().asMap().entries.map((
        entry,
      ) {
        final title = entry.value.key;
        final workouts = collectionWorkouts[title] ?? [];
        return CollectionItem(
          id: title,
          title: title,
          workoutCount: workouts.length,
          imageAsset: _fallbackImages[entry.key % _fallbackImages.length],
        );
      }).toList();
    } catch (error) {
      errorMessage = _mapError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<WorkoutItem>> _fetch({
    String? muscle,
    String? type,
    String? difficulty,
  }) async {
    final exercises = await _api.getExercises(
      muscle: muscle,
      type: type,
      difficulty: difficulty,
    );

    return exercises
        .asMap()
        .entries
        .map((entry) => _toWorkoutItem(entry.value, entry.key))
        .toList();
  }

  Future<Map<String, List<WorkoutItem>>> _fetchCollections() async {
    final entries = await Future.wait(
      _collectionMuscles.entries.map((entry) async {
        final workouts = await _fetch(muscle: entry.value);
        return MapEntry(entry.key, workouts);
      }),
    );

    return Map.fromEntries(entries);
  }

  WorkoutItem _toWorkoutItem(ExerciseDto exercise, int index) {
    final equipment = exercise.equipments?.isNotEmpty == true
        ? exercise.equipments!.first
        : 'No equipment';

    return WorkoutItem(
      id: exercise.name,
      title: exercise.name,
      subtitle:
          '${_capitalize(exercise.muscle)} · ${_capitalize(exercise.difficulty)} · $equipment',
      imageAsset: _fallbackImages[index % _fallbackImages.length],
    );
  }

  List<WorkoutItem> get allWorkouts {
    final items = <WorkoutItem>[
      ...newWorkouts,
      ...topPicks,
      ...browseWorkouts,
      ...browseMuscleGroup,
      ...plansFourWeek,
      ...plansBeginner,
      ...collectionWorkouts.values.expand((workouts) => workouts),
    ];

    return {for (final item in items) item.id: item}.values.toList();
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map && responseData['error'] != null) {
        return responseData['error'].toString();
      }

      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return 'API request failed with status $statusCode';
      }

      return error.message ?? 'Network request failed';
    }

    return error.toString();
  }
}
