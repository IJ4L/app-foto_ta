import 'package:flutter/material.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  enabled: false,
                  decoration: InputDecoration(
                    // hintText: 'Cari dokumentasi...',
                    contentPadding: EdgeInsets.symmetric(vertical: 1.8.h),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.blueGrey[300]),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.sort, color: Colors.blueGrey[300]),
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
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 6.w,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 6.w,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          6.wBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nama Pengguna', style: AppFonts.subtitle),
                              SizedBox(height: 0.4.h),
                              Text("sadnsa@gmail.com", style: AppFonts.caption),
                            ],
                          ),
                        ],
                      ),
                    ),
                    2.hBox,
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Terkait Akun', style: AppFonts.subtitle),
                    ),
                    1.hBox,
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            size: 6.w,
                            color: AppColors.primary,
                          ),
                          2.wBox,
                          Text(
                            'Profile',
                            style: AppFonts.body.copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 4.w,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    1.hBox,
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Icon(
                            Icons.camera_outlined,
                            size: 6.w,
                            color: AppColors.primary,
                          ),
                          2.wBox,
                          Text(
                            'Ganti foto Selfie',
                            style: AppFonts.body.copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 4.w,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    1.hBox,
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        backgroundColor: Colors.red.withValues(alpha: 0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app_outlined,
                            size: 6.w,
                            color: Colors.red,
                          ),
                          2.wBox,
                          Text(
                            'Keluar',
                            style: AppFonts.body.copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 4.w,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    2.hBox,
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Lainnya', style: AppFonts.subtitle),
                    ),
                    1.hBox,
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 6.w,
                            color: AppColors.primary,
                          ),
                          2.wBox,
                          Text(
                            'Bantuan dan Dukungan',
                            style: AppFonts.body.copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 4.w,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    1.hBox,
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 6.w,
                            color: AppColors.primary,
                          ),
                          2.wBox,
                          Text(
                            'Tentang Aplikasi',
                            style: AppFonts.body.copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 4.w,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    1.hBox,
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Icon(
                            Icons.coffee_outlined,
                            size: 6.w,
                            color: AppColors.primary,
                          ),
                          2.wBox,
                          Text(
                            'Traktir Kopi',
                            style: AppFonts.body.copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 4.w,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
