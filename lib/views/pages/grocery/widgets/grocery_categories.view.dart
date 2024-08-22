import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/view_models/vendor/categories.vm.dart';
import 'package:mealknight/widgets/vendor_type_categories.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class GroceryCategories extends StatefulWidget {
  const GroceryCategories(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _GroceryCategoriesState createState() => _GroceryCategoriesState();
}

class _GroceryCategoriesState extends State<GroceryCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            VendorTypeCategories(
              widget.vendorType,
              showTitle: true,
              title: "What are you getting today?".tr(),
              childAspectRatio: 1.4,
              crossAxisCount: AppStrings.categoryPerRow,
            ),
            //
          ],
        );
      },
    );
  }
}
