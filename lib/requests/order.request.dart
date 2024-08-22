// import 'package:mealknight/constants/api.dart';
// import 'package:mealknight/models/api_response.dart';
// import 'package:mealknight/models/order.dart';
// import 'package:mealknight/services/http.service.dart';
//
// class OrderRequest extends HttpService {
//   //
//   Future<List<Order>> getOrders(
//       {int page = 1, Map<String, dynamic>? params}) async {
//     final apiResult = await get(
//       Api.orders,
//       queryParameters: {
//         "page": page,
//         ...(params ?? {}),
//       },
//     );
//
//     //
//     final apiResponse = ApiResponse.fromResponse(apiResult);
//     if (apiResponse.allGood) {
//       List<Order> orders = [];
//       List<dynamic> jsonArray =
//           (apiResponse.body is List) ? apiResponse.body : apiResponse.data;
//       print("Arrray json $jsonArray");
//       print("Parsed JSON Array: $jsonArray");
//       for (var jsonObject in jsonArray) {
//         try {
//           orders.add(Order.fromJson(jsonObject));
//         } catch (e) {
//           print(e);
//         }
//       }
//
//       return orders;
//     } else {
//       throw apiResponse.message!;
//     }
//   }
//
//   //
//   Future<Order> getOrderDetails({required int id}) async {
//     final apiResult = await get(Api.orders + "/$id");
//     //
//     final apiResponse = ApiResponse.fromResponse(apiResult);
//     print("order detail response $apiResponse");
//     if (apiResponse.allGood) {
//       return Order.fromJson(apiResponse.body);
//     } else {
//       throw apiResponse.message!;
//     }
//   }
//
//   //
//   Future<String> updateOrder({int? id, String? status, String? reason}) async {
//     final apiResult = await patch(Api.orders + "/$id", {
//       "status": status,
//       "reason": reason,
//     });
//     //
//     final apiResponse = ApiResponse.fromResponse(apiResult);
//     if (apiResponse.allGood) {
//       return apiResponse.message!;
//     } else {
//       throw apiResponse.message!;
//     }
//   }
//
//   //
//   Future<Order> trackOrder(String code, {int? vendorTypeId}) async {
//     //
//     final apiResult = await post(
//       Api.trackOrder,
//       body:{
//         "code": code,
//         "vendor_type_id": vendorTypeId,
//       },
//     );
//     //
//     final apiResponse = ApiResponse.fromResponse(apiResult);
//     if (apiResponse.allGood) {
//       return Order.fromJson(apiResponse.body);
//     } else {
//       throw apiResponse.message!;
//     }
//   }
//
//   Future<ApiResponse> updateOrderPaymentMethod({
//     int? id,
//     int? paymentMethodId,
//     String? status,
//   }) async {
//     //
//     final apiResult = await patch(
//       Api.orders + "/$id",
//       {
//         "payment_method_id": paymentMethodId,
//         "payment_status": status,
//       },
//     );
//     //
//     final apiResponse = ApiResponse.fromResponse(apiResult);
//     if (apiResponse.allGood) {
//       return apiResponse;
//     } else {
//       throw apiResponse.message!;
//     }
//   }
//
//   Future<List<String>> orderCancellationReasons({
//     Order? order,
//   }) async {
//     //
//     final apiResult = await get(
//       Api.cancellationReasons,
//       queryParameters: {
//         "type": (order?.isTaxi ?? false) ? "taxi" : "order",
//       },
//     );
//     //
//     final apiResponse = ApiResponse.fromResponse(apiResult);
//     if (apiResponse.allGood) {
//       return (apiResponse.body as List).map((e) {
//         return e['reason'].toString();
//       }).toList();
//     } else {
//       throw apiResponse.message!;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:http/http.dart' as http;
import '../models/ticket_list_model.dart';
import '../services/auth.service.dart';

