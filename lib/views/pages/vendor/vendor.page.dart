import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/vendor.vm.dart';
import 'package:mealknight/views/common_widget/app_header.dart';
import 'package:mealknight/views/pages/vendor/widgets/banners.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/best_selling_products.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/for_you_products.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/nearby_vendors.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/top_vendors.view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/cards/view_all_vendors.view.dart';
import 'package:mealknight/widgets/vendor_type_categories.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorPage extends StatefulWidget {
  const VendorPage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;

  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage>
    with AutomaticKeepAliveClientMixin<VendorPage> {
  GlobalKey pageKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<VendorViewModel>.reactive(
      viewModelBuilder: () => VendorViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: false,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          key: pageKey,
          body: VStack(
            [
              AppHeader(
                type: "vendor",
                vendorType: widget.vendorType,
                subCategories: const [],
                vendorTypes: const [],
              ),

              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: model.refreshController,
                onRefresh: () {
                  setState(() {
                    pageKey = GlobalKey<State>();
                    model.refreshController.refreshCompleted();
                  });
                },
                // model.reloadPage,
                child: VStack(
                  [
                    //
                    Banners(vendorType:widget.vendorType),
                    //categories
                    VendorTypeCategories(
                      widget.vendorType,
                      showTitle: false,
                      description: "Categories".tr(),
                      childAspectRatio: 1.4,
                    ),

                    //nearby vendors
                    AppStrings.enableSingleVendor
                        ? UiSpacer.emptySpace()
                        : NearByVendors(widget.vendorType),

                    //best selling
                    BestSellingProducts(widget.vendorType),

                    //For you
                    ForYouProducts(widget.vendorType),

                    //
                    AppStrings.enableSingleVendor
                        ? UiSpacer.verticalSpace()
                        : TopVendors(widget.vendorType),

                    //view cart and all vendors
                    ViewAllVendorsView(vendorType: widget.vendorType),
                  ],
                ).scrollVertical(),
              ).expand(),
            ],
            // key: model.pageKey,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
