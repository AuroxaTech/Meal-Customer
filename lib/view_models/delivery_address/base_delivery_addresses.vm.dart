import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/requests/delivery_address.request.dart';
import 'package:mealknight/services/geocoder.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/views/pages/delivery_address/widgets/address_search.view.dart';
import 'package:google_places_flutter/model/prediction.dart';

class BaseDeliveryAddressesViewModel extends MyBaseViewModel {
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController placeSearchTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController what3wordsTEC = TextEditingController();
  bool isDefault = false;
  DeliveryAddress? deliveryAddress;

  openLocationPicker() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return AddressSearchView(
          this,
          addressSelected: (dynamic prediction) async {
            if (prediction is Prediction) {
              addressTEC.text = prediction.description ?? "";
              deliveryAddress?.address = prediction.description;
              deliveryAddress?.latitude = prediction.lat?.toDoubleOrNull();
              deliveryAddress?.longitude = prediction.lng?.toDoubleOrNull();
              //
              setBusy(true);
              await getLocationCityName(deliveryAddress!);
              setBusy(false);
            } else if (prediction is Address) {
              addressTEC.text = prediction.addressLine ?? "";
              deliveryAddress?.address = prediction.addressLine;
              deliveryAddress?.latitude = prediction.coordinates?.latitude;
              deliveryAddress?.longitude = prediction.coordinates?.longitude;
              deliveryAddress?.city = prediction.locality;
              deliveryAddress?.state = prediction.adminArea;
              deliveryAddress?.country = prediction.countryName;
            }
          },
          selectOnMap: showAddressLocationPicker,
        );
      },
    );
  }

  showAddressLocationPicker() {}
}
