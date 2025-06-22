import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foto_ta/config/injector/injection_conf.dart' as di;
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/core/utils/download_helper.dart';
import 'package:foto_ta/data/models/face_detection_model.dart';
import 'package:foto_ta/data/repositories/activity_repository.dart';
import 'package:foto_ta/presentation/cubits/face_detection/face_detection_cubit.dart';
import 'package:foto_ta/presentation/cubits/multi_select_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class FaceDetectionPage extends StatelessWidget {
  final int eventId;
  final String accessToken;
  final String eventName;

  const FaceDetectionPage({
    super.key,
    required this.eventId,
    required this.accessToken,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<FaceDetectionCubit>()),
        BlocProvider(create: (context) => MultiSelectCubit()),
      ],
      child: _FaceDetectionContent(
        eventId: eventId,
        accessToken: accessToken,
        eventName: eventName,
      ),
    );
  }
}

class _FaceDetectionContent extends StatefulWidget {
  final int eventId;
  final String accessToken;
  final String eventName;

  const _FaceDetectionContent({
    required this.eventId,
    required this.accessToken,
    required this.eventName,
  });

  @override
  State<_FaceDetectionContent> createState() => _FaceDetectionContentState();
}

class _FaceDetectionContentState extends State<_FaceDetectionContent> {
  @override
  void initState() {
    super.initState();
    _loadFaces();
  }

