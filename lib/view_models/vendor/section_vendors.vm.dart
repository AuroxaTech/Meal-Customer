import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import '../../models/category.dart';
import '../../models/delivery_address.dart';
import '../../models/search.dart';
import '../../models/vendor_type.dart';
import '../../requests/delivery_address.request.dart';
import '../../services/location.service.dart';
import '../vendor_distance.vm.dart';

class SectionVendorsViewModel extends MyBaseViewModel {
  SectionVendorsViewModel(
      BuildContext context,
      this.vendorType, {
        this.type = SearchFilterType.you,
        this.byLocation = false,
        this.category,
      }) {
    this.viewContext = context;
  }

  List<Vendor> vendors = [];
  VendorType? vendorType;
  SearchFilterType type;
  bool? byLocation;
  VendorRequest _vendorRequest = VendorRequest();
  Category? category;
  bool isPickup = false;
  bool delievryAddressOutOfRange = false;
  DeliveryAddress? deliveryAddress;
  Vendor? vendor; // Ensure vendor is initialized here
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  Future<void> locationListener() async {
    await LocationService.prepareLocationListener();
  }
  initialise() {
    isPickup = VendorDistanceViewModel().isPickup.value;
    VendorDistanceViewModel().isPickup.addListener(_onPickupChanged);
    locationListener();
    fetchVendors();
  }

  void _onPickupChanged() {
    isPickup = VendorDistanceViewModel().isPickup.value;
    notifyListeners();
  }

  Future<void> prefetchDeliveryAddress() async {
    setBusyForObject(deliveryAddress, true);
    try {
      // Fetch vendor details if not already fetched
      if (vendor == null) {
        await fetchVendorDetails(); // Ensure that the vendor object is initialized properly
      }

      // Fetch the preselected delivery address
      deliveryAddress = await deliveryAddressRequest.preselectedDeliveryAddress(
        vendorId: vendor?.id, // Ensure vendor ID is passed here
      );
      print("Delivery Address ===> ${deliveryAddress?.address}");

      if (deliveryAddress != null && vendor != null) {
        checkDeliveryRange();
      }
    } catch (error) {
      print("Error Fetching preselected Address ==> $error");
    }
    setBusyForObject(deliveryAddress, false);
  }

  Future<void> fetchVendorDetails() async {
    if (vendors.isNotEmpty) {
      vendor = vendors.first;
      print("Vendor ID fetched: ${vendor?.id}");
    }
    if (vendor == null) {
      print("Vendor not found, fetching vendor details...");
      // Use default or fallback logic here if vendor is null
    }
  }

  void checkDeliveryRange() {
    if (vendor != null && deliveryAddress != null) {
      // Check if the delivery address is within the vendor's delivery range
      delievryAddressOutOfRange =
          vendor!.deliveryRange < (deliveryAddress!.distance ?? 0);

      // Additional check if delivery is allowed based on canDeliver flag
      if (deliveryAddress?.canDeliver != null) {
        delievryAddressOutOfRange = !(deliveryAddress?.canDeliver ?? true);
      }

      print("Delivery address out of range: $delievryAddressOutOfRange");
    } else {
      print("Vendor or delivery address is null, skipping delivery range check.");
      delievryAddressOutOfRange = false;
    }

    notifyListeners();
  }

  Future<void> vendorSelected(Vendor vendor) async {
    print("isPickup: $isPickup");
    print("delievryAddressOutOfRange: $delievryAddressOutOfRange");

    this.vendor = vendor; // Assign the selected vendor
    await prefetchDeliveryAddress();

    if (!isPickup && delievryAddressOutOfRange) {
      print("isPickup: $isPickup");
      print("delievryAddressOutOfRange: $delievryAddressOutOfRange");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery address".tr(),
        text: "Delivery address is out of vendor delivery range".tr(),
      );
      return; // Stop further execution if the delivery address is out of range
    }

    Navigator.of(viewContext)
        .pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    )
        .then((value) {
      if (null != value && value is bool && value) {
        fetchVendors();
      }
    });
  }

  Future<void> fetchVendors() async {
    setBusy(true);
    try {
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: byLocation ?? true,
        params: {
          "vendor_type_id": vendorType?.id,
          "category_id": category?.id,
          "type": type.name,

        },
      );

      // Assign the first vendor after fetching
      if (vendors.isNotEmpty) {
        vendor = vendors.first;
        print("Vendor ID after fetching: ${vendor?.id}");
      }

      clearErrors();
    } catch (error) {
      print("Error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  void onFavoriteChange(int index, bool isFavorite) {
    vendors[index].isFavorite = isFavorite;
    if (vendors[index].id == vendor?.id) {
      vendor?.isFavorite = isFavorite;
    }
    notifyListeners();
  }

}
