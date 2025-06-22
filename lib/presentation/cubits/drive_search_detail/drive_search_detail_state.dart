part of 'drive_search_detail_cubit.dart';

abstract class DriveSearchDetailState extends Equatable {
  const DriveSearchDetailState();

  @override
  List<Object> get props => [];
}

class DriveSearchDetailInitial extends DriveSearchDetailState {}

class DriveSearchDetailLoading extends DriveSearchDetailState {}

class DriveSearchDetailLoaded extends DriveSearchDetailState {
  final List<DriveSearchImage> images;

  const DriveSearchDetailLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

class DriveSearchDetailEmpty extends DriveSearchDetailState {
  const DriveSearchDetailEmpty();
}

class DriveSearchDetailError extends DriveSearchDetailState {
  final String message;

  const DriveSearchDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
