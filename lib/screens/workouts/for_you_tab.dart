import 'package:flutter/material.dart';

import '../../widgets/workouts/collection_card.dart';
import '../../widgets/workouts/workout_card.dart';
import '../../widgets/workouts/workouts_horizontal_section.dart';
import '../../widgets/workouts/workouts_tab_body.dart';

class ForYouTab extends StatelessWidget {
  const ForYouTab({super.key, required this.onViewAllCollections});

  final VoidCallback onViewAllCollections;

  @override
  Widget build(BuildContext context) {
    return WorkoutsTabBody(
      builder: (context, provider) {
        return ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          children: [
            WorkoutsHorizontalSection(
              title: 'New Workouts',
              height: 200,
              itemCount: provider.newWorkouts.length,
              itemBuilder: (context, index) {
                return WorkoutCard(item: provider.newWorkouts[index]);
              },
            ),
            const SizedBox(height: 24),
            WorkoutsHorizontalSection(
              title: 'Top Picks for You',
              height: 200,
              itemCount: provider.topPicks.length,
              itemBuilder: (context, index) {
                return WorkoutCard(item: provider.topPicks[index]);
              },
            ),
            const SizedBox(height: 24),
            WorkoutsHorizontalSection(
              title: 'Collections',
              height: 260,
              trailingLabel: 'View All',
              onTrailingTap: onViewAllCollections,
              itemCount: provider.collections.length,
              itemBuilder: (context, index) {
                return CollectionCard(item: provider.collections[index]);
              },
            ),
          ],
        );
      },
    );
  }
}
