import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/tags/delivery.tag.dart';
import 'package:mealknight/widgets/tags/time.tag.dart';
import 'package:mealknight/widgets/tags/pickup.tag.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../view_models/vendor_distance.vm.dart';

class VendorListItem extends StatelessWidget {
  const VendorListItem({
    required this.vendor,
    required this.onPressed,
    super.key,
  });

  final Vendor vendor;
  final Function(Vendor) onPressed;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Hero(
                tag: vendor.heroTag ?? vendor.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomImage(
                    imageUrl: vendor.featureImage,
                    height: 80,
                    width: context.screenWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 10,
              child: Image.asset(
                AppImages.like,
                height: 25,
              ),
            ),
            //location routing
            // (!vendor.latitude.isEmptyOrNull && !vendor.longitude.isEmptyOrNull)
            //     ? Positioned(
            //         child: RouteButton(
            //           vendor,
            //           size: 12,
            //         ),
            //         bottom: 5,
            //         right: 10,
            //       )
            //     : UiSpacer.emptySpace(),

            //
            Positioned(
              left: 10,
              bottom: 5,
              child: VStack(
                [
                  TimeTag(vendor.prepareTime,
                      iconData: FlutterIcons.clock_outline_mco),
                  UiSpacer.verticalSpace(space: 5),
                  TimeTag(
                    vendor.deliveryTime,
                    iconData: FlutterIcons.ios_bicycle_ion,
                  ),
                ],
              ),
            ),

            //closed
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: Visibility(
                visible: !vendor.isOpen,
                child: VxBox(
                  child: "Closed"
                      .tr()
                      .text
                      .fontFamily(AppFonts.appFont)
                      .sm
                      .white
                      .bold
                      .makeCentered(),
                )
                    .color(
                      AppColor.closeColor.withOpacity(0.6),
                    )
                    .make(),
              ),
            ),
          ],
        ),

        //name
        vendor.name.text
            .fontFamily(AppFonts.appFont)
            .sm
            .medium
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .fontWeight(FontWeight.w600)
            .color(AppColor.primary)
            .make()
            .px8()
            .pOnly(top: Vx.dp8),
        //
        //description
        vendor.description.text
            .fontFamily(AppFonts.appFont)
            .minFontSize(6)
            .size(10)
            .medium
            .color(AppColor.primary)
            .maxLines(1)
            .make()
            .px8(),
        HStack([
          VStack([
            //words
            Wrap(
              spacing: Vx.dp12,
              children: [
                //

                " ${vendor.prepareTime}"
                    .text
                    .fontFamily(AppFonts.appFont)
                    .minFontSize(6)
                    .size(10)
                    .medium
                    .color(AppColor.primary)
                    .maxLines(1)
                    .make()
                    .px8(),

                ValueListenableBuilder<Vendor?>(
                  valueListenable:
                      VendorDistanceViewModel().listenToKey(vendor.id),
                  builder: (BuildContext context, Vendor? value, child) {
                    return HStack(
                      [
                        Icon(
                          FlutterIcons.direction_ent,
                          color: AppColor.primaryColor,
                          size: 10,
                        ),
                        " ${value?.distance.numCurrency} km"
                            .text
                            .fontFamily(AppFonts.appFont)
                            .minFontSize(6)
                            .size(10)
                            .medium
                            .color(AppColor.primary)
                            .maxLines(1)
                            .make()
                            .px8(),
                      ],
                    );
                  },
                ),
              ],
            ).px8(),

//delivery fee && time
            Wrap(
              spacing: Vx.dp12,
              children: [
                //
                Visibility(
                  visible: vendor.minOrder != null,
                  child: CurrencyHStack(
                    [
                      AppStrings.currencySymbol.text
                          .fontFamily(AppFonts.appFont)
                          .minFontSize(6)
                          .size(10)
                          .medium
                          .color(AppColor.primary)
                          .maxLines(1)
                          .make(),
                      //
                      Visibility(
                        visible: vendor.minOrder != null,
                        child: "${vendor.minOrder}"
                            .text
                            .fontFamily(AppFonts.appFont)
                            .minFontSize(6)
                            .size(10)
                            .medium
                            .color(AppColor.primary)
                            .maxLines(1)
                            .make(),
                      ),
                      //
                      Visibility(
                        visible:
                            vendor.minOrder != null && vendor.maxOrder != null,
                        child: " - "
                            .text
                            .fontFamily(AppFonts.appFont)
                            .minFontSize(6)
                            .size(10)
                            .medium
                            .color(AppColor.primary)
                            .maxLines(1)
                            .make(),
                      ),
                      //
                      Visibility(
                        visible: vendor.maxOrder != null,
                        child: "${vendor.maxOrder} "
                            .text
                            .fontFamily(AppFonts.appFont)
                            .minFontSize(6)
                            .size(10)
                            .medium
                            .color(AppColor.primary)
                            .maxLines(1)
                            .make(),
                      ),
                    ],
                  ),
                ),
              ],
            ).px8(),
          ]).expand(),
          HStack([
            "${vendor.rating.numCurrency} "
                .text
                .fontFamily(AppFonts.appFont)
                .minFontSize(6)
                .size(16)
                .color(AppColor.primary)
                .bold
                .make(),
            Image.asset(
              AppImages.goldenStar,
              height: 18,
            ),
          ]).px8()
        ]),

        //
        HStack(
          [
            //can deliver
            vendor.delivery == 1
                ? const DeliveryTag().pOnly(right: 10)
                : UiSpacer.emptySpace(),

            //can pickup
            vendor.pickup == 1
                ? const PickupTag().pOnly(right: 10)
                : UiSpacer.emptySpace(),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ).p8()
      ],
    )
        .onInkTap(
          () => onPressed(vendor),
        )
        .box
        .outerShadow
        .border(width: 2, color: AppColor.primary)
        .color(context.theme.colorScheme.surface)
        .clip(Clip.antiAlias)
        .withRounded(value: 22)
        .make()
        .pOnly(bottom: Vx.dp8);
  }
}
