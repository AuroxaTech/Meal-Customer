import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:mealknight/views/pages/vendor_search/vendor_search.page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'dart:ui' as ui;
import '../services/local_storage.service.dart';

class VendorDetailsViewModel extends MyBaseViewModel {
  VendorDetailsViewModel(
    BuildContext context,
    this.vendor,
  ) {
    viewContext = context;
  }

  final VendorRequest _vendorRequest = VendorRequest();

  Vendor? vendor;
  TabController? tabBarController;
  final currencySymbol = AppStrings.currencySymbol;

  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};

  Set<Marker>? mapMarkers;
  LatLng? pickupLatLng;
  LatLng? destinationLatLng;
  LatLng? driverLatLng;
  PolylinePoints polylinePoints = PolylinePoints();

  GoogleMapController? googleMapController;
  EdgeInsets googleMapPadding = EdgeInsets.only(top: kToolbarHeight);
  Set<Polyline> gMapPolylines = {};

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  Set<Marker> gMapMarkers = {};
  MarkerId driverMarkerId = const MarkerId("driverIcon");
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;
  bool canShowMap = true;

  //int travelTime = 0;
  //String travelDistance = '';
  String? currentAddress;

  int currentIndex = 0;
  LatLng? currentLocation, currentLocation1, destinationLocation;

  void getVendorDetails() async {
    setBusy(true);
    try {
      vendor = await _vendorRequest.vendorDetails(
        vendor!.id,
        params: {
          "type": "small",
        },
      );

      clearErrors();
      getCurrentLocation();
    } catch (error) {
      setError(error);
      if (kDebugMode) {
        print("error ==> $error");
      }
    }
    setBusy(false);
  }

  void productSelected(Product product) async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );
    notifyListeners();
  }

  void uploadPrescription() {
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => PharmacyUploadPrescription(vendor!)));
  }

  openVendorSearch() {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => VendorSearchPage(vendor!)));
  }

  void setMapController(GoogleMapController mController) {
    googleMapController = mController;
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

    googleMapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bound, 120),
    );
  }

  //
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

  onMapReady(GoogleMapController controller) async {
    googleMapController = controller;
    drawRoute(force: true);
    notifyListeners();
  }

  Future<void> drawRoute({bool force = false}) async {
    double latitude = (vendor?.latitude).toDouble();
    double longitude = (vendor?.longitude).toDouble();
    destinationLocation = LatLng(latitude, longitude);

    final Uint8List markerIconDestination =
        await _getMarkerIcon(Icons.pin_drop, Colors.green.shade900);
    final Uint8List markerIconCurrent =
        await _getMarkerIcon(Icons.gps_fixed_rounded, Colors.grey.shade300);

    if (currentLocation == null || force) {
      await getCurrentLocation();
    }

    Marker originMarker = Marker(
      markerId: const MarkerId('origin'),
      position: currentLocation!,
      icon: BitmapDescriptor.fromBytes(markerIconCurrent),
      infoWindow: const InfoWindow(title: 'Origin'),
    );

    gMapMarkers.clear();
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation!.latitude},${currentLocation!.longitude}'
        '&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}'
        '&key=AIzaSyBDc75DLs1UQ25VQfWAQhl4cthGEjaaV9Q&alternatives=true';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] != "ZERO_RESULTS") {
        //String duration = data['routes'][0]['legs'][0]['duration']['text'];
        //travelDistance = data['routes'][0]['legs'][0]['distance']['text'];
        //notifyListeners();
        //travelTime = int.tryParse(duration.split(' ').first) ?? 0;
        //vendor?.prepareTime = "${travelTime - 5}-${travelTime + 5}";
        Marker destinationMarker = Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation!,
          icon: BitmapDescriptor.fromBytes(markerIconDestination),
          // Use custom marker icon for destination
          infoWindow: const InfoWindow(title: 'Destination'),
        );
        notifyListeners();
        Set<Marker> markers = {originMarker, destinationMarker};
        notifyListeners();
        gMapMarkers = markers;
        List<LatLng> points =
            _decodePoly(data['routes'][0]['overview_polyline']['points']);
        notifyListeners();
        Set<Polyline> polylines = {};

        polylines.add(Polyline(
          polylineId: const PolylineId('route1'),
          visible: true,
          points: points,
          color: Colors.blueAccent,
          width: 5,
          startCap: Cap.customCapFromBitmap(
            await _createArrowBitmap(),
          ),
          // Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
        ));
        gMapPolylines = polylines;

        if (googleMapController != null) {
          googleMapController?.getZoomLevel().then((currentZoom) {
            googleMapController?.animateCamera(CameraUpdate.zoomTo(
              12,
            ));
          });
          notifyListeners();
        } else {
          print("Google Map controller is empty");
        }
        notifyListeners();
      } else {
        Set<Marker> markers = {originMarker};
        gMapMarkers = markers;
        if (googleMapController != null) {
          googleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                    currentLocation!.latitude, currentLocation!.longitude),
                zoom: 10.0,
              ),
            ),
          );
          notifyListeners();
        }
      }
      notifyListeners();
    } else {
      Set<Marker> markers = {originMarker};
      gMapMarkers = markers;
      if (googleMapController != null) {
        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentLocation!.latitude, currentLocation!.longitude),
              zoom: 10.0,
            ),
          ),
        );
      }
      notifyListeners();
      throw Exception('Failed to load route');
    }
    notifyListeners();
  }

  Future<BitmapDescriptor> _createArrowBitmap() async {
    const double width = 40.0;
    const double height = 30.0;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder,
        Rect.fromPoints(const Offset(0.0, 0.0), const Offset(width, height)));

    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(width / 2, height);
    path.lineTo(0.0, height / 2);
    path.lineTo(width / 4, height / 2);
    path.lineTo(width / 4, 0.0);
    path.lineTo(3 * width / 4, 0.0);
    path.lineTo(3 * width / 4, height / 2);
    path.lineTo(width, height / 2);
    path.lineTo(width / 2, height);

    // final Path path = Path();
    // path.moveTo(width / 2, 0.0);
    // path.lineTo(0.0, height / 2);
    // path.lineTo(width / 4, height / 2);
    // path.lineTo(width / 4, height);
    // path.lineTo(3 * width / 4, height);
    // path.lineTo(3 * width / 4, height / 2);
    // path.lineTo(width, height / 2);
    // path.lineTo(width / 2, 0.0);

    canvas.drawPath(path, paint);

    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<Uint8List> _createArrowPath() async {
    const double width = 40.0;
    const double height = 40.0;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder,
        Rect.fromPoints(const Offset(0.0, 0.0), const Offset(width, height)));

    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(width / 2, 0.0);
    path.lineTo(0.0, height / 2);
    path.lineTo(width / 4, height / 2);
    path.lineTo(width / 4, height);
    path.lineTo(3 * width / 4, height);
    path.lineTo(3 * width / 4, height / 2);
    path.lineTo(width, height / 2);
    path.lineTo(width / 2, 0.0);

    canvas.drawPath(path, paint);

    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  /*void getTravelTime() async {
    double latitude = (vendor?.latitude).toDouble();
    double longitude = (vendor?.longitude).toDouble();
    destinationLocation = LatLng(latitude, longitude);

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation!.latitude},${currentLocation!.longitude}'
        '&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}'
        '&key=AIzaSyBDc75DLs1UQ25VQfWAQhl4cthGEjaaV9Q&alternatives=true';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] != "ZERO_RESULTS") {
        ///
        String duration = data['routes'][0]['legs'][0]['duration']['text'];

        travelTime = int.tryParse(duration.split(' ').first) ?? 0;
        vendor?.prepareTime = "${travelTime - 5}-${travelTime + 5}";
        notifyListeners();
      } else {
        notifyListeners();
      }
    } else {
      notifyListeners();
      throw Exception('Failed to load route');
    }
    notifyListeners();
  }*/

  Future<Uint8List> _getMarkerIcon(IconData icon, Color color) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    const double radius = 22.0;

    canvas.drawCircle(const Offset(radius, radius), radius, paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: radius * 1.5,
        fontFamily: icon.fontFamily,
        color: Colors.white,
      ),
    );

    painter.layout();
    painter.paint(
      canvas,
      Offset(radius - painter.width / 2, radius - painter.height / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(
          (radius * 2).toInt(),
          (radius * 2).toInt(),
        );
    final data = await img.toByteData(format: ImageByteFormat.png);

    return data!.buffer.asUint8List();
  }

  List<LatLng> _decodePoly(String encoded) {
    var list = encoded.codeUnits;
    var index = 0;
    var len = encoded.length;
    int lat = 0, lng = 0;
    List<LatLng> poly = [];
    int shift, result, byte;
    while (index < len) {
      byte = 0;
      shift = 0;
      result = 0;
      do {
        byte = list[index] - 63;
        result |= (byte & 0x1F) << (shift * 5);
        shift++;
        index++;
      } while (byte >= 0x20);
      if ((result & 1) != 0) {
        lat += ~(result >> 1);
      } else {
        lat += (result >> 1);
      }
      shift = 0;
      result = 0;
      do {
        byte = list[index] - 63;
        result |= (byte & 0x1F) << (shift * 5);
        shift++;
        index++;
      } while (byte >= 0x20);
      if ((result & 1) != 0) {
        lng += ~(result >> 1);
      } else {
        lng += (result >> 1);
      }
      var latlng = LatLng(lat / 1E5, lng / 1E5);
      poly.add(latlng);
    }
    return poly;
  }

  Future<void> getCurrentLocation() async {
    try {
      gMapPolylines.clear();

      try {
        final storagePref = await LocalStorageService.getPrefs();
        currentAddress = storagePref.getString("current_address")!;
        if (currentAddress != null && currentAddress!.isNotEmpty) {
          List<Location> locations = await locationFromAddress(currentAddress!);
          for (var location in locations) {
            currentLocation = LatLng(location.latitude, location.longitude);
            currentLocation1 = LatLng(location.latitude, location.longitude);
            notifyListeners();
            drawRoute();
          }
        } else {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          currentLocation = LatLng(position.latitude, position.longitude);
          notifyListeners();
          drawRoute();
        }
      } catch (e) {
        print("getCurrentLocation Error: $e");
      }

      notifyListeners();
      //_drawRoute(currentIndex);
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

//
//   Future<void> updateDirectionIndicator(LatLng destination) async {
//
//     if(currentLocation == null)
//     {
//       await getCurrentLocation(false);
//     }
//       Set<Polyline> polylines = {};
//
//       polylines.add(Polyline(
//         polylineId: PolylineId('directionPolyline'),
//         color: Colors.red.shade100,
//         width: 5,
//         points: [currentLocation!, destination], // Update with current location and destination
//       ));
//       // Calculate rotation angle for arrow marker
//       double rotationAngle = getArrowRotation(currentLocation!, destination);
//
//       // Update arrow marker rotation
//       gMapMarkers.clear();
//       gMapMarkers.add(
//         Marker(
//           markerId: MarkerId('arrow'),
//           position: currentLocation!,
//           icon: arrowIcon,
//           rotation: rotationAngle,
//         ),
//       );
//       notifyListeners();
//   }
//
// // Calculate rotation angle for the arrow marker
//   double getArrowRotation(LatLng currentLocation, LatLng destination) {
//     double bearing = _calculateBearing(currentLocation, destination);
//
//     // Calculate rotation angle based on bearing
//     // Adjust rotation for left or right arrow indicator
//     if (bearing >= 0 && bearing <= 180) {
//       // Right arrow
//       return bearing - 90;
//     } else {
//       // Left arrow
//       return bearing + 90;
//     }
//   }
//
// // Calculate bearing between two points
//   double _calculateBearing(LatLng start, LatLng end) {
//     double startLat = _degreesToRadians(start.latitude);
//     double startLng = _degreesToRadians(start.longitude);
//     double endLat = _degreesToRadians(end.latitude);
//     double endLng = _degreesToRadians(end.longitude);
//
//     double dLng = endLng - startLng;
//     double dPhi = log(tan(endLat / 2 + pi / 4) / tan(startLat / 2 + pi / 4));
//     if (dLng.abs() > pi) {
//       if (dLng > 0) {
//         dLng = -(2 * pi - dLng);
//       } else {
//         dLng = (2 * pi + dLng);
//       }
//     }
//     return atan2(dLng, dPhi);
//   }
//
// // Convert degrees to radians
//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }
}
