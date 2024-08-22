import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/view_models/location_fetch.view_model.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dartx/dartx.dart';

class LocationFetchPage extends StatelessWidget {
  const LocationFetchPage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationFetchViewModel>.reactive(
        viewModelBuilder: () => LocationFetchViewModel(context, child),
        disposeViewModel: true,
        // onViewModelReady: (vm) => vm.initialise(),
        builder: (ctx, vm, child) {
          return Scaffold(
            body: VStack(
              [
                Center(
                  child: VStack(
                    [
                      FittedBox(
                        child: SvgPicture.asset(
                          AppImages.locationSvg,
                        )
                            .wh(context.percentWidth * 50, context.percentWidth * 50)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                      ),
                      UiSpacer.vSpace(),

                      //
                      Row(
                        children: [
                          "Enter Address"
                              .text
                              .medium
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .make()
                              .px20()
                              .py8(),
                          UiSpacer.expandedSpace(),
                        ],
                      ),
                      Container(
                        height: 45.0,
                        child: GooglePlaceAutoCompleteTextField(
                          boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.primaryColor, width: 2)),
                          showError: true,
                          textEditingController: vm.controller,
                          googleAPIKey: AppStrings.googleMapApiKey,
                          inputDecoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            labelStyle: Theme.of(context).textTheme.bodyLarge,
                            contentPadding: EdgeInsets.all(14),
                          ),
                          debounceTime: 800,
                          // default 600 ms,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (dynamic prediction) {
                            debugPrint("placeDetails latitude" + prediction.lat.toString());
                            debugPrint(prediction.lng);
                            debugPrint(prediction.lat);
                            if (prediction is Prediction) {
                              vm.deliveryAddress?.address = prediction.description;
                              vm.deliveryAddress?.latitude = prediction.lat?.toDoubleOrNull();
                              vm.deliveryAddress?.longitude = prediction.lng?.toDoubleOrNull();
                              vm.handleFetchSearchLocation();
                            }

                            vm.controller.clear();
                          },

                          // this callback is called when isLatLngRequired is true
                          itemClick: (Prediction prediction) {
                            // //
                            print(prediction.lng);
                            print(prediction.lat);
                            vm.controller.text = prediction.description!;
                            vm.controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: prediction.description?.length ?? 0),
                            );
                            debugPrint("calling item click");
                          },
                        ).pSymmetric(h: 20),
                      ),

                      Row(
                        children: [
                          UiSpacer.expandedSpace(),
                          "Locate me"
                              .text
                              .medium
                              .bold
                              .fontFamily(AppFonts.appFont)
                              .color(Colors.white)
                              .make()
                              .p(10)
                              .box
                              .withRounded(value: 10)
                              .color(AppColor.primaryColor)
                              .make()
                              .p(20)
                              .onTap(() {
                            vm.initialise();
                          })
                        ],
                      )
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                ).expand(),

                /* //skip
                HStack([
                  UiSpacer.expandedSpace(),
                  CustomTextButton(
                    title: "Skip".tr(),
                    onPressed: vm.loadNextPage,
                  ),
                ]).safeArea(),*/
              ],
            ),
          );
        });
  }
}
