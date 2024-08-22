import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealknight/constants/api.dart';
import 'package:mealknight/constants/app_file_limit.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/models/package_checkout.dart';
import 'package:mealknight/models/payment_method.dart';
import 'package:mealknight/models/service.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:mealknight/utils/utils.dart';

class CheckoutRequest extends HttpService {
  //
  Future<List<PaymentMethod>> getPaymentOptions() async {
    final apiResult = await get(Api.paymentMethods);

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

  Future<ApiResponse> newOrder(
    CheckOut checkout, {
    required bool isPickup,
    String note = "",
    String tip = "",
    List<Map>? fees = const [],
  }) async {
    final postData = {
      "tip": tip,
      "note": note,
      "coupon_code": checkout.coupon?.code ?? "",
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "products": checkout.cartItems,
      "vendor_id": checkout.cartItems?.first.product?.vendorId,
      "payment_method_id": checkout.paymentMethod?.id,
      "sub_total": checkout.subTotal,
      "order_total": checkout.orderTotalPrice,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "fees": fees,
      "total": checkout.total,
      "distance": checkout.distance,
      "travel_time": checkout.travelTime,
    };
    if (!isPickup) {
      postData["delivery_address_id"] = checkout.deliveryAddress?.id;
    }
    print(postData);
    final apiResult = await post(
      Api.orders,
      body:postData,
    );
    //
    checkout.cartItems!.forEach((element) {
      debugPrint('"vendor":${(jsonEncode(element.product!.vendor))}');
      debugPrint('"logo":${(jsonEncode(element.product!.vendor.logo))}');
      debugPrint(
          '"featureImage":${(jsonEncode(element.product!.vendor.featureImage))}');
      debugPrint('"menus":${(jsonEncode(element.product!.vendor.menus))}');
      debugPrint(
          '"categories":${(jsonEncode(element.product!.vendor.categories))}');
      debugPrint(
          '"packageTypesPricing":${(jsonEncode(element.product!.vendor.packageTypesPricing))}');
      debugPrint(
          '"deliverySlots":${(jsonEncode(element.product!.vendor.deliverySlots))}');
      debugPrint('"cities":${(jsonEncode(element.product!.vendor.cities))}');
      debugPrint('"states":${(jsonEncode(element.product!.vendor.states))}');
      debugPrint(
          '"countries":${(jsonEncode(element.product!.vendor.countries))}');
      debugPrint('"canRate":${(jsonEncode(element.product!.vendor.canRate))}');
      debugPrint(
          '"allowScheduleOrder":${(jsonEncode(element.product!.vendor.allowScheduleOrder))}');
      debugPrint(
          '"hasSubcategories":${(jsonEncode(element.product!.vendor.hasSubcategories))}');
      debugPrint(
          '"prepareTime":${(jsonEncode(element.product!.vendor.prepareTime))}');
      debugPrint(
          '"deliveryTime":${(jsonEncode(element.product!.vendor.deliveryTime))}');
      debugPrint(
          '"minPrepareTime":${(jsonEncode(element.product!.vendor.minPrepareTime))}');
      debugPrint(
          '"maxPrepareTime":${(jsonEncode(element.product!.vendor.maxPrepareTime))}');
      debugPrint(
          '"isFavorite":${(jsonEncode(element.product!.vendor.isFavorite))}');
    });
    print('processOrderPlacement data ===${jsonEncode({
          "tip": tip,
          "note": note,
          "coupon_code": checkout.coupon?.code ?? "",
          "pickup_date": checkout.deliverySlotDate,
          "pickup_time": checkout.deliverySlotTime,
        })}');
    debugPrint('processOrderPlacement data ===${(jsonEncode({
          "products": checkout.cartItems,
        }))}');
    print('processOrderPlacement data ===${jsonEncode({
          "vendor_id": checkout.cartItems?.first.product?.vendorId,
          "delivery_address_id": checkout.deliveryAddress?.id,
          "payment_method_id": checkout.paymentMethod?.id,
          "sub_total": checkout.subTotal,
          "discount": checkout.discount,
          "delivery_fee": checkout.deliveryFee,
          "tax": checkout.tax,
          "fees": fees,
          "total": checkout.total,
        })}');
    print('processOrderPlacement data ============2222222222');
    print('processOrderPlacement response===${apiResult.data}');
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> makeOrderPayment({
    required String orderId,
    required String paymentSourceId,
  }) async {
    final postData = {
      "order_id": orderId,
      "source_id": paymentSourceId,
    };
    final apiResult = await post(
      Api.orderPayment,
      body:postData,
    );
    print(apiResult.data);
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> newMultipleVendorOrder(
    CheckOut checkout, {
    String note = "",
    String tip = "",
    required Map payload,
  }) async {
    Map<String, dynamic> orderPayload = {
      ...payload,
      "tip": tip,
      "note": note,
      "coupon_code": checkout.coupon?.code ?? "",
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "delivery_address_id": checkout.deliveryAddress?.id,
      "payment_method_id": checkout.paymentMethod?.id,
      "sub_total": checkout.subTotal,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "total": checkout.total,
    };

    log("Multiple Vendor Order Payload: $orderPayload");

    final apiResult = await post(
      Api.orders,
      body:orderPayload,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> newPackageOrder(
    PackageCheckout packageCheckout, {
    String? note,
  }) async {
    //fees
    List<Map> feesObjects = [];
    for (var fee in packageCheckout.vendor?.fees ?? []) {
      double calFee = 0;
      String feeName = fee.name;
      if (fee.isPercentage) {
        calFee = fee.getRate(packageCheckout.subTotal);
        feeName = "$feeName (${fee.value}%)";
      } else {
        calFee = fee.value;
      }

      //
      feesObjects.add({
        "id": fee.id,
        "name": feeName,
        "amount": calFee,
      });
      //
    }

    Map<String, dynamic> payload = {
      "type": "package",
      "note": note,
      "coupon_code": packageCheckout.coupon?.code ?? "",
      "package_type_id": packageCheckout.packageType?.id,
      "vendor_id": packageCheckout.vendor?.id,
      "pickup_date": packageCheckout.date,
      "pickup_time": packageCheckout.time,
      "stops": packageCheckout.allStops?.map((e) {
        return e?.toJson();
      }).toList(),
      "recipient_name": packageCheckout.recipientName,
      "recipient_phone": packageCheckout.recipientPhone,
      "weight": packageCheckout.weight,
      "width": packageCheckout.width,
      "length": packageCheckout.length,
      "height": packageCheckout.height,
      "payment_method_id": packageCheckout.paymentMethod?.id,
      "sub_total": (packageCheckout.subTotal! - (packageCheckout.deliveryFee)),
      "discount": packageCheckout.discount,
      "delivery_fee": packageCheckout.deliveryFee,
      "tax": packageCheckout.tax,
      "tax_rate": packageCheckout.taxRate,
      "token": packageCheckout.token,
      "payer": packageCheckout.payer,
      "fees": feesObjects,
      "total": packageCheckout.total,
    };

    if (kDebugMode) {
      log("Package Order Payload: ${jsonEncode(payload)}");
    }

    final apiResult = await post(
      Api.orders,
      body:payload,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> newServiceOrder(
    CheckOut checkout, {
    List<Map>? fees,
    required Service service,
    double? service_amount,
    String? note,
  }) async {
    //
    final params = {
      "type": "service",
      "note": note,
      "service_id": service.id,
      "vendor_id": service.vendor.id,
      "delivery_address_id": checkout.deliveryAddress?.id,
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "hours": service.selectedQty,
      "service_price": service_amount != null
          ? service_amount
          : service.showDiscount
              ? service.discountPrice
              : service.price,
      "payment_method_id": checkout.paymentMethod?.id,
      "sub_total": checkout.subTotal,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "total": checkout.total,
      "coupon_code": checkout.coupon?.code ?? "",
      "fees": fees,
    };

    //if there is selected options
    if (service.selectedOptions.isNotEmpty) {
      String optionFlatten = "";
      List<int> optionIds = [];
      for (var option in service.selectedOptions) {
        optionFlatten += "${option.name}";
        //add , if its not the last option
        if (service.selectedOptions.last.id != option.id) {
          optionFlatten += ", ";
        }

        optionIds.add(option.id);
      }

      //
      params.addAll({
        "options_flatten": optionFlatten,
        "options_ids": optionIds,
      });
    }
    //
    final apiResult = await post(
      Api.orders,
      body:params,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> newPrescriptionOrder(
    CheckOut checkout,
    Vendor vendor, {
    List<XFile>? photos,
    String note = "",
  }) async {
    //
    Map<String, dynamic> postBody = {
      "type": vendor.vendorType.slug,
      "note": note,
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "vendor_id": vendor.id,
      "delivery_address_id": checkout.deliveryAddress?.id,
      "sub_total": checkout.subTotal,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "total": checkout.total,
    };
    FormData formData = FormData.fromMap(postBody);
    if (photos != null && photos.isNotEmpty) {
      for (XFile? file in photos) {
        //if the file size is bigger than the AppFileLimit.prescriptionFileSizeLimit then compress it
        //file size in kb
        final fileSize = (await file!.length()) / 1024;
        if (fileSize > AppFileLimit.prescriptionFileSizeLimit) {
          Uint8List? compressed = await Utils.compressFile(
            data: await file.readAsBytes(),
            filePath: file.path,
            quality: 60,
          );

          if (null != compressed) {
            formData.files.add(
              MapEntry("photos[]", MultipartFile.fromBytes(compressed)),
            );
          }
        } else {
          formData.files.add(
            MapEntry(
                "photos[]", MultipartFile.fromBytes(await file.readAsBytes())),
          );
        }
      }
    }

    //make api request
    final apiResult = await postWithFiles(
      Api.orders,
      formData,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<double> orderSummary(
      {required int deliveryAddressId, required int vendorId}) async {
    final params = {
      "vendor_id": "${vendorId}",
      "delivery_address_id": "${deliveryAddressId}",
    };

    //
    final apiResult = await get(
      Api.generalOrderSummary,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return PackageCheckout.fromJson(apiResponse.body).deliveryFee;
    }

    throw apiResponse.message!;
  }
}
