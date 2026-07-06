import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
      newWorkouts = await _fetch(
        type: 'strength',
        difficulty: 'intermediate',
      );
      topPicks = await _fetch(type: 'strength', difficulty: 'beginner');
      browseWorkouts = await _fetch(type: 'cardio');
      browseMuscleGroup = await _fetch(muscle: 'shoulders');
      plansFourWeek = await _fetch(type: 'strength', difficulty: 'expert');
      plansBeginner = await _fetch(type: 'stretching', difficulty: 'beginner');
      collectionWorkouts = await _fetchCollections();

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
    } catch (error, stackTrace) {
      errorMessage = _mapError(error);
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Failed to load workouts',
      );
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
    final collections = <String, List<WorkoutItem>>{};

    for (final entry in _collectionMuscles.entries) {
      collections[entry.key] = await _fetch(muscle: entry.value);
    }

    return collections;
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
