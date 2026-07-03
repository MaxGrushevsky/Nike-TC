import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workouts_provider.dart';
import '../../widgets/workouts/workout_thumbnail.dart';

class SavedWorkoutsPage extends StatelessWidget {
  const SavedWorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Workouts')),
      body: Consumer<WorkoutsProvider>(
        builder: (context, provider, _) {
          final savedWorkouts = provider.savedWorkouts;

          if (savedWorkouts.isEmpty) {
            return const Center(
              child: Text('No saved workouts yet. Tap the heart on a workout.'),
            );
          }

          return ListView.separated(
            itemCount: savedWorkouts.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final workout = savedWorkouts[index];
              return ListTile(
                leading: WorkoutThumbnail(item: workout),
                title: Text(workout.title),
                subtitle: Text(workout.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
