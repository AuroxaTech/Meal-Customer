import 'dart:convert';
import 'dart:developer';

import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/services/http.service.dart';

class FavouriteRequest extends HttpService {
  //
  Future<List<Product>> favourites() async {
    final apiResult = await get(Api.favourites);
    log("final favourites product list: \n ${jsonEncode(apiResult.data)} \n");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Product> products = [];
      (apiResponse.body as List).forEach(
        (jsonObject) {
          try {
            products.add(Product.fromJson(jsonObject["product"]));
          } catch (error) {
            print("error: $error");
          }
        },
      );
      return products;
    }

    throw apiResponse.message!;
  }

  Future<List<Vendor>> favouritesVendor() async {
    final apiResult = await get(Api.favouritesVendor);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendorList = [];
      (apiResponse.body as List).forEach(
        (jsonObject) {
          try {
            vendorList.add(Vendor.fromJson(jsonObject["vendor"]));
          } catch (error) {
            print("error: $error");
          }
        },
      );
      return vendorList;
    }

    throw apiResponse.message!;
  }

  //
  Future<ApiResponse> makeFavourite(int id) async {
    final apiResult = await post(
      Api.favourites,
      body:{
        "product_id": id,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> makeFavouriteVendor(int id) async {
    final apiResult = await post(
      Api.favouritesVendor,
      body:{
        // "user_id": ,
        "vendor_id": id,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> removeFavourite(int productId) async {
    final apiResult = await delete(Api.favourites + "/$productId");
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> removeFavouriteVendor(int vendorId) async {
    final apiResult = await delete(Api.favouritesVendor + "/$vendorId");
    return ApiResponse.fromResponse(apiResult);
  }
}
