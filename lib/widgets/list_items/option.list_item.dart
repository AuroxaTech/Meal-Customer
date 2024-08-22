import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/option.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/models/option_group.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/view_models/product_details.vm.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class OptionListItem extends StatelessWidget {
  const OptionListItem({
    required this.option,
    required this.optionGroup,
    required this.model,
    super.key,
  });

  final Option option;
  final OptionGroup optionGroup;
  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;
    return HStack(
      [
        if (option.photo.isNotEmpty && !option.photo.endsWith("default.png"))
          CustomImage(
            imageUrl: option.photo,
            width: Vx.dp32,
            height: Vx.dp32,
            canZoom: true,
          ),

        //details
        VStack(
          [
            //
            option.name.text
                .fontFamily(AppFonts.appFont)
                .color(AppColor.primaryColor)
                .medium
                .lg
                .make(),
            if (option.description.isNotEmptyAndNotNull)
              "${option.description}"
                  .text
                  .fontFamily(AppFonts.appFont)
                  .color(AppColor.primaryColor)
                  .sm
                  .maxLines(3)
                  .overflow(TextOverflow.ellipsis)
                  .make(),
          ],
        ).px12().expand(),

        //price
        if (option.price > 0)
          CurrencyHStack(
            [
              currencySymbol.text
                  .fontFamily(AppFonts.appFont)
                  .color(AppColor.primaryColor)
                  .sm
                  .medium
                  .make(),
              option.price
                  .currencyValueFormat()
                  .text
                  .fontFamily(AppFonts.appFont)
                  .color(AppColor.primaryColor)
                  .sm
                  .bold
                  .make(),
            ],
            crossAlignment: CrossAxisAlignment.end,
          ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 10.0),
          child: Icon(
            model.isOptionSelected(option)
                ? FlutterIcons.check_box_mdi
                : Icons.check_box_outline_blank,
            color: model.isOptionSelected(option)
                ? AppColor.accentColor
                : Colors.black,
          ),
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
    ).onInkTap(() => model.toggleOptionSelection(optionGroup, option));
  }
}
