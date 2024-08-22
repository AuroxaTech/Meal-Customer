import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
    this.imageUrl,
    this.title = "",
    this.actionText = "Action",
    this.description = "",
    this.showAction = false,
    this.showImage = true,
    this.actionPressed,
    this.auth = false,
  }) : super(key: key);

  final String title;
  final String actionText;
  final String description;
  final String? imageUrl;
  final Function? actionPressed;
  final bool showAction;
  final bool showImage;
  final bool auth;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: VStack(
        [
          //
          (imageUrl != null && imageUrl.isNotEmptyAndNotNull)
              ? Image.asset(imageUrl!)
                  .wh(
                    context.percentWidth * 30,
                    context.percentWidth * 30,
                  )
                  .box
                  .makeCentered()
                  .wFull(context)
              : UiSpacer.emptySpace(),
          UiSpacer.vSpace(5),

          //
          (title.isNotEmpty)
              ? title.text.lg.semiBold.center.makeCentered()
              : SizedBox.shrink(),

          //
          (auth && showImage)
              ? Image.asset(AppImages.profile)
                  .wh(
                    Vx.dp64,
                    Vx.dp64,
                  )
                  .box
                  .makeCentered()
                  .py2()
                  .wFull(context)
              : SizedBox.shrink(),
          //
          auth
              ? "You have to login to access profile and history"
                  .tr()
                  .text
                  .center
                  .sm
                  .light.color(AppColor.primaryColor)
                  .makeCentered().py2()
              : description.isNotEmpty
                  ? description.text.sm.light.center.makeCentered()
                  : SizedBox.shrink(),

          //
          auth
              ? CustomButton(
                  title: "Login".tr(),titleStyle: TextStyle(color: AppColor.primary),
                  onPressed: actionPressed,color: Colors.white,
                ).centered().box.border(color: AppColor.primaryColor).withRounded(value:Vx.dp4).make()
              : showAction
                  ? CustomButton(
                      title: actionText.tr(),
                      onPressed: actionPressed
                    ).centered().py8()
                  : SizedBox.shrink(),
        ],
        crossAlignment: CrossAxisAlignment.center,
        alignment: MainAxisAlignment.center,
      ).wFull(context),
    );
  }
}
