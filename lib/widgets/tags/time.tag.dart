import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class TimeTag extends StatelessWidget {
  const TimeTag(this.value, {required this.iconData, Key? key})
      : super(key: key);

  final String? value;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    //delivery time
    return Visibility(
      visible: value != null,
      child: HStack(
        [
          //icon
          Icon(
            iconData,
            size: 12,
          color:AppColor.primaryColor
          ),
          UiSpacer.smHorizontalSpace(space: 2),

          //
          "${value} ${'min'.tr()}"
              .text
              .minFontSize(6).fontFamily(AppFonts.appFont)
              .color(AppColor.primaryColor)
              .size(10)
              .medium
              .maxLines(1)
              .make(),
        ],
      )
          .py2()
          .px8()
          .box
          .color(context.theme.colorScheme.background)
          .rounded
          .outerShadow
          .make(),
    );
  }
}
