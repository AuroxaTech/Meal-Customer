import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/services/app.service.dart';
import 'package:mealknight/widgets/bottomsheets/location_permission.bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked_services/stacked_services.dart';
import 'geocoder.service.dart';

class LocationService {
  //
  static Location location = new Location();

  static bool? serviceEnabled;
  static PermissionStatus? _permissionGranted;
  static LocationData? _locationData;
  static Address? currenctAddress;
  static DeliveryAddress? deliveryaddress;
  static StreamSubscription? currentLocationListener;

  //
  static BehaviorSubject<Address> currenctAddressSubject =
  BehaviorSubject<Address>();
  // static Stream<Address> get currenctAddressStream =>
  //     _currenctAddressSubject.stream;

  static Future<void> prepareLocationListener() async {
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      bool requestPermission = true;
      if (!Platform.isIOS) {
        requestPermission = await showRequestDialog();
      }
      if (requestPermission) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print("Location permission denied.");
          return;
        }
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled == null || serviceEnabled == false) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled == null || serviceEnabled == false) {
        print("Location services not enabled.");
        return;
      }
    }

    print("Starting location listener.");
    startLocationListner();
  }

  static Future<bool> showRequestDialog() async {
    //
    var requestResult = false;
    if(null != StackedService.navigatorKey?.currentContext) {
      await showDialog(
        context: StackedService.navigatorKey!.currentContext!,
        builder: (context) {
          return LocationPermissionDialog(onResult: (result) {
            requestResult = result;
          });
        },
      );
    }

    //
    return requestResult;
  }

  static Future<void> startLocationListner() async {
    print("Listening for location changes...");

    // Throttle the location stream to only respond every 5 seconds
    currentLocationListener = Geolocator.getPositionStream()
        .debounceTime(Duration(seconds: 5)) // Debounce to control frequency
        .listen((Position currentLocation) {
      // Use current location
      _locationData = LocationData.fromMap(currentLocation.toJson());
      print("Current location data: ${_locationData?.latitude}, ${_locationData?.longitude}");

      // Fetch the geocoded address based on current coordinates
      geocodeCurrentLocation(true);
    });

    // Get the initial location
    _locationData = await location.getLocation();
    if (_locationData != null) {
      print("Initial location: ${_locationData?.latitude}, ${_locationData?.longitude}");
      geocodeCurrentLocation();
    } else {
      print("Initial location not available.");
    }
  }
  //
  static Future<void> geocodeCurrentLocation([bool closeListener = false]) async {
    if (_locationData != null) {
      final coordinates = new Coordinates(
        _locationData?.latitude ?? 0.0,
        _locationData?.longitude ?? 0.0,
      );

      try {
        final addresses = await GeocoderService().findAddressesFromCoordinates(coordinates);

        if (addresses.isNotEmpty) {
          currenctAddress = addresses.first;
          print("Geocoded address: ${currenctAddress?.addressLine}");
          currenctAddressSubject.add(currenctAddress!);
        } else {
          print("No addresses found for the current coordinates.");
        }
      } catch (error) {
        print("Error during geocoding: $error");
      }
    } else {
      print("Location data is null, cannot geocode.");
    }

    if (closeListener) {
      print("Location listener closed.");
      currentLocationListener?.cancel();
    }
  }

  //coordinates to address
  static Future<Address?> addressFromCoordinates({
    required double lat,
    required double lng,
  }) async {
    Address? address;
    final coordinates = new Coordinates(
      lat,
      lng,
    );

    try {
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        coordinates,
      );
      //
      address = addresses.first;
    } catch (error) {
      print("Issue with addressFromCoordinates ==> $error");
    }
    return address;
  }

  //Helper methods

  //get current lat
  static double? get cLat {
    print("LocationService Latitude===> ${LocationService.currenctAddress?.coordinates?.latitude}");
    return LocationService.currenctAddress?.coordinates?.latitude;
  }

  //get current lng
  static double? get cLng {
    return LocationService.currenctAddress?.coordinates?.longitude;
  }
}