import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactPermissionDialog extends StatelessWidget {
  const ContactPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          //title
          "Contact Permission Request".tr().text.semiBold.xl.make().py12(),
          ("${AppStrings.appName} ${"requires your contact/phone book permission to select order recipient info from".tr()}")
              .text
              .make(),
          UiSpacer.verticalSpace(),
          CustomButton(
            title: "Next".tr(),
            onPressed: () {
              if (null != StackedService.navigatorKey?.currentContext) {
                Navigator.of(StackedService.navigatorKey!.currentContext!)
                    .pop(true);
              }
            },
          ).py12(),
          CustomButton(
            title: "Cancel".tr(),
            color: Colors.grey[400],
            onPressed: () {
              if (null != StackedService.navigatorKey?.currentContext) {
                Navigator.of(StackedService.navigatorKey!.currentContext!)
                    .pop(false);
              }
            },
          ),
        ],
      ).p20().wFull(context).scrollVertical(), //.hTwoThird(context),
    );
  }
}
