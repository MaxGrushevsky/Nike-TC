import 'package:equatable/equatable.dart';

import '../../models/activity_item.dart';

sealed class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

final class ActivityStarted extends ActivityEvent {
  const ActivityStarted();
}

final class ActivityAdded extends ActivityEvent {
  const ActivityAdded(this.activity);

  final ActivityItem activity;

  @override
  List<Object?> get props => [activity];
}

final class ActivityFilterChanged extends ActivityEvent {
  const ActivityFilterChanged(this.filter);

  final String filter;

  @override
  List<Object?> get props => [filter];
}
