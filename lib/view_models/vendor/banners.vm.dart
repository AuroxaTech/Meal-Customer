import 'package:flutter/material.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/banner.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/constants/app_routes.dart';

import '../../models/app_banner.dart';

class BannersViewModel extends MyBaseViewModel {
  BannersViewModel(
    BuildContext context,
    this.vendorType, {
    this.featured = false,
  }) {
    this.viewContext = context;
  }

  //
  BannerRequest _bannerRequest = BannerRequest();
  bool featured;
  VendorType? vendorType;

  //
  List<AppBanner> banners = [];
  int currentIndex = 0;

  //
  initialise() async {
    setBusy(true);
    try {
      banners = await _bannerRequest.banners(
            vendorTypeId: vendorType?.id,
            params: {
              "featured": featured ? "1" : "0",
            },
          ) ??
          [];
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  bannerSelected(AppBanner banner) {
    if (banner.link != null && banner.link!.isNotEmpty) {
      openWebpageLink(banner.link!);
    } else if (banner.vendor != null) {
      Navigator.of(viewContext).pushNamed(
        AppRoutes.vendorDetails,
        arguments: banner.vendor,
      );
    }
  }
}
