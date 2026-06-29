import 'package:flutter/material.dart';

import '../base/workouts_base_page.dart';

class DashboardPage extends WorkoutsBasePage {
  const DashboardPage({super.key});

  @override
  String get pageTitle => 'Dashboard';

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text('Workouts'),
    );
  }
}
