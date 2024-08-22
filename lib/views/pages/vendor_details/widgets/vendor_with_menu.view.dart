import 'package:flutter/material.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_font.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_strings.dart';
import '../../../../models/menu.dart';
import '../../../../models/product.dart';
import '../../../../models/vendor.dart';
import '../../../../services/cart.service.dart';
import '../../../../utils/ui_spacer.dart';
import '../../../../view_models/vendor_menu_details.vm.dart';
import '../../../../widgets/busy_indicator.dart';
import '../../../../widgets/cards/custom.visibility.dart';
import '../../../../widgets/currency_hstack.dart';
import '../../../../widgets/custom_image.view.dart';
import '../../../../widgets/custom_list_view.dart';
import '../../../../widgets/tags/fav.positioned_vendor.dart';
import 'vendor_details_header.view.dart';

class VendorDetailsWithMenuPage extends StatefulWidget {
  const VendorDetailsWithMenuPage({
    required this.vendor,
    required this.onFavoriteChange,
    super.key,
  });

  final Vendor vendor;
  final Function(bool isFavorite) onFavoriteChange;

  @override
  State<VendorDetailsWithMenuPage> createState() =>
      _VendorDetailsWithMenuPageState();
}

class _VendorDetailsWithMenuPageState extends State<VendorDetailsWithMenuPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsWithMenuViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsWithMenuViewModel(
        context,
        widget.vendor,
        tickerProvider: this,
      ),
      onViewModelReady: (model) {
        model.tabBarController = TabController(
            length: model.vendor?.menus.length ?? 0,
            vsync: this,
            initialIndex: model.index);
        model.getVendorDetails();
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            // backgroundColor: context.theme.colorScheme.background,
            //floatingActionButton: UploadPrescriptionFab(model),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool scrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 220,
                    floating: false,
                    pinned: true,
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
                    backgroundColor: AppColor.faintBgColor,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          // model.openVendorSearch();
                        },
                        child: FavVendorPositionedView(
                          model.vendor!,
                          size: 45,
                          onFavoriteChange: (isFavorite) {
                            widget.onFavoriteChange.call(isFavorite);
                            model.onFavoriteChange(isFavorite);
                          },
                        ).pSymmetric(v: 10, h: 8),
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: const Text(""),
                      background:
                          //vendor image
                          CustomImage(
                        imageUrl: model.vendor!.featureImage,
                        height: 220,
                        canZoom: true,
                      ).wFull(context),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: VendorDetailsHeader(
                      model,
                      showFeatureImage: false,
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    title: "".text.make(),
                    floating: false,
                    pinned: false,
                    snap: false,
                    primary: false,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Row(
                      children: [
                        Image.asset(
                          "assets/images/icons/searchVectorIcon.png",
                          height: 25,
                        ).px12(),
                        Expanded(
                          child: TabBar(
                            indicatorColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            indicator:
                                const BoxDecoration(color: Colors.transparent),
                            onTap: (int index) {
                              setState(() {
                                setState(() {
                                  model.selectedTabName =
                                      model.vendor!.menus[index].name;
                                });
                              });
                            },
                            isScrollable: true,
                            labelPadding: const EdgeInsets.all(10),
                            controller: model.tabBarController,
                            tabAlignment: TabAlignment.start,
                            tabs: model.vendor!.menus.map(
                              (menu) {
                                return model.selectedTabName == menu.name
                                    ? Tab(
                                        child: menu.name.text.lg
                                            .fontFamily(AppFonts.appFont)
                                            .color(AppColor.primaryColor)
                                            .make()
                                            .py2()
                                            .px8()
                                            .box
                                            .border(
                                                color: AppColor.primaryColor,
                                                width: 2)
                                            .roundedLg
                                            .make(),
                                      )
                                    : Tab(
                                        child: menu.name.text.lg
                                            .fontFamily(AppFonts.appFont)
                                            .color(AppColor.primaryColor)
                                            .make()
                                            .py2(),
                                      );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: Container(
                child: model.isBusy
                    ? const BusyIndicator().p20().centered()
                    : GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if ((details.primaryVelocity ?? 0) > 0) {
                            // Swiped from left to right
                            if (model.tabBarController!.index != 0) {
                              //
                              //   model.tabBarController!.animateTo(model.tabBarController!.index - 1);
                            }
                          } else if ((details.primaryVelocity ?? 0) < 0) {
                            // Swiped from right to left
                            if (model.tabBarController!.index !=
                                model.tabBarController!.length - 1) {
                              // model.tabBarController!.animateTo(model.tabBarController!.index + 1);
                            }
                          }

                          setState(() {});
                        },
                        child: TabBarView(
                          //physics: NeverScrollableScrollPhysics(),
                          controller: model.tabBarController,
                          children: model.vendor!.menus.map(
                            (menu) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  menu.name.text.lg
                                      .fontFamily(AppFonts.appFont)
                                      .color(AppColor.primaryColor)
                                      .semiBold
                                      .maxLines(2)
                                      //.overflow(TextOverflow.ellipsis)
                                      .make()
                                      .pOnly(left: 20),
                                  Expanded(
                                    child: CustomListView(
                                      noScrollPhysics: true,
                                      refreshController:
                                          model.getRefreshController(menu.id),
                                      canPullUp: true,
                                      canRefresh: true,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      dataSet:
                                          model.menuProducts[menu.id] ?? [],
                                      isLoading: model.busy(menu.id),
                                      onLoading: () => model.loadMoreProducts(
                                        menu.id,
                                        initialLoad: false,
                                      ),
                                      onRefresh: () {
                                        model.loadMoreProducts(menu.id);
                                      },
                                      itemBuilder: (context, index) {
                                        final Product product =
                                            model.menuProducts[menu.id]?[index];
                                        return productItemView(
                                            index, product, menu, model);

                                        // return HorizontalProductListItem(
                                        //   product,
                                        //   onPressed: model.productSelected,
                                        //   qtyUpdated: model.addToCartDirectly,
                                        // );
                                      },
                                      separatorBuilder: (context, index) =>
                                          UiSpacer.verticalSpace(space: 5),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
              ),
            ),

            floatingActionButton: Padding(
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
          ),
        );
      },
    );
  }

  Widget productItemView(int index, Product product, Menu menu,
      VendorDetailsWithMenuViewModel model) {
    if (CartServices.productsInCart.isNotEmpty) {
      for (int i = 0; i < CartServices.productsInCart.length; i++) {
        if (CartServices.productsInCart[i].product!.id == product.id &&
            CartServices.productsInCart[i].product!.vendor.id ==
                product.vendor.id) {
          product.selectedQty =
              CartServices.productsInCart[i].product!.selectedQty;
        }
      }
    }
    final currencySymbol = AppStrings.currencySymbol;
    return GestureDetector(
      onTap: () async {
        final result = await model.productSelected(product);
        if (result == false) {
          model.menuProducts[menu.id]?[index]!.selectedQty = 0;
          product.selectedQty = 0;
          setState(() {});
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CustomImage(imageUrl: product.photo),
          )
              .wh(100, 100)
              .box
              .clip(Clip.antiAlias)
              .withRounded(value: 15.0)
              .border(color: AppColor.primaryColor, width: 2)
              .make(),
          18.widthBox,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      product.name.text.lg
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .semiBold
                          .maxLines(2)
                          .overflow(TextOverflow.ellipsis)
                          .make()
                          .expand(),
                      CurrencyHStack(
                        [
                          //price
                          CurrencyHStack(
                            [
                              currencySymbol.text.lg.bold
                                  .fontFamily(AppFonts.appFont)
                                  .color(AppColor.primaryColor)
                                  .make(),
                              (product.sellPrice.currencyValueFormat())
                                  .text
                                  .xl
                                  .fontFamily(AppFonts.appFont)
                                  .color(AppColor.primaryColor)
                                  .bold
                                  .make(),
                            ],
                            crossAlignment: CrossAxisAlignment.end,
                          ),
                          //discount
                          CustomVisibilty(
                            visible: product.showDiscount,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CurrencyHStack(
                                [
                                  currencySymbol.text.lineThrough.xs
                                      .fontFamily(AppFonts.appFont)
                                      .color(AppColor.primaryColor)
                                      .make(),
                                  product.price
                                      .currencyValueFormat()
                                      .text
                                      .lineThrough
                                      .fontFamily(AppFonts.appFont)
                                      .color(AppColor.primaryColor)
                                      .lg
                                      .medium
                                      .make(),
                                ],
                              ),
                            ),
                          ),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                  product.description.text.sm
                      .fontFamily(AppFonts.appFont)
                      .color(AppColor.primaryColor)
                      .maxLines(2)
                      .overflow(TextOverflow.ellipsis)
                      .make(),
                  /*Wrap(
                    children: [
                      "Add ons:"
                          .text
                          .sm
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .maxLines(2)
                          .overflow(TextOverflow.ellipsis)
                          .make(),
                      product.name.text.sm
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .maxLines(2)
                          .overflow(TextOverflow.ellipsis)
                          .make(),
                    ],
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (product.hasStock)
                          ? HStack(
                              [
                                if (product.selectedQty != 0)
                                  Image.asset(
                                    AppImages.minusSign,
                                    height: 40,
                                  ).p4().onInkTap(() async {
                                    if (product.selectedQty > 0) {
                                      product.selectedQty =
                                          product.selectedQty - 1;
                                      product.sellPriceNew =
                                          product.price * product.selectedQty;
                                      setState(() {});
                                      model.getUpdateItem(product);
                                      setState(() {});
                                    }
                                  }),
                                //
                                if (product.selectedQty != 0)
                                  "${product.selectedQty}"
                                      .text
                                      .fontFamily(AppFonts.appFont)
                                      .bold
                                      .color(AppColor.primaryColor)
                                      .make()
                                      .p4()
                                      .px8(),
                                //
                                Image.asset(
                                  AppImages.plusSign,
                                  height: 40,
                                ).p4().onInkTap(() async {
                                  if (product.selectedQty > 0) {
                                    if (product.availableQty! >
                                        product.selectedQty) {
                                      product.selectedQty =
                                          product.selectedQty + 1;
                                      product.sellPriceNew =
                                          product.price * product.selectedQty;
                                      setState(() {});
                                      model.getUpdateItem(product);
                                      setState(() {});
                                    }
                                  } else {
                                    final result =
                                        await model.productSelected(product);
                                    if (result == false) {
                                      model.menuProducts[menu.id]?[index]!
                                          .selectedQty = 0;
                                      product.selectedQty = 0;
                                      setState(() {});
                                    }
                                  }
                                }),
                              ],
                            ).box.make().py4().centered()
                          : !product.hasStock
                              ? "No stock"
                                  .tr()
                                  .text
                                  .sm
                                  .white
                                  .makeCentered()
                                  .py2()
                                  .px4()
                                  .box
                                  .red600
                                  .roundedSM
                                  .make()
                                  .p8()
                              : UiSpacer.emptySpace()
                      // ProductStockState(
                      //   product,
                      //   // qtyUpdated: model.addToCartDirectly,
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ).pSymmetric(h: 16, v: 10),
    );
  }
}
