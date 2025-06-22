part of 'face_detection_cubit.dart';

abstract class FaceDetectionState extends Equatable {
  const FaceDetectionState();
  
  @override
  List<Object> get props => [];
}

class FaceDetectionInitial extends FaceDetectionState {}

class FaceDetectionLoading extends FaceDetectionState {}

class FaceDetectionSuccess extends FaceDetectionState {
  final List<FaceDetectionResult> faces;

  const FaceDetectionSuccess({required this.faces});

  @override
  List<Object> get props => [faces];
}

class FaceDetectionEmpty extends FaceDetectionState {}

class FaceDetectionError extends FaceDetectionState {
  final String message;

  const FaceDetectionError({required this.message});

  @override
  List<Object> get props => [message];
}
