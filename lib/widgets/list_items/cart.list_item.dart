import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/cart.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/buttons/qty_stepper.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/states/product_stock.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_images.dart';

class CartListItem extends StatelessWidget {
  const CartListItem(
    this.cart, {
    required this.onQuantityChange,
    this.deleteCartItem,
    Key? key,
  }) : super(key: key);

  final Cart cart;
  final Function(int) onQuantityChange;
  final Function? deleteCartItem;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) newState) {
        return GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Stack(
                children: [

                  ClipRRect(
                    child: CustomImage(
                      imageUrl: cart.product!.photo,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  )
                      .wh(100, 100)
                      .box
                      .clip(Clip.antiAlias)
                      .withRounded(value: 15.0)
                      .border(color: AppColor.primaryColor, width: 2)
                      .make(),
                  Icon(
                    FlutterIcons.x_fea,
                    size: 15,
                    color: Colors.white,
                  )
                      .p4()
                      .onInkTap(
                    this.deleteCartItem != null ? () => this.deleteCartItem!() : null,
                  )
                      .box
                      .roundedSM
                      .color(Colors.red)
                      .make()
                      .positioned(
                    top: 0,
                    left: 0,
                  ),
                ],
              ),
              18.widthBox,

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "${cart.product?.name}"
                          .text
                          .lg
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .semiBold
                          .maxLines(2)
                          .overflow(TextOverflow.ellipsis)
                          .make(),
                      CurrencyHStack(
                        [
                          "${currencySymbol} "
                              .text
                              .color(AppColor.primary)
                              .lg
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .semiBold
                              .make(),
                          ("${cart.product!.sellPriceNew}"
                              .currencyValueFormat())
                              .text
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .lg
                              .semiBold
                              .make(),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      "Add ons:"
                          .text
                          .sm
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .maxLines(2)
                          .overflow(TextOverflow.ellipsis)
                          .make(),
                      "${cart.product?.name}"
                          .text
                          .sm
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .maxLines(2)
                          .overflow(TextOverflow.ellipsis)
                          .make(),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (cart.product!.hasStock)
                          ?  HStack(
                        [
                          //
                          if(cart.selectedQty != 0)
                            Image.asset(AppImages.minusSign,height: 40,).p4().onInkTap(() {
                              if (cart.product!.selectedQty > 1) {
                                cart.product!.selectedQty -= 1;
                                cart.product!.sellPriceNew = cart.product!.price * cart.product!.selectedQty;
                                print("cart.product!.selectedQty 2=====================${cart.product!.selectedQty}");
                                print("cart.product!.selectedQty 2=====================${cart.product!.price}");
                                newState((){});
                              }
                            }),
                          //
                          if(cart.product!.selectedQty != 0)
                            "${cart.product!.selectedQty}".text.fontFamily(AppFonts.appFont).bold
                                .color(AppColor.primaryColor).make().p4().px8(),
                          //
                          Image.asset(AppImages.plusSign,height: 40,).p4().onInkTap(() {
                            if (cart.product!.availableQty! > cart.product!.selectedQty) {
                              cart.product!.selectedQty += 1;
                              cart.product!.sellPriceNew = cart.product!.price * cart.product!.selectedQty;
                              print("cart.product!.selectedQty 1=====================${cart.product!.selectedQty}");
                              print("cart.product!.selectedQty 1=====================${cart.product!.price}");
                              newState((){});
                            }
                          }),
                        ],
                      ).box.make().py4().centered()
                          : !cart.product!.hasStock
                          ? "No stock"
                          .tr()
                          .text
                          .sm
                          .white
                          .makeCentered()
                          .py2()
                          .px4()
                          .box
                          .red600
                          .roundedSM
                          .make()
                          .p8()
                          : UiSpacer.emptySpace()
                      // ProductStockState(
                      //   cart.product!,
                      //   // qtyUpdated: model.addToCartDirectly,
                      // ),
                    ],
                  )
                ],
              ).expand(),
            ],
          ).pSymmetric(v: 10),
        );
      },
    );
/*
    return Stack(
      children: [
        HStack(
          [
            //
            //PRODUCT IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(7.5),
              child: CustomImage(
                imageUrl: cart.product!.photo,
                width: context.percentWidth * 18,
                height: context.percentWidth * 18,
              ),
            ).box.clip(Clip.antiAlias).roundedSM.border(width: 2,color: AppColor.primaryColor).make(),

            //
            UiSpacer.hSpace(10),
            VStack(
              [
                HStack([//product name
                  "${cart.product?.name}"
                      .text
                      .medium
                      .lg.color(AppColor.primaryColor).fontFamily(AppFonts.appFont)
                      .maxLines(2)
                      .ellipsis
                      .make(),
                  //cart item price
                  ("$currencySymbol" +
                      "${cart.price ?? cart.product!.sellPrice}")
                      .currencyFormat()
                      .text
                      .semiBold
                      .lg
                      .make(),
                ]),
                //product options
                if (cart.optionsSentence.isNotEmpty)
                  cart.optionsSentence.text.sm.gray600.make(),
                if (cart.optionsSentence.isNotEmpty) UiSpacer.vSpace(5),


              ],
            ),


          ],
          alignment: MainAxisAlignment.start,
          crossAlignment: CrossAxisAlignment.start,
        )
            .p12()
            .box
            .roundedSM
            .outerShadowSm
            .color(context.theme.colorScheme.background)
            .make(),

        //
        //delete icon
        Icon(
          FlutterIcons.x_fea,
          size: 16,
          color: Colors.white,
        )
            .p8()
            .onInkTap(
              this.deleteCartItem != null ? () => this.deleteCartItem!() : null,
            )
            .box
            .roundedSM
            .color(Colors.red)
            .make()
            .positioned(
              top: 0,
              left: 0,
            ),
      ],
    );*/
  }
}
