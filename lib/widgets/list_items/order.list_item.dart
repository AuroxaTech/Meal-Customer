import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_strings.dart';
import '../../models/order.dart';
import '../../view_models/vendor_details.vm.dart';
import '../custom_image.view.dart';

class OrderListItem extends StatefulWidget {
  const OrderListItem({
    required this.order,
    required this.onPayPressed,
    required this.orderPressed,
    super.key,
  });

  final Order order;
  final Function onPayPressed;
  final Function orderPressed;

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  VendorDetailsViewModel? vendorDetailsViewModel;

  @override
  void initState() {
    super.initState();
    VendorDetailsViewModel tempViewModel =
    VendorDetailsViewModel(context, widget.order.vendor);
    tempViewModel.getCurrentLocation().then((value) {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          vendorDetailsViewModel = tempViewModel;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppStrings.currencySymbol;

    return GestureDetector(
      onTap: () {
        widget.orderPressed();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          border: Border.all(width: 2, color: AppColor.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(28)),
              child: AspectRatio(
                aspectRatio: 21 / 9,
                child: CustomImage(
                  imageUrl: widget.order.vendor?.featureImage ?? "",
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.order.vendor?.name ?? "",
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),

                          "${widget.order.total}"
                              .text
                              .lg
                              .color(AppColor.primaryColor)
                              .semiBold
                              .make(),
                          currencySymbol.text.lg
                              .color(AppColor.primaryColor)
                              .semiBold
                              .make(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              Jiffy.parse("${widget.order.createdAt}",
                                      pattern: "yyyy-MM-dd HH:mm")
                                  .format(pattern: "d MMM, y  EEEE"),
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.order.status,
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).px8(),
                if (widget.order.canRateFood)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Rate Your Food",
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Image.asset(
                        AppImages.thumbsUp,
                        height: 26,
                      ),
                      Image.asset(
                        AppImages.thumbsDown,
                        height: 26,
                      ),
                    ],
                  ).px8(),
                if (widget.order.canRateDriver)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Rate Your Driver",
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Image.asset(
                        AppImages.thumbsUp,
                        height: 26,
                      ),
                      Image.asset(
                        AppImages.thumbsDown,
                        height: 26,
                      ),
                    ],
                  ).px8(),
                const SizedBox(
                  height: 4.0,
                ),
                if ((!widget.order.canRateFood ||
                        !widget.order.canRateDriver) &&
                    widget.order.showStatusTracking &&
                    null != vendorDetailsViewModel)
                  ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: ViewModelBuilder<VendorDetailsViewModel>.reactive(
                              viewModelBuilder: () => VendorDetailsViewModel(
                                    context,
                                    widget.order.vendor,
                                  ),
                              onViewModelReady: (model) {
                                model.getVendorDetails();
                              },
                              builder: (context, model, child) {
                                return GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      vendorDetailsViewModel!
                                              .currentLocation?.latitude ??
                                          vendorDetailsViewModel!
                                              .currentLocation1!.latitude,
                                      vendorDetailsViewModel!
                                              .currentLocation?.longitude ??
                                          vendorDetailsViewModel!
                                              .currentLocation1!.longitude,
                                    ),
                                    zoom: 150,
                                  ),
                                  myLocationButtonEnabled: true,
                                  trafficEnabled: true,
                                  onMapCreated:
                                      vendorDetailsViewModel!.onMapReady,
                                  // onCameraIdle: vm.taxiGoogleMapManagerService.onMapCameraIdle,
                                  padding:
                                      vendorDetailsViewModel!.googleMapPadding,
                                  markers: vendorDetailsViewModel!.gMapMarkers,
                                  polylines:
                                      vendorDetailsViewModel!.gMapPolylines,
                                  zoomControlsEnabled: true,
                                  myLocationEnabled: true,
                                  zoomGesturesEnabled: true,
                                );
                              }))
                      .h(220)
                      .w(context.percentWidth * 95)
                      .box
                      .clip(Clip.antiAlias)
                      .withRounded(value: 16.0)
                      .make(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
