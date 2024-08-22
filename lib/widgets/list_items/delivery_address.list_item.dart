import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';

class DeliveryAddressListItem extends StatelessWidget {
  const DeliveryAddressListItem({
    required this.deliveryAddress,
    this.onEditPressed,
    this.onUpdatePressed,
    this.action = true,
    this.border = true,
    this.borderColor,
    this.isDefault = false,
    this.showDefault = true,
    super.key,
  });

  final DeliveryAddress deliveryAddress;
  final Function? onEditPressed;
  final Function? onUpdatePressed;
  final bool action;
  final bool border;
  final bool isDefault;
  final bool showDefault;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            VStack(
              [
                Row(
                  children: [
                    Expanded(
                      child: Text('${deliveryAddress.name}',
                          style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 25)),
                    ),
                    Checkbox(
                        visualDensity: VisualDensity.compact,
                        activeColor: AppColor.primaryColor,
                        side: BorderSide(
                          color: AppColor.primaryColor,
                          width: 2,
                        ),
                        value: (deliveryAddress.defaultDeliveryAddress &&
                                showDefault)
                            ? true
                            : false,
                        onChanged: (value) {
                          onUpdatePressed!();
                        }),
                    "Default"
                        .tr()
                        .text
                        .color(AppColor.primary)
                        .size(12)
                        .semiBold
                        .make(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(
                              FlutterIcons.edit_ent,
                              size: 16,
                              color: Colors.red,
                            )),
                        "Edit"
                            .tr()
                            .text
                            .color(AppColor.primary)
                            .size(12)
                            .semiBold
                            .make(),
                      ],
                    ).onInkTap(
                      onEditPressed != null ? () => onEditPressed!() : () {},
                    ),
                  ],
                ).pOnly(bottom: 2),
                deliveryAddress.address != null &&
                        deliveryAddress.address!.isNotEmpty
                    ? Text('${deliveryAddress.address}',
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15))
                        .pOnly(bottom: 2)
                    : const SizedBox(),
                (deliveryAddress.addressType != null &&
                        deliveryAddress.addressType!.isNotEmpty &&
                        deliveryAddress.addressType != "Apartment")
                    ? Text('${deliveryAddress.addressType}',
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15))
                        .pOnly(bottom: 2)
                    : const SizedBox(),
                if (["House", "Home"]
                    .contains(deliveryAddress.addressType)) ...[
                  deliveryAddress.doorSide != null &&
                          deliveryAddress.doorSide!.isNotEmpty
                      ? Text('${deliveryAddress.doorSide}',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15))
                          .pOnly(bottom: 2)
                      : const SizedBox(),
                  deliveryAddress.leaveAt != null &&
                          deliveryAddress.leaveAt!.isNotEmpty
                      ? Text('${deliveryAddress.leaveAt}',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15))
                          .pOnly(bottom: 2)
                      : const SizedBox(),
                ] else if (deliveryAddress.addressType == "Apartment") ...[
                  deliveryAddress.apartmentNo != null &&
                          deliveryAddress.apartmentNo!.isNotEmpty
                      ? Text('Apartment No : ${deliveryAddress.apartmentNo}',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15))
                          .pOnly(bottom: 2)
                      : const SizedBox(),
                  deliveryAddress.buzzerNo != null &&
                          deliveryAddress.buzzerNo!.isNotEmpty
                      ? Text('Buzzer No : ${deliveryAddress.buzzerNo}',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15))
                          .pOnly(bottom: 2)
                      : const SizedBox(),
                ] else if (deliveryAddress.addressType == "Call When here") ...[
                  deliveryAddress.leaveAt != null &&
                          deliveryAddress.leaveAt!.isNotEmpty
                      ? Text('${deliveryAddress.leaveAt}',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15))
                          .pOnly(bottom: 2)
                      : const SizedBox(),
                ],
                deliveryAddress.description != null &&
                        deliveryAddress.description!.isNotEmpty
                    ? Text('${deliveryAddress.description}',
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15))
                        .pOnly(bottom: 2)
                    : const SizedBox(),
              ],
            ).p12().expand(),
          ],
        )
            .box
            .roundedSM
            .clip(Clip.antiAlias)
            .border(
              color: borderColor != null
                  ? borderColor!
                  : (border ? context.accentColor : Colors.transparent),
              width: border ? 1 : 0,
            )
            .color(Colors.white)
            .make(),

        //can deliver
        CustomVisibilty(
          visible: deliveryAddress.canDeliver != null &&
              !(deliveryAddress.canDeliver ?? true),
          child: "Vendor does not service this location"
              .tr()
              .text
              .red500
              .xs
              .thin
              .make()
              .px12()
              .py2(),
        ),
      ],
    );
  }
}
