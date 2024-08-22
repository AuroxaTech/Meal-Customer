import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_font.dart';
import '../../utils/ui_spacer.dart';
import '../currency_hstack.dart';

class PaymentCardView extends StatelessWidget {
  final String image;
  final String cardName;
  final String number;
  final String expiryDate;
  final bool setDefault;
  final VoidCallback? onSetAsDefault;
  final VoidCallback? onDisable;

  const PaymentCardView({
    super.key,
    required this.image,
    required this.cardName,
    required this.number,
    required this.expiryDate,
    required this.setDefault,
    this.onSetAsDefault,
    this.onDisable,
  });

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //name
        cardName.text.lg.medium
            .maxLines(1)
            .fontFamily(AppFonts.appFont)
            .overflow(TextOverflow.ellipsis)
            .fontWeight(FontWeight.w600)
            .color(AppColor.primary)
            .make()
            .px8()
            .pOnly(top: Vx.dp8),

        //number
        number.text.lg.medium
            .maxLines(1)
            .fontFamily(AppFonts.appFont)
            .overflow(TextOverflow.ellipsis)
            .fontWeight(FontWeight.w600)
            .color(AppColor.primary)
            .make()
            .px8()
            .pOnly(top: Vx.dp8),

        //name
        expiryDate.text.sm.medium
            .maxLines(1)
            .fontFamily(AppFonts.appFont)
            .overflow(TextOverflow.ellipsis)
            .color(AppColor.primary)
            .make()
            .px8()
            .pOnly(top: Vx.dp8),
        HStack([
          //price
          if (setDefault == true)
            CurrencyHStack(
              [
                Image.asset(
                  'assets/images/icons/VectorRightTick.png',
                  height: 25,
                ),
                "Default"
                    .text
                    .fontFamily(AppFonts.appFont)
                    .sm
                    .medium
                    .color(AppColor.primary)
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.end,
            )
          else
            CurrencyHStack(
              [
                "Set as Default"
                    .text
                    .fontFamily(AppFonts.appFont)
                    .sm
                    .medium
                    .color(AppColor.primary)
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.end,
            ).onInkTap(onSetAsDefault),
          UiSpacer.horizontalSpace(space: 20),
          //discount

          CurrencyHStack(
            [
              Image.asset(
                'assets/images/close_button.png',
                height: 25,
              ),
              "Delete"
                  .text
                  .fontFamily(AppFonts.appFont)
                  .sm
                  .medium
                  .color(AppColor.primary)
                  .make(),
            ],
            crossAlignment: CrossAxisAlignment.end,
          ).onInkTap(onDisable),

          UiSpacer.expandedSpace().expand(),
          Image.asset(
            image,
            height: 50,
            width: 80,
          )
        ]).pOnly(left: Vx.dp8),

        5.heightBox
      ],
    )
        .px8()
        .box
        .margin(const EdgeInsets.only(bottom: 10.0))
        .outerShadow
        .border(width: 2, color: AppColor.primary)
        .color(context.theme.colorScheme.surface)
        .clip(Clip.antiAlias)
        .withRounded(value: 22)
        .make()
        .pOnly(left: 20, right: 20);
  }
}
