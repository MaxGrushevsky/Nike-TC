import 'package:flutter/material.dart';

import 'base_page.dart';

abstract class WorkoutsBasePage extends BasePage {
  const WorkoutsBasePage({super.key});

  Widget buildBody(BuildContext context);

  void onProfileTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
            onPressed: () => onProfileTap(context),
          ),
        ],
      ),
      body: buildBody(context),
    );
  }
}
