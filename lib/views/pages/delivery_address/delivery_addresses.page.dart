import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/delivery_address/delivery_addresses.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/list_items/delivery_address.list_item.dart';
import 'package:mealknight/widgets/states/delivery_address.empty.dart';
import 'package:mealknight/widgets/states/error.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryAddressesPage extends StatelessWidget {
  const DeliveryAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => DeliveryAddressesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Delivery Addresses".tr(),
          elevation: 0,
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: const Color(0xffeefffd),
          isLoading: vm.isBusy,
          body: Column(
            children: [
              Expanded(
                child: CustomListView(
                  padding: EdgeInsets.fromLTRB(
                      20, 20, 20, context.percentHeight * 20),
                  dataSet: vm.deliveryAddresses,
                  isLoading: vm.busy(vm.deliveryAddresses),
                  emptyWidget: const EmptyDeliveryAddress(),
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchDeliveryAddresses,
                  ),
                  itemBuilder: (context, index) {
                    //
                    final deliveryAddress = vm.deliveryAddresses[index];
                    bool flag = vm.deliveryAddresses.length > 1 ? true : false;
                    return DeliveryAddressListItem(
                      deliveryAddress: deliveryAddress,
                      onEditPressed: () =>
                          vm.editDeliveryAddress(deliveryAddress, flag),
                      onUpdatePressed: () {
                        if (vm.deliveryAddresses.length > 1 ||
                            (vm.deliveryAddresses.length == 1 &&
                                vm.deliveryAddresses.first.isDefault == 0)) {
                          vm.updateDeliveryAddress(index);
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 10),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2, color: AppColor.primaryColor)),
                child: Text('Add New Address',
                    style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 25)),
              ).onInkTap(() {
                vm.newDeliveryAddressPressed();
              }),
            ],
          ),
        );
      },
    );
  }
}
