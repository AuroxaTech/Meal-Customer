import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/order_details.vm.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderStatusView extends StatelessWidget {
  const OrderStatusView(this.vm, {super.key});

  final OrderDetailsViewModel vm;


  @override
  Widget build(BuildContext context) {
    print("order status =======> ${vm.order.status}");
    return VStack(
      [
        HStack(
          [
            //status
            VStack(
              [
                "Status".tr().text.gray500.medium.sm.make(),
                vm.order.status
                    //.tr()
                    .capitalized
                    .text
                    .color(AppColor.getStausColor(vm.order.paymentStatus))
                    .bold
                    .xl2
                    .make()
              ],
            ).expand(),

            //payment status
            /*VStack(
              [
                "Payment Status".tr().text.gray500.medium.sm.make(),
                //
                vm.order.paymentStatus
                    .tr()
                    .capitalized
                    .text
                    .color(AppColor.getStausColor(vm.order.paymentStatus))
                    .medium
                    .xl
                    .make(),
              ],
            ),*/
          ],
        ).pOnly(bottom: Vx.dp20),

        //
        //show payer if order is parcel order
        CustomVisibilty(
          visible: vm.order.isPackageDelivery,
          child: VStack(
            [
              "Order Payer".tr().text.medium.make(),
              (vm.order.payer == "1" ? "Sender" : "Receiver")
                  .tr()
                  .text
                  .xl
                  .semiBold
                  .make(),
              UiSpacer.verticalSpace(),
            ],
          ),
        ),

        //scheduled order info
        vm.order.isScheduled
            ? HStack(
                [
                  //date
                  VStack(
                    [
                      //
                      "Scheduled Date".tr().text.gray500.medium.sm.make(),
                      // "${vm.order.pickupDate}"
                      Jiffy.parse(vm.order.pickupDate ?? "")
                          .format(pattern: "dd MMM yyyy")
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ).expand(),
                  //time
                  VStack(
                    [
                      //
                      "Scheduled Time".tr().text.gray500.medium.sm.make(),
                      Jiffy.parse(vm.order.pickupTime ?? "")
                          .format(pattern: "hh:mm a")
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ).expand(),
                ],
              )
            : UiSpacer.emptySpace(),

        //status changes
        /*"Order Status tracking".tr().text.make(),

        Timeline.tileBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          builder: TimelineTileBuilder.connected(
            contentsAlign: ContentsAlign.basic,
            nodePositionBuilder: (context, index) => 0.00,
            indicatorPositionBuilder: (context, index) => 0.35,
            indicatorBuilder: (context, index) {
              //
              final orderStatus = vm.order.totalStatuses[index];
              //
              return (orderStatus.passed ?? true)
                  ? DotIndicator(
                      color: AppColor.primaryColor,
                      size: 24,
                      child: Icon(
                        FlutterIcons.check_ant,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : OutlinedDotIndicator(
                      color: AppColor.primaryColor,
                      size: 24,
                    );
            },
            connectorBuilder: (context, index, connectorType) =>
                SolidLineConnector(
              color: AppColor.primaryColor,
            ),
            contentsBuilder: (context, index) => VStack(
              [
                Text(
                  ('${vm.order.totalStatuses[index].name}'.tr().capitalized),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontSize: Vx.dp16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                //if created at is not null
                Text(
                  vm.order.totalStatuses[index].createdAt != null
                      ? Jiffy.parseFromDateTime(
                              vm.order.totalStatuses[index].createdAt ??
                                  DateTime.now())
                          .format(pattern: "dd MMM, yyy 'at' hh:mm a")
                      : '',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontSize: Vx.dp16,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                //track order
                ((vm.order.totalStatuses[index].createdAt != null &&
                            "${vm.order.totalStatuses[index].name}" ==
                                "enroute" &&
                            vm.order.status == "enroute") &&
                        AppStrings.enableOrderTracking &&
                        (vm.order.dropoffLocation != null ||
                            vm.order.deliveryAddress != null)
                        //driver must be assigned
                        &&
                        vm.order.driverId != null)
                    ? CustomButton(
                        title: "Track Order".tr(),
                        icon: FlutterIcons.map_ent,
                        onPressed: vm.trackOrder,
                        loading: vm.busy(vm.order),
                      ).p20()
                    : UiSpacer.emptySpace(),
              ],
            ).p(Vx.dp20),
            itemCount: vm.order.totalStatuses.length,
          ),
        ),*/
      ],
    );
  }
}
