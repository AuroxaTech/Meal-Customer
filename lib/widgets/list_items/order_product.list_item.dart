import 'package:flutter/material.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/models/order_product.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/views/pages/order/widgets/order_digitial_product_download.dart';
import 'package:mealknight/widgets/bottomsheets/order_product_action.bottomsheet.dart';
import 'package:mealknight/widgets/buttons/arrow_indicator.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/cards/rounded_container.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';

class OrderProductListItem extends StatelessWidget {
  const OrderProductListItem({
    required this.orderProduct,
    required this.order,
    super.key,
  });

  final OrderProduct orderProduct;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //other status
        CustomVisibilty(
          visible: !order.isCommerce,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              RoundedContainer(
                child: CustomImage(
                  imageUrl: orderProduct.product!.photo,
                  width: 50,
                  height: 50,
                ),
              ),

              VStack(
                [
                  //
                  orderProduct.product!.name.text
                      .color(AppColor.primaryColor)
                      .make(),
                  if (orderProduct.heatLevelInfo().isNotEmpty)
                    "Heat Level : ${orderProduct.heatLevelInfo()}"
                        .text
                        .sm
                        .gray500
                        .medium
                        .make(),
                  Visibility(
                    visible: orderProduct.options != null,
                    child:
                        "${orderProduct.options}".text.sm.gray500.medium.make(),
                  ),
                  //
                  5.heightBox,
                  //qty
                  "x ${orderProduct.quantity}".text.bold.make(),
                ],
              ).px12().expand(),
              "${AppStrings.currencySymbol}${orderProduct.price}"
                  .currencyFormat()
                  .text
                  .semiBold
                  .make(),
              //
            ],
          ),
        ),

        //completed order
        CustomVisibilty(
          visible: order.isCommerce,
          child: VStack(
            [
              HStack(
                [
                  //
                  RoundedContainer(
                    child: CustomImage(
                      imageUrl: orderProduct.product!.photo,
                      width: 60,
                      height: 60,
                    ),
                  ),

                  VStack(
                    [
                      //
                      orderProduct.product!.name.text
                          .maxLines(2)
                          .ellipsis
                          .light
                          .make(),
                      orderProduct.options.isNotEmptyAndNotNull
                          ? orderProduct.options!.text.sm.gray500.medium.make()
                          : UiSpacer.emptySpace(),

                      HStack(
                        [
                          //qty
                          "Qty: %s"
                              .tr()
                              .fill([orderProduct.quantity])
                              .text
                              .semiBold
                              .make(),
                          //
                          UiSpacer.hSpace(15),
                          //price
                          "Price: %s"
                              .tr()
                              .fill(
                                [
                                  "${AppStrings.currencySymbol}${orderProduct.price}"
                                      .currencyFormat()
                                ],
                              )
                              .text
                              .semiBold
                              .make(),
                        ],
                      ),
                    ],
                  ).px12().expand(),
                  //
                  UiSpacer.hSpace(6),
                  ArrowIndicator(26),
                  //
                ],
              ),
              UiSpacer.divider().py8(),
              //digital download
              DigitialProductOrderDownload(order, orderProduct),
            ],
          ).onInkTap(
            () {
              //show bottomsheet
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (ctx) {
                  return OrderProductActionBottomSheet(orderProduct);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
