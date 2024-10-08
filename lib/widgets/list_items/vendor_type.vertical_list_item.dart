import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/constants/app_ui_styles.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorTypeVerticalListItem extends StatelessWidget {
  const VendorTypeVerticalListItem(
    this.vendorType, {
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    //
    final textColor = Utils.textColorByColor(Vx.hexToColor(vendorType.color));
    //
    return AnimationConfiguration.staggeredList(
      position: vendorType.id,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: InkWell(
            onTap: () => onPressed(),
            child: VStack(
              [
                //image + details
                Visibility(
                  visible: !AppStrings.showVendorTypeImageOnly,
                  child: VStack(
                    [
                      //
                      CustomImage(
                        imageUrl: vendorType.logo,
                        boxFit: AppUIStyles.vendorTypeImageStyle,
                        height: AppUIStyles.vendorTypeHeight,
                        width: AppUIStyles.vendorTypeWidth,
                      ).p12().centered(),
                      //
                      VStack(
                        [
                          vendorType.name.text.lg
                              .color(textColor)
                              .semiBold
                              .center
                              .makeCentered(),
                          Visibility(
                            visible: vendorType.description.isNotEmpty,
                            child: "${vendorType.description}"
                                .text
                                .color(textColor)
                                .center
                                .sm
                                .makeCentered()
                                .pOnly(top: 5),
                          ),
                        ],
                      ).py4(),
                    ],
                  ).p12().centered(),
                ),

                //image only
                Visibility(
                  visible: AppStrings.showVendorTypeImageOnly,
                  child: CustomImage(
                    imageUrl: vendorType.logo,
                    boxFit: AppUIStyles.vendorTypeImageStyle,
                    height: AppUIStyles.vendorTypeHeight,
                    width: AppUIStyles.vendorTypeWidth,
                  ),
                ),
              ],
            ),
          )
              .box
              .clip(Clip.antiAlias)
              .withRounded(value: 15)
              .outerShadow
              .color(Vx.hexToColor(vendorType.color))
              .make(),
        ),
      ),
    );
  }
}
