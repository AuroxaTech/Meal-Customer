import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mealknight/models/category.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/category.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:mealknight/models/app_banner.dart';
import '../requests/banner.request.dart';

class VendorViewModel extends MyBaseViewModel {
  VendorViewModel(BuildContext context, VendorType vendorType) {
    viewContext = context;
    this.vendorType = vendorType;
  }

  User? currentUser;
  StreamSubscription? currentLocationChangeStream;

  int queryPage = 1;

  RefreshController refreshController = RefreshController();
  BannerRequest _bannerRequest = BannerRequest();
  List<AppBanner> banners = [];

  List<Category> categories = [];

  CategoryRequest _categoryRequest = CategoryRequest();

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    //listen to user location change
    currentLocationChangeStream =
        LocationService.currenctAddressSubject.stream.listen(
      (location) {
        //
        deliveryaddress ??= DeliveryAddress();
        deliveryaddress!.address = location.addressLine;
        deliveryaddress!.latitude = location.coordinates?.latitude;
        deliveryaddress!.longitude = location.coordinates?.longitude;
        notifyListeners();
      },
    );

    fetchSubCategories();
    banners = await _bannerRequest.banners(
          vendorTypeId: vendorType?.id,
          params: {
            "featured": "1",
          },
        ) ??
        [];
    notifyListeners();
  }

  fetchSubCategories() async {
    setBusy(true);
    try {
      categories = await _categoryRequest.categories(
        vendorTypeId: vendorType?.id,
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  bannerSelected(AppBanner banner) {
    if (banner.link != null && banner.link!.isNotEmpty) {
      openWebpageLink(banner.link!);
    }
    // } else if (banner.vendor != null) {
    //   Navigator.of(viewContext).pushNamed(
    //     AppRoutes.vendorDetails,
    //     arguments: banner.vendor,
    //   );
    // } else {
    //   Navigator.of(viewContext).pushNamed(
    //     AppRoutes.search,
    //     arguments: Search(category: banner!.category!),
    //   );
    // }
  }

  //switch to use current location instead of selected delivery address
  void useUserLocation() {
    LocationService.geocodeCurrentLocation();
  }

  //
  dispose() {
    super.dispose();
    currentLocationChangeStream?.cancel();
  }

}
