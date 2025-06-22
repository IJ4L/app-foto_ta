import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foto_ta/data/models/face_detection_model.dart';
import 'package:foto_ta/data/repositories/event_repository.dart';

part 'face_detection_state.dart';

class FaceDetectionCubit extends Cubit<FaceDetectionState> {
  final EventRepository _eventRepository;

  FaceDetectionCubit({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(FaceDetectionInitial());
  Future<void> findMyFace(int eventId, String accessToken) async {
    try {
      emit(FaceDetectionLoading());
      
      final response = await _eventRepository.findMyFace(eventId, accessToken);
      
      if (!response.success) {
        emit(FaceDetectionError(message: response.message));
        return;
      }
      
      if (response.faces.isEmpty) {
        emit(FaceDetectionEmpty());
      } else {
        emit(FaceDetectionSuccess(faces: response.faces));
      }
    } catch (e) {
      emit(FaceDetectionError(message: e.toString()));
    }
  }
}
