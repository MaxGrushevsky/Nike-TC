import 'package:flutter/material.dart';

import '../../widgets/workouts/workout_card.dart';
import '../../widgets/workouts/workouts_horizontal_section.dart';
import '../../widgets/workouts/workouts_tab_body.dart';

class PlansTab extends StatelessWidget {
  const PlansTab({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkoutsTabBody(
      builder: (context, provider) {
        return ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          children: [
            WorkoutsHorizontalSection(
              title: '4-Week Plans',
              height: 200,
              itemCount: provider.plansFourWeek.length,
              itemBuilder: (context, index) {
                return WorkoutCard(item: provider.plansFourWeek[index]);
              },
            ),
            const SizedBox(height: 24),
            WorkoutsHorizontalSection(
              title: 'Beginner Plans',
              height: 200,
              itemCount: provider.plansBeginner.length,
              itemBuilder: (context, index) {
                return WorkoutCard(item: provider.plansBeginner[index]);
              },
            ),
          ],
        );
      },
    );
  }
}
