import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/view_models/favourite_vendor.vm.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class FavVendorPositionedView extends StatelessWidget {
  const FavVendorPositionedView(this.vendor,
      {super.key, required this.onFavoriteChange, this.size});

  final Vendor vendor;
  final double? size;
  final Function(bool isFavorite) onFavoriteChange;

  @override
  Widget build(BuildContext context) {
    double iconSize = size ?? 25;
    return ViewModelBuilder<FavouriteVendorViewModel>.reactive(
      viewModelBuilder: () => FavouriteVendorViewModel(context, vendor,onFavoriteChange),
      builder: (context, model, child) {
        return model.isBusy
            ? const BusyIndicator().wh(iconSize - 5, iconSize - 5)
            : GestureDetector(
                onTap: () {
                  !model.isAuthenticated()
                      ? model.openLogin()
                      : !model.vendor!.isFavorite
                          ? model.addFavouriteVendor()
                          : model.removeFavouriteVendor();
                },
                child: (model.vendor?.isFavorite ?? false)
                    ? Image.asset(
                        AppImages.like,
                        height: iconSize,
                        width: iconSize,
                      )
                    : Icon(FlutterIcons.favorite_border_mdi,
                        color: AppColor.primary, size: iconSize));
      },
    );
  }
}
