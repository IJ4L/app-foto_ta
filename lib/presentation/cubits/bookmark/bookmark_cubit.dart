import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/data/repositories/activity_repository.dart';

// States
abstract class BookmarkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkSuccess extends BookmarkState {
  final List<int> imageIds;

  BookmarkSuccess({required this.imageIds});

  @override
  List<Object?> get props => [imageIds];
}

class BookmarkError extends BookmarkState {
  final String message;

  BookmarkError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class BookmarkCubit extends Cubit<BookmarkState> {
  final ActivityRepository _activityRepository;

  BookmarkCubit({required ActivityRepository activityRepository})
    : _activityRepository = activityRepository,
      super(BookmarkInitial());

  Future<void> bookmarkImages(List<int> imageIds, String accessToken) async {
    emit(BookmarkLoading());

    try {
      final result = await _activityRepository.bookmarkImages(
        imageIds,
        accessToken,
      );

      if (result) {
        emit(BookmarkSuccess(imageIds: imageIds));
      } else {
        emit(BookmarkError(message: 'Failed to bookmark images'));
      }
    } catch (e) {
      emit(BookmarkError(message: 'Error: $e'));
    }
  }
}
