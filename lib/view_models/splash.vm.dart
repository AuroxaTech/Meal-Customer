// import 'dart:convert';
// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:cool_alert/cool_alert.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:mealknight/constants/app_colors.dart';
// import 'package:mealknight/constants/app_routes.dart';
// import 'package:mealknight/constants/app_strings.dart';
// import 'package:mealknight/constants/app_theme.dart';
// import 'package:mealknight/requests/settings.request.dart';
// import 'package:mealknight/services/auth.service.dart';
// import 'package:mealknight/services/firebase.service.dart';
// import 'package:mealknight/services/permission.service.dart';
// import 'package:mealknight/utils/utils.dart';
// import 'package:mealknight/views/pages/auth/login.page.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'base.view_model.dart';
//
// class SplashViewModel extends MyBaseViewModel {
//   SplashViewModel(BuildContext context) {
//     viewContext = context;
//   }
//
//   SettingsRequest settingsRequest = SettingsRequest();
//
//   initialise() async {
//     super.initialise();
//     await loadAppSettings();
//     if (AuthServices.authenticated()) {
//       await AuthServices.getCurrentUser(force: true);
//     }
//   }
//
//   loadAppSettings() async {
//     setBusy(true);
//     try {
//       final appSettingsObject = await settingsRequest.appSettings();
//       //app settings
//       await updateAppVariables(appSettingsObject.body["strings"]);
//       //colors
//       await updateAppTheme(appSettingsObject.body["colors"]);
//       loadNextPage();
//     } catch (error) {
//       setError(error);
//       print("Error loading app settings ==> $error");
//       //show a dialog
//       CoolAlert.show(
//         context: viewContext,
//         barrierDismissible: false,
//         type: CoolAlertType.error,
//         title: "An error occurred".tr(),
//         text: "$error",
//         confirmBtnText: "Retry".tr(),
//         onConfirmBtnTap: () {
//           Navigator.of(viewContext).pop();
//           initialise();
//         },
//       );
//     }
//     setBusy(false);
//   }
//
//   //
//   updateAppVariables(dynamic json) async {
//     //
//     await AppStrings.saveAppSettingsToLocalStorage(jsonEncode(json));
//   }
//
//   //theme change
//   updateAppTheme(dynamic colorJson) async {
//     //
//     await AppColor.saveColorsToLocalStorage(jsonEncode(colorJson));
//     //change theme
//     // await AdaptiveTheme.of(viewContext).reset();
//     AdaptiveTheme.of(viewContext).setTheme(
//       light: AppTheme().lightTheme(),
//       dark: AppTheme().darkTheme(),
//       notify: true,
//     );
//     await AdaptiveTheme.of(viewContext).persist();
//   }
//
//   //
//   loadNextPage() async {
//     print("Next page called");
//     //
//     await Utils.setJiffyLocale();
//     //
//     // if (AuthServices.firstTimeOnApp()) {
//     //   //choose language
//     //   await showModalBottomSheet(
//     //     context: viewContext,
//     //     builder: (context) {
//     //       return AppLanguageSelector();
//     //     },
//     //   );
//     // }
//     //
//     if (AuthServices.firstTimeOnApp()) {
//       Navigator.of(viewContext).pushNamedAndRemoveUntil(
//         AppRoutes.welcomeRoute,
//         (Route<dynamic> route) => false,
//       );
//     } else {
//       bool authenticated = await AuthServices.authenticated();
//
//       if (authenticated) {
//         bool granted = await PermissionService.isLocationGranted();
//         Navigator.of(viewContext).pushNamedAndRemoveUntil(
//           AppRoutes.homeRoute,
//           (Route<dynamic> route) => false,
//         );
//       } else {
//         Navigator.push(
//             viewContext,
//             MaterialPageRoute(
//               builder: (context) => const LoginPage(
//                 required: true,
//               ),
//             ));
//       }
//     }
//
//     //
//     RemoteMessage? initialMessage =
//         await FirebaseService().firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       FirebaseService().saveNewNotification(initialMessage);
//       FirebaseService().notificationPayloadData = initialMessage.data;
//       FirebaseService().selectNotification({});
//     }
//   }
// }

import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/constants/app_theme.dart';
import 'package:mealknight/requests/settings.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/firebase.service.dart';
import 'package:mealknight/services/permission.service.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/views/pages/auth/login.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';

class SplashViewModel extends MyBaseViewModel {
  SplashViewModel(BuildContext context) {
    viewContext = context;
  }

  SettingsRequest settingsRequest = SettingsRequest();

  initialise() async {
    super.initialise();
    await loadAppSettings();
    if (AuthServices.authenticated()) {
      await AuthServices.getCurrentUser(force: true);
    }
  }

  loadAppSettings() async {
    setBusy(true);
    try {
      final appSettingsObject = await settingsRequest.appSettings();
      //app settings
      await updateAppVariables(appSettingsObject.body["strings"]);
      //colors
      await updateAppTheme(appSettingsObject.body["colors"]);
      loadNextPage();
    } catch (error) {
      setError(error);
      print("Error loading app settings ==> $error");
      //show a dialog
      CoolAlert.show(
        context: viewContext,
        barrierDismissible: false,
        type: CoolAlertType.error,
        title: "An error occurred".tr(),
        text: "$error",
        confirmBtnText: "Retry".tr(),
        onConfirmBtnTap: () {
          Navigator.of(viewContext).pop();
          initialise();
        },
      );
    }
    setBusy(false);
  }

  //
  updateAppVariables(dynamic json) async {
    //
    await AppStrings.saveAppSettingsToLocalStorage(jsonEncode(json));
  }

  //theme change
  updateAppTheme(dynamic colorJson) async {
    //
    await AppColor.saveColorsToLocalStorage(jsonEncode(colorJson));
    //change theme
    // await AdaptiveTheme.of(viewContext).reset();
    AdaptiveTheme.of(viewContext).setTheme(
      light: AppTheme().lightTheme(),
      dark: AppTheme().darkTheme(),
      notify: true,
    );
    await AdaptiveTheme.of(viewContext).persist();
  }

  //
  loadNextPage() async {
    print("Next page called");
    //
    await Utils.setJiffyLocale();
    //
    // if (AuthServices.firstTimeOnApp()) {
    //   //choose language
    //   await showModalBottomSheet(
    //     context: viewContext,
    //     builder: (context) {
    //       return AppLanguageSelector();
    //     },
    //   );
    // }
    //
    if (AuthServices.firstTimeOnApp()) {
      Navigator.of(viewContext).pushNamedAndRemoveUntil(
        AppRoutes.welcomeRoute,
            (Route<dynamic> route) => false,
      );
    } else {
      bool authenticated = await AuthServices.authenticated();

      if (authenticated) {
        bool granted = await PermissionService.isLocationGranted();
        Navigator.of(viewContext).pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
              (Route<dynamic> route) => false,
        );
      } else {
        Navigator.push(
            viewContext,
            MaterialPageRoute(
              builder: (context) => const LoginPage(
                required: true,
              ),
            ));
      }
    }

    //
    RemoteMessage? initialMessage =
    await FirebaseService().firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      FirebaseService().saveNewNotification(initialMessage);
      FirebaseService().notificationPayloadData = initialMessage.data;
      FirebaseService().selectNotification(initialMessage.data);
    }
  }
}

