import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/data/models/bookmarked_photos_model.dart';
import 'package:foto_ta/presentation/cubits/bookmark/saved_photos_cubit.dart';
import 'package:foto_ta/presentation/cubits/multi_select_cubit.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class SavedPhotosView extends StatefulWidget {
  const SavedPhotosView({super.key});

  @override
  State<SavedPhotosView> createState() => _SavedPhotosViewState();
}

class _SavedPhotosViewState extends State<SavedPhotosView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedPhotosCubit>().loadSavedPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _SavedPhotosViewContent();
  }
}

class _SavedPhotosViewContent extends StatefulWidget {
  const _SavedPhotosViewContent();

  @override
  State<_SavedPhotosViewContent> createState() =>
      _SavedPhotosViewContentState();
}

class _SavedPhotosViewContentState extends State<_SavedPhotosViewContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiSelectCubit, MultiSelectState>(
      builder: (context, multiSelectState) {
        return BlocBuilder<SavedPhotosCubit, SavedPhotosState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: _buildContent(context, multiSelectState, state),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    MultiSelectState multiSelectState,
    SavedPhotosState state,
  ) {
    if (state is SavedPhotosInitial || state is SavedPhotosLoading) {
      return _buildLoadingState();
    } else if (state is SavedPhotosError) {
      return _buildErrorState(state.message);
    } else if (state is SavedPhotosEmpty) {
      return _buildEmptyState();
    } else if (state is SavedPhotosLoaded) {
      return _buildLoadedState(context, multiSelectState, state.savedPhotos);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: _buildSkeletonLoader(),
        );
      },
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
            'Gagal Memuat Data',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            message,
            style: AppFonts.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              context.read<SavedPhotosCubit>().loadSavedPhotos();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
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
            'assets/images/error_img.svg',
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(height: 2.h),
          Text(
            'Belum Ada Foto Tersimpan',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Anda belum menyimpan foto apapun. Tambahkan foto untuk melihatnya di sini.',
            style: AppFonts.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    MultiSelectState multiSelectState,
    List<BookmarkedPhotosModel> bookmarkedData,
  ) {
    if (bookmarkedData.isEmpty) {
      return _buildEmptyState();
    }

    final List<BookmarkedPhoto> allBookmarkedPhotos = [];
    for (var eventData in bookmarkedData) {
      allBookmarkedPhotos.addAll(eventData.bookmarkedPhotos);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            'Foto Tersimpan (${allBookmarkedPhotos.length})',
            style: AppFonts.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: allBookmarkedPhotos.length,
            itemBuilder: (context, index) {
              final bookmarkedPhoto = allBookmarkedPhotos[index];
              final eventData = bookmarkedData.firstWhere(
                (event) => event.bookmarkedPhotos.contains(bookmarkedPhoto),
                orElse: () => bookmarkedData.first,
              );

              return _buildImageCard(
                context,
                multiSelectState,
                bookmarkedPhoto.image.url,
                '${eventData.eventName} (${bookmarkedPhoto.image.fileName})',
                index,
                allBookmarkedPhotos.length,
                bookmarkedPhoto.image.id,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    MultiSelectState state,
    String imageUrl,
    String name,
    int index,
    int totalItems, [
    int? imageId,
  ]) {
    final bool isSelected = state.selectedIndices.contains(index);
    final MultiSelectCubit cubit = context.read<MultiSelectCubit>();

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (state.isMultiSelectMode) {
          cubit.toggleItemSelection(index);
        } else {}
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
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
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
                          name,
                          style: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!state.isMultiSelectMode) {
                            cubit.enterMultiSelectModeAndSelectItem(index);
                          } else if (isSelected) {
                            cubit.toggleItemSelection(index);
                          } else {
                            cubit.toggleItemSelection(index);
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: state.isMultiSelectMode
                              ? Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  size: 5.w,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                )
                              : SvgPicture.asset(
                                  'assets/icons/plus_ic.svg',
                                  height: 5.w,
                                  width: 5.w,
                                  color: AppColors.textPrimary,
                                ),
                        ),
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
}
