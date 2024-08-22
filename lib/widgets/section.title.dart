import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return "$title".text.lg.medium.fontWeight(FontWeight.w500).size(18).fontFamily(AppFonts.appFont).color(AppColor.primary).make();
  }
}
