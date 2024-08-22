import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/tags/fav.positioned.dart';
import 'package:mealknight/widgets/tags/product_tags.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductListItem extends StatelessWidget {
  const CommerceProductListItem(
    this.product, {
    this.height,
    this.boxFit,
    Key? key,
  }) : super(key: key);

  final Product product;
  final double? height;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //image and fav icon
        Stack(
          children: [
            //prouct first image
            CustomImage(
              imageUrl: "${product.photo}",
              width: double.infinity,
              height: height,
              boxFit: boxFit ?? BoxFit.contain,
            ).box.slate100.withRounded(value: 5).clip(Clip.antiAlias).make(),

            //fav icon
            FavPositiedView(product),
          ],
        ),

        //details
        VStack(
          [
            //name
            "${product.name}"
                .text
                .medium
                .size(14)
                .maxLines(2)
                .minFontSize(14)
                .maxFontSize(14)
                .ellipsis
                .make(),

            // "${product.vendor.name}".text.make(),

            // price
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                //price
                CurrencyHStack(
                  [
                    AppStrings.currencySymbol.text.base.semiBold.make(),
                    product.sellPrice
                        .currencyValueFormat()
                        .text
                        .base
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
                      AppStrings.currencySymbol.text.lineThrough.xs.make(),
                      product.price
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .xs
                          .medium
                          .make(),
                    ],
                  ).px4(),
                ),
              ],
            ),
          ],
        ).p8(),

        //
        ProductTags(product),
      ],
    )
        .onInkTap(
          () => openProductDetailsPage(context, product),
        )
        .material(color: context.theme.colorScheme.background)
        .box
        .clip(Clip.antiAlias)
        // .border(
        //   color: context.theme.colorScheme.background,
        //   width: 2,
        // )
        .color(context.theme.colorScheme.background)
        .withRounded(value: 5)
        .outerShadow
        .make();
  }

  openProductDetailsPage(BuildContext context, product) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AmazonStyledCommerceProductDetailsPage(product: product),
        ));
  }
}
