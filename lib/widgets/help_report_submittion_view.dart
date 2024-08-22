import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class ReportSuccessfullyView extends StatelessWidget {
  const ReportSuccessfullyView({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: VStack(
        [
          Spacer(),
          "Your report has been\nsuccessfully submitted. We\nwill get back to you within\n24 to 48 hours.".text.xl.medium.fontFamily(AppFonts.appFont).color(AppColor.primaryColor).make().px20().py8().box.make().centered(),

          "Ok".text.color(Colors.white).fontFamily(AppFonts.appFont).center.make().centered().px12().box.height(40).width(100).withRounded(value: 10).color(AppColor.primaryColor).make().centered().onTap(() {
            Navigator.pop(context);
          }).pOnly(top: 30),
          Spacer()

        ],
      ),
    );
  }
}
