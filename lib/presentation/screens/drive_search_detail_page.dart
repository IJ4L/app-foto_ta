import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/core/utils/download_helper.dart';
import 'package:foto_ta/data/models/drive_search_detail_model.dart';
import 'package:foto_ta/presentation/cubits/drive_search_detail/drive_search_detail_cubit.dart';
import 'package:foto_ta/presentation/cubits/multi_select_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

class DriveSearchDetailPage extends StatelessWidget {
  final int searchId;
  final String accessToken;

  const DriveSearchDetailPage({
    super.key,
    required this.searchId,
    required this.accessToken,
  });
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle back button press to ensure cleanup
      onWillPop: () async {
        // Don't try to access providers here directly - this can cause issues
        // when the WillPopScope tries to access providers during disposal

        // Manually reset the state since we're providing at app level
        try {
          final detailCubit = context.read<DriveSearchDetailCubit>();
          // Schedule state reset for after the current frame
          Future.microtask(() => detailCubit.resetState());
        } catch (e) {
          debugPrint('Error resetting state in WillPopScope: $e');
        }

        // Just handle navigation
        if (!context.canPop()) {
          // If we can't pop, navigate back to a known route
          context.go('/beranda');
          return false; // prevent default pop
        }
        return true;
      },
      child: MultiBlocProvider(
        providers: [
          // Only create MultiSelectCubit here - DriveSearchDetailCubit is provided at app level
          BlocProvider(create: (context) => MultiSelectCubit()),
        ],
        child: _DriveSearchDetailContent(
          searchId: searchId,
          accessToken: accessToken,
        ),
      ),
    );
  }
}

class _DriveSearchDetailContent extends StatefulWidget {
  final int searchId;
  final String accessToken;

  const _DriveSearchDetailContent({
    required this.searchId,
    required this.accessToken,
  });

  @override
  State<_DriveSearchDetailContent> createState() =>
      _DriveSearchDetailContentState();
}

