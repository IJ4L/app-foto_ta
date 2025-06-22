import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foto_ta/data/models/activity_model.dart';
import 'package:foto_ta/data/repositories/activity_repository.dart';

part 'activities_state.dart';

class ActivitiesCubit extends Cubit<ActivitiesState> {
  final ActivityRepository activityRepository;

  ActivitiesCubit({required this.activityRepository})
    : super(ActivitiesInitial());

  Future<void> getRecentActivities() async {
    try {
      emit(ActivitiesLoading());
      final activities = await activityRepository.getRecentActivities();
      emit(ActivitiesLoaded(activities: activities));
    } catch (e) {
      emit(ActivitiesError(message: e.toString()));
    }
  }
}
