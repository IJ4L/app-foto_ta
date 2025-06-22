import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/data/models/drive_search_model.dart';
import 'package:foto_ta/presentation/cubits/drive_search/drive_search_cubit.dart';
import 'package:foto_ta/presentation/widgets/drive_search_item_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class DriveSearchResultsView extends StatefulWidget {
  const DriveSearchResultsView({super.key});

  @override
  State<DriveSearchResultsView> createState() => _DriveSearchResultsViewState();
}

class _DriveSearchResultsViewState extends State<DriveSearchResultsView> {
  Future<String?> _getAuthToken() async {
    try {
      return EnvConfig.authToken;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }

  void _navigateToDriveSearchDetail(BuildContext context, int searchId) {
    print(
      'Navigating to drive search detail for ID: $searchId with token: ${EnvConfig.authToken.substring(0, 10)}...',
    );
    context.go(
      '/drive-search-detail',
      extra: {'searchId': searchId, 'accessToken': EnvConfig.authToken},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriveSearchCubit, DriveSearchState>(
      builder: (context, state) {
        if (state is DriveSearchInitial) {
          return _buildInitialState();
        } else if (state is DriveSearchLoading) {
          return _buildLoadingState();
        } else if (state is DriveSearchError) {
          return _buildErrorState(state.message);
        } else if (state is DriveSearchEmpty) {
          return _buildEmptyState();
        } else if (state is DriveSearchLoaded) {
          return _buildResultsList(context, state);
        }
        return _buildInitialState();
      },
    );
  }

  Widget _buildInitialState() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final authToken = await _getAuthToken();
        if (authToken != null) {
          await context.read<DriveSearchCubit>().refreshDriveSearches(
            authToken,
          );
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 15.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.drive_folder_upload,
                  size: 20.w,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                2.hBox,
                Text(
                  'Masukkan URL Google Drive untuk mulai mencari',
                  style: AppFonts.body.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                4.hBox,
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                0.5.hBox,
                Text(
                  'Tarik ke bawah untuk refresh',
                  style: AppFonts.body.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          2.hBox,
          Text(
            'Mencari foto di Drive...',
            style: AppFonts.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final authToken = await _getAuthToken();
        if (authToken != null) {
          final currentState = context.read<DriveSearchCubit>().state;
          if (currentState is DriveSearchLoaded &&
              currentState.lastQuery.isNotEmpty) {
            await context.read<DriveSearchCubit>().searchDrive(
              currentState.lastQuery,
              authToken,
            );
          } else {
            await context.read<DriveSearchCubit>().refreshDriveSearches(
              authToken,
            );
          }
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 15.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 20.w,
                  color: Colors.red.shade400,
                ),
                2.hBox,
                Text(
                  'Gagal mencari di Drive',
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
                4.hBox,
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                0.5.hBox,
                Text(
                  'Tarik ke bawah untuk mencoba lagi',
                  style: AppFonts.body.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final authToken = await _getAuthToken();
        if (authToken != null) {
          final currentState = context.read<DriveSearchCubit>().state;
          if (currentState is DriveSearchLoaded &&
              currentState.lastQuery.isNotEmpty) {
            await context.read<DriveSearchCubit>().searchDrive(
              currentState.lastQuery,
              authToken,
            );
          } else {
            await context.read<DriveSearchCubit>().refreshDriveSearches(
              authToken,
            );
          }
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 15.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 20.w, color: Colors.grey.shade400),
                2.hBox,
                Text(
                  'Tidak ada foto ditemukan',
                  style: AppFonts.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                1.hBox,
                Text(
                  'Coba gunakan URL Drive yang berbeda',
                  style: AppFonts.body.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                4.hBox,
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                0.5.hBox,
                Text(
                  'Tarik ke bawah untuk refresh',
                  style: AppFonts.body.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, DriveSearchLoaded state) {
    final List<DriveSearchResult> results = state.searchResults;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ditemukan ${results.length} hasil',
          style: AppFonts.subtitle.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        1.hBox,
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              final authToken = await _getAuthToken();
              if (authToken != null) {
                await context.read<DriveSearchCubit>().refreshDriveSearches(
                  authToken,
                );
              }
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return DriveSearchItemWidget(
                  id: result.id,
                  driveName: result.driveName,
                  driveUrl: result.driveUrl,
                  status: result.status,
                  createdAt: result.createdAt,
                  onTap: result.isCompleted
                      ? () {
                          _navigateToDriveSearchDetail(context, result.id);
                        }
                      : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
