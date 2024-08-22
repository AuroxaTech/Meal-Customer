import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/constants/app_theme.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.router.dart';
import 'constants/app_strings.dart';
import 'package:mealknight/services/router.service.dart' as router;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));*/
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return AdaptiveTheme(
      light: AppTheme().lightTheme(),
      dark: AppTheme().darkTheme(),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        return MaterialApp(
          //navigatorKey: AppService().navigatorKey,
          navigatorKey: StackedService.navigatorKey,

          onGenerateRoute: StackedRouter().onGenerateRoute,
          initialRoute: Routes.splashPage,

          //initialRoute: AppRoutes.splash,
          //onGenerateRoute: router.generateRoute,

          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          onUnknownRoute: (RouteSettings settings) {
            // open your app when is executed from outside when is terminated.
            return router.generateRoute(settings);
          },
          // initialRoute: _startRoute,
          localizationsDelegates: LocalizeAndTranslate.delegates,
          locale: LocalizeAndTranslate.getLocale(),
          supportedLocales: LocalizeAndTranslate.getLocals(),
          //home: SplashPage(),
          theme: theme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}
