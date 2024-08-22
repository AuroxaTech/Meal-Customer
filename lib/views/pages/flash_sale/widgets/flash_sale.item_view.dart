import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/services/navigation.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';

class FlashSaleItemListItem extends StatelessWidget {
  FlashSaleItemListItem(this.product, {this.fullPage = false, Key? key}) : super(key: key);

  final Product product;
  final bool fullPage;

  @override
  Widget build(BuildContext context) {
    return Row( children: [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: CustomImage(
            imageUrl: product.photo,
            width: double.infinity,
            height: fullPage ? (context.percentHeight * 12) : (context.percentWidth * 18),
          ),
        ).p(2),
      ),
      //
      Expanded(
        flex: 3,
        child: VStack(
          [
            "${product.name}".text.size(16).semiBold.color(AppColor.primary).ellipsis.make(),
            HStack([
              CurrencyHStack(
                [
                  "${product.sellPrice}"
                      .currencyValueFormat()
                      .text
                      .semiBold
                      .color(AppColor.primary)
                      .size(18)
                      .make(),
                  "${AppStrings.currencySymbol}"
                      .text
                      .size(18)
                      .semiBold
                      .color(AppColor.primary)
                      .make(),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              "${(product.vendor.prepareTime)}"
                  .text
                  .sm
                  .semiBold
                  .size(16)
                  .color(AppColor.primary)
                  .make(),
            ])
            //stock
          ],
        ).pOnly(bottom: 8,top: 8,left: 5,right: 5),
      ),
    ],)
        .w(context.percentWidth * 60)
        .box
        .color(Colors.white)
        .border(color: AppColor.primary, width: 2)
        .withRounded(value: 28)
        .make()
        .onTap(
      () {
        context.nextPage(
          NavigationService().productDetailsPageWidget(product),
        );
      },
    );
  }
}
