import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/service.vm.dart';
import 'package:mealknight/views/pages/service/widgets/popular_services.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/complex_header.view.dart';
import 'package:mealknight/views/pages/vendor/widgets/simple_styled_banners.view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/states/alternative.view.dart';
import 'package:mealknight/widgets/vendor_type_categories.view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widgets/top_service_vendors.view.dart';

class ServicePage extends StatefulWidget {
  const ServicePage(this.vendorType, {super.key});

  final VendorType vendorType;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with AutomaticKeepAliveClientMixin<ServicePage> {
  GlobalKey pageKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    final mBannerHeight =
        (AppStrings.bannerHeight < (context.percentHeight * 35)
            ? context.percentHeight * 35
            : AppStrings.bannerHeight);

    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: widget.vendorType.name,
          appBarColor: widget.vendorType.hasBanners
              ? Colors.transparent
              : context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          showCart: false,
          key: model.pageKey,
          body: SmartRefresher(
            controller: model.refreshController,
            onRefresh: model.reloadPage,
            child: VStack(
              [
                //
                AlternativeView(
                  ismain: widget.vendorType.hasBanners,
                  main: Stack(
                    children: [
                      //banners
                      SimpleStyledBanners(
                        widget.vendorType,
                        height: mBannerHeight,
                        withPadding: false,
                        radius: 0,
                      ).h(mBannerHeight).pOnly(bottom: 50),
                      //
                      ComplexVendorHeader(
                        model: model,
                        searchShowType: 5,
                        onrefresh: model.reloadPage,
                      )
                          .box
                          .color(context.theme.colorScheme.background)
                          .roundedSM
                          // .shadowXs
                          .outerShadow
                          .make()
                          .positioned(
                            left: 20,
                            right: 20,
                            bottom: 0,
                          ),
                    ],
                  ),
                  alt: VStack(
                    [
                      //
                      ComplexVendorHeader(
                        model: model,
                        searchShowType: 5,
                        onrefresh: model.reloadPage,
                      )
                          .box
                          .color(context.theme.colorScheme.background)
                          .roundedSM
                          .outerShadowSm
                          .make()
                          .px20(),
                      //
                      SimpleStyledBanners(
                        widget.vendorType,
                        height: AppStrings.bannerHeight,
                      ).py12(),
                    ],
                  ),
                ),

                //categories
                VendorTypeCategories(
                  widget.vendorType,
                  showTitle: false,
                  description: "Categories",
                  childAspectRatio: 1.4,
                  crossAxisCount: 4,
                ),

                //top services
                PopularServicesView(widget.vendorType),
                //
                UiSpacer.verticalSpace(),
                //top vendors
                TopServiceVendors(widget.vendorType),

                //
                UiSpacer.verticalSpace(
                  space: context.percentHeight * 20,
                ),
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
