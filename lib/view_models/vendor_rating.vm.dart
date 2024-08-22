import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class VendorRatingViewModel extends MyBaseViewModel {
  VendorRequest vendorRequest = VendorRequest();
  Order order;
  Function onSubmitted;
  int rating = 1;
  TextEditingController reviewTEC = TextEditingController();

  VendorRatingViewModel(BuildContext context, this.order, this.onSubmitted) {
    viewContext = context;
  }

  void updateRating(String value) {
    rating = double.parse(value).ceil();
  }

  submitRating() async {
    setBusy(true);
    final apiResponse = await vendorRequest.rateVendor(
      rating: rating,
      review: reviewTEC.text,
      orderId: order.id,
      vendorId: order.vendor!.id,
    );
    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Vendor Rating".tr(),
      text: apiResponse.message,
      onConfirmBtnTap: apiResponse.allGood
          ? () {
              //
              Navigator.of(viewContext).pop();
              //
              onSubmitted();
            }
          : null,
    );
  }
}
