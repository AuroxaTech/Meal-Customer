import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked_services/stacked_services.dart';

class AlertService {
  static Future<bool> showConfirm({
    String? title,
    String? text,
    String cancelBtnText = "Cancel",
    String confirmBtnText = "Ok",
    Function? onConfirm,
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: StackedService.navigatorKey!.currentContext!,
        type: CoolAlertType.confirm,
        title: title,
        text: text,
        cancelBtnText: cancelBtnText.tr(),
        confirmBtnText: confirmBtnText.tr(),
        onConfirmBtnTap: () {
          if (onConfirm == null) {
            result = true;
            if (null != StackedService.navigatorKey?.currentContext) {
              Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
            }
          } else {
            onConfirm();
          }
        });

    //
    return result;
  }

  static Future<bool> success({
    String? title,
    String? text,
    String cancelBtnText = "Cancel",
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    if (null != StackedService.navigatorKey?.currentContext) {
      await CoolAlert.show(
          context: StackedService.navigatorKey!.currentContext!,
          type: CoolAlertType.success,
          title: title,
          text: text,
          confirmBtnText: confirmBtnText.tr(),
          cancelBtnText: cancelBtnText.tr(),
          onConfirmBtnTap: () {
            result = true;
            Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
          });
    }
    return result;
  }

  static Future<bool> error({
    String? title,
    String? text,
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    if (null != StackedService.navigatorKey?.currentContext) {
      await CoolAlert.show(
          context: StackedService.navigatorKey!.currentContext!,
          type: CoolAlertType.error,
          title: title,
          text: text,
          confirmBtnText: confirmBtnText.tr(),
          onConfirmBtnTap: () {
            result = true;
            Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
          });
    }

    //
    return result;
  }

  static Future<bool> warning({
    String? title,
    String? text,
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    if (null != StackedService.navigatorKey?.currentContext) {
      await CoolAlert.show(
          context: StackedService.navigatorKey!.currentContext!,
          type: CoolAlertType.warning,
          title: title,
          text: text,
          confirmBtnText: confirmBtnText.tr(),
          onConfirmBtnTap: () {
            result = true;
            Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
          });
    }

    //
    return result;
  }

  static void showLoading() {
    if (null != StackedService.navigatorKey?.currentContext) {
      CoolAlert.show(
        context: StackedService.navigatorKey!.currentContext!,
        type: CoolAlertType.loading,
        title: "".tr(),
        text: "Processing. Please wait...".tr(),
        barrierDismissible: false,
      );
    }
  }

  static void stopLoading() {
    if (null != StackedService.navigatorKey?.currentContext) {
      Navigator.of(StackedService.navigatorKey!.currentContext!).pop();
    }
  }
}
