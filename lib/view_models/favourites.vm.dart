import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/requests/favourite.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

import '../models/vendor.dart';
import '../utils/utils.dart';

class FavouritesViewModel extends MyBaseViewModel {
  FavouriteRequest favouriteRequest = FavouriteRequest();
  List<Product> products = [];
  List<Vendor> vendorList = [];

  FavouritesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  void initialise() {
    fetchProducts();
    fetchVendor();
  }

  //
  fetchProducts() async {
    setBusyForObject(products, true);
    try {
      products = await favouriteRequest.favourites();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(products, false);
  }

  fetchVendor() async {
    setBusyForObject(vendorList, true);
    try {
      vendorList = await favouriteRequest.favouritesVendor();
      /*for (Vendor vendor in vendorList) {
        Utils.vendorDistanceFromDefaultAddress(vendor).then((value) {
          vendor.distance = value;
          notifyListeners();
        });
      }*/
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(vendorList, false);
  }

  removeFavourite(Product product) {
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.confirm,
        title: "Remove Product From Favourite".tr(),
        text:
            "Are you sure you want to remove this product from your favourite list?"
                .tr(),
        confirmBtnText: "Remove".tr(),
        onConfirmBtnTap: () {
          Navigator.of(viewContext).pop();
          processRemove(product);
        });
  }

  removeFavouriteVendor(Vendor vendor) {
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.confirm,
        title: "Remove Vendor From Favourite".tr(),
        text:
            "Are you sure you want to remove this vendor from your favourite list?"
                .tr(),
        confirmBtnText: "Remove".tr(),
        onConfirmBtnTap: () {
          processRemoveVendor(vendor);
        });
  }

  processRemoveVendor(Vendor vendor) async {
    setBusy(true);
    final apiResponse = await favouriteRequest.removeFavouriteVendor(
      vendor.id,
    );
    //remove from list
    if (apiResponse.allGood) {
      vendorList.remove(vendor);
    }
    setBusy(false);
    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Remove Vendor From Favourite".tr(),
      text: apiResponse.message,
    );
  }

  processRemove(Product product) async {
    setBusy(true);
    final apiResponse = await favouriteRequest.removeFavourite(
      product.id,
    );
    //remove from list
    if (apiResponse.allGood) {
      products.remove(product);
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Remove Product From Favourite".tr(),
      text: apiResponse.message,
    );
  }

  openProductDetails(Product product) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );
  }
  openVendorDetails(Vendor vendor) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
}
