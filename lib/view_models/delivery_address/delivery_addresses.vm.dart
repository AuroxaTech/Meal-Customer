import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/requests/delivery_address.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/local_storage.service.dart';
import '../vendor_distance.vm.dart';

class DeliveryAddressesViewModel extends MyBaseViewModel {
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  List<DeliveryAddress> deliveryAddresses = [];

  DeliveryAddress? deliveryAddressUpdate = DeliveryAddress();
  bool isDefault = false;
  DeliveryAddress? defaultDeliveryAddress;
  bool? result;

  DeliveryAddressesViewModel(BuildContext context) {
    viewContext = context;
  }

  void initialise() {
    fetchDeliveryAddresses();
  }

  fetchDeliveryAddresses() async {
    setBusyForObject(deliveryAddresses, true);
    try {
      deliveryAddresses = await deliveryAddressRequest.getDeliveryAddresses();
      deliveryAddresses.forEach((element) async {
        if (element.isDefault == 1) {
          final storagePref = await LocalStorageService.getPrefs();
          await storagePref.setString("current_address", element.address ?? '');
        }
      });
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(deliveryAddresses, false);
  }

  //
  newDeliveryAddressPressed() async {
    await Navigator.of(viewContext)
        .pushNamed(AppRoutes.newDeliveryAddressesRoute, arguments: false);
    fetchDeliveryAddresses();
  }

  //
  editDeliveryAddress(DeliveryAddress deliveryAddress, bool flag) async {
    Map<String, dynamic> getData = {
      'deliveryAddress': deliveryAddress,
      // Assuming DeliveryAddress is instantiated properly
      'flag': flag,
    };

    Navigator.of(viewContext)
        .pushNamed(
      AppRoutes.editDeliveryAddressesRoute,
      arguments: getData,
    )
        .then((value) {
      print(" The result is $value");
      fetchDeliveryAddresses();
    });
    //fetchDeliveryAddresses();
  }

  updateDeliveryAddress(int index) async {
    deliveryAddressUpdate = deliveryAddresses[index];
    deliveryAddressUpdate!.isDefault =
        deliveryAddresses[index].isDefault == 0 ? 1 : 0;
    setBusy(true);
    final apiRespose = await deliveryAddressRequest.updateDeliveryAddress(
      deliveryAddressUpdate!,
    );
    CoolAlert.show(
      context: viewContext,
      type: apiRespose.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Update Delivery Address".tr(),
      text: apiRespose.message,
      onConfirmBtnTap: () async {
        if (apiRespose.message!.lowerCamelCase.contains("successfully")) {
         VendorDistanceViewModel().updateDeliveryAddress(deliveryAddressUpdate!.address ?? '');

          for (var element in deliveryAddresses) {
            if (element.id != deliveryAddressUpdate!.id) {
              element.isDefault = 0;
            }
          }
          notifyListeners();
        } else {
          deliveryAddresses[index].isDefault == 0
              ? deliveryAddresses[index].isDefault = 1
              : deliveryAddresses[index].isDefault = 0;
        }
        Navigator.of(viewContext).pop(true);
      },
    );
    setBusy(false);
    notifyListeners();
  }

  // void toggleDefault(bool? value) {
  //   isDefault = value ?? false;
  //   defaultDeliveryAddress!.isDefault = isDefault ? 1 : 0;
  //   notifyListeners();
  // }

  //
  deleteDeliveryAddress(DeliveryAddress deliveryAddress) {
    //
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.confirm,
        title: "Delete Delivery Address".tr(),
        text: "Are you sure you want to delete this delivery address?".tr(),
        confirmBtnText: "Delete".tr(),
        onConfirmBtnTap: () {
          Navigator.of(viewContext).pop();
          processDeliveryAddressDeletion(deliveryAddress);
        });
  }

  //
  processDeliveryAddressDeletion(DeliveryAddress deliveryAddress) async {
    setBusy(true);
    //
    final apiResponse = await deliveryAddressRequest.deleteDeliveryAddress(
      deliveryAddress,
    );

    //remove from list
    if (apiResponse.allGood) {
      deliveryAddresses.remove(deliveryAddress);
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Delete Delivery Address".tr(),
      text: apiResponse.message,
    );
  }
}
