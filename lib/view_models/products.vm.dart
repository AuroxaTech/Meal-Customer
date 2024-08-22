import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/enums/product_fetch_data_type.enum.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/product.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';

class ProductsViewModel extends MyBaseViewModel {
  ProductsViewModel(
    BuildContext context,
    this.vendorType,
    this.type, {
    this.categoryId,
    this.byLocation = true,
  }) {
    viewContext = context;
    byLocation = AppStrings.enableFatchByLocation;
  }

  User? currentUser;

  VendorType? vendorType;
  int? categoryId;
  ProductFetchDataType type;
  ProductRequest productRequest = ProductRequest();
  List<Product> products = [];
  bool byLocation;

  bool get anyProductWithOptions {
    try {
      return products.firstOrNullWhere(
            (e) =>
                e.optionGroups.isNotEmpty &&
                e.optionGroups.first.options.isNotEmpty,
          ) !=
          null;
    } catch (error) {
      return false;
    }
  }

  void initialise() async {
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    deliveryaddress?.address = LocationService.currenctAddress?.addressLine;
    deliveryaddress?.latitude =
        LocationService.currenctAddress?.coordinates?.latitude;
    deliveryaddress?.longitude =
        LocationService.currenctAddress?.coordinates?.longitude;
    //get today picks
    fetchProducts();
  }

  fetchProducts() async {
    setBusy(true);
    try {
      Map<String, dynamic> queryParams = {
        "category_id": categoryId,
        "vendor_type_id": vendorType?.id,
        "type": type.name.toLowerCase(),
      };

      if (byLocation && deliveryaddress?.latitude != null) {
        queryParams.addAll({
          "latitude": deliveryaddress?.latitude,
          "longitude": deliveryaddress?.longitude,
        });
      }

      products = await productRequest.getProdcuts(
        queryParams: queryParams,
      );
    } catch (error) {
      if (kDebugMode) {
        print("fetchProducts Error ==> $error");
      }
    }
    setBusy(false);
  }
}
