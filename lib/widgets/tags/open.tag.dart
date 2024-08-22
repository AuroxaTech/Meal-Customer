import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class OpenTag extends StatelessWidget {
  const OpenTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return "Open"
        .tr()
        .text
        .sm.fontFamily(AppFonts.appFont)
        .color(Utils.isDark(AppColor.openColor) ? Colors.white : AppColor.primaryColor)
        .make()
        .py2()
        .px8()
        .box
        .roundedLg
        .color(AppColor.openColor)
        .make();
  }
}
