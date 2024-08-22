import 'package:flutter/material.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_font.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_strings.dart';
import '../../../../models/product.dart';
import '../../../../widgets/cards/custom.visibility.dart';
import '../../../../widgets/currency_hstack.dart';
import '../../../../widgets/tags/product_tags.dart';

class ProductDetailsHeader extends StatelessWidget {
  const ProductDetailsHeader({
    required this.product,
    this.showVendor = true,
    super.key,
  });

  final Product product;
  final bool showVendor;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppStrings.currencySymbol;

    return VStack(
      [
        HStack(
          [
            VStack(
              [
                HStack([
                  product.name.text.xl.semiBold
                      .fontFamily(AppFonts.appFont)
                      .color(AppColor.primaryColor)
                      .make()
                      .box
                      .make()
                      .expand(),
                  HStack([
                    "${product.vendor.rating.numCurrency} "
                        .text
                        .minFontSize(6)
                        .size(16)
                        .color(AppColor.primary)
                        .bold
                        .make(),
                    Image.asset(
                      AppImages.goldenStar,
                      height: 18,
                    ),
                  ])
                ]),
                HStack([
                  //size
                  HStack(
                    [
                      CurrencyHStack(
                        [
                          currencySymbol.text.lg.bold
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .make(),
                          (product.sellPrice.currencyValueFormat())
                              .text
                              .xl2
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .bold
                              .make(),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),

                      //discount
                      CustomVisibilty(
                        visible: product.showDiscount,
                        child: CurrencyHStack(
                          [
                            currencySymbol.text.lineThrough.xs
                                .fontFamily(AppFonts.appFont)
                                .color(AppColor.primaryColor)
                                .make(),
                            product.price
                                .currencyValueFormat()
                                .text
                                .lineThrough
                                .fontFamily(AppFonts.appFont)
                                .color(AppColor.primaryColor)
                                .lg
                                .medium
                                .make(),
                          ],
                        ),
                      ),
                    ],
                  ).expand(),
                  CustomVisibilty(
                    visible: !product.capacity.isEmptyOrNull &&
                        !product.unit.isEmptyOrNull,
                    child: "(${product.capacity}${product.unit} recommended)"
                        .text
                        .sm
                        .fontFamily(AppFonts.appFont)
                        .color(AppColor.primaryColor)
                        .make()
                        .box
                        .make(),
                  ),
                ]),
                product.description.text
                    .fontFamily(AppFonts.appFont)
                    .color(AppColor.primaryColor)
                    .sm
                    .medium
                    .make(),
              ],
            ).expand(),

            //price
          ],
        ),
        10.heightBox,
        ProductTags(product),
      ],
    ).px20().py12();
  }
}
