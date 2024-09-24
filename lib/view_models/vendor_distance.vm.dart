import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:flutter/foundation.dart';

import '../models/vendor.dart';
import '../services/local_storage.service.dart';
import '../utils/utils.dart';
import 'base.view_model.dart';

class VendorDistanceViewModel extends MyBaseViewModel {
  static final VendorDistanceViewModel _instance =
      VendorDistanceViewModel._internal();

  factory VendorDistanceViewModel() {
    return _instance;
  }

  VendorDistanceViewModel._internal();

  final ValueNotifier<bool> isPickup = ValueNotifier<bool>(false);

  final ValueNotifier<String> myAddress = ValueNotifier<String>("");

  final Map<int, Vendor> _data = {};

  // Map of ValueNotifiers to listen to specific key changes
  final Map<int, ValueNotifier<Vendor?>> _notifiers = {};

  // Method to get the value of a key
  Vendor? getValue(int key) => _data[key];

  // Method to update the value of a key
  void updateValue(Vendor value) {
    Vendor vendor = value.copy();
    _data[vendor.id] = vendor;
    // Notify the specific listener
    if (_notifiers.containsKey(vendor.id)) {
      _notifiers[vendor.id]?.value = vendor;
      print("Notifying listener ${vendor.name}");
    }
    notifyListeners();
  }

  // Method to get a ValueNotifier for a specific key
  ValueNotifier<Vendor?> listenToKey(int key) {
    if (!_notifiers.containsKey(key)) {
      _notifiers[key] = ValueNotifier<Vendor?>(_data[key]);
    }
    return _notifiers[key]!;
  }

  void addAllVendors(List<Vendor> vendors) async {
    if (myAddress.value.isEmpty) {
      await fetchCurrentLocation();
      final storagePref = await LocalStorageService.getPrefs();
      myAddress.value = storagePref.getString("current_address") ?? "";
    }
    List<Vendor> newVendors =
        vendors.where((vendor) => !_data.containsKey(vendor.id)).toList();
    for (var vendor in newVendors) {
      _data[vendor.id] = vendor;
      _notifiers[vendor.id] = ValueNotifier<Vendor?>(vendor);
    }
    for (var vendor in newVendors) {
      double latitude = (vendor.latitude).toDouble();
      double longitude = (vendor.longitude).toDouble();
      LatLng destinationLocation = LatLng(latitude, longitude);

      Utils.vendorDistanceFromDefaultAddresss(destinationLocation)
          .then((value) {
        if (value.length > 1) {
          vendor.distance = value[0];
          vendor.travelTime = value[1].toInt();
        }
        updatePreparingTime(vendor);
      });
    }
  }

  void onUpdatePickup(bool value) {
    isPickup.value = value;
    _data.forEach((key, vendor) {
      updatePreparingTime(vendor);
    });
  }

  Future<void> onChangeVendorFavorite(int vendorId, bool isFavorite) async {
    Vendor? vendor = _data[vendorId];
    if (null != vendor) {
      vendor.isFavorite = isFavorite;
      updateValue(vendor);
    }
  }

  Future<void> updateDeliveryAddress(String newAddress) async {
    myAddress.value = newAddress;
    final storagePref = await LocalStorageService.getPrefs();
    await storagePref.setString("current_address", newAddress);
    _data.forEach((key, vendor) {
      double latitude = (vendor.latitude).toDouble();
      double longitude = (vendor.longitude).toDouble();
      LatLng destinationLocation = LatLng(latitude, longitude);
      Utils.vendorDistanceFromDefaultAddresss(destinationLocation)
          .then((value) {
        if (value.length > 1) {
          vendor.distance = value[0];
          vendor.travelTime = value[1].toInt();
        }
        updatePreparingTime(vendor);
      });
    });
  }

  void updatePreparingTime(Vendor vendor) {
    if (isPickup.value) {
      vendor.prepareTime =
          "${(vendor.minPrepareTime + 5)} - ${(vendor.maxPrepareTime + 5)} min";
    } else {
      vendor.prepareTime =
          "${(vendor.minPrepareTime + vendor.travelTime + 5)} - ${(vendor.maxPrepareTime + vendor.travelTime + 5)} min";
    }
    print("Prepare Time: ${vendor.prepareTime}");
    print("Vendor Travel Time: ${vendor.travelTime}");
    updateValue(vendor);
  }
}
