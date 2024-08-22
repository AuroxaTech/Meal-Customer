import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/payment_method.dart';
import 'package:mealknight/services/http.service.dart';

class PaymentMethodRequest extends HttpService {
  //
  Future<List<PaymentMethod>> getPaymentOptions({
    int? vendorId,
    Map<String, dynamic>? params,
  }) async {
    //
    Map<String, dynamic> queryParameters = {
      ...(params ?? {}),
      "vendor_id": vendorId,
    };

    final apiResult = await get(
      Api.paymentMethods,
      queryParameters: queryParameters,
    );

    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.data.map((jsonObject) {
        return PaymentMethod.fromJson(jsonObject);
      }).toList())
          .where((element) => ["squareup", "wallet"].contains(element.slug))
          .toList()..sort((a,b) => a.id);
    } else {
      throw apiResponse.message!;
    }
  }

  Future<List<PaymentMethod>> getTaxiPaymentOptions() async {
    final apiResult = await get(
      Api.paymentMethods,
      queryParameters: {
        "use_taxi": 1,
      },
    );

    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return PaymentMethod.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message!;
    }
  }
}