class _DriveSearchDetailContentState extends State<_DriveSearchDetailContent>
    with AutomaticKeepAliveClientMixin {
  bool _isDisposed = false;
  bool _loadingScheduled = false;
  DriveSearchDetailCubit? _cubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Delay to ensure proper initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadImages();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache the cubit for cleanup
    _cubit = context.read<DriveSearchDetailCubit>();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // Reset state when leaving this screen, but defer the resetState call
    try {
      if (_cubit != null) {
        // Don't call resetState here - cubit may already be disposed
        // We'll use a safer approach
      }
    } catch (e) {
      debugPrint('Safe disposal error: $e');
    }
    super.dispose();
  }

  Future<void> _loadImages() async {
    if (!_isDisposed && mounted) {
      try {
        // Use the global DriveSearchDetailCubit safely
        if (context.mounted) {
          final cubit = context.read<DriveSearchDetailCubit>();
          cubit.fetchDriveSearchImages(
            searchId: widget.searchId,
            accessToken: widget.accessToken,
          );
        }
      } catch (e) {
        debugPrint('Error loading images: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // Must call super.build for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<DriveSearchDetailCubit, DriveSearchDetailState>(
        listener: (context, state) {
          if (!_isDisposed && state is DriveSearchDetailError) {
            ScaffoldMessenger.of(
              context,
            ).clearSnackBars(); // Clear any existing snackbars
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is DriveSearchDetailLoading) {
            return _buildLoadingState();
          } else if (state is DriveSearchDetailError) {
            return _buildErrorState(state.message);
          } else if (state is DriveSearchDetailLoaded) {
            if (state.images.isEmpty) {
              return _buildEmptyState();
            }
            return _buildContent(state);
          } else if (state is DriveSearchDetailInitial) {
            // Use a Future.microtask to avoid build-phase setState
            // Make sure to only schedule this once by checking _firstBuild
            if (!_loadingScheduled) {
              _loadingScheduled = true;
              Future.microtask(() {
                if (!_isDisposed && mounted) {
                  try {
                    context
                        .read<DriveSearchDetailCubit>()
                        .fetchDriveSearchImages(
                          searchId: widget.searchId,
                          accessToken: widget.accessToken,
                        );
                  } catch (e) {
                    debugPrint('Error in microtask fetch: $e');
                  }
                }
              });
            }
            return _buildLoadingState();
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0.5,
      title: BlocBuilder<MultiSelectCubit, MultiSelectState>(
        builder: (context, multiSelectState) {
          if (multiSelectState.isMultiSelectMode) {
            final driveSearchDetailState = _isDisposed
                ? null
                : context.read<DriveSearchDetailCubit>().state;
            int totalImages = 0;
            if (driveSearchDetailState is DriveSearchDetailLoaded) {
              totalImages = driveSearchDetailState.images.length;
            }

            return Row(
              children: [
                Text(
                  '${multiSelectState.selectedIndices.length} dipilih',
                  style: AppFonts.subtitle.copyWith(color: AppColors.primary),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.select_all,
                    color:
                        multiSelectState.selectedIndices.length ==
                                totalImages &&
                            totalImages > 0
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                  onPressed: () {
                    if (!_isDisposed &&
                        mounted &&
                        driveSearchDetailState is DriveSearchDetailLoaded) {
                      context.read<MultiSelectCubit>().toggleSelectAll(
                        driveSearchDetailState.images.length,
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: AppColors.primary),
                  onPressed: () {
                    _downloadSelectedImages(context);
                  },
                ),
              ],
            );
          } else {
            return Text(
              'Hasil Pencarian Drive',
              style: AppFonts.subtitle.copyWith(color: AppColors.textPrimary),
            );
          }
        },
      ),
      leading: BlocBuilder<MultiSelectCubit, MultiSelectState>(
        builder: (context, state) {
          return IconButton(
            icon: Icon(
              state.isMultiSelectMode ? Icons.close : Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              if (state.isMultiSelectMode) {
                context.read<MultiSelectCubit>().exitMultiSelectMode();
              } else {
                // Just use GoRouter to navigate back safely
                if (context.canPop()) {
                  context.pop();
                } else {
                  // Fallback to a safe route if can't pop
                  context.go('/beranda');
                }
              }
            },
          );
        },
      ),
      actions: [
        BlocBuilder<MultiSelectCubit, MultiSelectState>(
          builder: (context, state) {
            if (!state.isMultiSelectMode) {
              return IconButton(
                icon: const Icon(
                  Icons.select_all,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  context.read<MultiSelectCubit>().toggleMultiSelectMode();
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: AppColors.primary,
        size: 50,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 15.w, color: Colors.red),
          2.hBox,
          Text(
            'Error',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          1.hBox,
          Text(
            message,
            style: AppFonts.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          3.hBox,
          ElevatedButton(
            onPressed: _loadImages,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Coba Lagi',
              style: AppFonts.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
          Icon(Icons.search_off, size: 15.w, color: Colors.grey),
          2.hBox,
          Text(
            'Tidak Ada Gambar Ditemukan',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          1.hBox,
          Text(
            'Sepertinya tidak ada gambar yang ditemukan pada pencarian ini.',
            style: AppFonts.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DriveSearchDetailLoaded state) {
    // We'll use the state images directly, but sorted by similarity
    List<DriveSearchImage> displayImages = List.from(state.images)
      ..sort((a, b) => b.similarity.compareTo(a.similarity));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(2.w),
          child: Row(
            children: [
              Text(
                'Ditemukan ${state.images.length} gambar',
                style: AppFonts.subtitle.copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sort, size: 16),
                    SizedBox(width: 1.w),
                    Text(
                      'Diurutkan berdasarkan kesamaan',
                      style: AppFonts.body.copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadImages,
            color: AppColors.primary,
            child: GridView.builder(
              padding: EdgeInsets.all(2.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1.w,
                crossAxisSpacing: 1.w,
              ),
              itemCount: displayImages.length,
              itemBuilder: (context, index) {
                final image = displayImages[index];
                return BlocBuilder<MultiSelectCubit, MultiSelectState>(
                  builder: (context, multiSelectState) {
                    final isSelected = multiSelectState.selectedIndices
                        .contains(index);
                    final isMultiSelectMode =
                        multiSelectState.isMultiSelectMode;

                    return GestureDetector(
                      onTap: () {
                        if (isMultiSelectMode) {
                          context.read<MultiSelectCubit>().toggleItemSelection(
                            index,
                          );
                        } else {
                          // Handle image preview
                          _showImagePreview(context, image);
                        }
                      },
                      onLongPress: () {
                        if (!isMultiSelectMode) {
                          context
                              .read<MultiSelectCubit>()
                              .enterMultiSelectModeAndSelectItem(index);
                        }
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  image.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Shimmer(
                                          color: AppColors.primary,
                                          child: Container(
                                            color: Colors.grey.shade200,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 1.w,
                                    vertical: 0.2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${(image.similarity * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isMultiSelectMode)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 5.w,
                                height: 5.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white.withOpacity(0.7),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePreview(BuildContext context, DriveSearchImage image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    'Preview',
                    style: AppFonts.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(image.imageUrl, fit: BoxFit.contain),
                    if (image.faceCoords != null)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Get the dimensions of the container
                          final imageWidth = constraints.maxWidth;
                          final imageHeight = constraints.maxHeight;

                          // Calculate scale factors based on a typical image display
                          // These will need adjustment based on your actual image display logic
                          final scaleX = imageWidth / 1000; // Approximate scale
                          final scaleY =
                              imageHeight / 1000; // Approximate scale

                          return Positioned(
                            left: image.faceCoords!.x * scaleX,
                            top: image.faceCoords!.y * scaleY,
                            width: image.faceCoords!.w * scaleX,
                            height: image.faceCoords!.h * scaleY,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          // color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.face,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Confidence: ${(image.similarity * 100).toStringAsFixed(1)}%',
                              style: AppFonts.body.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => _downloadSingleImage(image),
                    icon: const Icon(Icons.download, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadSelectedImages(BuildContext context) async {
    // Check if the context is still valid
    if (!mounted) return;

    // Cache the data locally to avoid context issues during async operations
    final multiSelectCubit = context.read<MultiSelectCubit>();
    final selectedIndices = multiSelectCubit.state.selectedIndices;

    if (selectedIndices.isEmpty) return;

    final detailCubit = context.read<DriveSearchDetailCubit>();
    final state = detailCubit.state;

    if (state is DriveSearchDetailLoaded) {
      // Convert the indices to actual images
      final displayImages = List.from(state.images)
        ..sort((a, b) => b.similarity.compareTo(a.similarity));
      final selectedImages = selectedIndices
          .where((index) => index < displayImages.length)
          .map((index) => displayImages[index])
          .toList();

      if (selectedImages.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mulai mengunduh gambar...')),
          );
        }

        try {
          for (final image in selectedImages) {
            await DownloadHelper.downloadAndSaveImage(image.imageUrl);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Berhasil mengunduh ${selectedImages.length} gambar',
                ),
              ),
            );
            multiSelectCubit.exitMultiSelectMode();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal mengunduh beberapa gambar')),
            );
          }
        }
      }
    }
  }

  Future<void> _downloadSingleImage(DriveSearchImage image) async {
    // First check if the widget is still mounted
    if (!mounted) return;

    try {
      // Show initial message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mulai mengunduh gambar...')),
      );

      // Perform download
      await DownloadHelper.downloadAndSaveImage(image.imageUrl);

      // Check again after async operation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil diunduh')),
        );
      }
    } catch (e) {
      // Only show error if still mounted
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal mengunduh gambar')));
      }
    }
  }
}
