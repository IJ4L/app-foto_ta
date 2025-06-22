part of 'saved_photos_cubit.dart';

abstract class SavedPhotosState extends Equatable {
  const SavedPhotosState();

  @override
  List<Object> get props => [];
}

class SavedPhotosInitial extends SavedPhotosState {}

class SavedPhotosLoading extends SavedPhotosState {}

class SavedPhotosLoaded extends SavedPhotosState {
  final List<BookmarkedPhotosModel> savedPhotos;

  const SavedPhotosLoaded({required this.savedPhotos});

  @override
  List<Object> get props => [savedPhotos];
}

class SavedPhotosEmpty extends SavedPhotosState {}

class SavedPhotosError extends SavedPhotosState {
  final String message;

  const SavedPhotosError({required this.message});

  @override
  List<Object> get props => [message];
}
