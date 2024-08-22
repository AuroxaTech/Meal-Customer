import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/view_models/pharmacy.vm.dart';
import 'package:mealknight/views/pages/flash_sale/widgets/flash_sale.view.dart';
import 'package:mealknight/views/pages/pharmacy/widgets/pharmacy_categories.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/banners.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/best_selling_products.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/header.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/nearby_vendors.view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/cards/view_all_vendors.view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage(this.vendorType, {super.key});

  final VendorType vendorType;

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage>
    with AutomaticKeepAliveClientMixin<PharmacyPage> {
  GlobalKey pageKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<PharmacyViewModel>.reactive(
      viewModelBuilder: () => PharmacyViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          key: model.pageKey,
          body: VStack(
            [
              //
              VendorHeader(
                model: model,
                onrefresh: model.reloadPage,
              ),

              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: model.refreshController,
                onRefresh: model.reloadPage,
                child: VStack(
                  [
                    Banners(vendorType:widget.vendorType),

                    //categories
                    PharmacyCategories(widget.vendorType),

                    //flash sales products
                    FlashSaleView(widget.vendorType),

                    //best selling
                    BestSellingProducts(widget.vendorType),

                    //nearby
                    NearByVendors(widget.vendorType),

                    //view cart and all vendors
                    ViewAllVendorsView(vendorType: widget.vendorType),
                  ],
                ).scrollVertical(),
              ).expand(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
