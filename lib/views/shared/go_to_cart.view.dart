import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/services/cart.service.dart';
import 'package:mealknight/views/pages/cart/cart.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_routes.dart';

class GoToCartView extends StatelessWidget {
  const GoToCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: CartServices.productsInCart.length,
        stream: CartServices.cartItemsCountStream.stream,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.hasData && snapshot.data! > 0,
            child: HStack(
              [
                //
                "You have %s in your cart"
                    .tr()
                    .fill([snapshot.data])
                    .text
                    .white
                    .make()
                    .expand(),
                //
                CustomButton(
                  title: "View Cart".tr(),
                  height: 30,
                  color: AppColor.accentColor,
                  elevation: 1,
                  onPressed: () {

                    Navigator.pushNamed(context, AppRoutes.cartRoute);
                  },
                ),
                //
              ],
            )
                .p20()
                .safeArea(top: false)
                .box
                .color(AppColor.primaryColor)
                .topRounded()
                .make(),
          );
        });
  }
}
