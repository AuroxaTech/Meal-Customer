import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/flash_sale.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/services/http.service.dart';

class FlashSaleRequest extends HttpService {
  Future<List<FlashSale>> getFlashSales({
    Map<String, dynamic>? queryParams,
  }) async {
    Map<String, dynamic> params = {
      ...(queryParams ?? {}),
    };

    final apiResult = await get(
      Api.flashSales,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((jsonObject) => FlashSale.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  //
  Future<List<Product>> getProdcuts({
    Map<String, dynamic>? queryParams,
    int page = 1,
  }) async {
    Map<String, dynamic> params = {
      ...(queryParams ?? {}),
      "page": "$page",
    };

    final apiResult = await get(
      Api.flashSales,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Product> products = [];
      ((apiResponse.body is List) ? apiResponse.body : apiResponse.data).forEach((jsonObject) {
        if(null != jsonObject && null != jsonObject["item"]){
          products.add(Product.fromJson(jsonObject["item"]));
        }
      });
      return products;
    }

    throw apiResponse.message!;
  }
}
