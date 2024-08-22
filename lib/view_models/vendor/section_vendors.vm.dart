import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';

import '../../models/category.dart';

class SectionVendorsViewModel extends MyBaseViewModel {
  SectionVendorsViewModel(
    BuildContext context,
    this.vendorType, {
    this.type = SearchFilterType.you,
    this.byLocation = false,
    this.category,
  }) {
    this.viewContext = context;
  }

  List<Vendor> vendors = [];
  VendorType? vendorType;
  SearchFilterType type;
  bool? byLocation;
  VendorRequest _vendorRequest = VendorRequest();
  Category? category;

  initialise() {
    fetchVendors();
  }

  fetchVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: byLocation ?? true,
        params: {
          "vendor_type_id": vendorType?.id,
          "category_id": category?.id,
          "type": type.name,
        },
      );

      /*for (Vendor vendor in vendors) {
        Utils.vendorDistanceFromDefaultAddress(vendor).then((value) {
          vendor.distance = value;
          notifyListeners();
        });
      }*/

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  vendorSelected(Vendor vendor) async {
    Navigator.of(viewContext)
        .pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    )
        .then((value) {
      if (null != value && value is bool && value) {
        ///may be favorite is changes, just reload
        fetchVendors();
      }
    });
  }

  void onFavoriteChange(int index, bool isFavorite) {
    vendors[index].isFavorite = isFavorite;
    if (vendors[index].id == vendor?.id) {
      vendor?.isFavorite = isFavorite;
    }
    notifyListeners();
  }
}
