import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/data/models/bookmarked_photos_model.dart';
import 'package:foto_ta/data/repositories/activity_repository.dart';

part 'saved_photos_state.dart';

class SavedPhotosCubit extends Cubit<SavedPhotosState> {
  final ActivityRepository _activityRepository;

  SavedPhotosCubit({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository,
        super(SavedPhotosInitial());

  Future<void> loadSavedPhotos() async {
    try {
      emit(SavedPhotosLoading());
      
      final accessToken = EnvConfig.authToken;
      final response = await _activityRepository.getBookmarkedPhotos(accessToken);
      
      if (response.data.isNotEmpty) {
        emit(SavedPhotosLoaded(savedPhotos: response.data));
      } else {
        emit(SavedPhotosEmpty());
      }
    } catch (e) {
      print('Error loading saved photos: $e');
      emit(SavedPhotosError(message: e.toString()));
    }
  }

  Future<bool> deleteSelectedPhotos(List<int> imageIds) async {
    try {
      emit(SavedPhotosLoading());
      
      final accessToken = EnvConfig.authToken;
      final result = await _activityRepository.deleteBookmarkedPhotos(imageIds, accessToken);
      
      if (result) {
        // Reload the photos after deletion
        await loadSavedPhotos();
        return true;
      } else {
        emit(SavedPhotosError(message: 'Failed to delete selected photos'));
        return false;
      }
    } catch (e) {
      print('Error deleting saved photos: $e');
      emit(SavedPhotosError(message: e.toString()));
      return false;
    }
  }
}
