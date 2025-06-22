import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foto_ta/data/models/drive_search_model.dart';
import 'package:foto_ta/data/repositories/drive_search_repository.dart';

part 'drive_search_state.dart';

class DriveSearchCubit extends Cubit<DriveSearchState> {
  final DriveSearchRepository driveSearchRepository;

  DriveSearchCubit({required this.driveSearchRepository})
    : super(DriveSearchInitial());
  Future<void> searchDrive(String driveUrl, String accessToken) async {
    try {
      emit(DriveSearchLoading());

      if (driveUrl.isEmpty) {
        emit(const DriveSearchError(message: 'URL Drive tidak boleh kosong'));
        return;
      }

      final result = await driveSearchRepository.searchDrive(
        driveUrl,
        accessToken,
      );
      if (result.results.isEmpty) {
        emit(const DriveSearchEmpty());
      } else {
        emit(
          DriveSearchLoaded(
            searchResults: result.results,
            lastQuery: driveUrl,
            accessToken: accessToken,
          ),
        );
      }
    } catch (e) {
      emit(DriveSearchError(message: e.toString()));
    }
  }

  Future<void> refreshDriveSearches(String accessToken) async {
    try {
      // Don't emit loading state here to keep current results displayed during refresh

      final result = await driveSearchRepository.getDriveSearches(accessToken);

      if (result.results.isEmpty) {
        emit(const DriveSearchEmpty());
      } else {
        // When refreshing, we should keep the last query from the previous state
        // so that the search can be redone if needed
        String lastQuery = '';
        if (state is DriveSearchLoaded) {
          lastQuery = (state as DriveSearchLoaded).lastQuery;
        }

        emit(
          DriveSearchLoaded(
            searchResults: result.results,
            lastQuery: lastQuery,
            accessToken: accessToken,
          ),
        );
      }
    } catch (e) {
      emit(DriveSearchError(message: e.toString()));
    }
  }

  void resetState() {
    emit(DriveSearchInitial());
  }
}
