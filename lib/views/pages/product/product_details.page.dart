import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:banner_carousel/banner_carousel.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_ui_sizes.dart';
import '../../../models/option_group.dart';
import '../../../models/product.dart';
import '../../../utils/ui_spacer.dart';
import '../../../view_models/product_details.vm.dart';
import '../../../widgets/base.page.dart';
import '../../../widgets/busy_indicator.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/share.btn.dart';
import '../../../widgets/cart_page_action.dart';
import '../../../widgets/custom_grid_view.dart';
import '../../../widgets/custom_image.view.dart';
import '../../../widgets/list_items/category.list_item.dart';
import '../../../widgets/tags/fav.positioned.dart';
import '../vendor_details/vendor_category_products.page.dart';
import 'heart_level_selectionview.dart';
import 'widgets/product_details.header.dart';
import 'widgets/product_option_group.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    required this.product,
    super.key,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(context, product!),
      onViewModelReady: (model) => model.getProductDetails(),
      builder: (context, model, child) {
        return BasePage(
          title: model.product.name,
          showAppBar: false,
          showLeadingAction: true,
          elevation: 0,
          appBarColor: AppColor.faintBgColor,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          actions: [
            SizedBox(
              width: 50,
              height: 50,
              child: FittedBox(
                child: ShareButton(
                  model: model,
                ),
              ),
            ),
            UiSpacer.hSpace(10),
            const PageCartAction(),
          ],
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                floating: false,
                pinned: false,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, model.backFlag);
                  },
                  child: Container(
                    height: 50,
                    width: 45,
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Image.asset(AppImages.closeButton),
                  ),
                ),
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text(""),
                  background:
                  //vendor image
                  BannerCarousel(
                    customizedBanners: model.product.photos.map((photoPath) {
                      return CustomImage(
                        imageUrl: photoPath,
                        boxFit: BoxFit.cover,
                        canZoom: true,
                      );
                    }).toList(),
                    customizedIndicators: const IndicatorModel.animation(
                      width: 10,
                      height: 6,
                      spaceBetween: 2,
                      widthAnimation: 50,
                    ),
                    margin: EdgeInsets.zero,
                    height: 280,
                    width: context.percentWidth * 100,
                    activeColor: AppColor.primaryColor,
                    disableColor: Colors.grey.shade300,
                    animation: true,
                    borderRadius: 0,
                    indicatorBottom: false,
                  ).box.color(AppColor.faintBgColor).make().wFull(context),
                ),
                actions: [
                  product != null ? FavPositiedView(product!) : const SizedBox()
                ],
              ),
              //product image

              SliverToBoxAdapter(
                child: VStack(
                  [
                    //product header
                    ProductDetailsHeader(product: model.product),
                    // HStack([
                    //   VStack([
                    //     // HStack([
                    //     //   "Choose heat level:"
                    //     //       .tr()
                    //     //       .richText
                    //     //       .lg
                    //     //       .fontFamily(AppFonts.appFont)
                    //     //       .color(AppColor.primaryColor)
                    //     //       .bold
                    //     //       .make()
                    //     //       .fittedBox(),
                    //     //   5.widthBox,
                    //     //   "Required"
                    //     //       .text
                    //     //       .sm
                    //     //       .fontFamily(AppFonts.appFont)
                    //     //       .size(2)
                    //     //       .color(AppColor.primaryColor)
                    //     //       .make()
                    //     //       .p4()
                    //     //       .py0()
                    //     //       .box
                    //     //       .withRounded()
                    //     //       .color(Colors.grey.withOpacity(.4))
                    //     //       .make()
                    //     // ]),
                    //     "(Choose only 1)"
                    //         .text
                    //         .sm
                    //         .fontFamily(AppFonts.appFont)
                    //         .color(AppColor.primaryColor)
                    //         .make(),
                    //   ]).pOnly(left: 20),
                    // ]),
                    // HtmlTextView(model.product.description).px20(),
                    // HeartLevelSelectionView(
                    //   onValueChanged: (value) {
                    //     model.heatLevel = value;
                    //   },
                    // ),

                    //options header
                    Visibility(
                      visible: model.product.optionGroups.isNotEmpty,
                      child: VStack(
                        [
                          /*ProductOptionsHeader(
                            description:
                                "Select options to add them to the product/service"
                                    .tr(),
                          ),*/

                          /*HStack([
                            "Popular Add-ons:"
                                .tr()
                                .richText
                                .lg
                                .fontFamily(AppFonts.appFont)
                                .color(AppColor.primaryColor)
                                .bold
                                .make()
                                .fittedBox(),
                            5.widthBox,
                            "Optional"
                                .text
                                .sm
                                .fontFamily(AppFonts.appFont)
                                .size(2)
                                .color(AppColor.primaryColor)
                                .make()
                                .p4()
                                .py0()
                                .box
                                .withRounded()
                                .color(Colors.grey.withOpacity(.4))
                                .make()
                          ]).pOnly(left: 20, bottom: 10.0),*/
                          //options
                          model.busy(model.product)
                              ? const BusyIndicator().centered().py20()
                              : VStack(
                                  [
                                    ...buildProductOptions(model),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    if (model.isBusy)
                      const BusyIndicator().p20().centered()
                    else
                      CustomGridView(
                        noScrollPhysics: true,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: AppUISizes.getAspectRatio(
                          context,
                          AppStrings.categoryPerRow,
                          AppStrings.categoryImageHeight + 35,
                        ),
                        crossAxisCount: AppStrings.categoryPerRow,
                        dataSet: model.vendor?.categories,
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (ctx, index) {
                          final category = model.vendor?.categories[index];
                          return CategoryListItem(
                            h: AppStrings.categoryImageHeight + 20,
                            category: category!,
                            onPressed: (category) {
                              context.nextPage(
                                VendorCategoryProductsPage(
                                  category: category,
                                  vendor: model.vendor!,
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                )
                    .pOnly(bottom: context.percentHeight * 50)
                    .box
                    .outerShadow3Xl
                    .color(context.theme.colorScheme.background)
                    .topRounded(value: 20)
                    .clip(Clip.antiAlias)
                    .make(),
              ),
            ],
          ).box.color(AppColor.faintBgColor).make(),
          bottomSheet: (model.product.hasStock
                  ? CustomButton(
                      loading: model.isBusy,
                      shapeRadius: 10,
                      onPressed: model.addToCart,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            "Add to cart".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: AppColor.primaryColor,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold),
                          ).centered(),
                          const SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            "(${model.currencySymbol} ${model.total.currencyValueFormat()} plus fees and taxes minus discount)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10.0,
                                color: AppColor.primaryColor,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold),
                          ).centered(),
                          const SizedBox(
                            height: 12.0,
                          ),
                        ],
                      ),
                    )
                      .box
                      .withRounded(value: 10)
                      .border(width: 2, color: AppColor.primary)
                      .margin(
                        const EdgeInsets.symmetric(horizontal: 32.0),
                      )
                      .make()
                      .p12()
                  : "No stock"
                      .tr()
                      .text
                      .white
                      .fontFamily(AppFonts.appFont)
                      .makeCentered()
                      .p8()
                      .box
                      .red500
                      .roundedSM
                      .make()
                      .p8()
                      .wFull(context))
              .box
              .make()
              .wFull(context),
        );
      },
    );
  }

  buildProductOptions(model) {
    return model.product.optionGroups.map((OptionGroup optionGroup) {
      return ProductOptionGroup(optionGroup: optionGroup, model: model)
          .pOnly(bottom: Vx.dp12);
    }).toList();
  }
}
