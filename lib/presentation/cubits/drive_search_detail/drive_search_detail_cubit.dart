import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foto_ta/data/models/drive_search_detail_model.dart';
import 'package:foto_ta/data/repositories/drive_search_detail_repository.dart';

part 'drive_search_detail_state.dart';

class DriveSearchDetailCubit extends Cubit<DriveSearchDetailState> {
  final DriveSearchDetailRepository driveSearchDetailRepository;
  bool _closed = false;

  DriveSearchDetailCubit({required this.driveSearchDetailRepository})
    : super(DriveSearchDetailInitial());

  @override
  Future<void> close() async {
    debugPrint('DriveSearchDetailCubit is being closed');
    _closed = true;

    // Make sure we reset to initial state before closing
    try {
      emit(DriveSearchDetailInitial());
    } catch (e) {
      debugPrint('Error resetting state while closing: $e');
    }

    return super.close();
  }

  Future<void> fetchDriveSearchImages({
    required int searchId,
    required String accessToken,
  }) async {
    try {
      if (_closed) return; // Don't emit if already closed
      emit(DriveSearchDetailLoading());

      final images = await driveSearchDetailRepository.fetchDriveSearchImages(
        searchId,
        accessToken,
      );

      if (_closed) return; // Don't emit if closed during async operation

      if (images.isEmpty) {
        emit(const DriveSearchDetailEmpty());
      } else {
        emit(DriveSearchDetailLoaded(images: images));
      }
    } catch (e) {
      if (!_closed) {
        // Only emit error if not closed
        emit(DriveSearchDetailError(message: e.toString()));
      }
    }
  }

  void resetState() {
    try {
      if (!_closed) {
        debugPrint('Resetting DriveSearchDetailCubit state');
        emit(DriveSearchDetailInitial());
      }
    } catch (e) {
      debugPrint('Error in resetState: $e');
    }
  }
}
