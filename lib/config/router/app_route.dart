import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/config/injector/injection_conf.dart';
import 'package:foto_ta/config/router/app_route_path.dart';
import 'package:foto_ta/core/transition/slide_transition.dart';
import 'package:foto_ta/data/services/event_service.dart';
import 'package:foto_ta/presentation/cubits/auth/auth_cubit.dart';
import 'package:foto_ta/presentation/cubits/camera/camera_cubit.dart';
import 'package:foto_ta/presentation/cubits/cubit.dart';
import 'package:foto_ta/presentation/screens/beranda_page.dart';
import 'package:foto_ta/presentation/screens/camera_page.dart';
import 'package:foto_ta/presentation/screens/detail_event_page.dart';
import 'package:foto_ta/presentation/screens/drive_search_detail_page.dart';
import 'package:foto_ta/presentation/screens/foto_page.dart';
import 'package:foto_ta/presentation/screens/home_page.dart';
import 'package:foto_ta/presentation/screens/profile_page.dart';
import 'package:foto_ta/presentation/screens/sign_in_page.dart';
import 'package:foto_ta/presentation/screens/sign_up_page.dart';
import 'package:foto_ta/presentation/screens/splash_page.dart';
import 'package:foto_ta/presentation/screens/take_selfies_page.dart';
import 'package:go_router/go_router.dart';

final cameraCubit = CameraCubit()..loadCameras();

final appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  debugLogDiagnostics: true,
  // Add redirect handling
  redirect: (context, state) {
    // Add global redirects here if needed
    return null; // Return null to proceed with normal navigation
  },
  // Add error handling
  errorBuilder: (context, state) {
    print('Navigation error: ${state.error}');
    return const Scaffold(body: Center(child: Text('Halaman tidak ditemukan')));
  },
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) {
        return const SplashPage();
      },
      routes: [
        GoRoute(
          path: AppRoute.signIn.path,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 1800),
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => sl<SignInCubit>(),
                child: SignInPage(),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return slideTransition(animation, child);
                  },
            );
          },
        ),
        GoRoute(
          path: AppRoute.signUp.path,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 1500),
              key: state.pageKey,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => sl<ObscureCubit>()),
                  BlocProvider(
                    create: (context) => sl<ObscureCubitConfirmPassword>(),
                  ),
                ],
                child: SignUpPage(),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return slideFromRightTransition(animation, child);
                  },
            );
          },
        ),
        GoRoute(
          path: AppRoute.takeSelfies.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 1000),
            key: state.pageKey,
            child: TakeSelfiesPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return slideFromRightTransition(animation, child);
                },
          ),
          routes: [
            GoRoute(
              path: AppRoute.camera.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 1000),
                reverseTransitionDuration: const Duration(milliseconds: 1000),
                key: state.pageKey,
                child: CameraPage(),

                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return slideFromRightTransition(animation, child);
                    },
              ),
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: AppRoute.beranda.path,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: const BerandaPage());
          },
        ),
        GoRoute(
          path: AppRoute.foto.path,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: const FotoPage());
          },
        ),
        GoRoute(
          path: AppRoute.profile.path,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: const ProfilePage());
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.detailEvent.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final title = extra?['title'] as String? ?? 'Detail Event';
        final eventId = extra?['eventId'] as int? ?? 0;
        final images = extra?['images'] as List<EventImage>? ?? [];
        final accessToken = extra?['accessToken'] as String?;

        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailEventPage(
            title: title,
            eventId: eventId,
            images: images,
            accessToken: accessToken,
          ),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return slideFromRightTransition(animation, child);
          },
        );
      },
    ),
    GoRoute(
      path: AppRoute.driveSearchDetail.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final searchId = extra?['searchId'] as int? ?? 0;
        final accessToken = extra?['accessToken'] as String? ?? '';

        return CustomTransitionPage(
          key: state.pageKey,
          child: DriveSearchDetailPage(
            searchId: searchId,
            accessToken: accessToken,
          ),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return slideFromRightTransition(animation, child);
          },
        );
      },
    ),
  ],
);
