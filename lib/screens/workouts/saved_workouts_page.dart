import 'package:flutter/material.dart';

import '../../models/workout_item.dart';

class SavedWorkoutsPage extends StatelessWidget {
  const SavedWorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Workouts')),
      body: ListView.separated(
        itemCount: WorkoutsMockData.savedWorkouts.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final workout = WorkoutsMockData.savedWorkouts[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                workout.imageAsset,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(workout.title),
            subtitle: Text(workout.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
      ),
    );
  }
}
