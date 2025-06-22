import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class CustomeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
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

class CustomeIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const CustomeIconButton({
    super.key,
    required this.iconPath,
    this.onPressed,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: AppColors.greySmooth, width: 1),
      ),
      icon: isLoading
          ? SizedBox(
              width: double.infinity,
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 2.5.h,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath, height: 2.5.h),
                2.wBox,
                Text(
                  text,
                  style: AppFonts.button.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
