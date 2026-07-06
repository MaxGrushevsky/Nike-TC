import 'package:flutter/material.dart';

import '../../widgets/workouts/collection_card.dart';
import '../../widgets/workouts/workout_card.dart';
import '../../widgets/workouts/workouts_horizontal_section.dart';
import '../../widgets/workouts/workouts_tab_body.dart';

class CollectionsTab extends StatelessWidget {
  const CollectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkoutsTabBody(
      builder: (context, provider) {
        return ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          children: [
            WorkoutsHorizontalSection(
              title: 'All Collections',
              height: 260,
              itemCount: provider.collections.length,
              itemBuilder: (context, index) {
                return CollectionCard(item: provider.collections[index]);
              },
            ),
            const SizedBox(height: 24),
            for (final entry in provider.collectionWorkouts.entries) ...[
              WorkoutsHorizontalSection(
                title: entry.key,
                height: 200,
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  return WorkoutCard(item: entry.value[index]);
                },
              ),
              const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }
}
