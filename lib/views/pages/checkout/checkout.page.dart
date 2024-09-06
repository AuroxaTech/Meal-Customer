import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/cart.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/view_models/checkout.vm.dart';
import 'package:mealknight/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:mealknight/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:mealknight/views/pages/delivery_address/delivery_addresses.page.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/cards/order_summary.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';

import '../../../models/vendor.dart';
import '../../../view_models/vendor_distance.vm.dart';
import '../../../widgets/cards/custom.visibility.dart';
import '../../../widgets/payment/payment_card_view.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({
    required this.checkout,
    super.key,
  });

  final CheckOut checkout;

  final currencySymbol = AppStrings.currencySymbol;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      viewModelBuilder: () => CheckoutViewModel(context, checkout),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        print("Min Prepare Time ===> ${vm.vendor?.minPrepareTime}");
        print("Max Prepare Time ===> ${vm.vendor?.maxPrepareTime}");
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          title: "Checkout".tr(),
          appBarColor: context.theme.colorScheme.surface,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: const Color(0xffeefffd),
          body: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              bool getView = vm.viewMap;
              return VStack(
                [
                  UiSpacer.verticalSpace(),
                  if (!vm.isPickup)
                    Stack(children: [
                      Center(
                        child: Column(children: [
                          "Delivering to"
                              .tr()
                              .text
                              .lg
                              .fontFamily(AppFonts.appFont)
                              .size(16)
                              .color(Utils.isDark(AppColor.deliveryColor)
                                  ? Colors.white
                                  : AppColor.primaryColor)
                              .make()
                              .py2()
                              .px4(),
                          (checkout.deliveryAddress?.address ?? '')
                              .text
                              .lg
                              .center
                              .fontFamily(AppFonts.appFont)
                              .size(16)
                              .color(Utils.isDark(AppColor.deliveryColor)
                                  ? Colors.white
                                  : AppColor.primaryColor)
                              .make()
                              .py2()
                              .px8()
                        ]).p12(),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const DeliveryAddressesPage()))
                                .then((value) {
                              vm.prefetchDeliveryAddress();
                              vm.vendorDetailsViewModel?.drawRoute(force: true);
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/icons/vectorPencil.png',
                                height: 25,
                              ),
                              "Edit"
                                  .text
                                  .fontFamily(AppFonts.appFont)
                                  .sm
                                  .medium
                                  .color(AppColor.primary)
                                  .make()
                            ],
                          ).pOnly(right: 10, bottom: 5),
                        ),
                      )
                    ])
                        .box
                        .withRounded(value: 28)
                        .shadow
                        .width(context.screenWidth)
                        .color(Colors.white)
                        .make()
                  else
                    Center(
                      child: Column(children: [
                        "Pickup from"
                            .text
                            .lg
                            .fontFamily(AppFonts.appFont)
                            .size(16)
                            .color(Utils.isDark(AppColor.deliveryColor)
                                ? Colors.white
                                : AppColor.primaryColor)
                            .make()
                            .py2()
                            .px4(),
                        (vm.vendorDetailsViewModel?.vendor?.name ?? "")
                            .text
                            .lg
                            .center
                            .fontFamily(AppFonts.appFont)
                            .size(16)
                            .color(Utils.isDark(AppColor.deliveryColor)
                                ? Colors.white
                                : AppColor.primaryColor)
                            .make()
                            .py2()
                            .px8()
                      ]).p12(),
                    )
                        .box
                        .withRounded(value: 28)
                        .shadow
                        .width(context.screenWidth)
                        .color(Colors.white)
                        .make(),

                  ValueListenableBuilder<Vendor?>(
                    valueListenable: VendorDistanceViewModel().listenToKey(
                        vm.vendorDetailsViewModel?.vendor?.id ?? -1),
                    builder: (BuildContext context, Vendor? value, child) {
                      vm.checkout?.distance = value?.distance ?? 0.00;
                      vm.checkout?.travelTime = value?.travelTime ?? 0;
                      print("Prepare Time ===> ${value?.prepareTime}");
                      return Row(
                        children: [
                          "${value?.prepareTime}"
                              .text
                              .lg
                              .fontFamily(AppFonts.appFont)
                              .semiBold
                              .color(Utils.isDark(AppColor.deliveryColor)
                                  ? Colors.white
                                  : AppColor.primaryColor)
                              .size(18)
                              .make()
                              .py8()
                              .px8()
                              .expand(),
                          20.widthBox,
                          "${value?.distance.numCurrency} km"
                              .text
                              .lg
                              .fontFamily(AppFonts.appFont)
                              .semiBold
                              .size(18)
                              .color(Utils.isDark(AppColor.deliveryColor)
                                  ? Colors.white
                                  : AppColor.primaryColor)
                              .make()
                              .py2()
                              .px8(),
                        ],
                      )
                          .box
                          .withRounded()
                          .color(Colors.white)
                          .border(width: 2, color: AppColor.primaryColor)
                          .make()
                          .centered()
                          .py12();
                    },
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: getView
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                vm.vendorDetailsViewModel?.currentLocation
                                        ?.latitude ??
                                    vm.vendorDetailsViewModel?.currentLocation1
                                        ?.latitude ??
                                    0.0,
                                vm.vendorDetailsViewModel?.currentLocation
                                        ?.longitude ??
                                    vm.vendorDetailsViewModel?.currentLocation1
                                        ?.longitude ??
                                    0.0,
                              ),
                              zoom: 150,
                            ),
                            myLocationButtonEnabled: true,
                            trafficEnabled: true,
                            onMapCreated: vm.vendorDetailsViewModel!.onMapReady,
                            // onCameraIdle: vm.taxiGoogleMapManagerService.onMapCameraIdle,
                            padding:
                                vm.vendorDetailsViewModel!.googleMapPadding,
                            markers: vm.vendorDetailsViewModel!.gMapMarkers,
                            polylines: vm.vendorDetailsViewModel!.gMapPolylines,
                            zoomControlsEnabled: true,
                            myLocationEnabled: true,
                          )
                        : Image.asset(AppImages.map, width: double.infinity, height: 300, fit: BoxFit.cover,),
                  )
                      .h(220)
                      .w(context.percentWidth * 95)
                      .box
                      .clip(Clip.antiAlias)
                      .withRounded(value: 15.0)
                      .make()
                      .px4(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      "${vm.isPickup ? "Deliver" : "Pickup"} your order"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .sm
                          .medium
                          .shadow(
                            0,
                            4,
                            10,
                            const Color(0xff000000).withOpacity(.4),
                          )
                          .color(AppColor.primary)
                          .make()
                          .pOnly(right: 5)
                          .onTap(vm.changeSelectedDeliveryType)
                          .px20(),
                    ],
                  ),

                  // Visibility(
                  //   visible: !vm.isPickup,
                  //   child: CustomTextFormField(
                  //     labelText: "Driver Tip".tr() + " (${AppStrings.currencySymbol})",
                  //     textEditingController: vm.driverTipTEC,
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //     onChanged: (value) => vm.updateCheckoutTotalAmount(),
                  //   ).pOnly(bottom: Vx.dp20),
                  // ),
                  // //
                  // CustomTextFormField(
                  //   labelText: "Note".tr(),
                  //   textEditingController: vm.noteTEC,
                  // ),
                  //
                  // //note
                  // Divider(thickness: 3).py12(),

                  //pickup time slot

                  (checkout.cartItems?[0].product!.vendor.name ?? '')
                      .text
                      .lg
                      .fontFamily(AppFonts.appFont)
                      .size(18)
                      .semiBold
                      .color(AppColor.primaryColor)
                      .make()
                      .py2()
                      .px20(),
                  /*(checkout.cartItems?[0].product!.vendor.address ?? '')
                      .text
                      .lg
                      .fontFamily(AppFonts.appFont)
                      .size(18)
                      .color(AppColor.primaryColor)
                      .make()
                      .py2()
                      .px20(),*/

                  productList(),

                  Visibility(
                    visible: !vm.isPickup,
                    child: CustomTextFormField(
                      labelText:
                          "${"Add a tip".tr()} (${AppStrings.currencySymbol})",
                      textEditingController: vm.driverTipTEC,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => vm.updateCheckoutTotalAmount(),
                    ).pOnly(bottom: Vx.dp20, top: 20),
                  ),

                  // Visibility(
                  //   visible: true,
                  //   child: VStack([
                  //     HStack(
                  //       [
                  //         "Add to cart"
                  //             .tr()
                  //             .text
                  //             .fontFamily(AppFonts.appFont)
                  //             .color(AppColor.primaryColor)
                  //             .lg
                  //             .medium
                  //             .bold
                  //             .make()
                  //             .expand(),
                  //         CurrencyHStack(
                  //           [
                  //             "100.99"
                  //                 .text
                  //                 .fontFamily(AppFonts.appFont)
                  //                 .color(AppColor.primaryColor)
                  //                 .letterSpacing(1.5)
                  //                 .lg
                  //                 .semiBold
                  //                 .make(),
                  //             currencySymbol.text
                  //                 .fontFamily(AppFonts.appFont)
                  //                 .color(AppColor.primaryColor)
                  //                 .lg
                  //                 .make(),
                  //           ],
                  //         ),
                  //       ],
                  //     ).centered().px20(),
                  //   ])
                  //       .onInkTap(() {})
                  //       .centered()
                  //       .box
                  //       .withRounded(value: 10)
                  //       .width(context.percentWidth * 90)
                  //       .border(width: 2, color: AppColor.primary)
                  //       .color(Colors.white)
                  //       .make()
                  //       .h(Vx.dp48)
                  //       .py12()
                  //       .pOnly(bottom: context.percentHeight * 20),
                  // ).centered(),
                  // ScheduleOrderView(vm),

                  //its pickup
                  // OrderDeliveryAddressPickerView(vm),

                  //payment options
                  Visibility(
                    visible: vm.canSelectPaymentOption,
                    child: PaymentMethodsView(vm),
                  ),

                  if (vm.selectedPaymentMethod?.name == "Debit/Credit Card") ...[
                    if ((null != vm.paymentCard ||
                        null != vm.defaultCard.value))
                      PaymentCardView(
                          image: (vm.paymentCard ?? vm.defaultCard.value!)
                                      .cardBrand
                                      .toLowerCase() ==
                                  "visa"
                              ? "assets/images/visacard.png"
                              : "assets/images/masterCard.png",
                          cardName: (vm.paymentCard ?? vm.defaultCard.value!)
                              .cardholderName,
                          number:
                              "**** **** **** ${(vm.paymentCard ?? vm.defaultCard.value!).last4}",
                          expiryDate:
                              "${(vm.paymentCard ?? vm.defaultCard.value!).expMonth.padLeft(2, '0')}/${(vm.paymentCard ?? vm.defaultCard.value!).expYear}",
                          setDefault: true),
                    "Change Payment Method"
                        .text
                        .color(AppColor.primary)
                        .semiBold
                        .xl
                        .make()
                        .py(16.0)
                        .centered()
                        .onInkTap(vm.changePaymentMethod),
                  ],

                  //order final price preview
                  OrderSummary(
                    subTotal: vm.checkout?.subTotal,
                    orderTotalPrice: vm.checkout?.orderTotalPrice,
                    discount: (vm.checkout?.coupon?.for_delivery ?? false)
                        ? null
                        : vm.checkout?.discount,
                    deliveryDiscount:
                        (vm.checkout?.coupon?.for_delivery ?? false)
                            ? vm.checkout?.discount
                            : null,
                    deliveryFee: vm.checkout?.deliveryFee,
                    tax: vm.checkout?.tax,
                    vendorTax: vm.vendor?.tax,
                    driverTip: double.tryParse(vm.driverTipTEC.text) ?? 0.00,
                    total: vm.checkout?.totalWithTip ?? 0.0,
                    fees: vm.vendor?.fees ?? [],
                  ),

                  //show notice it driver should be paid in cash
                  if (vm.checkout?.deliveryAddress != null)
                    CheckoutDriverCashDeliveryNoticeView(
                      vm.checkout?.deliveryAddress ?? DeliveryAddress(),
                    ),
                  //

                  CustomButton(
                    title: "PLACE ORDER".tr().padRight(14),
                    icon: FlutterIcons.credit_card_fea,
                    color: Colors.white,
                    onPressed: () {
                      vm.placeOrder();
                    },
                    borderColor: AppColor.primary,
                    shapeRadius: 18,
                    titleStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        color: AppColor.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    // loading: vm.isBusy,
                  ).centered().py16(),
                ],
              )
                  .p20()
                  .scrollVertical()
                  .pOnly(bottom: context.mq.viewInsets.bottom);
            },
          ),
        );
      },
    );
  }

  Widget productList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: checkout.cartItems?.length ?? 0,
        itemBuilder: (context, index) {
          Cart? cartItem = checkout.cartItems?[index];

          if (cartItem != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    "${index + 1}"
                        .text
                        .lg
                        .size(16)
                        .fontFamily(AppFonts.appFont)
                        .color(Utils.isDark(AppColor.deliveryColor)
                            ? Colors.white
                            : AppColor.primaryColor)
                        .make(),
                    Expanded(
                      child:
                          "${cartItem.product?.name} * ${cartItem.product?.selectedQty}"
                              .text
                              .lg
                              .size(16)
                              .fontFamily(AppFonts.appFont)
                              .color(Utils.isDark(AppColor.deliveryColor)
                                  ? Colors.white
                                  : AppColor.primaryColor)
                              .make()
                              .py2()
                              .px8(),
                    ),
                    CurrencyHStack(
                      [
                        CurrencyHStack(
                          [
                            currencySymbol.text.lg.bold
                                .fontFamily(AppFonts.appFont)
                                .color(AppColor.primaryColor)
                                .make(),
                            Text(
                                ((cartItem.product!
                                            .sellPrice /** cartItem.product!.selectedQty*/)
                                        .currencyValueFormat())
                                    .toString(),
                                style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16)),
                          ],
                          crossAlignment: CrossAxisAlignment.end,
                        ),

                        //discount
                        CustomVisibilty(
                          visible: cartItem.product!.showDiscount,
                          child: CurrencyHStack(
                            [
                              currencySymbol.text.lineThrough.xs
                                  .fontFamily(AppFonts.appFont)
                                  .color(AppColor.primaryColor)
                                  .make(),
                              Text(
                                  ((cartItem.product!
                                              .price /** cartItem.product!.selectedQty*/)
                                          .currencyValueFormat())
                                      .toString(),
                                  style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        // ((cartItem.product!.sellPrice * cartItem.product!.selectedQty).toString()).
                        // text.lg.color(AppColor.primary).semiBold.make(),
                        // currencySymbol.text.lg.color(AppColor.primary).semiBold.make(),
                      ],
                      crossAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
                if ((cartItem.heatLevel ?? -1) > -1)
                  ("Heat Level : ${cartItem.heatLevelInfo()}")
                      .text
                      .maxFontSize(10)
                      .minFontSize(6)
                      .fontFamily(AppFonts.appFont)
                      .color(Utils.isDark(AppColor.deliveryColor)
                          ? Colors.white
                          : AppColor.primaryColor)
                      .make()
                      .py2()
                      .px8(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (int i = 0; i < (cartItem.options?.length ?? 0); i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (cartItem.options?[i].name ?? '')
                            .text
                            .maxFontSize(10)
                            .minFontSize(6)
                            .fontFamily(AppFonts.appFont)
                            .color(Utils.isDark(AppColor.deliveryColor)
                                ? Colors.white
                                : AppColor.primaryColor)
                            .make()
                            .py2()
                            .px8(),
                        CurrencyHStack(
                          [
                            (cartItem.options?[i].price ?? '')
                                .toString()
                                .text
                                .maxFontSize(10)
                                .minFontSize(6)
                                .fontFamily(AppFonts.appFont)
                                .color(Utils.isDark(AppColor.deliveryColor)
                                    ? Colors.white
                                    : AppColor.primaryColor)
                                .make(),
                            currencySymbol.text
                                .maxFontSize(10)
                                .minFontSize(6)
                                .fontFamily(AppFonts.appFont)
                                .color(Utils.isDark(AppColor.deliveryColor)
                                    ? Colors.white
                                    : AppColor.primaryColor)
                                .make(),
                          ],
                          crossAlignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                ])
              ],
            );
          } else {
            return "No Items found"
                .text
                .fontFamily(AppFonts.appFont)
                .color(AppColor.primaryColor)
                .letterSpacing(1.5)
                .lg
                .make();
          }
        });
  }
}

