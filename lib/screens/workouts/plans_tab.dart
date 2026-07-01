import 'package:flutter/material.dart';

import '../../models/workout_item.dart';
import '../../widgets/workouts/workout_card.dart';
import '../../widgets/workouts/workouts_horizontal_section.dart';

class PlansTab extends StatelessWidget {
  const PlansTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        WorkoutsHorizontalSection(
          title: '4-Week Plans',
          height: 200,
          itemCount: WorkoutsMockData.plansFourWeek.length,
          itemBuilder: (context, index) {
            return WorkoutCard(item: WorkoutsMockData.plansFourWeek[index]);
          },
        ),
        const SizedBox(height: 24),
        WorkoutsHorizontalSection(
          title: 'Beginner Plans',
          height: 200,
          itemCount: WorkoutsMockData.plansBeginner.length,
          itemBuilder: (context, index) {
            return WorkoutCard(item: WorkoutsMockData.plansBeginner[index]);
          },
        ),
      ],
    );
  }
}
