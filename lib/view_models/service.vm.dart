import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../constants/app_routes.dart';

class ServiceViewModel extends MyBaseViewModel {
  ServiceViewModel(BuildContext context, VendorType vendorType) {
    this.viewContext = context;
    this.vendorType = vendorType;
  }

  User? currentUser;
  StreamSubscription? currentLocationChangeStream;

  VendorRequest vendorRequest = VendorRequest();
  RefreshController refreshController = RefreshController();
  List<Vendor> vendors = [];

  void initialise() async {
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    //listen to user location change
    currentLocationChangeStream =
        LocationService.currenctAddressSubject.stream.listen(
      (location) {
        //
        deliveryaddress ??= DeliveryAddress();
        deliveryaddress?.address = location.addressLine;
        deliveryaddress?.latitude = location.coordinates?.latitude;
        deliveryaddress?.longitude = location.coordinates?.longitude;
        notifyListeners();
      },
    );

    //get vendors
    getVendors();
  }

  //
  dispose() {
    super.dispose();
    currentLocationChangeStream?.cancel();
  }

  //
  getVendors() async {
    //
    setBusyForObject(vendors, true);
    try {
      vendors = await vendorRequest.nearbyVendorsRequest(
        params: {
          "vendor_type_id": vendorType?.id,
        },
      );
    } catch (error) {
      print("Error ==> $error");
    }
    setBusyForObject(vendors, false);
  }

  //
  openVendorDetails(Vendor vendor) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
}
