import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/presentation/cubits/camera/camera_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambil Foto', style: AppFonts.subtitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.background,
      ),
      body: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          if (state is CameraLoading || state is CameraInitial) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 4.h,
              ),
            );
          }

          if (state is CameraError) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/error_img.svg',
                    width: 5.h,
                    height: 5.h,
                  ),
                  2.hBox,
                  Text(
                    state.message,
                    style: AppFonts.body.copyWith(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (state is CameraReady) {
            final controller = CameraController(
              state.cameras.last,
              ResolutionPreset.high,
            );

            return FutureBuilder(
              future: controller.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primary,
                      size: 4.h,
                    ),
                  );
                }

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: double.infinity,
                          child: CameraPreview(controller),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: SvgPicture.asset(
                            'assets/images/face_img.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: FloatingActionButton(
                        onPressed: () {
                          context.read<CameraCubit>().takePicture(controller);
                        },
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/take_photo_img.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            );
          }

          if (state is CameraPictureTaken) {
            return Column(
              children: [
                Image.file(
                  File(state.imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,
                ),
                const Spacer(),
                Center(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    foregroundColor: AppColors.primary,

                    elevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const Spacer(),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
