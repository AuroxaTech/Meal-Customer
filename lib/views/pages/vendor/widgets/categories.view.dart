import 'package:flutter/material.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/vendor/categories.vm.dart';
import 'package:mealknight/views/pages/category/categories.page.dart';
import 'package:mealknight/widgets/custom_horizontal_list_view.dart';
import 'package:mealknight/widgets/list_items/category.list_item.dart';
import 'package:mealknight/widgets/section.title.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class Categories extends StatelessWidget {
  const Categories(this.vendorType, {Key? key}) : super(key: key);
  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () => CategoriesViewModel(
        context,
        vendorType: vendorType,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            HStack(
              [
                SectionTitle("Categories".tr()).expand(),
                UiSpacer.smHorizontalSpace(),
                "See all".tr().text.color(context.primaryColor).make().onInkTap(
                  () {
                    //
                    context.nextPage(
                      CategoriesPage(vendorType: vendorType),
                    );
                  },
                ),
              ],
            ).p12(),

            //categories list
            CustomHorizontalListView(
              isLoading: model.isBusy,
              itemsViews: model.categories.map(
                (category) {
                  return CategoryListItem(
                    category: category,
                    onPressed: model.categorySelected,
                    maxLine: false,
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
