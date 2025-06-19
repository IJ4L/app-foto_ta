import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:foto_ta/core/transition/slide_transition.dart';
import 'package:foto_ta/presentation/screens/auth_page.dart';
import 'package:foto_ta/presentation/screens/splash_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: AppRoute.auth.path,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 1800),
          key: state.pageKey,
          child: AuthPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return slideTransition(animation, child);
          },
        );
      },
    ),
  ],
);
