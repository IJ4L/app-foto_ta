import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/presentation/cubits/activities/activities_cubit.dart';
import 'package:foto_ta/presentation/widgets/document_item_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:foto_ta/config/injector/injection_conf.dart' as di;

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActivitiesCubit(activityRepository: di.sl())..getRecentActivities(),
      child: const _BerandaPageContent(),
    );
  }
}

class _BerandaPageContent extends StatefulWidget {
  const _BerandaPageContent();

  @override
  State<_BerandaPageContent> createState() => _BerandaPageContentState();
}

class _BerandaPageContentState extends State<_BerandaPageContent> {
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildLoadingShimmer() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 2.5.h, bottom: 2.5.h),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        return Shimmer(
          color: Colors.grey[300]!,
          duration: const Duration(seconds: 2),
          enabled: true,
          direction: const ShimmerDirection.fromLeftToRight(),
          child: Container(
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          SizedBox(height: 1.h),
          Text(
            'Terjadi kesalahan',
            style: AppFonts.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.h),
          Text(message, textAlign: TextAlign.center, style: AppFonts.body),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              context.read<ActivitiesCubit>().getRecentActivities();
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 48, color: Colors.blue[300]),
          SizedBox(height: 1.h),
          Text(
            'Belum Ada Aktivitas',
            style: AppFonts.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.h),
          Text('Anda belum memiliki aktivitas apapun', style: AppFonts.body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        body: SafeArea(
          child: Column(
            children: [
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
                        child: Icon(Icons.sort, color: Colors.blueGrey[900]),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              1.8.hBox,
              TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textPrimary,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.black38,
                labelStyle: AppFonts.body.copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: AppFonts.body.copyWith(),
                indicatorWeight: 0.5.h,
                tabs: const [
                  Tab(text: 'Aktivitas'),
                  Tab(text: 'Arsip'),
                ],
              ),
              Expanded(
                child: Container(
                  color: AppColors.background,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: TabBarView(
                    children: [
                      BlocBuilder<ActivitiesCubit, ActivitiesState>(
                        builder: (context, state) {
                          if (state is ActivitiesLoading) {
                            return _buildLoadingShimmer();
                          } else if (state is ActivitiesError) {
                            return _buildErrorView(state.message);
                          } else if (state is ActivitiesLoaded) {
                            if (state.activities.isEmpty) {
                              return _buildEmptyView();
                            }
                            return ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              padding: EdgeInsets.only(
                                top: 2.5.h,
                                bottom: 2.5.h,
                              ),
                              itemCount: state.activities.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 2.h),
                              itemBuilder: (context, index) {
                                final activity = state.activities[index];
                                return DocumentItemWidget(
                                  activity: activity,
                                  passwordController: passwordController,
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Center(child: Text('')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
