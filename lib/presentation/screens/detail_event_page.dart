import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foto_ta/config/injector/injection_conf.dart' as di;
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/data/services/event_service.dart';
import 'package:foto_ta/presentation/cubits/bookmark/bookmark_cubit.dart';
import 'package:foto_ta/presentation/cubits/event/event_cubit.dart';
import 'package:foto_ta/presentation/cubits/multi_select_cubit.dart';
import 'package:foto_ta/presentation/screens/face_detection_page.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class DetailEventPage extends StatelessWidget {
  final String title;
  final int eventId;
  final List<EventImage> images;
  final String? accessToken;

  const DetailEventPage({
    super.key,
    required this.title,
    this.eventId = 0,
    this.images = const [],
    this.accessToken,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MultiSelectCubit()),
        BlocProvider<BookmarkCubit>(
          create: (context) => di.sl<BookmarkCubit>(),
        ),
        if (accessToken != null && eventId > 0)
          BlocProvider<EventCubit>(create: (context) => di.sl<EventCubit>()),
      ],
      child: _DetailEventPageContent(
        title: title,
        eventId: eventId,
        images: images,
        accessToken: accessToken,
      ),
    );
  }
}

class _DetailEventPageContent extends StatefulWidget {
  final String title;
  final int eventId;
  final List<EventImage> images;
  final String? accessToken;

  const _DetailEventPageContent({
    required this.title,
    this.eventId = 0,
    this.images = const [],
    this.accessToken,
  });

  @override
  State<_DetailEventPageContent> createState() =>
      _DetailEventPageContentState();
}

class _DetailEventPageContentState extends State<_DetailEventPageContent> {
  late ScrollController _scrollController;
  List<Map<String, String>> imageItems = [];
  bool isLoading = false;
  bool hasMoreImages = true;
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _initializeImageItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeImageItems() {
    if (widget.images.isEmpty) {
      imageItems = [
        {'image': 'https://picsum.photos/id/237/200/300', 'name': 'Foto 1'},
        {'image': 'https://picsum.photos/id/238/200/300', 'name': 'Foto 2'},
        {'image': 'https://picsum.photos/id/239/200/300', 'name': 'Foto 3'},
        {'image': 'https://picsum.photos/id/240/200/300', 'name': 'Foto 4'},
        {'image': 'https://picsum.photos/id/241/200/300', 'name': 'Foto 5'},
        {'image': 'https://picsum.photos/id/242/200/300', 'name': 'Foto 6'},
      ];
      hasMoreImages = false;
    } else {
      _loadImagesFromApi(widget.images.map((e) => e.url).toList());
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMoreImages) {
      _loadMoreImages();
    }
  }

  void _loadImagesFromApi(List<String> images) {
    final startIdx = imageItems.length;
    final endIdx = startIdx + itemsPerPage;
    final newImages = images.sublist(
      startIdx,
      endIdx < images.length ? endIdx : images.length,
    );

    final newImageItems = newImages.asMap().entries.map((entry) {
      final int index = startIdx + entry.key;
      final String url = entry.value;

      int? imageId;
      if (index < widget.images.length) {
        imageId = widget.images[index].id;
      }

      return {
        'image': url,
        'name': imageId != null ? 'Foto $imageId' : url.split('/').last,
        'id': imageId != null ? imageId.toString() : '',
      };
    }).toList();

    setState(() {
      imageItems.addAll(newImageItems);
      hasMoreImages = images.length > imageItems.length;
    });
  }

  Future<void> _loadMoreImages() async {
    if (!hasMoreImages || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.images.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        _loadImagesFromApi(widget.images.map((e) => e.url).toList());
      } else if (widget.accessToken != null && widget.eventId > 0) {
        try {
          final nextPage = currentPage + 1;
          final eventCubit = context.read<EventCubit>();
          await eventCubit.getEventImages(
            widget.eventId,
            widget.accessToken!,
            page: nextPage,
          );

          final state = eventCubit.state;
          if (state is EventImagesLoaded) {
            setState(() {
              final newImages = state.images.map((image) {
                return {'image': image.url, 'name': 'Foto ${image.id}'};
              }).toList();

              imageItems.addAll(newImages);
              hasMoreImages = nextPage < state.totalPages;
            });
          } else if (state is EventImagesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load more images: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
            hasMoreImages = false;
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading more images: $e'),
              backgroundColor: Colors.red,
            ),
          );
          hasMoreImages = false;
        }
      }

