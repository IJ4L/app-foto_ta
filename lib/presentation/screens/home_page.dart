import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.state,
  });

  int _calculateSelectedIndex() {
    final location = state.uri.toString();
    if (location.startsWith(AppRoute.beranda.path)) return 0;
    if (location.startsWith(AppRoute.foto.path)) return 1;
    if (location.startsWith(AppRoute.profile.path)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex();
    return Scaffold(
      body: child,
      bottomNavigationBar: SizedBox(
        height: 65,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                0,
                selectedIndex,
                'Home',
                'assets/icons/beranda_ic.svg',
                'assets/icons/beranda_bold_ic.svg',
                () => context.go(AppRoute.beranda.path),
              ),
              _buildNavItem(
                context,
                1,
                selectedIndex,
                'FotoTa',
                'assets/icons/foto_ic.svg',
                'assets/icons/foto_bold_ic.svg',
                () => context.go(AppRoute.foto.path),
              ),
              _buildNavItem(
                context,
                2,
                selectedIndex,
                'Profile',
                'assets/icons/profile_ic.svg',
                'assets/icons/profile_bold_ic.svg',
                () => context.go(AppRoute.profile.path),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    int selectedIndex,
    String label,
    String iconPath,
    String selectedIconPath,
    VoidCallback onTap,
  ) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 30.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? selectedIconPath : iconPath,
              width: isSelected ? 3.h : 4.h,
              height: isSelected ? 3.h : 4.h,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
