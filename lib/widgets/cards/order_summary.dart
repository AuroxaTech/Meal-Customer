import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/fee.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/views/pages/cart/widgets/amount_tile.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../currency_hstack.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    this.subTotal,
    this.discount,
    this.orderTotalPrice,
    this.deliveryFee,
    this.deliveryDiscount,
    this.tax,
    this.vendorTax,
    this.fees = const [],
    required this.total,
    this.driverTip = 0.00,
    this.mCurrencySymbol,
    this.customWidget,
    super.key,
  });

  final double? subTotal;
  final double? discount;
  final double? orderTotalPrice;
  final double? deliveryFee;
  final double? deliveryDiscount;
  final double? tax;
  final String? vendorTax;
  final double total;
  final double? driverTip;
  final String? mCurrencySymbol;
  final List<Fee> fees;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = mCurrencySymbol ?? AppStrings.currencySymbol;
    return Container(
      color: Colors.white,
      child: VStack(
        [
          // "Order Summary".tr().text.semiBold.xl.make().pOnly(bottom: Vx.dp12),
          //custom details
          if (customWidget != null) customWidget!,
          HStack([
            "Subtotal"
                .tr()
                .text
                .color(AppColor.primary)
                .fontFamily(AppFonts.appFont)
                .make()
                .expand(),
            UiSpacer.horizontalSpace(),
            CurrencyHStack(
              [
                currencySymbol.text.lg.bold
                    .fontFamily(AppFonts.appFont)
                    .color(AppColor.primaryColor)
                    .make(),
                Text(formatCurrency(orderTotalPrice!,),
                    style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
              ],
              crossAlignment: CrossAxisAlignment.end,
            ),
          ]).py2(),
          Visibility(
            visible: ((orderTotalPrice ?? 0) > 0),
            child: AmountTile(
              "Discount".tr(),
              "- ${"$currencySymbol ${((orderTotalPrice ?? 0) - (subTotal ?? 0)).toStringAsFixed(2)}".currencyFormat(currencySymbol)}",
            ).py2(),
          ),
          Visibility(
            visible: (discount ?? 0) > 0,
            child: AmountTile(
              "Coupon Discount".tr(),
              "- ${"$currencySymbol ${(discount ?? 0).toStringAsFixed(2)}".currencyFormat(currencySymbol)}",
            ).py2(),
          ),
          AmountTile(
            "Tax (%s)".tr().fill(["${vendorTax ?? 0}%"]),
            "+ ${" $currencySymbol ${(tax ?? 0).toStringAsFixed(2)}".currencyFormat(currencySymbol)}",
          ).py2(),
          Visibility(
            visible: deliveryFee != null,
            child: VStack([
              // DottedLine(dashColor: context.textTheme.bodyLarge!.color!).py8(),
              AmountTile(
                "Service Fee",
                "+ ${"$currencySymbol ${deliveryFee ?? 0}".currencyFormat(currencySymbol)}",
              ),
              Visibility(
                visible: deliveryDiscount != null,
                child: AmountTile(
                  "Delivery Discount".tr(),
                  "- ${"$currencySymbol ${(deliveryDiscount ?? 0).toStringAsFixed(2)}".currencyFormat(currencySymbol)}",
                ),
              ),
            ]).py2(),
          ),
          // DottedLine(dashColor: context.textTheme.bodyLarge!.color!).py8(),
          Visibility(
            visible: fees.isNotEmpty,
            child: VStack(
              [
                ...((fees).map((fee) {
                  //fixed
                  if ((fee.percentage != 1)) {
                    return AmountTile(
                      "${fee.name}".tr(),
                      "+ ${" $currencySymbol ${fee.value.toStringAsFixed(2)}".currencyFormat(currencySymbol)}",
                    ).py2();
                  } else {
                    //percentage
                    return AmountTile(
                      "${fee.name} (%s)"
                          .tr()
                          .fill(["${fee.value.toStringAsFixed(2)}%"]),
                      "+ ${" $currencySymbol ${fee.getRate(subTotal ?? 0)}".currencyFormat(currencySymbol)}",
                    ).py2();
                  }
                }).toList()),
                DottedLine(dashColor: context.textTheme.bodyLarge!.color!)
                    .py8(),
              ],
            ),
          ),
          Visibility(
            visible: driverTip != null && driverTip! > 0,
            child: VStack(
              [
                AmountTile(
                  "Driver Tip".tr(),
                  "+ ${"$currencySymbol ${driverTip ?? 0}".currencyFormat(currencySymbol)}",
                ).py2(),
                DottedLine(dashColor: context.textTheme.bodyLarge!.color!)
                    .py8(),
              ],
            ),
          ),
          HStack([
            "Total Amount"
                .text
                .color(AppColor.primary)
                .size(24)
                .fontFamily(AppFonts.appFont)
                .semiBold
                .make()
                .expand(),
            UiSpacer.horizontalSpace(),
            "$currencySymbol ${total.toStringAsFixed(2)}"
                .text
                .color(AppColor.primary)
                .size(24)
                .fontFamily(AppFonts.appFont)
                .semiBold
                .fontFamily(AppFonts.appFont)
                .make(),
          ])
        ],
      ),
    );
  }
}