      currentPage++;
    } catch (e) {
      print('Error loading more images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading more images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _bookmarkSelectedImages(
    BuildContext context,
    Set<int> selectedIndices,
  ) async {
    if (selectedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No images selected'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final List<int> selectedImageIds = [];

    for (final index in selectedIndices) {
      if (index < widget.images.length) {
        final imageId = widget.images[index].id;
        selectedImageIds.add(imageId);
        continue;
      }

      if (index < imageItems.length) {
        final idStr = imageItems[index]['id'];
        if (idStr != null && idStr.isNotEmpty) {
          final id = int.tryParse(idStr);
          if (id != null) {
            selectedImageIds.add(id);
          }
        }
      }
    }

    if (selectedImageIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid image IDs found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final bookmarkCubit = context.read<BookmarkCubit>();
      await bookmarkCubit.bookmarkImages(
        selectedImageIds,
        widget.accessToken ?? '',
      );

      if (context.mounted) {
        context.read<MultiSelectCubit>().toggleMultiSelectMode();
      }
    } catch (e) {
      print('Error in _bookmarkSelectedImages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookmarkCubit, BookmarkState>(
          listener: (context, state) {
            if (state is BookmarkSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${state.imageIds.length} images bookmarked successfully',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is BookmarkError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to bookmark images: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MultiSelectCubit, MultiSelectState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  if (state.isMultiSelectMode) {
                    context.read<MultiSelectCubit>().toggleMultiSelectMode();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: state.isMultiSelectMode
                  ? Text(
                      "${state.selectedIndices.length} item terpilih",
                      style: AppFonts.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : Text(
                      widget.title,
                      style: AppFonts.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
              actions: state.isMultiSelectMode
                  ? [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/plus_ic.svg',
                          height: 5.w,
                          width: 5.w,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          _bookmarkSelectedImages(
                            context,
                            state.selectedIndices,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.download_outlined,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          context
                              .read<MultiSelectCubit>()
                              .toggleMultiSelectMode();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          state.selectedIndices.length == imageItems.length
                              ? Icons.deselect
                              : Icons.select_all,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          context.read<MultiSelectCubit>().toggleSelectAll(
                            imageItems.length,
                          );
                        },
                      ),
                      2.wBox,
                    ]
                  : null,
            ),
            body: Column(
              children: [
                Expanded(
                  child: imageItems.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.1,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                              ),
                          itemCount:
                              imageItems.length +
                              (isLoading && hasMoreImages ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= imageItems.length) {
                              return _buildLoadingIndicator();
                            }

                            return _buildImageCard(
                              context,
                              state,
                              imageItems[index]['image'] ?? '',
                              imageItems[index]['name'] ?? '',
                              index,
                              imageItems.length,
                            );
                          },
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (widget.eventId > 0 && widget.accessToken != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaceDetectionPage(
                        eventId: widget.eventId,
                        accessToken: widget.accessToken!,
                        eventName: widget.title,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak dapat memulai pendeteksian wajah'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              backgroundColor: AppColors.primary,
              child: SvgPicture.asset(
                'assets/icons/scan_ic.svg',
                height: 5.w,
                width: 5.w,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildImageCard(
  BuildContext context,
  MultiSelectState state,
  String imageUrl,
  String name,
  int index,
  int totalItems,
) {
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
                        if (loadingProgress == null) {
                          return child; // Ini yang penting!
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
                            : InkWell(
                                onTap: () {
                                  try {
                                    final detailPage = context
                                        .findAncestorStateOfType<
                                          _DetailEventPageContentState
                                        >();

                                    if (detailPage == null) return;

                                    int? id;

                                    if (index <
                                        detailPage.widget.images.length) {
                                      id = detailPage.widget.images[index].id;
                                    } else if (index <
                                        detailPage.imageItems.length) {
                                      final idStr =
                                          detailPage.imageItems[index]['id'];
                                      if (idStr != null && idStr.isNotEmpty) {
                                        id = int.tryParse(idStr);
                                      }
                                    }

                                    if (id != null) {
                                      context
                                          .read<BookmarkCubit>()
                                          .bookmarkImages(
                                            [id],
                                            detailPage.widget.accessToken ?? '',
                                          );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Cannot bookmark this image (ID not found)',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print(
                                      'Error processing image bookmark: $e',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/plus_ic.svg',
                                  height: 5.w,
                                  width: 5.w,
                                  color: AppColors.textPrimary,
                                ),
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

Widget _buildLoadingIndicator() {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Shimmer(
        duration: const Duration(milliseconds: 800),
        interval: const Duration(milliseconds: 300),
        color: Colors.grey[100]!,
        colorOpacity: 0.3,
        enabled: true,
        direction: const ShimmerDirection.fromLeftToRight(),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
      ),
    ),
  );
}
