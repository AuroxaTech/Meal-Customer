import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/order_stop.dart';
import 'package:mealknight/models/review.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:mealknight/services/location.service.dart';
import '../view_models/vendor_distance.vm.dart';

class VendorRequest extends HttpService {

  Future<List<Vendor>> vendorsRequest({
    int page = 1,
    bool byLocation = true,
    Map? params,
  }) async {
    // Ensure location is ready
    await ensureLocationIsReady();

    Map<String, dynamic> queryParameters = {
      ...(params ?? {}),
      "page": "$page",
    };

    final isAuth = AuthServices.authenticated();
    // Check if location data is available before adding it to the query parameters
    if (byLocation && LocationService.cLat != null && LocationService.cLng != null) {
      queryParameters["latitude"] =
          LocationService.currenctAddress?.coordinates?.latitude;
      queryParameters["longitude"] =
          LocationService.currenctAddress?.coordinates?.longitude;
    }

    print("Latitude send to api===> ${LocationService.currenctAddress?.coordinates?.latitude}");
    print("Longitude send to api ===> ${LocationService.currenctAddress?.coordinates?.longitude}");

    final apiResult = await get(
      isAuth ? Api.user_vendors : Api.vendors,
      queryParameters: queryParameters,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = [];
      for (var jsonObject in apiResponse.data) {
        try {
          vendors.add(Vendor.fromJson(jsonObject));
        } catch (error) {
          print("===============================");
          print("Fetching Vendor error ==> $error");
          print("Vendor Id ==> ${jsonObject['id']}");
          print("===============================");
        }
      }
      VendorDistanceViewModel().addAllVendors(vendors);
      return vendors;
    }
    throw apiResponse.message!;
  }

//Ensure location is ready before proceeding
  Future<void> ensureLocationIsReady() async {
    if (LocationService.currenctAddress == null) {
      print("Waiting for location...");
      await LocationService.prepareLocationListener();
      //Wait until the location is ready
      while (LocationService.currenctAddress == null) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
  }

  Future<List<Vendor>> topVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    final isAuth = await AuthServices.authenticated();

    final apiResult = await get(
      isAuth ? Api.user_vendors : Api.vendors,
      queryParameters: {
        ...(params ?? {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      VendorDistanceViewModel().addAllVendors(vendors);
      return vendors;
    }
    throw apiResponse.message!;
  }

  Future<List<Vendor>> nearbyVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    final isAuth = await AuthServices.authenticated();

    final apiResult = await get(
      isAuth ? Api.user_vendors : Api.vendors,
      queryParameters: {
        ...(params ?? {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      VendorDistanceViewModel().addAllVendors(vendors);
      return vendors;
    }
    throw apiResponse.message!;
  }

  Future<Vendor> vendorDetails(
    int id, {
    Map<String, String>? params,
  }) async {
    //
    final apiResult = await get(
      "${Api.vendors}/$id",
      queryParameters: params,
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      Vendor vendor = Vendor.fromJson(apiResponse.body);
      VendorDistanceViewModel().addAllVendors([vendor]);
      return vendor;
    }
    throw apiResponse.message!;
  }

  Future<List<Vendor>> fetchParcelVendors({
    required int packageTypeId,
    int? vendorTypeId,
    required List<OrderStop> stops,
  }) async {
    final apiResult = await post(
      Api.packageVendors,
      body:{
        "vendor_type_id": vendorTypeId,
        "package_type_id": "$packageTypeId",
        "locations": stops.map(
          (stop) {
            return {
              "lat": stop.deliveryAddress?.latitude,
              "long": stop.deliveryAddress?.longitude,
              "city": stop.deliveryAddress?.city,
              "state": stop.deliveryAddress?.state,
              "country": stop.deliveryAddress?.country,
            };
          },
        ).toList(),
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = (apiResponse.body['vendors'] as List)
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      VendorDistanceViewModel().addAllVendors(vendors);
      return vendors;
    }
    throw apiResponse.message!;
  }

  Future<ApiResponse> rateVendor({
    required int rating,
    required String review,
    required int orderId,
    required int vendorId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      body:{
        "order_id": orderId,
        "vendor_id": vendorId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> rateDriver({
    required int rating,
    required String review,
    required int orderId,
    required int driverId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      body:{
        "order_id": orderId,
        "driver_id": driverId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<Review>> getReviews({
    int? page,
    int? vendorId,
  }) async {
    final apiResult = await get(
      Api.vendorReviews,
      queryParameters: {
        "vendor_id": vendorId,
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Review> reviews = apiResponse.data.map(
        (jsonObject) {
          return Review.fromJson(jsonObject);
        },
      ).toList();
      return reviews;
    }
    throw apiResponse.message!;
  }
}