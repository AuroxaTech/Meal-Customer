import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/order_details.vm.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderStopsView extends StatelessWidget {
  const OrderStopsView(this.vm, {super.key});

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: vm.order.orderStops != null && vm.order.orderStops!.isNotEmpty,
      child: VStack(
        [
          "Order Stops".tr().text.xl.semiBold.make(),
          UiSpacer.vSpace(10),
          Timeline.tileBuilder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            builder: TimelineTileBuilder.connected(
              itemCount: vm.order.orderStops?.length ?? 0,
              contentsAlign: ContentsAlign.basic,
              nodePositionBuilder: (context, index) => 0.00,
              indicatorPositionBuilder: (context, index) => 0.10,
              indicatorBuilder: (context, index) {
                return DotIndicator(
                  color: AppColor.primaryColor,
                  size: 24,
                  child: const Icon(
                    FlutterIcons.location_pin_ent,
                    size: 12,
                    color: Colors.white,
                  ),
                );
              },
              connectorBuilder: (context, index, connectorType) {
                return SolidLineConnector(color: AppColor.primaryColor);
              },
              contentsBuilder: (context, index) {
                final orderStop = vm.order.orderStops![index];
                return VStack(
                  [
                    //if created at is not null
                    Text(
                      "${orderStop.deliveryAddress?.name}",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${orderStop.deliveryAddress?.address}",
                      style: context.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    //conact info
                    Text(
                      "${orderStop.name} (${orderStop.phone})",
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Visibility(
                      visible:
                          orderStop.note != null && orderStop.note!.isNotEmpty,
                      child: Text(
                        "${orderStop.note}",
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    //attachments
                    Visibility(
                      visible: orderStop.attachments != null &&
                          orderStop.attachments!.isNotEmpty,
                      child: CustomListView(
                        scrollDirection: Axis.horizontal,
                        dataSet: vm.order.attachments ?? [],
                        itemBuilder: (ctx, index) {
                          final attachment = orderStop.attachments![index];
                          return Column(
                            children: [
                              UiSpacer.vSpace(10),
                              CustomImage(
                                imageUrl: attachment.link!,
                                canZoom: true,
                                width: 70,
                                height: 70,
                              ),
                              //
                              "${attachment.collectionName}".text.make().py2(),
                            ],
                          );
                        },
                      ).h(110),
                    ),
                  ],
                ).p(Vx.dp20);
              },
            ),
          ),
          // UiSpacer.vSpace(10),
          UiSpacer.divider().py8(),
        ],
      ),
    );
  }
}
