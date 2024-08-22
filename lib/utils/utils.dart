import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../services/local_storage.service.dart';

class Utils {
  static bool get isArabic =>
      LocalizeAndTranslate.getLocale().languageCode == "ar";

  static TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  static bool get currencyLeftSided {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      final currencylOCATION = uiConfig["currency"]["location"] ?? 'left';
      return currencylOCATION.toLowerCase() == "left";
    } else {
      return true;
    }
  }

  static bool isDark(Color color) {
    return ColorUtils.calculateRelativeLuminance(
            color.red, color.green, color.blue) <
        0.5;
  }

  static bool isPrimaryColorDark([Color? mColor]) {
    final color = mColor ?? AppColor.primaryColor;
    return ColorUtils.calculateRelativeLuminance(
            color.red, color.green, color.blue) <
        0.5;
  }

  static Color textColorByTheme([bool reversed = false]) {
    if (reversed) {
      return !isPrimaryColorDark() ? Colors.white : Colors.black;
    }
    return isPrimaryColorDark() ? Colors.white : Colors.black;
  }

  static Color textColorByBrightness(BuildContext context,
      [bool reversed = false]) {
    if (reversed) {
      return !context.isDarkMode ? Colors.white : Colors.black;
    }
    return context.isDarkMode ? Colors.white : Colors.black;
  }

  static Color textColorByColor(Color color) {
    return isPrimaryColorDark(color) ? Colors.white : Colors.black;
  }

  static setJiffyLocale() async {
    String cLocale = LocalizeAndTranslate.getLocale().languageCode;
    List<String> supportedLocales = Jiffy.getSupportedLocales();
    if (supportedLocales.contains(cLocale)) {
      await Jiffy.setLocale(LocalizeAndTranslate.getLocale().languageCode);
    } else {
      await Jiffy.setLocale("en");
    }
  }

  static Future<Uint8List?> compressFile({
    Uint8List? data,
    String? filePath,
    String? targetPath,
    int quality = 40,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    FlutterImageCompress.validator.ignoreCheckExtName = true;
    Uint8List? result;
    if (null != data) {
      result = await FlutterImageCompress.compressWithList(
        data,
        quality: quality,
        format: format,
      );
    }
    if (null != filePath) {
      result = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: quality,
        format: format,
      );
    }

    return result;
  }

  static bool isDefaultImg(String? url) {
    return url == null ||
        url.isEmpty ||
        url == "default.png" ||
        url == "default.jpg" ||
        url == "default.jpeg" ||
        url.contains("default.png");
  }

  //get vendor distance from address
  static Future<List<double>> vendorDistanceFromDefaultAddresss(
      LatLng destinationLocation) async {
    try {
      final storagePref = await LocalStorageService.getPrefs();
      String? currentAddress = storagePref.getString("current_address")!;
      if (null != currentAddress && currentAddress.isNotEmpty) {
        List<Location> locations = await locationFromAddress(currentAddress);
        LatLng? currentLocation;
        if (locations.isNotEmpty) {
          currentLocation =
              LatLng(locations.first.latitude, locations.first.longitude);
        }
        //for (var location in locations) {
        //currentLocation = LatLng(location.latitude, location.longitude);
        //}

        if (null != currentLocation) {
          String url =
              'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation.latitude},${currentLocation.longitude}'
              '&destination=${destinationLocation.latitude},${destinationLocation.longitude}'
              '&key=AIzaSyBDc75DLs1UQ25VQfWAQhl4cthGEjaaV9Q&alternatives=true';
          print(url);
          var response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] != "ZERO_RESULTS") {
              print("Map route ${data['routes']}");
              String distance =
                  data['routes'][0]['legs'][0]['distance']['text'];
              String duration =
                  data['routes'][0]['legs'][0]['duration']['text'];
              double travelDistance =
                  double.tryParse(distance.split(' ').first) ?? 0;
              int travelTime = int.tryParse(duration.split(' ').first) ?? 0;

              print(
                  "Map distance $distance $travelDistance $duration $travelTime");
              return [travelDistance, travelTime.toDouble()];
            }
          } else {
            print("Failed to get location distance");
          }
        }
      }
    } catch (e) {
      print("getCurrentLocation Error: $e");
    }

    return [];
  }

  //get vendor distance to current location
  static double vendorDistance(Vendor vendor) {
    if (vendor.latitude.isEmptyOrNull || vendor.longitude.isEmptyOrNull) {
      return 0;
    }

    //if location service current location is not available
    if (LocationService.currenctAddress == null) {
      return 0;
    }

    //get distance
    double distance = Geolocator.distanceBetween(
      LocationService.currenctAddress?.coordinates?.latitude ?? 0,
      LocationService.currenctAddress?.coordinates?.longitude ?? 0,
      double.parse(vendor.latitude),
      double.parse(vendor.longitude),
    );

    //convert distance to km
    distance = distance / 1000;
    return distance;
  }

  //
  //get country code
  static Future<String> getCurrentCountryCode() async {
    String countryCode = "US";
    try {
      //make request to get country code
      final response = await HttpService().dio!.get(
            "http://ip-api.com/json/?fields=countryCode",
          );
      //get the country code
      countryCode = response.data["countryCode"];
    } catch (e) {
      try {
        countryCode = AppStrings.countryCode
            .toUpperCase()
            .replaceAll("AUTO", "")
            .replaceAll("INTERNATIONAL", "")
            .split(",")[0];
      } catch (e) {
        countryCode = "us";
      }
    }

    return countryCode.toUpperCase();
  }

  static Future<File> imageToFile({String? imageName}) async {
    var bytes = await rootBundle.load('${imageName}');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }
}
