import 'package:flutter/material.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/view_models/vendor/banners.vm.dart';
import 'package:mealknight/widgets/list_items/banner.list_item.dart';
import 'package:mealknight/widgets/states/loading.shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Banners extends StatelessWidget {
  const Banners({
    this.vendorType,
    this.viewportFraction = 0.8,
    this.showIndicators = false,
    this.featured = false,
    this.disableCenter = false,
    this.padding = 5,
    this.itemRadius,
    super.key,
  });

  final VendorType? vendorType;
  final double viewportFraction;
  final bool showIndicators;
  final bool featured;
  final bool disableCenter;
  final double padding;
  final double? itemRadius;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BannersViewModel>.reactive(
      viewModelBuilder: () => BannersViewModel(
        context,
        vendorType,
        featured: featured,
      ),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return model.isBusy
            ? const LoadingShimmer().px20().h(150)
            : Visibility(
                visible: model.banners.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: VStack(
                    [
                      CarouselSlider(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: BannerListItem(
                                imageUrl: banner.photo ?? "",
                                radius: 20,
                                noMargin: true,
                                onPressed: () => model.bannerSelected(banner),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
