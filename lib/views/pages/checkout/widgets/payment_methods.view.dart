import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/view_models/checkout_base.vm.dart';
import 'package:mealknight/widgets/custom_grid_view.dart';
import 'package:mealknight/widgets/list_items/payment_method.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView(this.vm, {super.key});

  final CheckoutBaseViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "Payment Methods".tr().text.color(AppColor.primary).semiBold.xl.make(),
        CustomGridView(
          noScrollPhysics: true,
          dataSet: vm.paymentMethods,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          isLoading: vm.busy(vm.paymentMethods),
          itemBuilder: (context, index) {
            //
            final paymentMethod = vm.paymentMethods[index];
            return PaymentOptionListItem(
              paymentMethod,
              selected: vm.isSelected(paymentMethod),
              onSelected: vm.onChangePaymentMethod,
            );
          },
        ).pOnly(top: Vx.dp16, bottom: Vx.dp16),
        //
      ],
    );
  }
}
