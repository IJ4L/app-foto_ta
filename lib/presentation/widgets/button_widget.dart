import 'package:flutter/material.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const CustomeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.borderRadius = 8,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.8.h),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 4.w,
                height: 4.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text, style: AppFonts.button),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.padding,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.1.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style:
            textStyle ??
            AppFonts.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
