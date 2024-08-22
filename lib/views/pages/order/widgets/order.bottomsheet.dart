import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/order_details.vm.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderBottomSheet extends StatelessWidget {
  const OrderBottomSheet(this.vm, {super.key});

  final OrderDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    print("Order Status 2 =====> ${ vm.order.status}");
    return vm.order.canCancel && !vm.isBusy
        ? SafeArea(
            child: VStack(
              [
                ///
                vm.order.canCancel ||
                        (
                            vm.order.status != 'delivered' ||
                            vm.order.status != 'Cancelled'
                        )
                    ? CustomButton(
                        title: "Cancel Order".tr(),
                        color: AppColor.closeColor,
                        icon: FlutterIcons.close_ant,
                        onPressed: vm.cancelOrder,
                        loading: vm.busy(vm.order),
                      ).p20()
                    : UiSpacer.emptySpace(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
          )
            .box
            .shadow
            .color(context.theme.colorScheme.background)
            .make()
            .wFull(context)
        : UiSpacer.emptySpace();
  }
}
