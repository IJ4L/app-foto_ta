import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  @override
  void onChange(Change<CameraState> change) {
    super.onChange(change);
    debugPrint(
      'SignInCubit state changed: ${change.currentState} -> ${change.nextState}',
    );
  }

  Future<void> loadCameras() async {
    emit(CameraLoading());
    try {
      final status = await Permission.camera.status;

      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.camera.request();

        if (!result.isGranted) {
          emit(CameraError("Izin kamera ditolak"));
          return;
        }
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(CameraError("Tidak ada kamera ditemukan"));
      } else {
        emit(CameraReady(cameras));
      }
    } catch (e) {
      emit(CameraError("Izin kamera ditolak atau tidak tersedia."));
    }
  }

  Future<void> takePicture(CameraController controller) async {
    if (!controller.value.isInitialized) {
      emit(CameraError("Camera is not initialized"));
      return;
    }

    try {
      final imagePath = await controller.takePicture();
      debugPrint("Picture taken: ${imagePath.path}");
      emit(CameraPictureTaken(imagePath.path));
    } catch (e) {
      emit(CameraPictureError("Error taking picture: $e"));
    }
  }

  Future<void> initializeCamera(CameraDescription camera) async {
    emit(CameraLoading());
    try {
      final controller = CameraController(camera, ResolutionPreset.high);
      await controller.initialize();
      emit(CameraReady([camera]));
    } catch (e) {
      emit(CameraError("Error initializing camera: $e"));
    }
  }

  Future<void> disposeController(CameraController controller) async {
    await controller.dispose();
    emit(CameraInitial());
  }

  Future<void> switchCamera(
    CameraController controller,
    CameraDescription camera,
  ) async {
    if (controller.value.isInitialized) {
      await controller.dispose();
    }
    await initializeCamera(camera);
  }

  Future<void> captureImage(CameraController controller) async {
    if (!controller.value.isInitialized) {
      emit(CameraError("Camera is not initialized"));
      return;
    }

    try {
      final imagePath = await controller.takePicture();
      emit(CameraPictureTaken(imagePath.path));
    } catch (e) {
      emit(CameraPictureError("Error capturing image: $e"));
    }
  }

  Future<void> resetCamera() async {
    emit(CameraInitial());
  }
}
