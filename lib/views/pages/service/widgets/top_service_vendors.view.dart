import 'package:flutter/material.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/vendor/top_vendors.vm.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/custom_grid_view.dart';
import 'package:mealknight/widgets/list_items/top_service_vendor.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TopServiceVendors extends StatelessWidget {
  const TopServiceVendors(
    this.vendorType, {
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopVendorsViewModel>.reactive(
      viewModelBuilder: () => TopVendorsViewModel(
        context,
        vendorType,
        params: {"type": "rated"},
        enableFilter: false,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            Visibility(
              visible: model.isBusy,
              child: BusyIndicator().centered(),
            ),
            //
            Visibility(
              visible: model.vendors.isNotEmpty,
              child: VStack(
                [
                  //
                  // UiSpacer.vSpace(),
                  "Top Rated".tr().text.lg.medium.make().px20(),
                  UiSpacer.vSpace(10),
                  //vendors list
                  CustomGridView(
                    noScrollPhysics: true,
                    dataSet: model.vendors,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    itemBuilder: (context, index) {
                      //
                      final vendor = model.vendors[index];
                      return TopServiceVendorListItem(
                        vendor: vendor,
                        onPressed: model.vendorSelected,
                      );
                    },
                  ).px20(),
                ],
              ).py12(),
            ),
          ],
        );
      },
    );
  }
}
