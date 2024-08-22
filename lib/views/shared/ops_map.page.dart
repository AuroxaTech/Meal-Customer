import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mealknight/models/address.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/ops_map.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OPSMapPage extends StatelessWidget {
  const OPSMapPage({
    this.useCurrentLocation,
    this.region,
    this.initialPosition,
    this.initialZoom = 50,
    super.key,
  });

  final bool? useCurrentLocation;
  final String? region;
  final LatLng? initialPosition;
  final double initialZoom;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: ViewModelBuilder<OPSMapViewModel>.reactive(
        viewModelBuilder: () => OPSMapViewModel(context),
        onViewModelReady: (viewModel) => viewModel.mapCameraMove(
          CameraPosition(
            target: initialPosition ?? const LatLng(0.00, 0.00),
            zoom: initialZoom,
          ),
        ),
        builder: (ctx, vm, child) {
          return SafeArea(
            child: VStack(
              [
                HStack(
                  [
                    //close btn
                    const Icon(
                      FlutterIcons.arrow_back_mdi,
                    ).p2().onInkTap(() {
                      Navigator.of(context).pop();
                    }),
                    UiSpacer.horizontalSpace(),
                    //auto complete
                    TypeAheadField<Address>(
                      retainOnLoading: false,
                      hideWithKeyboard: false,
                      debounceDuration: const Duration(milliseconds: 900),
                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          // note how the controller is passed
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Search address'.tr(),
                          ),
                        );
                      },
                      suggestionsCallback: (String search) async {
                        if (search.length > 2) {
                          return await vm.fetchPlaces(search);
                        }
                        return [];
                      },
                      itemBuilder: (BuildContext context, Address suggestion) {
                        return ListTile(
                          title: "${suggestion.featureName}"
                              .text
                              .base
                              .semiBold
                              .make(),
                          subtitle: "${suggestion.addressLine}".text.sm.make(),
                        );
                      },
                      onSelected: vm.addressSelected,
                    ).expand(),
                  ],
                ).px20().py4().scrollVertical().centered().wFull(context).h(70),

                //google map body
                Stack(
                  children: [
                    //
                    GoogleMap(
                      myLocationEnabled: useCurrentLocation ?? true,
                      myLocationButtonEnabled: useCurrentLocation ?? true,
                      initialCameraPosition: CameraPosition(
                        target: initialPosition ?? const LatLng(0.00, 0.00),
                        zoom: initialZoom,
                      ),
                      padding: vm.googleMapPadding,
                      onMapCreated: vm.onMapCreated,
                      onCameraMove: vm.mapCameraMove,
                      markers: Set<Marker>.of(vm.gMarkers.values),
                    ),

                    //loading indicator
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: CustomVisibilty(
                        visible: vm.busy(vm.selectedAddress),
                        child: const BusyIndicator().centered().p32(),
                      ),
                    ),
                    //selected address details
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: CustomVisibilty(
                        visible: vm.selectedAddress != null,
                        child: MeasureSize(
                          onChange: vm.updateMapPadding,
                          child: VStack(
                            [
                              //address full
                              "${vm.selectedAddress?.featureName}"
                                  .text
                                  .semiBold
                                  .center
                                  .xl
                                  .maxLines(3)
                                  .overflow(TextOverflow.ellipsis)
                                  .make(),
                              UiSpacer.verticalSpace(space: 5),
                              "${vm.selectedAddress?.addressLine}"
                                  .text
                                  .light
                                  .center
                                  .sm
                                  .maxLines(2)
                                  .overflow(TextOverflow.ellipsis)
                                  .make(),
                              UiSpacer.verticalSpace(),
                              //submit
                              CustomButton(
                                title: "Select".tr(),
                                onPressed: vm.submit,
                              ),
                            ],
                          )
                              .box
                              .shadow2xl
                              .color(context.theme.colorScheme.background)
                              .p20
                              .make(),
                        ),
                      ),
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        },
      ),
    );
  }
}