  Future<void> _loadFaces() async {
    await context.read<FaceDetectionCubit>().findMyFace(
      widget.eventId,
      widget.accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiSelectCubit, MultiSelectState>(
      builder: (context, multiSelectState) {
        return Scaffold(
          appBar: multiSelectState.isMultiSelectMode
              ? _buildMultiSelectAppBar(context, multiSelectState)
              : AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.5,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Wajah Anda di ${widget.eventName}',
                    style: AppFonts.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
          body: BlocBuilder<FaceDetectionCubit, FaceDetectionState>(
            builder: (context, state) {
              if (state is FaceDetectionLoading) {
                return _buildLoadingState();
              } else if (state is FaceDetectionError) {
                return _buildErrorState(state.message);
              } else if (state is FaceDetectionEmpty) {
                return _buildEmptyState();
              } else if (state is FaceDetectionSuccess) {
                return _buildSuccessState(context, state.faces);
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.primary,
              size: 4.h,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Mencari wajah Anda...',
            style: AppFonts.body.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Harap tunggu sementara kami mendeteksi wajah Anda di foto.',
            style: AppFonts.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/error_img.svg',
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(height: 2.h),
          Text(
            'Gagal Mendeteksi Wajah',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w),
          //   child: Text(
          //     message,
          //     style: AppFonts.body.copyWith(color: AppColors.textSecondary),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: _loadFaces,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              child: Text(
                'Coba Lagi',
                style: AppFonts.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/face_img.svg',
            height: 30.h,
            width: 30.h,
          ),
          SizedBox(height: 2.h),
          Text(
            'Tidak Ada Wajah Terdeteksi',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'Maaf, kami tidak dapat menemukan wajah Anda di foto acara ini.',
              style: AppFonts.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    List<FaceDetectionResult> faces,
  ) {
    return BlocBuilder<MultiSelectCubit, MultiSelectState>(
      builder: (context, multiSelectState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Ditemukan ${faces.length} foto dengan wajah Anda',
                style: AppFonts.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: faces.length,
                itemBuilder: (context, index) {
                  final face = faces[index];
                  return _buildFaceCard(context, multiSelectState, face, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFaceCard(
    BuildContext context,
    MultiSelectState state,
    FaceDetectionResult face,
    int index,
  ) {
    final bool isSelected = state.selectedIndices.contains(index);
    final MultiSelectCubit cubit = context.read<MultiSelectCubit>();

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (state.isMultiSelectMode) {
          cubit.toggleItemSelection(index);
        } else {
          // Open detailed view
          _showDetailedFace(face);
        }
      },
      onLongPress: () {
        if (!state.isMultiSelectMode) {
          cubit.enterMultiSelectModeAndSelectItem(index);
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 0,
            color: state.isMultiSelectMode && isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: state.isMultiSelectMode && isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            face.url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _buildSkeletonLoader();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/error_img.svg',
                                    height: 14.h,
                                    width: 14.h,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Face highlight rectangle
                          Positioned(
                            left: face.face.x.toDouble(),
                            top: face.face.y.toDouble(),
                            width: face.face.w.toDouble(),
                            height: face.face.h.toDouble(),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 2.w, bottom: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          face.fileName,
                          style: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (state.isMultiSelectMode)
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 5.w,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedFace(FaceDetectionResult face) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(
                        face.url,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildSkeletonLoader();
                        },
                      ),
                    ),
                    // Face highlight rectangle
                    Positioned(
                      left: face.face.x.toDouble(),
                      top: face.face.y.toDouble(),
                      width: face.face.w.toDouble(),
                      height: face.face.h.toDouble(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Tutup'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Get the current state and save this individual face
                      Navigator.pop(context);
                      try {
                        final activityRepository = di.sl<ActivityRepository>();
                        activityRepository
                            .bookmarkImages([face.id], widget.accessToken)
                            .then((success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Foto berhasil disimpan'
                                        : 'Gagal menyimpan foto',
                                  ),
                                  backgroundColor: success
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal menyimpan foto'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer(
      duration: const Duration(milliseconds: 800),
      interval: const Duration(milliseconds: 300),
      color: Colors.grey[100]!,
      colorOpacity: 0.3,
      enabled: true,
      direction: const ShimmerDirection.fromLeftToRight(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  AppBar _buildMultiSelectAppBar(BuildContext context, MultiSelectState state) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => context.read<MultiSelectCubit>().exitMultiSelectMode(),
      ),
      title: Text(
        '${state.selectedIndices.length} item dipilih',
        style: AppFonts.subtitle.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        // Select All button
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          onPressed: () {
            final faceDetectionState = context.read<FaceDetectionCubit>().state;
            if (faceDetectionState is FaceDetectionSuccess) {
              context.read<MultiSelectCubit>().selectAll(
                faceDetectionState.faces.length,
              );
            }
          },
          tooltip: 'Pilih Semua',
        ),
        // Save button
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: state.selectedIndices.isEmpty
              ? null
              : () => _saveSelectedFaces(context, state),
          tooltip: 'Simpan',
        ),
        // Download button
        IconButton(
          icon: const Icon(Icons.download, color: Colors.white),
          onPressed: state.selectedIndices.isEmpty
              ? null
              : () => _downloadSelectedFaces(context, state),
          tooltip: 'Unduh',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _saveSelectedFaces(BuildContext context, MultiSelectState state) async {
    final faceDetectionState = context.read<FaceDetectionCubit>().state;
    if (faceDetectionState is FaceDetectionSuccess) {
      final selectedFaces = state.selectedIndices
          .map((index) => faceDetectionState.faces[index])
          .toList();

      // Get the image IDs from selected faces
      final imageIds = selectedFaces.map((face) => face.id).toList();

      try {
        final activityRepository = di.sl<ActivityRepository>();
        final result = await activityRepository.bookmarkImages(
          imageIds,
          widget.accessToken,
        );

        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${selectedFaces.length} foto berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan foto'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Exit multi-select mode after saving
      context.read<MultiSelectCubit>().exitMultiSelectMode();
    }
  }

  void _downloadSelectedFaces(
    BuildContext context,
    MultiSelectState state,
  ) async {
    final faceDetectionState = context.read<FaceDetectionCubit>().state;
    if (faceDetectionState is FaceDetectionSuccess) {
      final selectedFaces = state.selectedIndices
          .map((index) => faceDetectionState.faces[index])
          .toList();

      // Get the image URLs from selected faces
      final imageUrls = selectedFaces.map((face) => face.url).toList();

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mengunduh foto...'),
          duration: Duration(seconds: 2),
        ),
      );

      try {
        // Download images using the helper
        final results = await DownloadHelper.downloadImages(imageUrls);

        // Count successful downloads
        final successCount = results.values.where((success) => success).length;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$successCount dari ${imageUrls.length} foto berhasil diunduh ke galeri',
            ),
            backgroundColor: successCount > 0 ? Colors.green : Colors.orange,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengunduh foto: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Exit multi-select mode after downloading
      context.read<MultiSelectCubit>().exitMultiSelectMode();
    }
  }
}
