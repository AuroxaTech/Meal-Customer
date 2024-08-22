import 'package:flutter/material.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/view_models/vendor_details.vm.dart';
import 'package:mealknight/views/pages/vendor_details/widgets/vendor_with_menu.view.dart';
import 'package:stacked/stacked.dart';

import 'widgets/vendor_plain_details.view.dart';

class VendorDetailsPage extends StatelessWidget {
  const VendorDetailsPage({
    required this.vendor,
    super.key,
  });

  final Vendor? vendor;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsViewModel(context, vendor),
      onViewModelReady: (model) => model.getVendorDetails(),
      builder: (context, model, child) {
        return (!model.vendor!.hasSubcategories && !model.vendor!.isServiceType)
            ? VendorDetailsWithMenuPage(
                vendor: model.vendor!,
                onFavoriteChange: (isFavorite){

                },
              )
            : VendorPlainDetailsView(
                model,
                onFavoriteChange:  (isFavorite){

                },
              );
      },
    );
  }
}
