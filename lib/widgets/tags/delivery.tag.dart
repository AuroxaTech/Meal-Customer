import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class DeliveryTag extends StatelessWidget {
  const DeliveryTag({super.key});

  @override
  Widget build(BuildContext context) {
    return "Delivery"
        .tr()
        .text
        .fontFamily(AppFonts.appFont)
        .fontWeight(FontWeight.normal)
        .color(Utils.isDark(AppColor.deliveryColor)
            ? Colors.white
            : AppColor.primaryColor)
        .make()
        .px8()
        .box
        .roundedLg
        .make();
  }
}
