import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorHeader extends StatefulWidget {
  const VendorHeader({
    super.key,
    required this.model,
    this.showSearch = true,
    required this.onrefresh,
  });

  final MyBaseViewModel model;
  final bool showSearch;
  final Function onrefresh;

  @override
  State<VendorHeader> createState() => _VendorHeaderState();
}

class _VendorHeaderState extends State<VendorHeader> {
  @override
  void initState() {
    super.initState();
    if (widget.model.deliveryaddress == null) {
      widget.model.fetchCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        HStack(
          [
            const Icon(
              FlutterIcons.location_pin_sli,
              size: 24,
            ).onInkTap(
              widget.model.useUserLocation,
            ),
            VStack(
              [
                HStack(
                  [
                    "Delivery Location".tr().text.sm.semiBold.make(),
                    const Icon(
                      FlutterIcons.chevron_down_fea,
                    ).px4(),
                  ],
                ),
                "${widget.model.deliveryaddress?.address}"
                    .text
                    .maxLines(1)
                    .ellipsis
                    .base
                    .make(),
              ],
            )
                .onInkTap(() {
                  widget.model.pickDeliveryAddress(
                    vendorCheckRequired: false,
                    onselected: widget.onrefresh,
                  );
                })
                .px12()
                .expand(),
          ],
        ).expand(),

        //
        CustomVisibilty(
          visible: widget.showSearch,
          child: const Icon(
            FlutterIcons.search_fea,
            size: 20,
          )
              .p8()
              .onInkTap(() {
                widget.model.openSearch(type: "vendor");
              })
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .color(context.theme.colorScheme.background)
              .outerShadowSm
              .make(),
        ),
      ],
    )
        .p12()
        .box
        .color(context.theme.colorScheme.background)
        .bottomRounded()
        .outerShadowSm
        .make()
        .pOnly(bottom: Vx.dp20);
  }
}
