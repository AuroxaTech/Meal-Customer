import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/app_banner.dart';
import 'package:mealknight/services/http.service.dart';

class BannerRequest extends HttpService {
  //
  Future<List<AppBanner>?> banners({
    int? vendorTypeId,
    Map? params,
  }) async {
    final apiResult = await get(
      Api.banners,
      // queryParameters: {
      //   "vendor_type_id": vendorTypeId,
      //   ...(params != null ? params : {}),
      // },
    );

    //final apiResponse = ApiResponse.fromResponse(apiResult);
    // if (apiResponse.allGood) {
    //    var banner = Banner.fromJson(apiResult.data);
    //    return banner.data;
    // } else {
    //   throw apiResponse.message!;
    // }

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return AppBanner.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message!;
    }
  }
}
