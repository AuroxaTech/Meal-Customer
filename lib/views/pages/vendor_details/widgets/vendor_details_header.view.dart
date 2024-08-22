import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_font.dart';
import '../../../../constants/app_images.dart';
import '../../../../models/vendor.dart';
import '../../../../services/location.service.dart';
import '../../../../utils/utils.dart';
import '../../../../view_models/vendor_details.vm.dart';
import '../../../../view_models/vendor_distance.vm.dart';
import '../../../../widgets/cards/custom.visibility.dart';
import '../../../../widgets/custom_image.view.dart';

class VendorDetailsHeader extends StatefulWidget {
  const VendorDetailsHeader(this.model,
      {this.showFeatureImage = true, super.key});

  final VendorDetailsViewModel model;
  final bool showFeatureImage;

  @override
  State<VendorDetailsHeader> createState() => _VendorDetailsHeaderState();
}

class _VendorDetailsHeaderState extends State<VendorDetailsHeader> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) newState) {
      return VStack(
        [
          VStack(
            [
              CustomVisibilty(
                visible: widget.showFeatureImage,
                child: CustomImage(
                  imageUrl: widget.model.vendor!.featureImage,
                  height: 220,
                  canZoom: true,
                ).wFull(context),
              ),
              HStack(
                [
                  VStack(
                    [
                      widget.model.vendor!.name.text
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primary)
                          .size(20)
                          .make(),
                      CustomVisibilty(
                        visible: widget
                            .model.vendor!.description.isNotEmptyAndNotNull,
                        child: widget.model.vendor!.description.text.light.sm
                            .fontFamily(AppFonts.appFont)
                            .color(AppColor.primary)
                            .maxLines(1)
                            .make(),
                      ),
                    ],
                  ).pOnly(left: Vx.dp12).expand(),
                  //icons
                  VStack(
                    [
                      Column(
                        children: [
                          Row(
                            children: [
                              (widget.model.vendor?.rating.toDouble() ?? 0)
                                  .toString()
                                  .text
                                  .lg
                                  .fontFamily(AppFonts.appFont)
                                  .color(AppColor.primaryColor)
                                  .thin
                                  .make(),
                              FittedBox(
                                  child: Image.asset(AppImages.goldenStar,
                                      height: 35))
                            ],
                          ),
                          "(${widget.model.vendor!.reviewsCount} ${'Reviews'.tr()})"
                              .text
                              .sm
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .thin
                              .make(),
                        ],
                      ),
                    ],
                  ).pOnly(left: Vx.dp12),
                ],
              ).p8(),
            ],
          ),

          //
          //
          HStack(
            [
              Expanded(
                child: ValueListenableBuilder<Vendor?>(
                  valueListenable: VendorDistanceViewModel()
                      .listenToKey(widget.model.vendor?.id ?? -1),
                  builder: (BuildContext context, Vendor? value, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: VendorDistanceViewModel().isPickup,
                      builder: (BuildContext context, bool isPickup, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //can deliveree
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                decoration: !isPickup
                                    ? BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      )
                                    : const BoxDecoration(),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      HStack([
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Image.asset(
                                                  "assets/images/icons/carVectoricon.png",
                                                  height: 20,
                                                  width: 20,
                                                ).pOnly(left: 8, right: 4),
                                              ),
                                              WidgetSpan(
                                                  child: "Delivery"
                                                      .tr()
                                                      .text
                                                      .lineHeight(1)
                                                      .fontFamily(
                                                          AppFonts.appFont)
                                                      .fontWeight(
                                                          FontWeight.bold)
                                                      .size(15)
                                                      .color(Utils.isDark(
                                                              AppColor
                                                                  .deliveryColor)
                                                          ? Colors.white
                                                          : AppColor
                                                              .primaryColor)
                                                      .make()
                                                      .box
                                                      .roundedLg
                                                      .make()
                                                      .pOnly(right: 8)),
                                              TextSpan(
                                                  text:
                                                      "\n${((value?.minPrepareTime ?? 20) + (value?.travelTime ?? 0) + 5)} - ${((value?.maxPrepareTime ?? 20) + (value?.travelTime ?? 0) + 5)} min",
                                                  style: TextStyle(
                                                    color:
                                                        AppColor.primaryColor,
                                                    fontFamily:
                                                        AppFonts.appFont,
                                                    fontSize: 10,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ])
                                    ])).onInkTap(() {
                              VendorDistanceViewModel().onUpdatePickup(false);
                            }),
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                              decoration: isPickup
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    )
                                  : const BoxDecoration(),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    HStack([
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Image.asset(
                                                "assets/images/icons/pedestrian.png",
                                                height: 20,
                                                width: 20,
                                              ).pOnly(left: 4, right: 2),
                                            ),
                                            WidgetSpan(
                                                child: "Pickup"
                                                    .tr()
                                                    .text
                                                    .lineHeight(1)
                                                    .fontFamily(
                                                        AppFonts.appFont)
                                                    .fontWeight(FontWeight.bold)
                                                    .size(15)
                                                    .color(Utils.isDark(AppColor
                                                            .deliveryColor)
                                                        ? Colors.white
                                                        : AppColor.primaryColor)
                                                    .make()
                                                    .box
                                                    .roundedLg
                                                    .make()
                                                    .pOnly(right: 8)),
                                            TextSpan(
                                                text:
                                                    "\n${((value?.minPrepareTime ?? 20) + 5)} - ${((value?.maxPrepareTime ?? 30) + 5)} min",
                                                style: TextStyle(
                                                  color: AppColor.primaryColor,
                                                  fontFamily: AppFonts.appFont,
                                                  fontSize: 10,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ])
                                  ]),
                            ).onInkTap(() {
                              VendorDistanceViewModel().onUpdatePickup(true);
                            })
                          ],
                        )
                            .px8()
                            .box
                            .withRounded(value: 32)
                            .p8
                            .border(color: AppColor.primaryColor, width: 2)
                            .make();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                widget.model.canShowMap
                    ? Image.asset(
                        "assets/images/icons/location 1.png",
                        height: 35,
                      ).pOnly(left: 8).onInkTap(() async {
                        widget.model.canShowMap = false;
                        if (widget.model.currentLocation == null) {
                          await widget.model.getCurrentLocation();
                        }
                        LatLng? currentLocation = widget.model.currentLocation;

                        if (currentLocation == null) {
                          Position position =
                              await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high,
                          );
                          currentLocation =
                              LatLng(position.latitude, position.longitude);
                        }
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) newState) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  content: ViewModelBuilder<
                                          VendorDetailsViewModel>.reactive(
                                      viewModelBuilder: () =>
                                          VendorDetailsViewModel(
                                            context,
                                            widget.model.vendor,
                                          ),
                                      onViewModelReady: (model) {
                                        model.getVendorDetails();
                                      },
                                      builder: (context, model, child) {
                                        return Container(
                                          height: MediaQuery.sizeOf(context)
                                              .shortestSide,
                                          width: MediaQuery.sizeOf(context)
                                              .shortestSide,
                                          margin: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 4,
                                                  color:
                                                      AppColor.primaryColor)),
                                          child: GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                currentLocation?.latitude ??
                                                    LocationService
                                                        .currenctAddress
                                                        ?.coordinates
                                                        ?.latitude ??
                                                    0.00,
                                                currentLocation?.longitude ??
                                                    LocationService
                                                        .currenctAddress
                                                        ?.coordinates
                                                        ?.longitude ??
                                                    0.00,
                                              ),
                                              zoom: 10.0,
                                            ),
                                            //   onCameraMove: (CameraPosition position) {
                                            //     // Update direction indicator based on camera movement
                                            // model.updateDirectionIndicator(position.target);
                                            //   },
                                            myLocationButtonEnabled: true,
                                            trafficEnabled: true,
                                            onMapCreated: model.onMapReady,
                                            // onCameraIdle: vm.taxiGoogleMapManagerService.onMapCameraIdle,
                                            padding: model.googleMapPadding,
                                            markers: model.gMapMarkers,
                                            polylines: model.gMapPolylines,
                                            zoomControlsEnabled: false,
                                            myLocationEnabled: true,
                                          )
                                              .h(MediaQuery.sizeOf(context)
                                                      .shortestSide -
                                                  10)
                                              .w(MediaQuery.sizeOf(context)
                                                      .shortestSide -
                                                  30)
                                              .box
                                              .clip(Clip.antiAlias)
                                              .withRounded(value: 15.0)
                                              .make(),
                                        );
                                      }),
                                );
                              },
                            );
                          },
                        ).then((value) {
                          widget.model.canShowMap = true;
                          newState(() {});
                        });
                      })
                    : const SizedBox(),
                10.heightBox,
                Image.asset(
                  "assets/images/icons/Telephone 1.png",
                  height: 35,
                ).pOnly(left: 8).onInkTap(() async {
                  String url = "tel:${widget.model.vendor?.phone}";
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
              ])
            ],
          ).px20().py12(),
        ],
      );
    });
  }
}
