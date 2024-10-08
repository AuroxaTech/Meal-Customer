import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/view_models/taxi.vm.dart';
import 'package:mealknight/views/pages/taxi/widgets/new_order_step_1.dart';
import 'package:mealknight/views/pages/taxi/widgets/new_order_step_2.dart';
import 'package:mealknight/views/pages/taxi/widgets/taxi_rate_driver.view.dart';
import 'package:mealknight/views/pages/taxi/widgets/taxi_trip_ready.view.dart';
import 'package:mealknight/views/pages/taxi/widgets/trip_driver_search.dart';
import 'package:mealknight/views/pages/taxi/widgets/unsupported_taxi_location.view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_leading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;

  @override
  _TaxiPageState createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> with WidgetsBindingObserver {
  //
  late TaxiViewModel taxiViewModel;

  @override
  void initState() {
    super.initState();
    taxiViewModel = TaxiViewModel(context, widget.vendorType);
  }

  //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState. resumed) {
    // }
    taxiViewModel.setGoogleMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TaxiViewModel>.reactive(
      viewModelBuilder: () => taxiViewModel,
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: false,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          body: Stack(
            children: [
              //google map
              SafeArea(
                child: GoogleMap(
                  initialCameraPosition: vm.mapCameraPosition,
                  onMapCreated: vm.onMapCreated,
                  padding: vm.googleMapPadding,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: vm.gMapMarkers,
                  polylines: vm.gMapPolylines,
                ),
              ),

              //custom leading appbar
              Visibility(
                visible: !AppStrings.isSingleVendorMode,
                child: CustomLeading(
                  padding: 10,
                  size: 24,
                  color: AppColor.primaryColor,
                  bgColor: Utils.textColorByTheme(),
                ).safeArea().positioned(
                      top: 0,
                      left: !Utils.isArabic ? 20 : null,
                      right: Utils.isArabic ? 20 : null,
                    ),
              ),

              //show when location is not supported
              UnSupportedTaxiLocationView(vm),

              //new taxi order form - Step 1
              NewTaxiOrderLocationEntryView(vm),

              //new taxi order form - step 2
              NewTaxiOrderSummaryView(vm),

              //
              Visibility(
                visible: vm.currentStep(3),
                child: TripDriverSearch(vm),
              ),
              //
              Visibility(
                visible: vm.currentStep(4),
                child: TaxiTripReadyView(vm),
              ),
              //
              Visibility(
                visible: vm.currentStep(6),
                child: TaxiRateDriverView(vm),
              ),
            ],
          ),
        );
      },
    );
  }
}
