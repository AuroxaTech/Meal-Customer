import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/vendor_details.vm.dart';
import 'package:mealknight/views/pages/vendor_details/service_vendor_details.page.dart';
import 'package:mealknight/views/pages/vendor_details/widgets/upload_prescription.btn.dart';
import 'package:mealknight/views/pages/vendor_details/widgets/vendor_with_subcategory.view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_leading.dart';
import 'package:mealknight/widgets/buttons/share.btn.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/cart_page_action.dart';
import 'package:mealknight/widgets/tags/fav.positioned_vendor.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorPlainDetailsView extends StatelessWidget {
  const VendorPlainDetailsView(this.model,
      {required this.onFavoriteChange, super.key});

  final VendorDetailsViewModel model;
  final Function(bool isFavorite) onFavoriteChange;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      showCart: true,
      elevation: 0,
      extendBodyBehindAppBar: true,
      appBarColor: Colors.transparent,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 50,
          width: 45,
          margin: const EdgeInsets.all(5),
          alignment: Alignment.center,
          child: Image.asset(AppImages.closeButton),
        ),
      ),
      fab: UploadPrescriptionFab(model),
      actions: [
        FavVendorPositionedView(
          model.vendor!,
          size: 40,
          onFavoriteChange: onFavoriteChange,
        ).p8(),
        // SizedBox(
        //   width: 50,
        //   height: 50,
        //   child: FittedBox(
        //     child: ShareButton(
        //       model: model,
        //     ),
        //   ),
        // ),
        // UiSpacer.hSpace(10),
        // PageCartAction(),
      ],
      body: VStack(
        [
          //subcategories && hide for service vendor type
          CustomVisibilty(
            visible: (model.vendor!.hasSubcategories &&
                !model.vendor!.isServiceType),
            child: VendorDetailsWithSubcategoryPage(
              vendor: model.vendor!,
            ),
          ),

          //show for service vendor type
          CustomVisibilty(
            visible: model.vendor!.isServiceType,
            child: ServiceVendorDetailsPage(
              model,
              vendor: model.vendor!,
            ),
          ),
        ],
      ),
    );
  }
}
