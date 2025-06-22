import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/string/assets_string.dart';
import 'package:foto_ta/core/string/text_string.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:foto_ta/presentation/cubits/cubit.dart';
import 'package:foto_ta/presentation/widgets/button_widget.dart';
import 'package:foto_ta/presentation/widgets/form_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode birthDateFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController birthDateController;
  late TextEditingController phoneController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    birthDateController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthDateController.dispose();
    phoneController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    birthDateFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      String formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        birthDateController.text = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    text: TextString.signUpTitle,
                    style: AppFonts.heading1.copyWith(color: AppColors.primary),
                    children: [
                      TextSpan(
                        text: TextString.signUpTitleTwo,
                        style: AppFonts.heading1.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  TextString.signUpSubtitle,
                  style: AppFonts.body.copyWith(color: Colors.grey[700]),
                ),
                4.hBox,
                formWidget(
                  label: TextString.name,
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return TextString.nameCannotEmpty;
                    }
                    return null;
                  },
                ),
                2.hBox,
                formWidget(
                  label: TextString.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: emailFocusNode,
                  nextFocusNode: passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return TextString.emailCannotEmpty;
                    }
                    return null;
                  },
                ),
                2.hBox,
                BlocBuilder<ObscureCubit, bool>(
                  builder: (context, status) {
                    return formWidget(
                      label: TextString.password,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: passwordFocusNode,
                      nextFocusNode: confirmPasswordFocusNode,
                      textInputAction: TextInputAction.next,
                      obscureText: status,
                      obscureTextOn: true,
                      onTap: () {
                        context.read<ObscureCubit>().toggleObscure();
                      },
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return TextString.passwordCannotEmpty;
                        }
                        if (password.length < 6) {
                          return TextString.passwordMinLength;
                        }
                        return null;
                      },
                    );
                  },
                ),
                2.hBox,
                BlocBuilder<ObscureCubitConfirmPassword, bool>(
                  builder: (context, status) {
                    return formWidget(
                      label: TextString.confirmPassword,
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: confirmPasswordFocusNode,
                      nextFocusNode: birthDateFocusNode,
                      textInputAction: TextInputAction.next,
                      obscureText: status,
                      obscureTextOn: true,
                      onTap: () {
                        context
                            .read<ObscureCubitConfirmPassword>()
                            .toggleObscure();
                      },
                      validator: (confirmPassword) {
                        if (confirmPassword == null ||
                            confirmPassword.isEmpty) {
                          return TextString.confirmPasswordCannotEmpty;
                        }
                        if (confirmPassword != passwordController.text) {
                          return TextString.passwordNotMatch;
                        }
                        return null;
                      },
                    );
                  },
                ),
                2.hBox,
                Text(
                  TextString.birthDate,
                  style: AppFonts.body.copyWith(fontWeight: FontWeight.w400),
                ),
                1.hBox,
                TextFormField(
                  controller: birthDateController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: selectDate,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  readOnly: true,
                  onTap: selectDate,
                ),
                2.hBox,
                formWidget(
                  label: TextString.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  focusNode: phoneFocusNode,
                  nextFocusNode: null,
                  textInputAction: TextInputAction.done,
                  validator: (phone) {
                    if (phone == null || phone.isEmpty) {
                      return TextString.phoneCannotEmpty;
                    }
                    return null;
                  },
                ),
                3.hBox,
                CustomeButton(text: TextString.signUp, onPressed: () {}),
                2.hBox,
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TextString.alreadyHaveAccount,
                        style: AppFonts.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go(
                            AppRoute.splash.path + AppRoute.signIn.path,
                          );
                        },
                        child: Text(
                          TextString.signIn,
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
      ),
    );
  }
}
