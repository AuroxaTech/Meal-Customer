import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/view_models/favourite.vm.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class FavPositiedView extends StatelessWidget {
  const FavPositiedView(this.product, {Key? key,this.size}) : super(key: key);

  final Product product;
  final double ?size;

  @override
  Widget build(BuildContext context) {
    double iconSize = size??45;
    //fav icon

    return ViewModelBuilder<FavouriteViewModel>.reactive(
      viewModelBuilder: () => FavouriteViewModel(context, product),
      builder: (context, model, child) {
        return model.isBusy
            ? BusyIndicator().wh(iconSize-10, iconSize-10).p8()
            : GestureDetector(
                onTap: () {
                  !model.isAuthenticated()
                      ? model.openLogin()
                      : !model.product.isFavourite
                          ? model.addFavourite()
                          : model.removeFavourite();
                },
                child: product.isFavourite
                    ? Image.asset(
                        AppImages.like,
                        height: iconSize,
                        width: iconSize,
                      )
                    : Icon(FlutterIcons.favorite_border_mdi,
                        color:AppColor.primary, size: iconSize));


      },
    );
  }
}
