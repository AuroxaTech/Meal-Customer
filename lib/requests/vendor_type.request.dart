import 'dart:developer';

import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:mealknight/services/location.service.dart';

class VendorTypeRequest extends HttpService {
  //
  Future<List<VendorType>> index() async {
    final apiResult = await get(
      Api.vendorTypes,
      queryParameters: {
        "latitude": LocationService.currenctAddress?.coordinates?.latitude,
        "longitude": LocationService.currenctAddress?.coordinates?.longitude,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      log("this is vendortype list: ${apiResponse.body}");

      return (apiResponse.body as List)
          .map((e) => VendorType.fromJson(e))
          .toList();
    }

    throw apiResponse.message!;
  }
}
