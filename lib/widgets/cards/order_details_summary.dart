import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/views/pages/cart/widgets/amount_tile.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/app_colors.dart';

class OrderDetailsSummary extends StatelessWidget {
  const OrderDetailsSummary(
    this.order, {
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    print("order status ====> ${order.status}");
    final currencySymbol = AppStrings.currencySymbol;
    print('subtotal ======>${order.orderTotal}');
    return VStack(
      [
        "Order Summary".tr().text.bold.xl2
            .color(AppColor.primaryColor).make().pOnly(bottom: Vx.dp12),

        AmountTile("Subtotal".tr(),
                (order.subTotal??0).currencyValueFormat())
            .py2(),
        if ((order.orderTotal ?? 0) > 0)
          AmountTile(
            "Discount".tr(),
            "- ${"$currencySymbol ${(order.orderTotal ?? 0) - (order.subTotal ?? 0)}".currencyFormat(currencySymbol)}",
          ).py2(),
        AmountTile(
          "Coupon Discount".tr(),
          "- ${"$currencySymbol ${order.discount ?? 0}".currencyFormat(currencySymbol)}",
        ).py2(),
        Visibility(
          visible: order.deliveryFee != null,
          child: AmountTile(
            "Transit Fee".tr(),
            "+ ${"$currencySymbol ${order.deliveryFee ?? 0}".currencyFormat(currencySymbol)}",
          ).py2(),
        ),
        AmountTile(
          "Tax (%s)".tr().fill(["${order.taxRate ?? 0}%"]),
          "+ ${" $currencySymbol ${order.tax ?? 0}".currencyFormat(currencySymbol)}",
        ).py2(),
        DottedLine(dashColor: context.textTheme.bodyLarge!.color!).py8(),
        Visibility(
          visible: order.fees != null && order.fees!.isNotEmpty,
          child: VStack(
            [
              ...((order.fees ?? []).map((fee) {
                return AmountTile(
                  fee.name.tr(),
                  "+ ${" $currencySymbol ${fee.amount}".currencyFormat(currencySymbol)}",
                ).py2();
              }).toList()),
              DottedLine(dashColor: context.textTheme.bodyLarge!.color!).py8(),
            ],
          ),
        ),
        Visibility(
          visible: order.tip != null && order.tip! > 0,
          child: VStack(
            [
              AmountTile(
                "Driver Tip".tr(),
                "+ ${"$currencySymbol ${order.tip ?? 0}".currencyFormat(currencySymbol)}",
              ).py2(),
              DottedLine(dashColor: context.textTheme.bodyLarge!.color!).py8(),
            ],
          ),
        ),
        AmountTile(
          "Total Amount".tr(),
          "$currencySymbol ${order.total ?? 0}".currencyFormat(currencySymbol),
        ),
        SizedBox(height: order.status == "Cancelled"? 30 : 0,),
        order.status == "Cancelled"?AmountTile(
          "Amount Refunded",
          "$currencySymbol ${order.total ?? 0}".currencyFormat(currencySymbol),
        ):SizedBox(),
      ],
    );
  }
}
