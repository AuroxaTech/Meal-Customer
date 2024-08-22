import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../models/address.dart';
import '../../models/delivery_address.dart';
import '../../requests/delivery_address.request.dart';
import 'base_delivery_addresses.vm.dart';

class EditDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController apartmentNo = TextEditingController();
  TextEditingController buzzerNo = TextEditingController();
  bool isDefault = false;
  dynamic getData;
  DeliveryAddress? deliveryAddress;
  bool isTrue = true;
  bool isSelectedDoor = true;
  String selectedHomeItem = 'House';
  String selectedDoorItem = "Front Door";
  String selectedDeliveryItem = "Hand it to me directly";
  List<String> deliveryItems = [
    'Hand it to me directly',
    'Leave at door',
    'Meet outside'
  ];
  List<String> homeItems = ['House', 'Apartment', 'Call When here'];
  List<String> doorItems = [
    'Front Door',
    'Left Door',
    'Right Door',
    'Back Door',
  ];

  //
  EditDeliveryAddressesViewModel(BuildContext context, this.getData) {
    this.viewContext = context;
  }

  //
  void initialise() {
    // Accessing the first element (DeliveryAddress)
    deliveryAddress = getData['deliveryAddress'] as DeliveryAddress?;

    deliveryAddress = getData['deliveryAddress'];
    isTrue = (getData['flag'] as bool?) ?? true;

    if (!isTrue && deliveryAddress!.isDefault == 0) {
      isTrue = true;
    }

    nameTEC.text = deliveryAddress!.name!;
    addressTEC.text = deliveryAddress!.address!;
    descriptionTEC.text = deliveryAddress!.description!;
    isDefault = deliveryAddress!.isDefault == 1;

    apartmentNo.text = deliveryAddress!.apartmentNo ?? '';
    buzzerNo.text = deliveryAddress!.buzzerNo ?? '';
    if (deliveryAddress!.addressType == "Home") {
      selectedHomeItem = 'House';
    } else {
      selectedHomeItem = deliveryAddress?.addressType ?? 'House';
    }
    selectedDoorItem = deliveryAddress!.doorSide ?? "Front Door";
    if (deliveryAddress!.leaveAt == null) {
      selectedDeliveryItem = "Hand it to me directly";
    } else {
      selectedDeliveryItem =
          deliveryAddress!.leaveAt ?? "Hand it to me directly";
    }
    if (selectedHomeItem.contains('Call When here')) {
      isSelectedDoor = false;
      selectedDeliveryItem = 'Meet outside';
    }
    notifyListeners();
  }

  //
  showAddressLocationPicker() async {
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      addressTEC.text = locationResult.formattedAddress ?? "";
      deliveryAddress?.address = locationResult.formattedAddress;
      deliveryAddress?.latitude = locationResult.geometry?.location.lat;
      deliveryAddress?.longitude = locationResult.geometry?.location.lng;

      //
      if (locationResult.addressComponents != null &&
          locationResult.addressComponents!.isNotEmpty) {
        //fetch city, state and country from address components
        locationResult.addressComponents?.forEach((addressComponent) {
          if (addressComponent.types.contains("locality")) {
            deliveryAddress!.city = addressComponent.longName;
          }
          if (addressComponent.types.contains("administrative_area_level_1")) {
            deliveryAddress!.state = addressComponent.longName;
          }
          if (addressComponent.types.contains("country")) {
            deliveryAddress!.country = addressComponent.longName;
          }
        });
      } else {
        // From coordinates
        setBusy(true);
        deliveryAddress = await getLocationCityName(deliveryAddress!);
        setBusy(false);
      }
      notifyListeners();
    } else if (result is Address) {
      Address locationResult = result;
      addressTEC.text = locationResult.addressLine ?? "";
      deliveryAddress?.address = locationResult.addressLine;
      deliveryAddress?.latitude = locationResult.coordinates?.latitude;
      deliveryAddress?.longitude = locationResult.coordinates?.longitude;
      deliveryAddress?.city = locationResult.locality;
      deliveryAddress?.state = locationResult.adminArea;
      deliveryAddress?.country = locationResult.countryName;
    }
  }

  void toggleDefault(bool? value) {
    isDefault = value ?? false;
    deliveryAddress!.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  //
  updateDeliveryAddress() async {
    if (formKey.currentState?.validate() ?? false) {
      deliveryAddress?.name = nameTEC.text;
      deliveryAddress?.description = descriptionTEC.text;
      deliveryAddress?.addressType = selectedHomeItem;
      deliveryAddress?.doorSide = selectedDoorItem;
      deliveryAddress?.leaveAt = selectedDeliveryItem;

      if (selectedHomeItem == "House") {
        deliveryAddress?.apartmentNo = "";
        deliveryAddress?.buzzerNo = "";
      } else {
        deliveryAddress?.apartmentNo = apartmentNo.text;
        deliveryAddress?.buzzerNo = buzzerNo.text;
      }
      setBusy(true);
      final apiResponse = await deliveryAddressRequest.updateDeliveryAddress(
        deliveryAddress!,
      );

      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Update Delivery Address".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: () {
          Navigator.of(viewContext).pop(true);
        },
      );
      //
      setBusy(false);
    }
  }

  deleteDeliveryAddress(DeliveryAddress? deliveryAddress) {
    if (null != deliveryAddress) {
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
  }

  processDeliveryAddressDeletion(DeliveryAddress deliveryAddress) async {
    //
    final apiResponse = await deliveryAddressRequest.deleteDeliveryAddress(
      deliveryAddress,
    );

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Delete Delivery Address".tr(),
      text: apiResponse.message,
      onConfirmBtnTap: () {
        Navigator.of(viewContext).pop();
        Navigator.of(viewContext).pop(true);
      },
    );
  }
}
