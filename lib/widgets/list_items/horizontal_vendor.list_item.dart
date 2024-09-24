import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/tags/fav.positioned_vendor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

import '../../view_models/vendor_distance.vm.dart';

class HorizontalVendorListItem extends StatelessWidget {
  const HorizontalVendorListItem({
    required this.vendor,
    required this.onPressed,
    required this.onFavoriteChange,
    super.key,
  });



  final Vendor vendor;
  final Function(Vendor) onPressed;
  final Function(bool isFavorite) onFavoriteChange;

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
                    height: 120,
                    width: context.screenWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 10,
              child: FavVendorPositionedView(vendor,
                  size: 40, onFavoriteChange: onFavoriteChange),
            ),
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
                vendor.name.text.lg.medium
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
                      "${value?.prepareTime}"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .sm
                          .medium
                          .color(AppColor.primary)
                          .maxLines(1)
                          .make(),
                      UiSpacer.horizontalSpace(space: 5),
                      " ${value?.distance.numCurrency} km"
                          .text
                          .fontFamily(AppFonts.appFont)
                          .sm
                          .medium
                          .color(AppColor.primary)
                          .maxLines(1)
                          .make(),
                    ]).pOnly(left: Vx.dp8);
                  },
                ),

                UiSpacer.verticalSpace(space: 5),
              ],
            ).expand(),
          ]).expand(),
          HStack([
            "${vendor.rating.numCurrency} "
                .text
                .fontFamily(AppFonts.appFont)
                .lg
                .color(AppColor.primary)
                .bold
                .make(),
            Image.asset(
              AppImages.goldenStar,
              height: 20,
            ),
          ]).pOnly(right: 4)
        ])
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
