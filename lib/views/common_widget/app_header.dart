import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_font.dart';
import '../../constants/app_images.dart';
import '../../models/category.dart';
import '../../models/search.dart';
import '../../models/vendor_type.dart';
import '../../services/navigation.service.dart';
import '../../view_models/search.vm.dart';
import '../pages/favourite/favourites.page.dart';
import 'header_option.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.vendorType,
    required this.type,
    required this.subCategories,
    required this.vendorTypes,
    this.showFilter = true,
    this.hintText = "Search here...",
    this.onCategorySelected,
  });

  final VendorType? vendorType;
  final List<Category> subCategories;
  final List<VendorType> vendorTypes;
  final String hintText;
  final bool showFilter;
  final String type;
  final Function(Category? category)? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
        viewModelBuilder: () => SearchViewModel(
              context,
              Search(
                vendorId: vendorType?.id,
                vendorType: (null != vendorType && vendorType!.isService)
                    ? vendorType
                    : null,
                type: (null != vendorType && vendorType!.isService)
                    ? 'service'
                    : 'product',
              ),
            ),
        onViewModelReady: (model) => model.startSearch(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 45.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(width: 2, color: AppColor.primary),
                              borderRadius: BorderRadius.circular(42),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(AppImages.searchImage,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.contain),
                                ),
                                hintText.text
                                    .color(AppColor.primaryColor)
                                    .size(12.0)
                                    .fontFamily(AppFonts.appFont)
                                    .make()
                                    .expand(),
                              ],
                            )
                            /*Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SearchBarInput(
                                hintText: hintText,
                                readOnly: true,
                                search: Search(
                                  vendorType: vendorType,
                                  viewType: SearchType.vendorProducts,
                                ),
                                onSubmitted: (keyword) {
                                  model.keyword = keyword;
                                  model.startSearch();
                                },
                                searchTEC: model.searchTEC,
                              ),
                            ),
                            if (showFilter)
                              IconButton(
                                onPressed: () => model.showFilterOptions(),
                                color: Colors.transparent,
                                icon: Image.asset(
                                  AppImages.sortIcon,
                                  height: 20,
                                ),
                              )
                          ],
                        ),*/

                            ).onInkTap(() {
                          final page =
                              NavigationService().searchPageWidget(Search(
                            type: type,
                            vendorType: vendorType,
                            viewType: SearchType.vendorProducts,
                          ));
                          context.nextPage(page);
                        }),
                      ),
                      10.widthBox,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouritesPage(
                                      vendorTypes: vendorTypes,
                                    )),
                          );
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(42)),
                          child: Image.asset(AppImages.like),
                        ),
                      ),
                      5.widthBox,
                    ],
                  ),
                ),
                if (subCategories.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 5),
                    child: HeaderOption(
                      subCategoryList: subCategories,
                      onCategorySelected: onCategorySelected,
                    ),
                  ),
                ]
              ],
            ),
          );
        });
  }
}
