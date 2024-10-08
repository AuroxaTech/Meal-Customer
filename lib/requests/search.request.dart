import 'dart:convert';

import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/models/search_data.dart';
import 'package:mealknight/models/service.dart';
import 'package:mealknight/models/tag.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/services/http.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/services/search.service.dart';

class SearchRequest extends HttpService {
  //
  Future<List<Tag>> getTags() async {
    final apiResult = await get(Api.tags);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List).map(
        (jsonObject) {
          return Tag.fromJson(jsonObject);
        },
      ).toList();
    }
    throw apiResponse.message!;
  }

  Future<SearchData> getSearchFilterData({int? vendorTypeId}) async {
    final apiResult = await get(
      Api.searchData,
      queryParameters: {
        "vendor_type_id": vendorTypeId,
      },
    );
    print("search      ==> $apiResult");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return SearchData.fromJson(apiResponse.body);


    }
    throw apiResponse.message!;
  }

  //
  Future<List<dynamic>> searchRequest({
    String keyword = "",
    String? type,
    required Search search,
    int page = 1,
  }) async {
    //save the search keyword
    if (keyword.isNotEmpty) {
      await SearchService.saveSearchHistory(keyword);
    }
    //
 try{
   Map<String, dynamic> params = {
     "merge": "1",
     "page": page,
     "keyword": keyword,
     "category_id": (search.subcategory == null && search.category != null)
         ? search.category?.id
         : null,
     "subcategory_id":
     search.subcategory != null ? search.subcategory?.id : '',
     "vendor_type_id": search.vendorType != null ? search.vendorType?.id : "",
     "vendor_id": search.vendorId ?? "",
     "type": type ?? search.type,
     "min_price": search.minPrice,
     "max_price": search.maxPrice,
     "sort": search.sort,
     "tags": search.tags?.map((e) => e.id).toList(),
   };

   //
   if (search.byLocation ?? true) {
     params = {
       ...params,
       "latitude": LocationService.currenctAddress?.coordinates?.latitude,
       "longitude": LocationService.currenctAddress?.coordinates?.longitude,
     };
   }

   print("params ==> ${jsonEncode(params)}");
   final apiResult = await get(Api.search, queryParameters: params,includeHeaders: true);

   final apiResponse = ApiResponse.fromResponse(apiResult);
   print("My response ==> ${apiResponse.body}");
   if (apiResponse.allGood) {
     //
     List<dynamic> result = [];

     //
     type ??= search.type;

     //
     result = (apiResponse.data).map(
           (jsonObject) {
         dynamic model;
         if (type == 'product') {
           model = Product.fromJson(jsonObject);
         } else if (type == "vendor") {
           model = Vendor.fromJson(jsonObject);
         } else if (type == "service") {
           model = Service.fromJson(jsonObject);
         } else {
           model = Product.fromJson(jsonObject);
         }
         return model;
       },
     ).toList();
     print("my resul $result");
     return result;
   }
 }catch(e){
   print("error ==> ${e}");
   rethrow;

 }

    throw dynamic;
  }
}
