import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';

class AppUIStyles extends AppStrings {
  //
  static int themeUIStyle() {
    dynamic uiEnv = AppStrings.env("ui");
    if (uiEnv == null ||
        uiEnv["home"] == null ||
        uiEnv['home']["homeViewStyle"] == null) {
      return 1;
    }
    return int.tryParse(uiEnv['home']["homeViewStyle"].toString()) ?? 1;
  }

  static bool get isModern => themeUIStyle() == 2;

  static bool get isOriginal => [1, null].contains(themeUIStyle());

//   vendortypeHeight
// vendortypeWidth
// vendortypeImageStyle

  //vendor type sizes
  static double get vendorTypeWidth {
    try {
      dynamic uiEnv = AppStrings.env("ui");
      if (uiEnv == null ||
          uiEnv["home"] == null ||
          uiEnv['home']["vendortypeWidth"] == null) {
        return double.infinity;
      }
      return double.tryParse(uiEnv['home']["vendortypeWidth"].toString()) ??
          double.infinity;
    } catch (e) {
      print(e);
      return double.infinity;
    }
  }

  static double get vendorTypeHeight {
    try {
      dynamic uiEnv = AppStrings.env("ui");
      if (uiEnv == null ||
          uiEnv["home"] == null ||
          uiEnv['home']["vendortypeHeight"] == null) {
        return 60;
      }
      return double.tryParse(uiEnv['home']["vendortypeHeight"].toString()) ??
          60.0;
    } catch (e) {
      print(e);
      return 60;
    }
  }

  static BoxFit get vendorTypeImageStyle {
    dynamic uiEnv = AppStrings.env("ui");
    if (uiEnv == null ||
        uiEnv["home"] == null ||
        uiEnv['home']["vendortypeImageStyle"] == null) {
      return BoxFit.cover;
    }

    //
    BoxFit boxFit = BoxFit.cover;

    switch (uiEnv['home']["vendortypeImageStyle"].toString()) {
      case "center":
        boxFit = BoxFit.contain;
        break;
      case "contain":
        boxFit = BoxFit.contain;
        break;
      case "cover":
        boxFit = BoxFit.cover;
        break;
      case "fill":
        boxFit = BoxFit.fill;
        break;
      case "none":
        boxFit = BoxFit.none;
        break;
      case "scaleDown":
        boxFit = BoxFit.scaleDown;
        break;
      default:
        return BoxFit.cover;
    }

    return boxFit;
  }
}
