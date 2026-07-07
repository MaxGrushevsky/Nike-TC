import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'platform_refresh_spinner.dart';

class PlatformPullToRefresh extends StatelessWidget {
  const PlatformPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.slivers,
  });

  final Future<void> Function() onRefresh;
  final List<Widget> slivers;

  static const _scrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: _scrollPhysics,
          slivers: slivers,
        ),
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: onRefresh,
              builder: (
                context,
                refreshState,
                pulledExtent,
                refreshTriggerPullDistance,
                refreshIndicatorExtent,
              ) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: PlatformRefreshSpinner(size: 18),
                  ),
                );
              },
            ),
            ...slivers,
          ],
        );
      case TargetPlatform.android:
      default:
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            physics: _scrollPhysics,
            slivers: slivers,
          ),
        );
    }
  }
}
