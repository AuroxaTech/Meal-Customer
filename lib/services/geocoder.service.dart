import 'package:mealknight/constants/api.dart';
import 'package:mealknight/constants/app_map_settings.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/address.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/coordinates.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

export 'package:mealknight/models/address.dart';
export 'package:mealknight/models/coordinates.dart';

class GeocoderService extends HttpService {

  Future<List<Address>> findAddressesFromCoordinates(
    Coordinates coordinates, {
    int limit = 5,
  }) async {
    //use backend api
    if (!AppMapSettings.useGoogleOnApp) {
      final apiresult = await get(
        Api.geocoderForward,
        queryParameters: {
          "lat": coordinates.latitude,
          "lng": coordinates.longitude,
          "limit": limit,
        },
      );

      //
      final apiResponse = ApiResponse.fromResponse(apiresult);
      if (apiResponse.allGood) {
        return (apiResponse.data).map((e) {
          // return Address().fromServerMap(e);
          Address address;
          try {
            address = Address().fromMap(e);
          } catch (error) {
            address = Address().fromServerMap(e);
          }
          return address;
        }).toList();
      }

      return [];
    }
    //use in-app geocoding
    final apiKey = AppStrings.googleMapApiKey;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.toString()};key=$apiKey";

    final apiResult = await get(
      Api.externalRedirect,
      queryParameters: {"endpoint": url},
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    //
    if (apiResponse.allGood) {
      Map<String, dynamic> apiResponseData = apiResponse.body;
      return (apiResponseData["results"] as List).map((e) {
        try {
          return Address().fromMap(e);
        } catch (error) {
          return Address().fromServerMap(e);
        }
      }).toList();
    }
    return [];
  }

  Future<List<Address>> findAddressesFromQuery(String address) async {
    //use in-app geocoding
    String myLatLng = "";
    if (LocationService.currenctAddress != null) {
      myLatLng = "${LocationService.currenctAddress?.coordinates?.latitude},";
      myLatLng += "${LocationService.currenctAddress?.coordinates?.longitude}";
    }

    //get current device region
    String? region;
    try {
      region = await Utils.getCurrentCountryCode();
    } catch (error) {
      region = "";
    }

    //use backend api
    if (!AppMapSettings.useGoogleOnApp) {
      final apiresult = await get(
        Api.geocoderReserve,
        queryParameters: {
          "keyword": address,
          "location": myLatLng,
          "region": region,
        },
      );

      //
      final apiResponse = ApiResponse.fromResponse(apiresult);
      if (apiResponse.allGood) {
        return (apiResponse.data).map((e) {
          Address address;
          try {
            address = Address().fromMap(e);
          } catch (error) {
            address = Address().fromServerMap(e);
          }
          address.gMapPlaceId = e["place_id"] ?? "";
          return address;
        }).toList();
      }

      return [];
    }
    //use in-app geocoding
    final apiKey = AppStrings.googleMapApiKey;
    address = address.replaceAll(" ", "+");
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$address;key=$apiKey;location=$myLatLng;region=$region";
    final result = await get(
      Api.externalRedirect,
      queryParameters: {"endpoint": url},
    );

    final apiResult = ApiResponse.fromResponse(result);

    //
    if (apiResult.allGood) {
      //
      Map<String, dynamic> apiResponse = apiResult.body;
      return (apiResponse["predictions"] as List).map((e) {
        Address address;
        try {
          address = Address().fromMap(e);
        } catch (error) {
          address = Address().fromServerMap(e);
        }
        address.gMapPlaceId = e["place_id"];
        return address;
      }).toList();
    }
    return [];
  }

  Future<Address> fecthPlaceDetails(Address address) async {
    //use backend api
    if (!AppMapSettings.useGoogleOnApp) {
      final apiresult = await get(
        Api.geocoderPlaceDetails,
        queryParameters: {
          "place_id": address.gMapPlaceId,
          "plain": true,
        },
      );

      //
      final apiResponse = ApiResponse.fromResponse(apiresult);
      if (apiResponse.allGood) {
        return Address().fromPlaceDetailsMap(apiResponse.body as Map);
      }

      return address;
    }

    //use in-app geocoding
    final apiKey = AppStrings.googleMapApiKey;
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?fields=address_component,formatted_address,name,geometry;place_id=${address.gMapPlaceId};key=$apiKey";
    final result = await get(
      Api.externalRedirect,
      queryParameters: {"endpoint": url},
    );
    final apiResult = ApiResponse.fromResponse(result);

    //
    if (apiResult.allGood) {
      Map<String, dynamic> apiResponse = apiResult.body;
      address = address.fromPlaceDetailsMap(apiResponse["result"]);
      return address;
    }
    throw "Failed".tr();
  }
}
