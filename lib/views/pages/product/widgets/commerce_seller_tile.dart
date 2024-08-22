import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/product_details.vm.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_routes.dart';

class CommerceSellerTile extends StatelessWidget {
  const CommerceSellerTile({
    required this.model,
    super.key,
  });

  final ProductDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        "Seller:".text.make().expand(flex: 2),
        UiSpacer.smHorizontalSpace(),
        model.product.vendor.name.text.underline
            .color(AppColor.primaryColor)
            .make()
            .onInkTap(() {
          Navigator.of(context).pushNamed(
            AppRoutes.vendorDetails,
            arguments: model.product.vendor,
          );
        }).expand(flex: 4),
      ],
    ).py12().px20();
  }
}
