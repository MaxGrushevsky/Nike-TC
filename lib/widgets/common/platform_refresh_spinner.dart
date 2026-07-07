import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformRefreshSpinner extends StatelessWidget {
  const PlatformRefreshSpinner({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return SizedBox(
        width: size * 3,
        height: 4,
        child: const LinearProgressIndicator(minHeight: 4),
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActivityIndicator(radius: size / 2);
      case TargetPlatform.android:
      default:
        return SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(strokeWidth: 2.5),
        );
    }
  }
}
