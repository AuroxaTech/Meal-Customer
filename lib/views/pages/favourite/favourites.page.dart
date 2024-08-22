import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/view_models/favourites.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/custom_list_view.dart';
import 'package:mealknight/widgets/states/error.state.dart';
import 'package:mealknight/widgets/states/product.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/vendor.dart';
import '../../../view_models/vendor_distance.vm.dart';

class FavouritesPage extends StatelessWidget {
  final List<VendorType> vendorTypes;

  const FavouritesPage({super.key, required this.vendorTypes});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavouritesViewModel>.reactive(
      viewModelBuilder: () => FavouritesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        var vendorTypesList =
            vm.vendorList.map((e) => e.vendorType.name).toList();

        return Stack(
          children: [
            BasePage(
              showAppBar: true,
              showLeadingAction: true,
              isLoading: vm.isBusy,
              elevation: 0,
              title: "Favourites".tr(),
              appBarColor: context.theme.colorScheme.surface,
              appBarItemColor: AppColor.primaryColor,
              backgroundColor: const Color(0xffeefffd),
              body: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  "Note: Tap & Hold to remove favourite"
                      .tr()
                      .text
                      .color(AppColor.primary)
                      .fontFamily(AppFonts.appFont)
                      .lg
                      .fontWeight(FontWeight.w600)
                      .make()
                      .p20(),
                  if (vendorTypesList.isEmpty && vm.products.isEmpty)
                    const EmptyProduct(),
                  for (var i in vendorTypes) ...[
                    if (vendorTypesList.contains(i.name))
                      i.name.text
                          .color(AppColor.primary)
                          .fontFamily(AppFonts.appFont)
                          .lg
                          .size(18)
                          .fontWeight(FontWeight.w600)
                          .make()
                          .pOnly(left: 20, top: 4, bottom: 8),
                    if (vendorTypesList.contains(i.name))
                      CustomListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        dataSet: vm.vendorList,
                        scrollDirection: Axis.horizontal,
                        isLoading: vm.busy(vm.vendorList),
                        //emptyWidget: const EmptyProduct(),
                        errorWidget: LoadingError(
                          onrefresh: vm.fetchVendor,
                        ),
                        itemBuilder: (context, index) {
                          final vendor = vm.vendorList[index];

                          if (i.name == vendor.vendorType.name) {
                            return VStack(
                              [
                                Stack(
                                  children: [
                                    Hero(
                                      tag: vendor.heroTag ?? vendor.id,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CustomImage(
                                            imageUrl: vendor.featureImage,
                                            height: 150,
                                            width: context.screenWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                HStack([
                                  HStack([
                                    VStack(
                                      [
                                        vendor.name.text.lg.medium
                                            .fontFamily(AppFonts.appFont)
                                            .maxLines(1)
                                            .overflow(TextOverflow.ellipsis)
                                            .fontWeight(FontWeight.w600)
                                            .color(AppColor.primary)
                                            .make()
                                            .px8()
                                            .pOnly(top: Vx.dp8),

                                        HStack([
                                          CurrencyHStack(
                                            [
                                              "${vendor.prepareTime}"
                                                  .text
                                                  .fontFamily(AppFonts.appFont)
                                                  .color(AppColor.primary)
                                                  .semiBold
                                                  .make(),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ValueListenableBuilder<Vendor?>(
                                                valueListenable:
                                                    VendorDistanceViewModel()
                                                        .listenToKey(vendor.id),
                                                builder: (BuildContext context,
                                                    Vendor? value, child) {
                                                  return "${value?.distance.numCurrency} km"
                                                      .text
                                                      .fontFamily(
                                                          AppFonts.appFont)
                                                      .color(AppColor.primary)
                                                      .semiBold
                                                      .make();
                                                },
                                              ),

                                              // currencySymbol.text.sm
                                              //     .fontFamily(AppFonts.appFont)
                                              //     .color(AppColor.primary)
                                              //     .make(),
                                              // (product.showDiscount
                                              //         ? product.discountPrice.currencyValueFormat()
                                              //         : product.price.currencyValueFormat())
                                              //     .text
                                              //     .lg
                                              //     .fontFamily(AppFonts.appFont)
                                              //     .color(AppColor.primary)
                                              //     .semiBold
                                              //     .make(),
                                            ],
                                            crossAlignment:
                                                CrossAxisAlignment.end,
                                          ),
                                          // UiSpacer.horizontalSpace(space: 5),
                                          // //discount
                                          // product.showDiscount
                                          //     ? CurrencyHStack(
                                          //         [
                                          //           currencySymbol.text.lineThrough.xs
                                          //               .fontFamily(AppFonts.appFont)
                                          //               .color(AppColor.primary)
                                          //               .make(),
                                          //           product.price
                                          //               .currencyValueFormat()
                                          //               .text
                                          //               .fontFamily(AppFonts.appFont)
                                          //               .lineThrough
                                          //               .color(AppColor.primary)
                                          //               .lg
                                          //               .medium
                                          //               .make(),
                                          //         ],
                                          //       )
                                          //     : UiSpacer.emptySpace(),
                                        ]).pOnly(left: Vx.dp8),

                                        UiSpacer.verticalSpace(space: 5),

                                        //
                                        //description
                                        // "${vendor.description}"
                                        //     .text
                                        //     .gray400
                                        //     .minFontSize(9)
                                        //     .size(9)
                                        //     .maxLines(1)
                                        //     .overflow(TextOverflow.ellipsis)
                                        //     .make()
                                        //     .px8(),
                                      ],
                                    ).expand(),
                                    // VStack(
                                    //   [
                                    //     UiSpacer.verticalSpace(space: 5),
                                    //     TimeTag(vendor.prepareTime,
                                    //         iconData: FlutterIcons.clock_outline_mco),
                                    //     UiSpacer.verticalSpace(space: 5),
                                    //     TimeTag(
                                    //       vendor.deliveryTime,
                                    //       iconData: FlutterIcons.ios_bicycle_ion,
                                    //     ),
                                    //   ],
                                    // ).pSymmetric(h: 2)
                                  ]).px8().expand(),
                                  VStack([
                                    HStack([
                                      "${vendor.rating} "
                                          .text
                                          .minFontSize(6)
                                          .size(24)
                                          .color(AppColor.primary)
                                          .bold
                                          .make(),
                                      Image.asset(
                                        AppImages.goldenStar,
                                        height: 28,
                                      ),
                                    ]),
                                    /*  ProductStockState(
                                product,
                                qtyUpdated: vm.addToCartDirectly,
                              ),*/
                                  ]).px8()
                                ])
                              ],
                            )
                                .onLongPress(
                                  () => vm.removeFavouriteVendor(vendor),
                                  GlobalKey(),
                                )
                                .onTap(() => vm.openVendorDetails(vendor))
                                .w(context.percentWidth * 80)
                                .box
                                .outerShadow
                                .border(width: 2, color: AppColor.primary)
                                .color(context.theme.colorScheme.surface)
                                .clip(Clip.antiAlias)
                                .withRounded(value: 22)
                                .make()
                                .pOnly(bottom: Vx.dp8, right: 15);
                          } else {
                            return const SizedBox();
                          }
                        },
                        separatorBuilder: (context, index) =>
                            UiSpacer.verticalSpace(space: 10),
                      ).h(223),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (vm.products.isNotEmpty)
                    "Products"
                        .tr()
                        .text
                        .color(AppColor.primary)
                        .fontFamily(AppFonts.appFont)
                        .lg
                        .size(18)
                        .fontWeight(FontWeight.w600)
                        .make()
                        .pOnly(left: 20, top: 4, bottom: 8),
                  CustomListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    dataSet: vm.products,
                    scrollDirection: Axis.horizontal,
                    isLoading: vm.busy(vm.products),
                    //emptyWidget: const EmptyProduct(),
                    errorWidget: LoadingError(
                      onrefresh: vm.fetchProducts,
                    ),
                    itemBuilder: (context, index) {
                      //
                      final product = vm.products[index];

                      return VStack(
                        [
                          //
                          Stack(
                            children: [
                              //
                              Hero(
                                tag: product.heroTag ?? product.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CustomImage(
                                    imageUrl: product.photo,
                                    height: 150,
                                    width: context.screenWidth,
                                  ),
                                ),
                              ),

                              // Positioned(
                              //   child: FavPositiedView(product,size: 35,),
                              //   top: 5,
                              //   right: 10,
                              // ),
                              //
                            ],
                          ),

                          HStack([
                            HStack([
                              VStack(
                                [
                                  //name
                                  product.name.text.lg.medium
                                      .fontFamily(AppFonts.appFont)
                                      .maxLines(1)
                                      .overflow(TextOverflow.ellipsis)
                                      .fontWeight(FontWeight.w600)
                                      .color(AppColor.primary)
                                      .make()
                                      .px8()
                                      .pOnly(top: Vx.dp8),

                                  HStack([
                                    //price
                                    CurrencyHStack(
                                      [
                                        "${product.vendor.prepareTime}"
                                            .text
                                            .fontFamily(AppFonts.appFont)
                                            .color(AppColor.primary)
                                            .semiBold
                                            .make(),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ValueListenableBuilder<Vendor?>(
                                          valueListenable:
                                              VendorDistanceViewModel()
                                                  .listenToKey(
                                                      product.vendor.id),
                                          builder: (BuildContext context,
                                              Vendor? value, child) {
                                            return "${value?.distance.numCurrency} km"
                                                .text
                                                .fontFamily(AppFonts.appFont)
                                                .color(AppColor.primary)
                                                .semiBold
                                                .make();
                                          },
                                        ),

                                        // currencySymbol.text.sm
                                        //     .fontFamily(AppFonts.appFont)
                                        //     .color(AppColor.primary)
                                        //     .make(),
                                        // (product.showDiscount
                                        //         ? product.discountPrice.currencyValueFormat()
                                        //         : product.price.currencyValueFormat())
                                        //     .text
                                        //     .lg
                                        //     .fontFamily(AppFonts.appFont)
                                        //     .color(AppColor.primary)
                                        //     .semiBold
                                        //     .make(),
                                      ],
                                      crossAlignment: CrossAxisAlignment.end,
                                    ),
                                    // UiSpacer.horizontalSpace(space: 5),
                                    // //discount
                                    // product.showDiscount
                                    //     ? CurrencyHStack(
                                    //         [
                                    //           currencySymbol.text.lineThrough.xs
                                    //               .fontFamily(AppFonts.appFont)
                                    //               .color(AppColor.primary)
                                    //               .make(),
                                    //           product.price
                                    //               .currencyValueFormat()
                                    //               .text
                                    //               .fontFamily(AppFonts.appFont)
                                    //               .lineThrough
                                    //               .color(AppColor.primary)
                                    //               .lg
                                    //               .medium
                                    //               .make(),
                                    //         ],
                                    //       )
                                    //     : UiSpacer.emptySpace(),
                                  ]).pOnly(left: Vx.dp8),

                                  UiSpacer.verticalSpace(space: 5),

                                  //
                                  //description
                                  // "${vendor.description}"
                                  //     .text
                                  //     .gray400
                                  //     .minFontSize(9)
                                  //     .size(9)
                                  //     .maxLines(1)
                                  //     .overflow(TextOverflow.ellipsis)
                                  //     .make()
                                  //     .px8(),
                                ],
                              ).expand(),
                              // VStack(
                              //   [
                              //     UiSpacer.verticalSpace(space: 5),
                              //     TimeTag(vendor.prepareTime,
                              //         iconData: FlutterIcons.clock_outline_mco),
                              //     UiSpacer.verticalSpace(space: 5),
                              //     TimeTag(
                              //       vendor.deliveryTime,
                              //       iconData: FlutterIcons.ios_bicycle_ion,
                              //     ),
                              //   ],
                              // ).pSymmetric(h: 2)
                            ]).px8().expand(),
                            VStack([
                              HStack([
                                "${product.rating} "
                                    .text
                                    .minFontSize(6)
                                    .size(24)
                                    .color(AppColor.primary)
                                    .bold
                                    .make(),
                                Image.asset(
                                  AppImages.goldenStar,
                                  height: 28,
                                ),
                              ]),
                              /*  ProductStockState(
                                product,
                                qtyUpdated: vm.addToCartDirectly,
                              ),*/
                            ]).px8()
                          ])
                        ],
                      )
                          .onLongPress(
                            () => vm.removeFavourite(product),
                            GlobalKey(),
                          )
                          .onTap(() => vm.openProductDetails(product))
                          .w(context.percentWidth * 80)
                          .box
                          .outerShadow
                          .border(width: 2, color: AppColor.primary)
                          .color(context.theme.colorScheme.surface)
                          .clip(Clip.antiAlias)
                          .withRounded(value: 22)
                          .make()
                          .pOnly(bottom: Vx.dp8, right: 15);
                    },
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(space: 10),
                  ).h(223),
                  const SizedBox(height: 20)
                ],
              ),
            ),
            Positioned(
                right: 0,
                top: 0,
                child: Image.asset(
                  'assets/images/fav_header.png',
                  height: 90,
                ))
          ],
        );
      },
    );
  }
}
