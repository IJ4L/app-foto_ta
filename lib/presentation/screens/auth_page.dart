import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/string/assets_string.dart';
import 'package:foto_ta/core/string/text_string.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/presentation/cubits/cubit.dart';
import 'package:foto_ta/presentation/widgets/button_widget.dart';
import 'package:foto_ta/presentation/widgets/form_widget.dart';
import 'package:sizer/sizer.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 6.w, right: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              1.hBox,
              SvgPicture.asset(AssetsString.logo, height: 4.h),
              4.hBox,
              Text.rich(
                TextSpan(
                  text: TextString.loginTitleOne,
                  style: AppFonts.heading1.copyWith(color: AppColors.primary),
                  children: [
                    TextSpan(
                      text: TextString.loginTitleTwo,
                      style: AppFonts.heading1.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                TextString.loginSubtitle,
                style: AppFonts.body.copyWith(color: Colors.grey[700]),
              ),
              4.hBox,
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    formWidget(
                      label: TextString.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return TextString.emailCannotEmpty;
                        }
                        if (!RegExp(TextString.regExp).hasMatch(p0)) {
                          return TextString.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    2.hBox,
                    BlocProvider(
                      create: (context) => ObscureCubit(),
                      child: BlocBuilder<ObscureCubit, bool>(
                        builder: (context, status) {
                          return formWidget(
                            label: TextString.password,
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            nextFocusNode: null,
                            keyboardType: TextInputType.visiblePassword,
                            obscureTextOn: true,
                            obscureText: status,
                            onTap: () =>
                                context.read<ObscureCubit>().toggleObscure(),
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return TextString.passwordCannotEmpty;
                              }
                              if (p0.length < 6) {
                                return TextString.passwordMinLength;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              1.hBox,
              Align(
                alignment: Alignment.centerRight,
                child: CustomTextButton(
                  text: TextString.forgotPassword,
                  onPressed: () {},
                  textStyle: AppFonts.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              1.hBox,
              CustomeButton(
                text: TextString.signIn,
                onPressed: () {
                  // if (formKey.currentState!.validate()) {}
                },
              ),
              2.hBox,
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[400], thickness: 0.5),
                  ),
                  3.wBox,
                  Text(
                    TextString.orLoginWith,
                    style: AppFonts.caption.copyWith(color: Colors.grey[700]),
                  ),
                  3.wBox,
                  Expanded(
                    child: Divider(color: Colors.grey[400], thickness: 0.5),
                  ),
                ],
              ),
              2.hBox,
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.5.h,
                  ),
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: AppColors.greySmooth, width: 1),
                ),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetsString.googleIc, height: 2.5.h),
                    2.wBox,
                    Text(
                      TextString.loginWithGoogle,
                      style: AppFonts.button.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TextString.dontHaveAccount,
                      style: AppFonts.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        TextString.signUp,
                        style: AppFonts.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              2.hBox,
            ],
          ),
        ),
      ),
    );
  }
}
