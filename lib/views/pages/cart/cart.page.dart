import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/cart.vm.dart';
import 'package:mealknight/views/pages/cart/widgets/apply_coupon.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/utils.dart';
import '../../../widgets/cards/custom.visibility.dart';
import '../../../widgets/currency_hstack.dart';
import '../../../widgets/custom_image.view.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Image.asset(
              AppImages.swipeLeft,
              height: 60,
              width: 60,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          "Cart"
              .tr()
              .text
              .maxLines(1)
              .bold
              .overflow(TextOverflow.ellipsis)
              .color(AppColor.primaryColor)
              .make(),
          Image.asset(
            "assets/images/icons/Shopping cart 1.png",
            height: 40,
          ),
        ],
      ),
      appBarColor: context.theme.colorScheme.background,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: const Color(0xffeefffd),
      body: SafeArea(
        child: ViewModelBuilder<CartViewModel>.reactive(
          viewModelBuilder: () => CartViewModel(context),
          onViewModelReady: (model) => model.initialise(),
          builder: (context, model, child) {
            return Container(
              key: model.pageKey,
              child: VStack(
                [
                  //
                  /*  if (model.cartItems.isEmpty)
                    EmptyCart().centered().expand()
                  else*/
                  VStack(
                    [
                      "Your order"
                          .tr()
                          .text
                          .xl2
                          .maxLines(1)
                          .bold
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .make()
                          .px20(),
                      (model.vendor?.name ??
                              (model.cartItems.isNotEmpty
                                  ? model.cartItems.first.product?.vendor
                                          .name ??
                                      ""
                                  : ""))
                          .text
                          .xl2
                          .maxLines(1)
                          .lg
                          .semiBold
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .make()
                          .px20(),
                      (model.deliveryaddress?.name ??
                              model.vendor?.address ??
                              (model.cartItems.isNotEmpty
                                  ? model.cartItems.first.product?.vendor
                                          .address ??
                                      ""
                                  : ""))
                          .text
                          .xl2
                          .maxLines(1)
                          .sm
                          .medium
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .make()
                          .px20(),
                    ],
                  ).backgroundColor(Colors.white),

                  VStack(
                    [
                      CustomListView(
                        noScrollPhysics: true,
                        dataSet: model.cartItems,
                        itemBuilder: (context, index) {
                          //
                          final currencySymbol = AppStrings.currencySymbol;
                          return InkWell(
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CustomImage(
                                        imageUrl: model
                                            .cartItems[index].product!.photo,
                                      ),
                                    )
                                        .wh(100, 100)
                                        .box
                                        .clip(Clip.antiAlias)
                                        .withRounded(value: 15.0)
                                        .border(
                                            color: AppColor.primaryColor,
                                            width: 2)
                                        .make(),
                                    // Icon(
                                    //   FlutterIcons.x_fea,
                                    //   size: 15,
                                    //   color: Colors.white,
                                    // )
                                    //     .p4()
                                    //     .onInkTap(
                                    //     (){
                                    //       model.deleteCartItem(index);
                                    //     }
                                    // )
                                    //     .box
                                    //     .roundedSM
                                    //     .color(Colors.red)
                                    //     .make()
                                    //     .positioned(
                                    //   top: 0,
                                    //   left: 0,
                                    // ),
                                  ],
                                ),
                                18.widthBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              "${model.cartItems[index].product?.name}"
                                                  .text
                                                  .lg
                                                  .fontFamily(AppFonts.appFont)
                                                  .color(AppColor.primaryColor)
                                                  .semiBold
                                                  .maxLines(2)
                                                  .overflow(
                                                      TextOverflow.ellipsis)
                                                  .make(),
                                        ),
                                        CurrencyHStack(
                                          [
                                            //price
                                            CurrencyHStack(
                                              [
                                                currencySymbol.text.lg.bold
                                                    .fontFamily(
                                                        AppFonts.appFont)
                                                    .color(
                                                        AppColor.primaryColor)
                                                    .make(),
                                                (model.cartItems[index].product!
                                                        .sellPrice
                                                        .currencyValueFormat())
                                                    .text
                                                    .xl
                                                    .fontFamily(
                                                        AppFonts.appFont)
                                                    .color(
                                                        AppColor.primaryColor)
                                                    .bold
                                                    .make(),
                                              ],
                                              crossAlignment:
                                                  CrossAxisAlignment.end,
                                            ),

                                            //discount
                                            CustomVisibilty(
                                              visible: model.cartItems[index]
                                                  .product!.showDiscount,
                                              child: CurrencyHStack(
                                                [
                                                  currencySymbol
                                                      .text.lineThrough.xs
                                                      .fontFamily(
                                                          AppFonts.appFont)
                                                      .color(
                                                          AppColor.primaryColor)
                                                      .make(),
                                                  model.cartItems[index]
                                                      .product!.price
                                                      .currencyValueFormat()
                                                      .text
                                                      .lineThrough
                                                      .fontFamily(
                                                          AppFonts.appFont)
                                                      .color(
                                                          AppColor.primaryColor)
                                                      .lg
                                                      .medium
                                                      .make(),
                                                ],
                                              ),
                                            ),
                                            // "${currencySymbol} "
                                            //     .text
                                            //     .color(AppColor.primary)
                                            //     .lg
                                            //     .fontFamily(AppFonts.appFont)
                                            //     .color(AppColor.primaryColor)
                                            //     .semiBold
                                            //     .make(),
                                            // ("${model.cartItems[index].product!.price}"
                                            //     .currencyValueFormat())
                                            //     .text
                                            //     .fontFamily(AppFonts.appFont)
                                            //     .color(AppColor.primaryColor)
                                            //     .lg
                                            //     .semiBold
                                            //     .make(),
                                          ],
                                          crossAlignment:
                                              CrossAxisAlignment.end,
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
                                        model.cartItems[index]
                                            .heatLevelInfo()
                                            .text
                                            .sm
                                            .fontFamily(AppFonts.appFont)
                                            .color(AppColor.primaryColor)
                                            .maxLines(2)
                                            .overflow(TextOverflow.ellipsis)
                                            .make(),
                                      ],
                                    ),
                                    for (int i = 0;
                                        i <
                                            (model.cartItems[index].options
                                                    ?.length ??
                                                0);
                                        i++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          (model.cartItems[index].options?[i]
                                                      .name ??
                                                  '')
                                              .text
                                              .maxFontSize(10)
                                              .minFontSize(6)
                                              .fontFamily(AppFonts.appFont)
                                              .color(Utils.isDark(
                                                      AppColor.deliveryColor)
                                                  ? Colors.white
                                                  : AppColor.primaryColor)
                                              .make()
                                              .py2()
                                              .px8(),
                                          CurrencyHStack(
                                            [
                                              (model.cartItems[index]
                                                          .options?[i].price ??
                                                      '')
                                                  .toString()
                                                  .text
                                                  .maxFontSize(10)
                                                  .minFontSize(6)
                                                  .fontFamily(AppFonts.appFont)
                                                  .color(Utils.isDark(AppColor
                                                          .deliveryColor)
                                                      ? Colors.white
                                                      : AppColor.primaryColor)
                                                  .make(),
                                              currencySymbol.text
                                                  .maxFontSize(10)
                                                  .minFontSize(6)
                                                  .fontFamily(AppFonts.appFont)
                                                  .color(Utils.isDark(AppColor
                                                          .deliveryColor)
                                                      ? Colors.white
                                                      : AppColor.primaryColor)
                                                  .make(),
                                            ],
                                            crossAlignment:
                                                CrossAxisAlignment.end,
                                          ),
                                        ],
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        (model.cartItems[index].product!
                                                .hasStock)
                                            ? HStack(
                                                [
                                                  //
                                                  if (model
                                                          .cartItems[index]
                                                          .product!
                                                          .selectedQty !=
                                                      0)
                                                    Image.asset(
                                                      AppImages.minusSign,
                                                      height: 40,
                                                    ).p4().onInkTap(() async {
                                                      if (model
                                                              .cartItems[index]
                                                              .product!
                                                              .selectedQty >
                                                          1) {
                                                        model
                                                            .cartItems[index]
                                                            .product!
                                                            .selectedQty -= 1;
                                                        model
                                                            .cartItems[index]
                                                            .product!
                                                            .sellPriceNew = model
                                                                .cartItems[
                                                                    index]
                                                                .product!
                                                                .price *
                                                            model
                                                                .cartItems[
                                                                    index]
                                                                .product!
                                                                .selectedQty;
                                                        model
                                                            .calculateSubTotal();
                                                        await model.getUpdateItem(
                                                            index,
                                                            model
                                                                .cartItems[
                                                                    index]
                                                                .product!
                                                                .selectedQty);
                                                        setState(() {});
                                                      } else {
                                                        await model
                                                            .deleteCartItem(
                                                                index);
                                                        setState(() {});
                                                      }
                                                    }),
                                                  //
                                                  if (model
                                                          .cartItems[index]
                                                          .product!
                                                          .selectedQty !=
                                                      0)
                                                    "${model.cartItems[index].product!.selectedQty}"
                                                        .text
                                                        .fontFamily(
                                                            AppFonts.appFont)
                                                        .bold
                                                        .color(AppColor
                                                            .primaryColor)
                                                        .make()
                                                        .p4()
                                                        .px8(),
                                                  //
                                                  Image.asset(
                                                    AppImages.plusSign,
                                                    height: 40,
                                                  ).p4().onInkTap(() async {
                                                    if (model
                                                            .cartItems[index]
                                                            .product!
                                                            .availableQty! >
                                                        model
                                                            .cartItems[index]
                                                            .product!
                                                            .selectedQty) {
                                                      model
                                                          .cartItems[index]
                                                          .product!
                                                          .selectedQty += 1;
                                                      model
                                                          .cartItems[index]
                                                          .product!
                                                          .sellPriceNew = model
                                                              .cartItems[index]
                                                              .product!
                                                              .price *
                                                          model
                                                              .cartItems[index]
                                                              .product!
                                                              .selectedQty;

                                                      model.calculateSubTotal();
                                                      await model.getUpdateItem(
                                                          index,
                                                          model
                                                              .cartItems[index]
                                                              .product!
                                                              .selectedQty);
                                                      setState(() {});
                                                    }
                                                  }),
                                                ],
                                              ).box.make().py4().centered()
                                            : !model.cartItems[index].product!
                                                    .hasStock
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
                            // CartListItem(
                            //   cart,
                            //   onQuantityChange: (qty) =>
                            //       model.updateCartItemQuantity(qty, index),
                            //   deleteCartItem: () =>
                            //       model.deleteCartItem(index),
                            // ),
                            onTap: () => model.productSelected(
                                model.cartItems[index].product!),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 24.0,
                      ),
                      ApplyCoupon(model),
                      /*AmountTile(
                          "Total Item".tr(), model.totalCartItems.toString()),
                      AmountTile(
                          "Sub-Total".tr(),
                          "${model.currencySymbol} ${model.subTotalPrice}"
                              .currencyFormat()),
                      Visibility(
                        visible:
                            model.coupon != null && !model.coupon!.for_delivery,
                        child: AmountTile(
                            "Discount".tr(),
                            "${model.currencySymbol} ${model.discountCartPrice}"
                                .currencyFormat()),
                      ),
                      //
                      Visibility(
                        visible:
                            model.coupon != null && model.coupon!.for_delivery,
                        child: VStack(
                          [
                            DottedLine(
                              dashColor: context.textTheme.bodyLarge!.color!,
                            ).py12(),
                            "Discount will be applied to delivery fee on checkout"
                                .tr()
                                .text
                                .fontFamily(AppFonts.appFont)
                                .medium
                                .make(),
                          ],
                        ).py(4),
                      ),
                      DottedLine(dashColor: context.textTheme.bodyLarge!.color!)
                          .py12(),
                      AmountTile(
                          "Total".tr(),
                          "${model.currencySymbol} ${model.totalCartPrice}"
                              .currencyFormat()),*/
                      //
                      CustomButton(
                        shapeRadius: 10,
                        onPressed: model.checkoutPressed,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              "CHECKOUT".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: AppColor.primaryColor,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold),
                            ).centered(),
                            const SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              "(${model.currencySymbol} ${formatCurrency(model.orderTotalPrice)} plus fees and taxes minus discount)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: AppColor.primaryColor,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold),
                            ).centered(),
                            const SizedBox(
                              height: 12.0,
                            ),
                          ],
                        ),
                      )
                          .box
                          .withRounded(value: 10)
                          .border(width: 2, color: AppColor.primary)
                          .make()
                          .py32()
                    ],
                  )
                      .pOnly(bottom: context.mq.viewPadding.bottom)
                      .scrollVertical(padding: const EdgeInsets.all(20))
                      .expand(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
