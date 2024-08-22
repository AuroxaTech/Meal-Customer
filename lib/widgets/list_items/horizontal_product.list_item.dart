import 'package:flutter/material.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/states/product_stock.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class HorizontalProductListItem extends StatelessWidget {
  //
  const HorizontalProductListItem(
    this.product, {
    this.onPressed,
    required this.qtyUpdated,
    this.height,
    Key? key,
  }) : super(key: key);

  //
  final Product product;
  final Function(Product)? onPressed;
  final Function(Product, int)? qtyUpdated;
  final double? height;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    //
    Widget widget = HStack(
      [
        //
        Hero(
          tag: product.heroTag ?? product.id,
          child: CustomImage(imageUrl: product.photo)
              .wh(Vx.dp40, Vx.dp40)
              .box
              .clip(Clip.antiAlias)
              .roundedSM
              .make(),
        ),

        //Details
        VStack(
          [
            //name
            product.name.text.lg.medium.fontFamily(AppFonts.appFont)
                .maxLines(2)
                .overflow(TextOverflow.ellipsis)
                .make(),
            "${product.vendor.name}"
                .text.fontFamily(AppFonts.appFont)
                .sm
                .semiBold
                .maxLines(2)
                .overflow(TextOverflow.ellipsis)
                .make(),
            // //description
            // product.description.text.xs.light
            //     .maxLines(1)
            //     .overflow(TextOverflow.ellipsis)
            //     .make(),
          ],
        ).px12().expand(),

        //
        VStack(
          [
            //price
            CurrencyHStack(
              [
                currencySymbol.text.fontFamily(AppFonts.appFont).sm.make(),
                (product.showDiscount
                        ? product.discountPrice.currencyValueFormat()
                        : product.price.currencyValueFormat())
                    .text.fontFamily(AppFonts.appFont)
                    .lg
                    .semiBold
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.end,
            ),
            //discount
            product.showDiscount
                ? CurrencyHStack(
                    [
                      currencySymbol.text.fontFamily(AppFonts.appFont).lineThrough.xs.make(),
                      product.price
                          .currencyValueFormat()
                          .text.fontFamily(AppFonts.appFont)
                          .lineThrough
                          .lg
                          .medium
                          .make(),
                    ],
                  )
                : UiSpacer.emptySpace(),

            // plus/min icon here
            ProductStockState(
              product,
              qtyUpdated: qtyUpdated,
            ),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
      ],
    ).onInkTap(
      onPressed == null ? null : () => onPressed!(product),
    );

    //height set
    if (height != null) {
      widget = widget.h(height!);
    }

    //
    return widget.box.p4.roundedSM
        .color(context.cardColor)
        .outerShadow
        .makeCentered()
        .p8();
  }
}
