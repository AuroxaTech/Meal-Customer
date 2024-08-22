import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

mixin QrcodeScannerTrait {
  //scanning
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  bool flashEnabled = false;

  Future<String?> openScanner(BuildContext viewContext) async {
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
                      Navigator.of(viewContext).pop(barcodes.first.rawValue);
                    }
                  }),
                /*onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  //final Uint8List? image = capture.image;
                  for (final barcode in barcodes) {
                    debugPrint('Barcode found! ${barcode.rawValue}');
                  }
                  if (barcodes.isNotEmpty) {
                    Navigator.of(viewContext).pop(barcodes.first.rawValue);
                  }
                },*/
              ),
            ],
          ),
        );
      },

      //
    );

    //
    print("Results ==> $result");
    //
    FocusScope.of(viewContext).requestFocus(FocusNode());
    return result;
  }
}
