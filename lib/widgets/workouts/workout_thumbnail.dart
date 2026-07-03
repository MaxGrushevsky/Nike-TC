import 'package:flutter/material.dart';

import '../../models/workout_item.dart';

class WorkoutThumbnail extends StatelessWidget {
  const WorkoutThumbnail({
    super.key,
    required this.item,
    this.width = 56,
    this.height = 56,
    this.borderRadius = 8,
  });

  final WorkoutItem item;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        item.imageAsset,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
