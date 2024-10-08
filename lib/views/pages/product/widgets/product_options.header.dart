import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class ProductOptionsHeader extends StatelessWidget {
  const ProductOptionsHeader({
    this.iconData,
    this.title,
    this.description,
    Key? key,
  }) : super(key: key);

  final IconData? iconData;
  final String? title;
  final String? description;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        Icon(
          iconData ?? FlutterIcons.plus_circle_fea,
          size: 20,
        ).pOnly(right: Vx.dp20),
        //
        VStack(
          [
            title != null
                ? title!.text.xl.semiBold.fontFamily(AppFonts.appFont)
                .color(AppColor.primaryColor).make()
                : "Options".tr().text.lg.semiBold.fontFamily(AppFonts.appFont)
                .color(AppColor.primaryColor).make(),
            description != null
                ? description!.text.sm.make()
                : UiSpacer.emptySpace(),
          ],
        ).expand(),
      ],
    ).px20().pOnly(top: Vx.dp20, bottom: Vx.dp12);
  }
}