class OrderRequest extends HttpService {
  //
  Future<List<Order>> getOrders(
      {int page = 1, Map<String, dynamic>? params}) async {
    final apiResult = await get(
      Api.orders,
      queryParameters: {
        "page": page,
        ...(params ?? {}),
      },
    );
    print("Orders API result =======.$apiResult");

    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Order> orders = [];
      List<dynamic> jsonArray =
          (apiResponse.body is List) ? apiResponse.body : apiResponse.data;
      print("Arrray json $jsonArray");
      print("Parsed JSON Array: $jsonArray");
      for (var jsonObject in jsonArray) {
        try {
          orders.add(Order.fromJson(jsonObject));
        } catch (e) {
          print(e);
          rethrow;
        }
      }

      return orders;
    } else {
      throw apiResponse.message!;
    }
  }

  //
  Future<Order> getOrderDetails({required int id}) async {
    try {
      final apiResult = await get(Api.orders + "/$id");

      final apiResponse = ApiResponse.fromResponse(apiResult);
      print("order detail response =====> $apiResponse");
      if (apiResponse.allGood) {
        return Order.fromJson(apiResponse.body);
      } else {
        throw apiResponse.message!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //
  Future<String> updateOrder({int? id, String? status, String? reason}) async {
    final apiResult = await patch(Api.orders + "/$id", {
      "status": status,
      "reason": reason,
    });
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.message!;
    } else {
      throw apiResponse.message!;
    }
  }

  //
  Future<Order> trackOrder(String code, {int? vendorTypeId}) async {
    //
    final apiResult = await post(
      Api.trackOrder,
      body: {
        "code": code,
        "vendor_type_id": vendorTypeId,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse> updateOrderPaymentMethod({
    int? id,
    int? paymentMethodId,
    String? status,
  }) async {
    //
    final apiResult = await patch(
      Api.orders + "/$id",
      {
        "payment_method_id": paymentMethodId,
        "payment_status": status,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message!;
    }
  }

  Future<List<String>> orderCancellationReasons({
    Order? order,
  }) async {
    //
    final apiResult = await get(
      Api.cancellationReasons,
      queryParameters: {
        "type": (order?.isTaxi ?? false) ? "taxi" : "order",
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List).map((e) {
        return e['reason'].toString();
      }).toList();
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse> createTicket({
    required int orderId,
    required List<int> itemIds,
    required int isUser,
    required String title,
    required String? message,
    required List<File> photoPaths, // List of File objects
  }) async {
    try {
      final userToken = await AuthServices.getAuthBearerToken();

      // Prepare the form data
      FormData formData = FormData.fromMap({
        'order_id': orderId.toString(),
        'is_user': isUser.toString(),
        'message': message ?? "",
        'title': title,
        'items': json.encode(itemIds), // Convert itemIds to JSON string
      });

      // Add multiple photo files to the form data
      for (var photo in photoPaths) {
        formData.files.add(MapEntry(
          'photo', // Assuming the server expects the field name to be 'photo'
          await MultipartFile.fromFile(photo.path),
        ));
      }

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $userToken', // Add authorization token
        'Content-Type': 'multipart/form-data', // Set content type for form data
        // Add any other headers if necessary
      };

      // Send the request
      Response response = await dio!.post(
        Api.baseUrl + Api.createTicket,
        data: formData,
        options: Options(
          headers: headers, // Add headers to the request
        ),
      );

      // Handle the response using ApiResponse
      final apiResponse = ApiResponse.fromResponse(response);

      if (apiResponse.allGood) {
        return apiResponse;
      } else {
        throw apiResponse.message!;
      }
    } catch (e) {
      print("Error creating ticket: $e");
      rethrow;
    }
  }

  Future<Message?> replyToTicket({
    required int? ticketId,
    required String message,
    required bool isUser,
    required bool isAdmin,
    required bool isVendor,
    File? photo,
  }) async {
    try {
      final userToken = await AuthServices.getAuthBearerToken();

      FormData formData = FormData.fromMap({
        'ticket_id': ticketId.toString(),
        'message': message,
        'is_user': isUser ? '1' : '0',
        'is_admin': isAdmin ? '1' : '0',
        'is_vendor': isVendor ? '1' : '0',
        if (photo != null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      });

      final response = await dio!.post(
        Api.ticketReply,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      print('API Response: ${response.data}');

      final apiResponse = ApiResponse.fromResponse(response);

      if (apiResponse.allGood) {
        // Handle the response when no message data is returned
        if (apiResponse.data is Map<String, dynamic>) {
          return Message.fromJson(apiResponse.data as Map<String, dynamic>);
        } else if (apiResponse.data is List && apiResponse.data.isNotEmpty) {
          return Message.fromJson(apiResponse.data[0] as Map<String, dynamic>);
        } else {
          // Return null or a default Message if no actual message data is returned
          print('No message data returned from the API.');
          return null;
        }
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print("Error in replyToTicket: $e");
      rethrow;
    }
  }

  Future<List<Ticket>> getTickets() async {
    final userToken = await AuthServices.getAuthBearerToken();
    try {
      // Constructing the API URL
      final url = "https://mealknight.ca/api/ticket/list";

      // Making the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      // Checking for a successful response
      if (response.statusCode == 200) {
        final apiResponse = jsonDecode(response.body);
        print("Api Response =====> $apiResponse");
        List<Ticket> tickets = [];
        for (var ticketJson in apiResponse) {
          tickets.add(Ticket.fromJson(ticketJson));
        }
        return tickets;
      } else {
        print('Failed to get tickets =====> ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching tickets: $e');
      rethrow;
    }
  }

  Future<void> closeTicket(int ticketId) async {
    final response = await http.post(
      Uri.parse(Api.closeTicket),
      body: {
        'ticket_id': ticketId.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Ticket closed: ${response.body}');
    } else {
      print('Failed to close ticket: ${response.body}');
    }
  }
}
