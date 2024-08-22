import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/order_details.vm.dart';
import 'package:mealknight/widgets/list_items/parcel_order_stop.list_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_font.dart';

class OrderAddressesView extends StatelessWidget {
  const OrderAddressesView(this.vm, {super.key});

  final OrderDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        vm.order.isPackageDelivery
            ? VStack(
                [
                  ParcelOrderStopListView(
                    "Pickup Location",
                    vm.order.orderStops!.first,
                    canCall: vm.order.canChatVendor,
                  ),

                  ...stopsList(),
                  //
                  ParcelOrderStopListView(
                    "Dropoff Location",
                    vm.order.orderStops!.last,
                    canCall: vm.order.canChatVendor,
                  ),
                ],
              )
            : UiSpacer.emptySpace(),

        //regular delivery address
        Visibility(
          visible: !vm.order.isPackageDelivery,
          child: VStack(
            [
              //"Pickup".text.xl.semiBold.make(),
              //vendor address
              HStack(
                [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: Icon(Icons.pin_drop, color: Colors.green.shade900),
                  ),
                  UiSpacer.horizontalSpace(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "${vm.order.vendor?.name}"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .lg
                          .semiBold
                          .make(),
                      "${vm.order.vendor?.address}"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .make()
                    ],
                  ).expand(),
                ],
                crossAlignment: CrossAxisAlignment.start,
              ).py12(),
            ],
          ),
        ),
        3.heightBox,
        Image.asset(
          'assets/images/down_arrow.png',
          height: 45,
          width: 45,
        ),
        3.heightBox,
        //regular delivery address
        Visibility(
          visible: vm.order.deliveryAddress != null,
          child: HStack(
            [
              SizedBox(
                width: 15,
                height: 15,
                child:
                    Icon(Icons.gps_fixed_rounded, color: Colors.grey.shade300),
              ),
              UiSpacer.horizontalSpace(),
              VStack(
                [
                  vm.order.deliveryAddress != null
                      ? "${vm.order.deliveryAddress!.name}"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .lg
                          .semiBold
                          .make()
                      : UiSpacer.emptySpace(),
                  vm.order.deliveryAddress != null
                      ? "${vm.order.deliveryAddress!.address}"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .make()
                      : UiSpacer.emptySpace(),
                ],
              ).expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ).py(12.0),
        ),
      ],
    );
  }

  //
  List<Widget> stopsList() {
    List<Widget> stopViews = [];
    if (vm.order.orderStops != null && vm.order.orderStops!.length > 2) {
      stopViews = vm.order.orderStops!
          .sublist(1, vm.order.orderStops!.length - 1)
          .mapIndexed((stop, index) {
        return VStack(
          [
            ParcelOrderStopListView(
              "${"Stop".tr()} ${index + 1}",
              stop,
              canCall: vm.order.canChatVendor,
            ),
          ],
        );
      }).toList();
    } else {
      stopViews.add(UiSpacer.emptySpace());
    }

    return stopViews;
  }
}
