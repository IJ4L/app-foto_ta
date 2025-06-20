import 'package:flutter/material.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';

Widget formWidget({
  required String label,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String? Function(String?)? validator,
  bool obscureTextOn = false,
  bool obscureText = false,
  void Function()? onTap,
  textInputAction = TextInputAction.done,
  FocusNode? focusNode,
  FocusNode? nextFocusNode,
}) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.body.copyWith(fontWeight: FontWeight.w400)),
        1.hBox,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          focusNode: focusNode,
          autovalidateMode: AutovalidateMode.disabled,
          onFieldSubmitted: (value) {
            if (nextFocusNode != null) {
              FocusScope.of(focusNode!.context!).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(focusNode!.context!).unfocus();
            }
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            suffixIcon: obscureTextOn
                ? IconButton(
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(8.0),
                          left: Radius.circular(0.0),
                        ),
                      ),
                    ),
                    icon: Icon(
                      color: AppColors.primary,
                      obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: onTap,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: validator,
        ),
      ],
    ),
  );
}
