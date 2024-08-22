import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/enums/product_fetch_data_type.enum.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/view_models/products.vm.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/list_items/commerce_product.list_item.dart';
import 'package:mealknight/widgets/list_items/food_horizontal_product.list_item.dart';
import 'package:mealknight/widgets/list_items/grid_view_product.list_item.dart';
import 'package:mealknight/widgets/list_items/grocery_product.list_item.dart';
import 'package:mealknight/widgets/list_items/horizontal_product.list_item.dart';
import 'package:mealknight/widgets/section.title.dart';
import 'package:mealknight/widgets/states/vendor.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SectionProductsView extends StatefulWidget {
  const SectionProductsView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.type = ProductFetchDataType.BEST,
    this.itemWidth,
    this.itemHeight,
    this.viewType,
    this.listHeight = 195,
    this.separator,
    this.byLocation = false,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final Axis scrollDirection;
  final ProductFetchDataType type;
  final String title;
  final double? itemWidth;
  final double? itemHeight;
  final dynamic viewType;
  final double? listHeight;
  final Widget? separator;
  final bool byLocation;

  @override
  State<SectionProductsView> createState() => _SectionProductsViewState();
}

class _SectionProductsViewState extends State<SectionProductsView> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  // void statusBar() {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     statusBarBrightness: Brightness.dark,
  //   ));
  // }
  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // statusBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      // visible: !AppStrings.enableSingleVendor,
      child: ViewModelBuilder<ProductsViewModel>.reactive(
        viewModelBuilder: () => ProductsViewModel(
          context,
          widget.vendorType,
          widget.type,
          byLocation: widget.byLocation,
        ),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          //
          //listview
          Widget listView = CustomListView(
            scrollDirection: widget.scrollDirection,
            padding: EdgeInsets.symmetric(horizontal: 10),
            dataSet: model.products,
            isLoading: model.isBusy,
            noScrollPhysics: widget.scrollDirection != Axis.horizontal,
            itemBuilder: (context, index) {
              //
              final product = model.products[index];
              Widget itemView;

              //
              if (widget.viewType != null &&
                  widget.viewType == HorizontalProductListItem) {
                itemView = HorizontalProductListItem(
                  product,
                  qtyUpdated: model.addToCartDirectly,
                  onPressed: model.productSelected,
                  height: widget.itemHeight,
                );
              } else if (widget.viewType != null &&
                  widget.viewType == FoodHorizontalProductListItem) {
                itemView = FoodHorizontalProductListItem(
                  product,
                  qtyUpdated: model.addToCartDirectly,
                  onPressed: model.productSelected,
                  height: widget.itemHeight,
                );
              } else if (widget.viewType != null &&
                  widget.viewType == GridViewProductListItem) {
                itemView = GridViewProductListItem(
                  product: product,
                  qtyUpdated: model.addToCartDirectly,
                  onPressed: model.productSelected,
                );
              } else {
                //grocery product list item
                if (product.vendor.vendorType.isGrocery) {
                  itemView = GroceryProductListItem(
                    product: product,
                    onPressed: model.productSelected,
                    qtyUpdated: model.addToCartDirectly,
                  );
                }
                //regular views
                itemView = CommerceProductListItem(
                  product,
                  height: 80,
                );
              }

              //
              if (widget.itemWidth != null) {
                return itemView.w(widget.itemWidth!);
              }
              return itemView;
            },
            emptyWidget: EmptyVendor(),
            separatorBuilder: widget.separator != null
                ? (ctx, index) => widget.separator!
                : null,
          );
          //
          return CustomVisibilty(
            visible: !model.isBusy && !model.products.isEmpty,
            child: VStack(
              [
                //
                SectionTitle("${widget.title}").p12(),
                //
                if (model.products.isEmpty)
                  listView.h(240)
                else if (widget.listHeight != null)
                  listView.h(widget.listHeight!)
                else
                  listView
              ],
            ),
          );

          //
        },
      ),
    );
  }
}
