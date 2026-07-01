import 'package:flutter/material.dart';

class WorkoutsTabContent extends StatelessWidget {
  const WorkoutsTabContent({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [Text(title, style: Theme.of(context).textTheme.headlineSmall)],
    );
  }
}
