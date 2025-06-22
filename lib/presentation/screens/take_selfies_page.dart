import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foto_ta/config/injector/injection_conf.dart';
import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/string/text_string.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/presentation/cubits/camera/camera_cubit.dart';
import 'package:foto_ta/presentation/widgets/button_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class TakeSelfiesPage extends StatefulWidget {
  const TakeSelfiesPage({super.key});

  @override
  State<TakeSelfiesPage> createState() => _TakeSelfiesPageState();
}

class _TakeSelfiesPageState extends State<TakeSelfiesPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          sl<CameraCubit>().resetCamera();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: AppColors.background,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 6.w, right: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.hBox,
                Text.rich(
                  TextSpan(
                    text: TextString.takeSelfiesTitle,
                    style: AppFonts.heading1.copyWith(color: AppColors.primary),
                    children: [
                      TextSpan(
                        text: TextString.takeSelfiesTitleTwo,
                        style: AppFonts.heading1.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  TextString.takeSelfiesSubtitle,
                  style: AppFonts.body.copyWith(color: Colors.grey[700]),
                ),
                4.hBox,
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: Colors.grey[600]!,
                    strokeWidth: 1,
                    dashPattern: const [10, 8],
                    radius: Radius.circular(6),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        AppRoute.splash.path +
                            AppRoute.takeSelfies.path +
                            AppRoute.camera.path,
                      );
                      sl<CameraCubit>().resetCamera();
                      sl<CameraCubit>().loadCameras();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: BlocBuilder<CameraCubit, CameraState>(
                        builder: (context, state) {
                          if (state is CameraPictureTaken) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(state.imagePath),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.textSecondary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.repeat,
                                          color: AppColors.textPrimary,
                                        ),
                                        1.wBox,
                                        Text(
                                          "Klik untuk ambil ulang",
                                          style: AppFonts.body,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/take_photo_img.svg',
                                height: 5.h,
                                width: 5.h,
                              ),
                              2.hBox,
                              Text(
                                TextString.knockKnock,
                                textAlign: TextAlign.center,
                                style: AppFonts.body.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                2.hBox,
                Text(
                  TextString.note,
                  textAlign: TextAlign.center,
                  style: AppFonts.body.copyWith(color: Colors.grey[700]),
                ),
                2.hBox,
                BlocBuilder<CameraCubit, CameraState>(
                  builder: (context, state) {
                    return CustomeButton(
                      text: "Selesaikan",
                      onPressed: state is CameraPictureTaken ? () {} : null,
                    );
                  },
                ),
                2.hBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
