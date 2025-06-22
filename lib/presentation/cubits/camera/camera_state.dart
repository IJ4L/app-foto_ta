part of 'camera_cubit.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

final class CameraInitial extends CameraState {}

final class CameraLoading extends CameraState {}

final class CameraReady extends CameraState {
  final List<CameraDescription> cameras;

  const CameraReady(this.cameras);

  @override
  List<Object> get props => [cameras];
}

final class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);

  @override
  List<Object> get props => [message];
}

final class CameraPictureTaken extends CameraState {
  final String imagePath;

  const CameraPictureTaken(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

final class CameraPictureError extends CameraState {
  final String message;

  const CameraPictureError(this.message);

  @override
  List<Object> get props => [message];
}
