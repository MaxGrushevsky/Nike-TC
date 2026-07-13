import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/mock/activity_mock_data.dart';
import '../../models/activity_item.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(const ActivityState()) {
    on<ActivityStarted>(_onStarted);
    on<ActivityAdded>(_onAdded);
    on<ActivityFilterChanged>(_onFilterChanged);
  }

  void _onStarted(ActivityStarted event, Emitter<ActivityState> emit) {
    emit(
      state.copyWith(
        activities: List<ActivityItem>.from(ActivityMockData.seedActivities),
      ),
    );
  }

  void _onAdded(ActivityAdded event, Emitter<ActivityState> emit) {
    emit(
      state.copyWith(
        activities: [...state.activities, event.activity],
      ),
    );
  }

  void _onFilterChanged(
    ActivityFilterChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }
}
