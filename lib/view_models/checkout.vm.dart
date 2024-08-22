import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/view_models/checkout_base.vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/payment_card.dart';
import '../models/user.dart';
import '../services/auth.service.dart';
import '../views/pages/payment/payment_screen.dart';

class CheckoutViewModel extends CheckoutBaseViewModel {
  Set<Marker>? mapMarkers;
  LatLng? pickupLatLng;
  LatLng? destinationLatLng;
  LatLng? driverLatLng;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController? controller;

  CheckoutViewModel(
    BuildContext context,
    CheckOut checkout,
  ) {
    viewContext = context;
    this.checkout = checkout;
  }

  void changePaymentMethod() async {
    await Navigator.push(
      viewContext,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
    User user = await AuthServices.getCurrentUser(force: true);
    paymentCard = paymentCards
        .firstOrNullWhere((e) => e.id == user.squareupDefaultCardId);
    notifyListeners();
  }

  void setMapController(GoogleMapController mController) async{
    controller = mController;
    notifyListeners();
    //zoom map camera to bound
    zoomToLatLngBound();
  }

  zoomToLatLngBound() {
    if (driverLatLng == null || destinationLatLng == null) {
      return;
    }
    LatLngBounds bound = boundsFromLatLngList(
      [driverLatLng!, destinationLatLng!],
    );

    controller?.animateCamera(
      CameraUpdate.newLatLngBounds(bound, 120),
    );
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0;
    double? x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0.00)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0.00)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? 0.00)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1 ?? 0.00, y1 ?? 0.00),
        southwest: LatLng(x0 ?? 0.00, y0 ?? 0.00));
  }
}
