import 'package:flutter/material.dart';

import '../../models/workout_item.dart';
import '../../widgets/workouts/workout_card.dart';
import '../../widgets/workouts/workouts_horizontal_section.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        WorkoutsHorizontalSection(
          title: 'Popular Workouts',
          height: 200,
          itemCount: WorkoutsMockData.browseWorkouts.length,
          itemBuilder: (context, index) {
            return WorkoutCard(item: WorkoutsMockData.browseWorkouts[index]);
          },
        ),
        const SizedBox(height: 24),
        WorkoutsHorizontalSection(
          title: 'By Muscle Group',
          height: 200,
          itemCount: WorkoutsMockData.browseMuscleGroup.length,
          itemBuilder: (context, index) {
            return WorkoutCard(item: WorkoutsMockData.browseMuscleGroup[index]);
          },
        ),
      ],
    );
  }
}
