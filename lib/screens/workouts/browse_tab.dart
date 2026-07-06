import 'package:flutter/material.dart';

import '../../widgets/workouts/workout_card.dart';
import '../../widgets/workouts/workouts_horizontal_section.dart';
import '../../widgets/workouts/workouts_tab_body.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkoutsTabBody(
      builder: (context, provider) {
        return ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          children: [
            WorkoutsHorizontalSection(
              title: 'Popular Workouts',
              height: 200,
              itemCount: provider.browseWorkouts.length,
              itemBuilder: (context, index) {
                return WorkoutCard(item: provider.browseWorkouts[index]);
              },
            ),
            const SizedBox(height: 24),
            WorkoutsHorizontalSection(
              title: 'By Muscle Group',
              height: 200,
              itemCount: provider.browseMuscleGroup.length,
              itemBuilder: (context, index) {
                return WorkoutCard(item: provider.browseMuscleGroup[index]);
              },
            ),
          ],
        );
      },
    );
  }
}
