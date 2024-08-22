import 'package:flutter/material.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/requests/favourite.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';

class FavouriteVendorViewModel extends MyBaseViewModel {
  FavouriteRequest favouriteRequest = FavouriteRequest();
  final Vendor vendor;
  final Function(bool isFavorite) onFavoriteChange;

  FavouriteVendorViewModel(BuildContext context, this.vendor,this.onFavoriteChange) {
    viewContext = context;
  }

  removeFavouriteVendor() async {
    setBusy(true);
    final apiResponse = await favouriteRequest.removeFavouriteVendor(
      vendor.id,
    );
    if (apiResponse.allGood) {
      vendor.isFavorite = false;
      onFavoriteChange.call(false);
    } else {
      toastError("${apiResponse.message}");
    }
    notifyListeners();
    setBusy(false);
  }

  addFavouriteVendor() async {
    setBusy(true);
    final apiResponse = await favouriteRequest.makeFavouriteVendor(
      vendor.id,
    );
    if (apiResponse.allGood) {
      vendor.isFavorite = true;
      onFavoriteChange.call(true);
    } else {
      toastError("${apiResponse.message}");
    }
    notifyListeners();
    setBusy(false);
  }
}
