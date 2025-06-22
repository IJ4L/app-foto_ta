part of 'activities_cubit.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends ActivitiesState {}

class ActivitiesLoading extends ActivitiesState {}

class ActivitiesLoaded extends ActivitiesState {
  final List<ActivityModel> activities;

  const ActivitiesLoaded({required this.activities});

  @override
  List<Object> get props => [activities];
}

class ActivitiesError extends ActivitiesState {
  final String message;

  const ActivitiesError({required this.message});

  @override
  List<Object> get props => [message];
}
