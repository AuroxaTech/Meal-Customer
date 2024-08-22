import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/cart.vm.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:mealknight/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class ApplyCoupon extends StatelessWidget {
  const ApplyCoupon(this.vm, {Key? key}) : super(key: key);

  final CartViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Add Coupon".tr().text.semiBold.xl.fontFamily(AppFonts.appFont).make(),
        UiSpacer.verticalSpace(space: 10),
        //
        vm.isAuthenticated()
            ? CustomTextFormField(
                hintText: "Coupon Code".tr(),
                textEditingController: vm.couponTEC,
                errorText: vm.hasErrorForKey("coupon")
                    ? vm.error("coupon").toString()
                    : "",
                onChanged: vm.couponCodeChange,
                suffixIcon: CustomButton(
                  child: Icon(
                    FlutterIcons.check_ant,
                  ),
                  isFixedHeight: true,
                  loading: vm.busy(vm.coupon) || vm.busy("coupon"),
                  onPressed: vm.canApplyCoupon ? vm.applyCoupon : null,
                ).w(62).p8(),
              )
            : VStack(
                [
                  //
                  EmptyState(
                    auth: true,
                    showImage: false,
                    actionPressed: vm.openLogin,
                  ),
                ],
              ),
      ],
    );
  }
}
