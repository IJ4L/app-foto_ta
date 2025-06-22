import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/data/models/activity_model.dart';
import 'package:foto_ta/data/repositories/event_repository.dart';
import 'package:foto_ta/presentation/cubits/cubit.dart';
import 'package:foto_ta/presentation/cubits/event/event_cubit.dart';
import 'package:foto_ta/presentation/cubits/expand_cubit.dart';
import 'package:foto_ta/presentation/widgets/form_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:foto_ta/config/injector/injection_conf.dart' as di;

class DocumentItemWidget extends StatelessWidget {
  final ActivityModel activity;
  final TextEditingController passwordController;

  const DocumentItemWidget({
    super.key,
    required this.passwordController,
    required this.activity,
  });

  String formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      return 'Dibuat pada ${DateFormat('d MMMM yyyy').format(date)}';
    } catch (e) {
      return dateStr;
    }
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 2.h,
            left: 4.w,
            right: 4.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/archive_ic.svg',
                    width: 8.w,
                    height: 8.w,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      activity.name,
                      style: AppFonts.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              const Divider(height: 1),
              SizedBox(height: 1.h),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
                leading: Icon(
                  Icons.bookmark_outline,
                  color: AppColors.textPrimary,
                ),
                title: Text('Simpan', style: AppFonts.body),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
                leading: Icon(
                  Icons.edit_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text('Edit', style: AppFonts.body),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
                leading: Icon(
                  Icons.share_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text('Bagikan', style: AppFonts.body),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  'Hapus',
                  style: AppFonts.body.copyWith(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 3.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 1.h, bottom: 2.h, left: 4.w, right: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 2.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/archive_ic.svg',
                width: 6.w,
                height: 6.w,
                color: AppColors.primary,
              ),
              4.wBox,
              Expanded(
                child: Text(
                  activity.name,
                  style: AppFonts.body,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showOptionsBottomSheet(context);
                },
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  iconSize: 8.w,
                ),
                icon: SvgPicture.asset(
                  'assets/icons/button_ic.svg',
                  width: 8.w,
                  height: 8.w,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          0.8.hBox,
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: activity.imagesPreview.isEmpty
                  ? 4
                  : activity.imagesPreview.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                if (activity.imagesPreview.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(children: []),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      activity.imagesPreview[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          1.2.hBox,
          BlocProvider(
            create: (context) => ExpandCubit(),
            child: BlocBuilder<ExpandCubit, bool>(
              builder: (context, isExpanded) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              activity.owner?.picture ??
                                  "https://res.cloudinary.com/dotz74j1p/raw/upload/v1716044962/tje4vyigverxlotuhvpb.png",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.owner?.name ?? activity.name,
                                  style: AppFonts.body,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatDate(activity.createdAt),
                                  style: AppFonts.caption,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<ExpandCubit>().toggleExpand();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              isExpanded ? "Sembunyikan" : "Selengkapnya",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      1.hBox,
                      Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: BlocProvider(
                          create: (context) => ObscureCubit(),
                          child: BlocBuilder<ObscureCubit, bool>(
                            builder: (context, state) {
                              return formWidget(
                                label: "Password",
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: state,
                                obscureTextOn: true,
                                onTap: () {
                                  context.read<ObscureCubit>().toggleObscure();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Field ini tidak boleh kosong';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      1.2.hBox,
                      Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: BlocProvider(
                          create: (context) => EventCubit(
                            eventRepository: di.sl<EventRepository>(),
                          ),
                          child: BlocConsumer<EventCubit, EventState>(
                            listener: (context, state) {
                              if (state is EventImagesLoaded) {
                                context.push(
                                  AppRoute.detailEvent.path,
                                  extra: {
                                    'title': activity.name,
                                    'eventId': activity.id,
                                    'images': state.images,
                                    'accessToken': state.accessToken,
                                  },
                                );
                              } else if (state is EventAccessError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gagal membuka event"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (state is EventImagesError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gagal memuat gambar event"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 6.h,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed:
                                      state is EventAccessLoading ||
                                          state is EventImagesLoading
                                      ? null
                                      : () {
                                          final cubit = context
                                              .read<EventCubit>();
                                          cubit.accessEvent(
                                            activity.id,
                                            passwordController.text,
                                          );
                                        },
                                  icon:
                                      state is EventAccessLoading ||
                                          state is EventImagesLoading
                                      ? SizedBox(
                                          width: double.infinity,
                                          child:
                                              LoadingAnimationWidget.threeRotatingDots(
                                                color: AppColors.primary,
                                                size: 2.5.h,
                                              ),
                                        )
                                      : Text(
                                          "Buka",
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
