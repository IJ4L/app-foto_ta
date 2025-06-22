import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/data/models/bookmarked_photos_model.dart';
import 'package:foto_ta/data/repositories/activity_repository.dart';
import 'package:foto_ta/data/repositories/drive_search_repository.dart';
import 'package:foto_ta/data/services/activity_service.dart';
import 'package:foto_ta/data/services/drive_search_service.dart';
import 'package:foto_ta/presentation/cubits/bookmark/saved_photos_cubit.dart';
import 'package:foto_ta/presentation/cubits/drive_search/drive_search_cubit.dart';
import 'package:foto_ta/presentation/cubits/foto_page_cubit.dart';
import 'package:foto_ta/presentation/cubits/multi_select_cubit.dart';
import 'package:foto_ta/presentation/widgets/button_widget.dart';
import 'package:foto_ta/presentation/widgets/drive_search_results_view.dart';
import 'package:foto_ta/presentation/widgets/form_widget.dart';
import 'package:foto_ta/presentation/widgets/saved_photos_view.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class FotoPage extends StatelessWidget {
  const FotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FotoPageCubit()),
        BlocProvider(create: (context) => MultiSelectCubit()),
        BlocProvider(
          create: (context) => SavedPhotosCubit(
            activityRepository: ActivityRepositoryImpl(
              activityService: ActivityServiceImpl(client: http.Client()),
            ),
          )..loadSavedPhotos(),
        ),
        BlocProvider(
          create: (context) => DriveSearchCubit(
            driveSearchRepository: DriveSearchRepositoryImpl(
              driveSearchService: DriveSearchServiceImpl(client: http.Client()),
            ),
          ),
        ),
      ],
      child: const _FotoPageContent(),
    );
  }
}

class _FotoPageContent extends StatefulWidget {
  const _FotoPageContent();

  @override
  State<_FotoPageContent> createState() => _FotoPageContentState();
}

class _FotoPageContentState extends State<_FotoPageContent> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MultiSelectCubit, MultiSelectState>(
      listener: (context, multiSelectState) {
        context.read<FotoPageCubit>().setMultiSelectMode(
          multiSelectState.isMultiSelectMode,
        );
      },
      child: BlocBuilder<FotoPageCubit, FotoPageState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              body: SafeArea(
                child: Column(
                  children: [
                    if (state.isMultiSelectMode)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: _buildMultiSelectAppBar(context),
                      ),
                    if (!state.isMultiSelectMode)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari dokumentasi...',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.blueGrey[900],
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.sort,
                                  color: Colors.blueGrey[900],
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),

                    Column(
                      children: [
                        1.8.hBox,
                        TabBar(
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textPrimary,
                          indicatorColor: AppColors.primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.black38,
                          labelStyle: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: AppFonts.body.copyWith(),
                          indicatorWeight: 0.5.h,
                          tabs: const [
                            Tab(text: 'Cari di Drive'),
                            Tab(text: 'Disimpan'),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                2.65.hBox,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: formWidget(
                                    label: "Link Drive",
                                    controller: controller,
                                    keyboardType: TextInputType.url,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Link Drive tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                1.8.hBox,
                                CustomeButton(
                                  text: "Mulai Pencarian",
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    final driveUrl = controller.text.trim();
                                    if (driveUrl.isNotEmpty) {
                                      // Get Auth Token
                                      final authToken = EnvConfig.authToken;
                                      context
                                          .read<DriveSearchCubit>()
                                          .searchDrive(driveUrl, authToken);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Masukkan URL Drive terlebih dahulu',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                2.hBox,
                                const Expanded(child: DriveSearchResultsView()),
                              ],
                            ),
                            const SavedPhotosView(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMultiSelectAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () {
              context.read<MultiSelectCubit>().toggleMultiSelectMode();
            },
          ),
          Expanded(
            child: BlocBuilder<MultiSelectCubit, MultiSelectState>(
              builder: (context, state) {
                return Text(
                  "${state.selectedIndices.length} item terpilih",
                  style: AppFonts.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<MultiSelectCubit, MultiSelectState>(
                builder: (context, multiSelectState) {
                  return IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 6.w,
                      color: multiSelectState.selectedIndices.isEmpty
                          ? Colors
                                .grey // Disabled color
                          : Colors.red,
                    ),
                    onPressed: multiSelectState.selectedIndices.isEmpty
                        ? null
                        : () async {
                            final selectedIds = _getSelectedPhotoIds(
                              context,
                              multiSelectState,
                            );

                            if (selectedIds.isNotEmpty) {
                              final bool confirmed =
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hapus Foto'),
                                      content: Text(
                                        'Apakah Anda yakin ingin menghapus ${selectedIds.length} foto yang dipilih?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('BATAL'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('HAPUS'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              if (confirmed) {
                                final result = await context
                                    .read<SavedPhotosCubit>()
                                    .deleteSelectedPhotos(selectedIds);

                                if (result) {
                                  context
                                      .read<MultiSelectCubit>()
                                      .toggleMultiSelectMode();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Foto berhasil dihapus'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Gagal menghapus foto'),
                                    ),
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tidak ada foto yang dipilih'),
                                ),
                              );
                            }
                          },
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.download_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mengunduh foto...')),
                  );
                },
              ),
              BlocBuilder<MultiSelectCubit, MultiSelectState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      state.selectedIndices.isEmpty
                          ? Icons.select_all
                          : Icons.deselect,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      context.read<MultiSelectCubit>().toggleSelectAll(20);
                    },
                  );
                },
              ),
              2.hBox,
            ],
          ),
        ],
      ),
    );
  }

  List<int> _getSelectedPhotoIds(BuildContext context, MultiSelectState state) {
    final List<int> selectedIds = [];
    final currentTabController = DefaultTabController.of(context);

    if (currentTabController.index == 1) {
      final savedPhotosState = context.read<SavedPhotosCubit>().state;

      if (savedPhotosState is SavedPhotosLoaded) {
        final List<BookmarkedPhoto> allBookmarkedPhotos = [];
        for (var eventData in savedPhotosState.savedPhotos) {
          allBookmarkedPhotos.addAll(eventData.bookmarkedPhotos);
        }

        for (int index in state.selectedIndices) {
          if (index < allBookmarkedPhotos.length) {
            final photo = allBookmarkedPhotos[index];
            selectedIds.add(photo.image.id);
          }
        }
      }
    }

    return selectedIds;
  }
}
