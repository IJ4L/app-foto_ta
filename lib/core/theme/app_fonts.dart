import 'package:flutter/material.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppFonts {
  static const primaryFont = 'Roboto';

  static final heading1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimary,
  );

  static final heading2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimary,
  );

  static final subtitle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimary,
  );

  static final body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textPrimary,
  );

  static final caption = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    color: Colors.grey[700],
  );

  static final button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textSecondary,
  );
}
