import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/models/address.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/requests/delivery_address.request.dart';
import 'package:mealknight/view_models/delivery_address/base_delivery_addresses.vm.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

import '../../constants/app_routes.dart';

class NewDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController what3wordsTEC = TextEditingController();
  TextEditingController apartmentNo = TextEditingController();
  TextEditingController buzzerNo = TextEditingController();

  DeliveryAddress? deliveryAddress = new DeliveryAddress();
  bool isDefault = true, isFromRegister = false, isSelectedDoor = true;
  String selectedHomeItem = 'House';
  String selectedDoorItem = "Front Door";
  String selectedDeliveryItem = "Hand it to me directly";
  List<String> deliveryItems = [
    'Hand it to me directly',
    'Leave at door',
    'Meet outside'
  ];
  List<String> homeItems = ['House', 'Apartment', 'Call When here '];
  List<String> doorItems = [
    'Front Door',
    'Left Door',
    'Right Door',
    'Back Door',
  ];

  //
  NewDeliveryAddressesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  @override
  showAddressLocationPicker() async {
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      addressTEC.text = locationResult.formattedAddress ?? "";
      deliveryAddress!.address = locationResult.formattedAddress;
      deliveryAddress!.latitude = locationResult.geometry?.location.lat;
      deliveryAddress!.longitude = locationResult.geometry?.location.lng;

      if (locationResult.addressComponents != null &&
          locationResult.addressComponents!.isNotEmpty) {
        //fetch city, state and country from address components
        locationResult.addressComponents!.forEach((addressComponent) {
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
      deliveryAddress!.address = locationResult.addressLine;
      deliveryAddress!.latitude = locationResult.coordinates?.latitude;
      deliveryAddress!.longitude = locationResult.coordinates?.longitude;
      deliveryAddress!.city = locationResult.locality;
      deliveryAddress!.state = locationResult.adminArea;
      deliveryAddress!.country = locationResult.countryName;

      deliveryAddress!.description = descriptionTEC.text;
      deliveryAddress!.addressType = selectedHomeItem;
      deliveryAddress!.doorSide = selectedDoorItem;
    }
    deliveryAddress!.description = descriptionTEC.text;
    deliveryAddress!.addressType = selectedHomeItem;
    deliveryAddress!.doorSide = selectedDoorItem;
  }

  //
  void selectItemDoor(String item) {
    selectedDoorItem = item;
  }

  void selectItemHome(String item) {
    selectedHomeItem = item;
  }

  void toggleDefault(bool? value) {
    isDefault = value ?? false;
    deliveryAddress!.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  //
  saveNewDeliveryAddress() async {
    if (formKey.currentState!.validate()) {
      //
      deliveryAddress!.name = nameTEC.text;
      deliveryAddress!.leaveAt = selectedDeliveryItem;
      deliveryAddress!.description = descriptionTEC.text;
      deliveryAddress!.addressType = selectedHomeItem;
      deliveryAddress!.doorSide = selectedDoorItem;
      deliveryAddress!.apartmentNo = apartmentNo.text ?? '';
      deliveryAddress!.buzzerNo = buzzerNo.text ?? '';

      setBusy(true);

      final apiRespose = await deliveryAddressRequest.saveDeliveryAddress(
        deliveryAddress!,
      );

      //
      CoolAlert.show(
        context: viewContext,
        type: apiRespose.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "New Delivery Address".tr(),
        text: apiRespose.message,
        onConfirmBtnTap: () {
          Navigator.of(viewContext).pop();
          Navigator.of(viewContext).pop(true);
          if (isFromRegister) {
            Navigator.of(viewContext).pushNamedAndRemoveUntil(
              AppRoutes.homeRoute,
              (Route<dynamic> route) => false,
            );
          }
        },
      );
      //
      setBusy(false);
    }
  }

//
}
