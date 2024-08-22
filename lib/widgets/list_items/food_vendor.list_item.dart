import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../view_models/vendor_distance.vm.dart';
import '../tags/fav.positioned_vendor.dart';

class FoodVendorListItem extends StatelessWidget {
  const FoodVendorListItem({
    required this.vendor,
    required this.onPressed,
    this.onFavoriteChange,
    super.key,
  });

  final Vendor vendor;
  final Function(Vendor) onPressed;
  final Function(bool isFavorite)? onFavoriteChange;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Stack(
          children: [
            Hero(
              tag: vendor.heroTag ?? vendor.id,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
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
              child: FavVendorPositionedView(vendor,
                  onFavoriteChange: onFavoriteChange!),
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
                      .lg
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

        HStack([
          HStack([
            VStack(
              [
                //name
                vendor.name.text.sm.medium
                    .fontFamily(AppFonts.appFont)
                    .maxLines(1)
                    .overflow(TextOverflow.ellipsis)
                    .fontWeight(FontWeight.w600)
                    .color(AppColor.primary)
                    .make()
                    .px8()
                    .pOnly(top: Vx.dp8),
                ValueListenableBuilder<Vendor?>(
                  valueListenable:
                      VendorDistanceViewModel().listenToKey(vendor.id),
                  builder: (BuildContext context, Vendor? value, child) {
                    return HStack([
                      "${(value?.prepareTime)}"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .minFontSize(6)
                          .size(10)
                          .medium
                          .color(AppColor.primary)
                          .maxLines(1)
                          .make(),
                      UiSpacer.horizontalSpace(space: 5),
                      " ${value?.distance.numCurrency} km"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .minFontSize(6)
                          .size(10)
                          .medium
                          .color(AppColor.primary)
                          .maxLines(1)
                          .make(),
                    ]).pOnly(left: Vx.dp8);
                  },
                ),

                UiSpacer.verticalSpace(space: 5),

                //
                //description
                // "${vendor.description}"
                //     .text
                //     .gray400
                //     .minFontSize(9)
                //     .size(9)
                //     .maxLines(1)
                //     .overflow(TextOverflow.ellipsis)
                //     .make()
                //     .px8(),
              ],
            ).expand(),
            // VStack(
            //   [
            //     UiSpacer.verticalSpace(space: 5),
            //     TimeTag(vendor.prepareTime,
            //         iconData: FlutterIcons.clock_outline_mco),
            //     UiSpacer.verticalSpace(space: 5),
            //     TimeTag(
            //       vendor.deliveryTime,
            //       iconData: FlutterIcons.ios_bicycle_ion,
            //     ),
            //   ],
            // ).pSymmetric(h: 2)
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
          ])
        ])

// //delivery fee && time
//         Wrap(
//           spacing: Vx.dp12,
//           children: [
//             //
//             Visibility(
//               visible: vendor.minOrder != null,
//               child: CurrencyHStack(
//                 [
//                   "${AppStrings.currencySymbol}"
//                       .text
//                       .minFontSize(6)
//                       .size(10)
//                       .gray600
//                       .medium
//                       .maxLines(1)
//                       .make(),
//                   //
//                   Visibility(
//                     visible: vendor.minOrder != null,
//                     child: "${vendor.minOrder}"
//                         .text
//                         .minFontSize(6)
//                         .size(10)
//                         .gray600
//                         .medium
//                         .maxLines(1)
//                         .make(),
//                   ),
//                   //
//                   Visibility(
//                     visible: vendor.minOrder != null && vendor.maxOrder != null,
//                     child: " - "
//                         .text
//                         .minFontSize(6)
//                         .size(10)
//                         .gray600
//                         .medium
//                         .maxLines(1)
//                         .make(),
//                   ),
//                   //
//                   Visibility(
//                     visible: vendor.maxOrder != null,
//                     child: "${vendor.maxOrder} "
//                         .text
//                         .minFontSize(6)
//                         .size(10)
//                         .gray600
//                         .medium
//                         .maxLines(1)
//                         .make(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ).px8(),

        //
        // HStack(
        //   [
        //     //can deliver
        //     vendor.delivery == 1
        //         ? DeliveryTag().pOnly(right: 10)
        //         : UiSpacer.emptySpace(),
        //
        //     //can pickup
        //     vendor.pickup == 1
        //         ? PickupTag().pOnly(right: 10)
        //         : UiSpacer.emptySpace(),
        //   ],
        //   crossAlignment: CrossAxisAlignment.end,
        // ).p8()
      ],
    )
        .onInkTap(
          () => onPressed(vendor),
        )
        .w(175)
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
