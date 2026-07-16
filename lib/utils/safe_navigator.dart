import 'package:flutter/material.dart';

import '../router.dart';

Future<bool> safePop<T>(BuildContext context, [T? result]) {
  return Navigator.of(context).maybePop(result);
}

Future<void> safePopOrWelcome(BuildContext context) async {
  final didPop = await Navigator.of(context).maybePop();
  if (didPop || !context.mounted) {
    return;
  }

  await Navigator.of(context).pushReplacementNamed(AppRouter.welcome);
}
