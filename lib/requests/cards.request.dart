import 'package:dio/dio.dart';

import '../models/api_response.dart';
import '../models/payment_card.dart';
import '../models/user.dart';
import '../services/auth.service.dart';
import '../services/http.service.dart';

class CardsRequest extends HttpService {
  //
  Future<void> saveCard({

    required String uuid,
    required String nonce,
    required User user,
    required String addressLineOne,
    String? addressLineTwo,
    required String locality,
    required String administrativeDistrictLevelOne,
    required String postalCode,
    required String country,
  }) async {
    final userToken = await AuthServices.getAuthBearerToken();

    /*"billing_address": {
          "address_line_1": "1777 Upland Dr.",
          "address_line_2": "",
          "locality": "Vancouver",
          "administrative_district_level_1": "BC",
          "postal_code": "V5P 2C3",
          "country": "CA"
        },*/
    Map<String, dynamic> body = {
      "idempotency_key": uuid,
      "source_id": nonce,
      "card": {
        "billing_address": {
          "address_line_1": addressLineOne,
          "address_line_2": addressLineTwo ?? "",
          "locality": locality,
          "administrative_district_level_1": administrativeDistrictLevelOne,
          "postal_code": postalCode,
          "country": country,
        },
        "cardholder_name": user.name,
        "customer_id": user.squareCustomerId,
        "reference_id": "user-id-${user.id}",
      }
    };

    print(body);

    //
    final apiResult = await post("/v2/cards",
        body: body,
        /*baseUrl: "https://connect.squareupsandbox.com",
        headers: {
          'Square-Version': '2024-05-15',
          'Authorization':
              'Bearer EAAAlx7cpK3mNRBAr4A5rlY35mh4QXa41qUODPhhjU00Eyicl0GK30FSM5FQn8gz',
          'Content-Type': 'application/json'
        });*/

        baseUrl: "https://connect.squareup.com",
        headers: {
          'Square-Version': '2024-06-04',
          'Authorization':
              'Bearer $userToken',
          'Content-Type': 'application/json'
        });

    print("queryParameters ==> $body");
    print(apiResult.data);
    return;

    /*final apiResponse = ApiResponse.fromResponse(apiResult);
    print(apiResponse.data);
    if (apiResponse.allGood) {
      //return apiResponse.data.map((jsonObject) => Coupon.fromJson(jsonObject)).toList();
    }
    throw apiResponse.message!;*/
  }

  Future<List<PaymentCard>> getCards(User user) async {
    final userToken = await AuthServices.getAuthBearerToken();
    print("User Token =====> $userToken");

    Map<String, dynamic> queryParameters = {
      "customer_id": user.squareCustomerId,
    };
    print("Card id =====> ${user.squareupDefaultCardId}");

    final apiResult = await get('/v2/cards',
        queryParameters: queryParameters,
        /*baseUrl: "https://connect.squareupsandbox.com",
        headers: {
          'Square-Version': '2024-05-15',
          'Authorization': 'Bearer EAAAlx7cpK3mNRBAr4A5rlY35mh4QXa41qUODPhhjU00Eyicl0GK30FSM5FQn8gz',
          'Content-Type': 'application/json'
        });*/
        baseUrl: 'https://connect.squareup.com',

          headers: {
            'Square-Version': '2024-03-20',
            'Authorization':
            'Bearer EAAAl_WIGd9u-3YE-HHtVvXRJGFeVC2JTqMv-BGiOdUTgbbfqb41ZcCo7JY2MQ-U',
            'Content-Type': 'application/json',
          },
        );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    print("Cards Detail =======> ${apiResponse.body}");

    if (apiResponse.allGood && apiResponse.body.containsKey('cards')) {
      List<PaymentCard> orders = [];
      List<dynamic> jsonArray = apiResponse.body['cards'];
      for (var jsonObject in jsonArray) {
        try {
          orders.add(PaymentCard.fromJson(jsonObject));
        } catch (e) {
          print("Error getting cards ====> $e");
          rethrow;
        }
      }

      return orders;
    } else {
      print("Api Response Message ====> ${apiResponse.message}");
      return [];
      //throw apiResponse.message!;
    }
  }

  Future<bool?> disableCard(String cardId) async {
    final userToken = await AuthServices.getAuthBearerToken();
    final apiResult = await post("/v2/cards/$cardId/disable",
        /*baseUrl: "https://connect.squareupsandbox.com",
        headers: {
          'Square-Version': '2024-05-15',
          'Authorization': 'Bearer EAAAlx7cpK3mNRBAr4A5rlY35mh4QXa41qUODPhhjU00Eyicl0GK30FSM5FQn8gz',
          'Content-Type': 'application/json'
        });*/

        baseUrl: "https://connect.squareup.com",
        headers: {
          'Square-Version': '2024-06-04',
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json'
        });

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return true;
    } else {
      throw apiResponse.message!;
    }
  }
}
