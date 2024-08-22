import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/services/app.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:stacked/stacked.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({
    super.key,
    required this.onResult,
  });

  //
  final Function(bool) onResult;

  //
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          //title
          "Location Permission Request".tr().text.semiBold.xl.make().py12(),
          "Thank you for using %s. To provide you with the best experience possible, our app needs access to your location. We use your location data to show you nearby vendors, enable you to set up a delivery address or location during checkout."
              .tr()
              .fill([AppStrings.appName])
              .text
              .make(),
          UiSpacer.verticalSpace(),
          CustomButton(
            title: "Next".tr(),
            onPressed: () {
              onResult(true);
              Navigator.of(context).pop();
            },
          ).py12(),
          Visibility(
            visible: !Platform.isIOS,
            child: CustomButton(
              title: "Cancel".tr(),
              color: Colors.grey[400],
              onPressed: () {
                onResult(false);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ).p20().wFull(context).scrollVertical(), //.hTwoThird(context),
    );
  }
}
