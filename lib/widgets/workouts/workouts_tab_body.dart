import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workouts_provider.dart';

class WorkoutsTabBody extends StatelessWidget {
  const WorkoutsTabBody({super.key, required this.builder});

  final Widget Function(BuildContext context, WorkoutsProvider provider)
  builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.newWorkouts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null && provider.newWorkouts.isEmpty) {
          return _WorkoutsMessage(
            title: 'Failed to load workouts',
            message: provider.errorMessage!,
            action: TextButton(
              onPressed: provider.loadWorkouts,
              child: const Text('Retry'),
            ),
          );
        }

        return builder(context, provider);
      },
    );
  }
}

class _WorkoutsMessage extends StatelessWidget {
  const _WorkoutsMessage({
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
