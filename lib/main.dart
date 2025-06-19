import 'package:flutter/material.dart';
import 'package:foto_ta/core/string/text_string.dart';
import 'package:foto_ta/core/theme/app_theme.dart';
import 'package:sizer/sizer.dart';
import 'config/injector/injection_conf.dart' as di;
import 'package:foto_ta/config/router/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
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
          child: MaterialApp.router(
            title: TextString.appName,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
          ),
        );
      },
    );
  }
}
