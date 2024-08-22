import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class AmountTile extends StatelessWidget {
  const AmountTile(this.title, this.amount, {Key? key}) : super(key: key);

  final String title;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        title.text.color(AppColor.primary).fontFamily(AppFonts.appFont).make().expand(),
        UiSpacer.horizontalSpace(),
        amount.text.color(AppColor.primary).fontFamily(AppFonts.appFont).semiBold.xl.fontFamily(AppFonts.appFont).make(),
      ],
    );
  }
}
