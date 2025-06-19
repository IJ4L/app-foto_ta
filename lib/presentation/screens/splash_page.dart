import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:foto_ta/core/string/assets_string.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacement(AppRoute.auth.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SvgPicture.asset(
              AssetsString.logo,
              height: 14.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
