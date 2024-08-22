import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/view_models/vendor/section_vendors.vm.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/list_items/food_vendor.list_item.dart';
import 'package:mealknight/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:mealknight/widgets/section.title.dart';
import 'package:mealknight/widgets/states/vendor.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../models/category.dart';

class SectionVendorsView extends StatefulWidget {
  const SectionVendorsView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.type = SearchFilterType.sales,
    this.itemWidth,
    this.viewType,
    this.separator,
    this.byLocation = false,
    this.itemsPadding,
    this.titlePadding,
    this.hideEmpty = false,
    this.category,
    super.key,
  });

  final VendorType? vendorType;
  final Axis scrollDirection;
  final SearchFilterType type;
  final String title;
  final double? itemWidth;
  final dynamic viewType;
  final Widget? separator;
  final bool byLocation;
  final EdgeInsets? itemsPadding;
  final EdgeInsets? titlePadding;
  final bool hideEmpty;
  final Category? category;

  @override
  State<SectionVendorsView> createState() => _SectionVendorsViewState();
}

class _SectionVendorsViewState extends State<SectionVendorsView> {
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
      visible: !AppStrings.enableSingleVendor,
      child: ViewModelBuilder<SectionVendorsViewModel>.reactive(
        viewModelBuilder: () => SectionVendorsViewModel(
          context,
          widget.vendorType,
          type: widget.type,
          byLocation: widget.byLocation,
          category: widget.category,
        ),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          //
          Widget listView = CustomListView(
            scrollDirection: widget.scrollDirection,
            padding: widget.itemsPadding ??
                const EdgeInsets.symmetric(horizontal: 10),
            dataSet: model.vendors,
            isLoading: model.isBusy,
            noScrollPhysics: widget.scrollDirection != Axis.horizontal,
            itemBuilder: (context, index) {
              final vendor = model.vendors[index];
              if (widget.viewType != null &&
                  widget.viewType == HorizontalVendorListItem) {
                return HorizontalVendorListItem(
                  vendor: vendor,
                  onPressed: model.vendorSelected,
                  onFavoriteChange: (isFavorite) {
                    model.onFavoriteChange(index, isFavorite);
                  },
                );
              } else {
                return FittedBox(
                  child: FoodVendorListItem(
                    vendor: vendor,
                    onPressed: model.vendorSelected,
                    onFavoriteChange: (isFavorite) {
                      model.onFavoriteChange(index, isFavorite);
                    },
                  ).w(
                    widget.itemWidth ?? (context.percentWidth * 50),
                  ),
                );
              }
            },
            emptyWidget: const EmptyVendor(),
            separatorBuilder: widget.separator != null
                ? (ctx, index) => widget.separator!
                : null,
          );

          return Visibility(
            visible: !widget.hideEmpty || (model.vendors.isNotEmpty),
            child: VStack(
              [
                Visibility(
                  visible: widget.title.isNotBlank,
                  child: Padding(
                    padding: widget.titlePadding ?? const EdgeInsets.all(12),
                    child: SectionTitle(widget.title),
                  ),
                ),

                //vendors list
                if (model.vendors.isEmpty)
                  listView.h(model.vendors.isEmpty ? 240 : 195).wFull(context)
                else if (widget.scrollDirection == Axis.horizontal)
                  listView.h(195).wFull(context)
                else
                  listView.wFull(context)
              ],
            ),
          );
        },
      ),
    );
  }
}
