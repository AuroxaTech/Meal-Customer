import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/order.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/views/pages/order/orders_details.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class ParcelViewModel extends MyBaseViewModel {
  ParcelViewModel(
    BuildContext context, {
    required this.vendorType,
  }) {
    viewContext = context;
  }

  VendorType? vendorType;
  OrderRequest orderRequest = OrderRequest();
  RefreshController refreshController = RefreshController();
  GlobalKey pageKey = GlobalKey<State>();
  Order? order;
  MobileScannerController mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: true,
  );

  //scanning
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flashEnabled = false;

  void reloadPage() {
    refreshController.refreshCompleted();
    pageKey = GlobalKey<State>();
    refreshController = RefreshController();
    notifyListeners();
  }

  //
  trackOrder(String orderCode) async {
    setBusy(true);

    try {
      order = await orderRequest.trackOrder(
        orderCode,
        vendorTypeId: vendorType?.id,
      );
      clearErrors();

      //open order details
      viewContext.nextPage(
        OrderDetailsPage(
          order: order!,
          isOrderTracking: true,
        ),
      );
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
      //
      CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Track your package".tr(),
          text: "$error");
    }

    setBusy(false);
  }

  //
  void openCodeScanner() async {
    //
    final result = await showDialog(
      context: viewContext,
      builder: (context) {
        return Dialog(
          child: VStack(
            [
              //qr code preview
              MobileScanner(
                key: qrKey,
                // fit: BoxFit.contain,

                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                  facing: CameraFacing.back,
                  torchEnabled: true,
                )..barcodes.first.then((capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    //final Uint8List? image = capture.image;
                    for (final barcode in barcodes) {
                      debugPrint('Barcode found! ${barcode.rawValue}');
                    }
                    if (barcodes.isNotEmpty) {
                      //cloe dialog
                      Navigator.of(viewContext).pop();
                      //start searching
                      trackOrder(barcodes.first.rawValue!);
                    }
                  }),
                /*onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  //final Uint8List? image = capture.image;
                  for (final barcode in barcodes) {
                    debugPrint('Barcode found! ${barcode.rawValue}');
                  }
                  if (barcodes.isNotEmpty) {
                    //cloe dialog
                    Navigator.of(viewContext).pop();
                    //start searching
                    trackOrder(barcodes.first.rawValue!);
                  }
                },*/
              ),
            ],
          ),
        );
      },
    );

    //
    print("Results ==> $result");
    //
    FocusScope.of(viewContext).requestFocus(FocusNode());
  }
}
