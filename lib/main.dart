import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/core/string/text_string.dart';
import 'package:foto_ta/core/theme/app_theme.dart';
import 'package:foto_ta/presentation/cubits/camera/camera_cubit.dart';
import 'package:foto_ta/presentation/cubits/drive_search/drive_search_cubit.dart';
import 'package:foto_ta/presentation/cubits/drive_search_detail/drive_search_detail_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/injector/injection_conf.dart' as di;
import 'package:foto_ta/config/router/app_route.dart';
import 'package:go_router/go_router.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('BLoC onChange: ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('BLoC error in ${bloc.runtimeType}: $error');
    debugPrint(stackTrace.toString());
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    debugPrint('BLoC closed: ${bloc.runtimeType}');
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    debugPrint('BLoC created: ${bloc.runtimeType}');
    super.onCreate(bloc);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await dotenv.load();
  await di.init();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => di.sl<CameraCubit>()),
              BlocProvider(create: (context) => di.sl<DriveSearchCubit>()),
              BlocProvider(
                create: (context) => di.sl<DriveSearchDetailCubit>(),
              ),
            ],
            child: MaterialApp.router(
              title: TextString.appName,
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
            ),
          ),
        );
      },
    );
  }
}
