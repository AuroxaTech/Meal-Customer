import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/order_details.vm.dart';
import 'package:mealknight/views/pages/order/widgets/order.bottomsheet.dart';
import 'package:mealknight/views/pages/order/widgets/order_address.view.dart';
import 'package:mealknight/views/pages/order/widgets/order_attachment.view.dart';
import 'package:mealknight/views/pages/order/widgets/order_details_driver_info.view.dart';
import 'package:mealknight/views/pages/order/widgets/order_details_items.view.dart';
import 'package:mealknight/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:mealknight/views/pages/order/widgets/order_status.view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/cards/order_details_summary.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:glass_kit/glass_kit.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_ui_settings.dart';
import '../../../models/vendor.dart';
import '../../../utils/utils.dart';
import '../../../view_models/vendor_distance.vm.dart';
import '../../../widgets/buttons/custom_button.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    required this.order,
    this.isOrderTracking = false,
    super.key,
  });

  final Order order;
  final bool isOrderTracking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder<OrderDetailsViewModel>.reactive(
        viewModelBuilder: () => OrderDetailsViewModel(context, order),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            title: "Order Details".tr(),
            showAppBar: true,
            elevation: 0,
            appBarColor: context.theme.colorScheme.surface,
            appBarItemColor: AppColor.primaryColor,
            backgroundColor: const Color(0xffeefffd),
            showLeadingAction: true,
            isLoading: vm.isBusy,
            onBackPressed: () {
              Navigator.of(context).pop(vm.order);
            },
            //share button for parcel delivery order
            actions: vm.order.isPackageDelivery
                ? [
                    const Icon(
                      FlutterIcons.share_2_fea,
                      color: Colors.white,
                    ).p8().onInkTap(vm.shareOrderDetails).p8(),
                  ]
                : [],
            body: vm.isBusy
                ? const BusyIndicator().centered()
                : StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      bool getView = vm.viewMap;
                      return SmartRefresher(
                        controller: vm.refreshController,
                        onRefresh: vm.fetchOrderDetails,
                        child: Stack(
                          children: [
                            //vendor details
                            Positioned(
                              child: Stack(
                                children: [
                                  //vendor feature image
                                  CustomImage(
                                    imageUrl: vm.order.vendor!.featureImage,
                                    width: double.infinity,
                                    height: 200,
                                    boxFit: BoxFit.contain,
                                  ),
                                  //vendor details
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: GlassContainer(
                                      height: 200,
                                      width: context.screenWidth,
                                      color: Colors.black54,
                                      borderGradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.60),
                                          Colors.white.withOpacity(0.10),
                                          AppColor.primaryColor
                                              .withOpacity(0.05),
                                          AppColor.primaryColor.withOpacity(0.6)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0.0, 0.39, 0.40, 1.0],
                                      ),
                                      blur: 2.0,
                                      borderWidth: 0,
                                      elevation: 0,
                                      isFrostedGlass: true,
                                      shadowColor:
                                          Colors.black.withOpacity(0.20),
                                      alignment: Alignment.center,
                                      frostedOpacity: 0.30,
                                      padding: const EdgeInsets.all(8.0),
                                      child: VStack(
                                        [
                                          vm.order.vendor!.name.text.center
                                              .white.xl3.semiBold
                                              .makeCentered(),
                                          UiSpacer.verticalSpace(space: 40)
                                        ],
                                        alignment: MainAxisAlignment.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //
                            VStack(
                              [
                                UiSpacer.verticalSpace(space: 160),
                                VStack(
                                  [
                                    //free space
                                    //header view
                                    HStack(
                                      [
                                        //vendor logo
                                        CustomImage(
                                          imageUrl: vm.order.vendor!.logo,
                                          width: 50,
                                          height: 50,
                                        )
                                            .box
                                            .roundedSM
                                            .clip(Clip.antiAlias)
                                            .make(),
                                        UiSpacer.horizontalSpace(),
                                        //
                                        VStack(
                                          [
                                            //
                                            vm.order.status
                                                //.tr()
                                                .capitalized
                                                .text
                                                .semiBold
                                                .xl
                                                .color(AppColor.getStausColor(
                                                    vm.order.status))
                                                .make(),
                                            Jiffy.parseFromDateTime(
                                                    vm.order.updatedAt)
                                                .format(pattern: 'MMM dd, yyyy')
                                                .text
                                                .color(AppColor.primaryColor)
                                                .light
                                                .lg
                                                .make(),
                                            "#${vm.order.code}"
                                                .text
                                                .xs
                                                .gray400
                                                .light
                                                .make(),
                                          ],
                                        ).expand(),
                                        //qr code icon
                                        vm.order.deliveryAddress?.leaveAt !=
                                                'Leave at door'
                                            ? Visibility(
                                                visible: !vm.order.isTaxi &&
                                                    !vm.order.isSerice,
                                                child: const Icon(
                                                  FlutterIcons.qrcode_ant,
                                                  size: 28,
                                                ).onInkTap(
                                                    vm.showVerificationQRCode),
                                              )
                                            : const SizedBox(),

                                        //call
                                        if (AppUISettings.canCallVendor)
                                          CustomButton(
                                            icon: FlutterIcons.phone_call_fea,
                                            iconColor: Colors.white,
                                            color: AppColor.primaryColor,
                                            shapeRadius: Vx.dp20,
                                            onPressed: vm.callVendor,
                                            height: 40.0,
                                          ).p12(),
                                      ],
                                    ).p20().wFull(context),
                                    //
                                    UiSpacer.cutDivider(),
                                    //Payment status
                                    OrderPaymentInfoView(vm),
                                    //status
                                    Visibility(
                                      // visible: vm.order.showStatusTracking,
                                      child: VStack(
                                        [
                                          OrderStatusView(vm).p20(),
                                          UiSpacer.divider(),
                                        ],
                                      ),
                                    ),

                                    ValueListenableBuilder<Vendor?>(
                                      valueListenable:
                                      VendorDistanceViewModel().listenToKey(vm.vendorDetailsViewModel?.vendor?.id ?? -1),
                                      builder: (BuildContext context, Vendor? value, child) {
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            "${value?.prepareTime}"
                                                .text
                                                .lg
                                                .fontFamily(AppFonts.appFont)
                                                .semiBold
                                                .color(Utils.isDark(
                                                AppColor.deliveryColor)
                                                ? Colors.white
                                                : AppColor.primaryColor)
                                                .size(18)
                                                .make()
                                                .py8()
                                                .px8(),
                                            20.widthBox,
                                            "${value?.distance.numCurrency} km"
                                                .text
                                                .lg
                                                .fontFamily(AppFonts.appFont)
                                                .semiBold
                                                .size(18)
                                                .color(Utils.isDark(
                                                AppColor.deliveryColor)
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
                                            .border(
                                            width: 2,
                                            color: AppColor.primaryColor)
                                            .make()
                                            .centered()
                                            .py8()
                                            .px20();
                                      },
                                    ),


                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: getView
                                          ? GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                  vm
                                                          .vendorDetailsViewModel!
                                                          .currentLocation
                                                          ?.latitude ??
                                                      vm
                                                          .vendorDetailsViewModel!
                                                          .currentLocation1
                                                          ?.latitude ??
                                                      0.0,
                                                  vm
                                                          .vendorDetailsViewModel!
                                                          .currentLocation
                                                          ?.longitude ??
                                                      vm
                                                          .vendorDetailsViewModel!
                                                          .currentLocation1
                                                          ?.longitude ??
                                                      0.0,
                                                ),
                                                zoom: 150,
                                              ),
                                              myLocationButtonEnabled: true,
                                              trafficEnabled: true,
                                              onMapCreated: vm
                                                  .vendorDetailsViewModel!
                                                  .onMapReady,
                                              // onCameraIdle: vm.taxiGoogleMapManagerService.onMapCameraIdle,
                                              padding: vm
                                                  .vendorDetailsViewModel!
                                                  .googleMapPadding,
                                              markers: vm
                                                  .vendorDetailsViewModel!
                                                  .gMapMarkers,
                                              polylines: vm
                                                  .vendorDetailsViewModel!
                                                  .gMapPolylines,
                                              zoomControlsEnabled: true,
                                              myLocationEnabled: true,
                                              zoomGesturesEnabled: true,
                                            )
                                          : Image.asset(AppImages.map, width: double.infinity, height: 300, fit: BoxFit.cover,),
                                    )
                                        .h(220)
                                        .w(context.percentWidth * 95)
                                        .box
                                        .clip(Clip.antiAlias)
                                        .withRounded(value: 15.0)
                                        .make()
                                        .px8(),
                                    // either products/package details
                                    OrderDetailsItemsView(vm).p20(),
                                    //show package delivery addresses
                                    Visibility(
                                      visible: vm.order.deliveryAddress != null,
                                      child: VStack([
                                        UiSpacer.divider(),
                                        OrderAddressesView(vm).p20()
                                      ]),
                                    ),
                                    //
                                    OrderAttachmentView(vm),
                                    //
                                    CustomVisibilty(
                                      visible: (!vm.order.isPackageDelivery &&
                                          vm.order.deliveryAddress == null),
                                      child: "Customer Order Pickup"
                                          .tr()
                                          .text
                                          .italic
                                          .light
                                          .xl
                                          .medium
                                          .make()
                                          .px20()
                                          .py20(),
                                    ),

                                    //note
                                    if (vm.order.note.isNotEmpty) ...[
                                      "Note"
                                          .tr()
                                          .text
                                          .semiBold
                                          .xl
                                          .make()
                                          .px20(),
                                      vm.order.note.text.light.sm.make().px20(),
                                    ],
                                    UiSpacer.divider(),
                                    //vendor
                                    //UiSpacer.vSpace(),
                                    //OrderDetailsVendorInfoView(vm),

                                    //driver
                                    OrderDetailsDriverInfoView(vm),

                                    UiSpacer.divider(),
                                    //order summary
                                    OrderDetailsSummary(vm.order)
                                        .wFull(context)
                                        .p20()
                                        .pOnly(
                                            bottom: context.percentHeight * 10)
                                        .box
                                        .make()
                                  ],
                                )
                                    .box
                                    .topRounded(value: 15)
                                    .clip(Clip.antiAlias)
                                    .color(context.theme.colorScheme.surface)
                                    .make(),
                                //
                                UiSpacer.vSpace(50),
                              ],
                            ).scrollVertical(),
                          ],
                        ),
                      );
                    },
                  ),

            bottomSheet: vm.order.status == "Cancelled" ? null : OrderBottomSheet(vm),
          );
        },
      ),
    );
  }
}
