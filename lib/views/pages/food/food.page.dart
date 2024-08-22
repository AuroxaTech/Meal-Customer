import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_strings.dart';
import '../../../enums/product_fetch_data_type.enum.dart';
import '../../../models/category.dart';
import '../../../models/search.dart';
import '../../../models/vendor_type.dart';
import '../../../utils/ui_spacer.dart';
import '../../../view_models/vendor.vm.dart';
import '../../../widgets/base.page.dart';
import '../../../widgets/cards/custom.visibility.dart';
import '../../../widgets/list_items/banner.list_item.dart';
import '../../../widgets/list_items/horizontal_product.list_item.dart';
import '../../../widgets/list_items/horizontal_vendor.list_item.dart';
import '../../common_widget/app_header.dart';
import '../flash_sale/widgets/flash_sale.view.dart';
import '../vendor/widgets/section_products.view.dart';
import '../vendor/widgets/section_vendors.view.dart';

class FoodPage extends StatefulWidget {
  const FoodPage(this.vendorType, this.vendorList, {super.key});

  final VendorType vendorType;
  final List<VendorType> vendorList;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage>
    with AutomaticKeepAliveClientMixin<FoodPage> {
  GlobalKey pageKey = GlobalKey<State>();
  Category? category;
  bool filterDone = true;
  bool isSelected = true;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<VendorViewModel>.reactive(
      viewModelBuilder: () => VendorViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          showCartView: false,
          title: widget.vendorType.name,
          appBarColor: context.theme.colorScheme.surface,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: const Color(0xffeefffd),
          showCart: false,
          key: model.pageKey,
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: model.refreshController,
            onRefresh: model.reloadPage,
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                // persistent header
                SliverPersistentHeader(
                  pinned: false,
                  floating: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: model.categories.isNotEmpty ? 162 : 76,
                    maxHeight: model.categories.isNotEmpty ? 162 : 76,
                    child: Container(
                      // color: innerBoxIsScrolled ? Colors.white : Colors.transparent,
                      //height: model.categories.isNotEmpty ? 162 : 76,
                      //margin: const EdgeInsets.only(top: 4.0),
                      color: Colors.white,
                      child: AppHeader(
                        type: "vendor",
                        vendorType: widget.vendorType,
                        subCategories: model.categories,
                        vendorTypes: widget.vendorList,
                        onCategorySelected: (Category? category) {
                          this.category = category;
                          setState(() {
                            filterDone = false;
                            isSelected = !isSelected;
                          });
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              filterDone = true;
                            });
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              scrollController.animToBottom();
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    isSelected == true ?  CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        initialPage: 1,
                        height: (!model.isBusy && model.banners.isNotEmpty)
                            ? 180.0
                            : 0.00,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                      ),
                      items: model.banners.map(
                        (banner) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: BannerListItem(
                              imageUrl: banner.photo ?? "",
                              radius: 20,
                              noMargin: true,
                              onPressed: () => model.bannerSelected(banner),
                            ),
                          );
                        },
                      ).toList(),
                    ).box.clip(Clip.antiAlias).make() : SizedBox(),

                    isSelected == true ?    SectionVendorsView(
                      widget.vendorType,
                      title: "Featured Stores".tr(),
                      scrollDirection: Axis.horizontal,
                      type: SearchFilterType.featured,
                      itemWidth: context.percentWidth * 55,
                      // byLocation: AppStrings.enableFatchByLocation,
                    ) : SizedBox(),

                    isSelected == true ? FlashSaleView(widget.vendorType) : SizedBox(),

                    isSelected == true ? SectionVendorsView(
                      widget.vendorType,
                      title: "Popular nearby".tr(),
                      scrollDirection: Axis.horizontal,
                      type: SearchFilterType.you,
                      itemWidth: context.percentWidth * 55,
                      // itemHeight: 175,
                      //viewType: FoodHorizontalProductListItem,
                      // listHeight: 175,
                      byLocation: AppStrings.enableFatchByLocation,
                    ) : SizedBox(),
                    //all vendor
                    if (filterDone)
                      CustomVisibilty(
                        visible: !AppStrings.enableSingleVendor,
                        child: SectionVendorsView(
                          widget.vendorType,
                          title: "All ${widget.vendorType.name}",
                          scrollDirection: Axis.vertical,
                          type: SearchFilterType.best,
                          viewType: HorizontalVendorListItem,
                          separator: UiSpacer.verticalSpace(space: 0),
                          category: category,
                        ),
                      ),
                    //all products
                    CustomVisibilty(
                      visible: AppStrings.enableSingleVendor,
                      child: SectionProductsView(
                        widget.vendorType,
                        title: "Top Picks".tr(),
                        scrollDirection: Axis.vertical,
                        type: ProductFetchDataType.BEST,
                        viewType: HorizontalProductListItem,
                        separator: UiSpacer.verticalSpace(space: 0),
                        listHeight: null,
                      ),
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                  ]),
                ),
              ],
            ),
          ),
          fab: Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cartRoute);
              },
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  AppImages.shoppingCartShield,
                  height: 60,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  @override
  double get minExtent => minHeight!;

  @override
  double get maxExtent => max(maxHeight!, minHeight!);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
