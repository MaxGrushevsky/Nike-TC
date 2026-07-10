import 'package:flutter/material.dart';

import '../../data/mock/activity_mock_data.dart';

class ActivityFilterPage extends StatelessWidget {
  const ActivityFilterPage({
    super.key,
    required this.selectedFilter,
  });

  final String selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: ActivityMockData.filterOptions.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final option = ActivityMockData.filterOptions[index];
          final isSelected = option == selectedFilter;

          return ListTile(
            title: Text(option),
            trailing: isSelected ? const Icon(Icons.check, color: Colors.black) : null,
            onTap: () => Navigator.pop(context, option),
          );
        },
      ),
    );
  }

  static Future<String?> show(
    BuildContext context, {
    required String selectedFilter,
  }) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ActivityFilterPage(selectedFilter: selectedFilter),
      ),
    );
  }
}
