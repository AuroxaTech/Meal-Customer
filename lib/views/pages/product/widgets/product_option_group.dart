import 'package:flutter/material.dart';
import 'package:mealknight/models/option_group.dart';
import 'package:mealknight/view_models/product_details.vm.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/list_items/option.list_item.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_font.dart';

class ProductOptionGroup extends StatelessWidget {
  const ProductOptionGroup({
    required this.optionGroup,
    required this.model,
    super.key,
  });

  final OptionGroup optionGroup;
  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //group name
        /*optionGroup.name.text
            .fontFamily(AppFonts.appFont)
            .color(AppColor.primaryColor)
            .base
            .semiBold
            .make(),*/
        HStack([
          optionGroup.name.richText.lg
              .fontFamily(AppFonts.appFont)
              .color(AppColor.primaryColor)
              .bold
              .make()
              .fittedBox(),
          5.widthBox,
          "Optional"
              .text
              .sm
              .fontFamily(AppFonts.appFont)
              .size(2)
              .color(AppColor.primaryColor)
              .make()
              .p4()
              .py0()
              .box
              .withRounded()
              .color(Colors.grey.withOpacity(.4))
              .make()
        ]),
        //options
        CustomListView(
          dataSet: optionGroup.options,
          noScrollPhysics: true,
          justList: true,
          padding: const EdgeInsets.only(top: 8.0),
          itemBuilder: (context, index) {
            final option = optionGroup.options[index];
            return OptionListItem(
              option: option,
              optionGroup: optionGroup,
              model: model,
            );
          },
        ),
      ],
    ).px20();
  }
}
