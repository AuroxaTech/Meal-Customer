import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class TaxiDiscountSection extends StatelessWidget {
  const TaxiDiscountSection(
    this.vm, {
    this.fullView = false,
    Key? key,
  }) : super(key: key);

  final dynamic vm;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        HStack(
          [
            "Add Coupon".tr().text.fontFamily(AppFonts.appFont).make().expand(),
            UiSpacer.hSpace(5),
            !fullView
                ? Icon(
                    FlutterIcons.plus_ant,
                    color: AppColor.primaryColor,
                    size: 20,
                  )
                : UiSpacer.emptySpace(),
          ],
          crossAlignment: CrossAxisAlignment.center,
          alignment: MainAxisAlignment.center,
        ).p(!fullView ? 10 : 0),
        Visibility(
          visible: fullView,
          child: UiSpacer.verticalSpace(space: 10),
        ),
        //
        Visibility(
          visible: fullView,
          child: HStack(
            [
              //
              CustomTextFormField(
                hintText: "Coupon Code".tr(),
                textEditingController: vm.couponTEC,
                errorText: vm.hasErrorForKey("coupon")
                    ? vm.error("coupon").toString()
                    : null,
                onChanged: vm.couponCodeChange,
              ).expand(flex: 2),
              //
              UiSpacer.horizontalSpace(),
              Column(
                children: [
                  CustomButton(
                    title: "Apply".tr(),
                    isFixedHeight: true,
                    loading: vm.busy("coupon"),
                    onPressed: vm.canApplyCoupon ? vm.applyCoupon : null,
                  ).h(Vx.dp56),
                  //
                  vm.hasErrorForKey("coupon")
                      ? UiSpacer.verticalSpace(space: 12)
                      : UiSpacer.verticalSpace(space: 1),
                ],
              ).expand(),
            ],
          ),
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
      alignment: MainAxisAlignment.center,
    );
  }
}
