import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/widgets/cards/custom.visibility.dart';
import 'package:mealknight/widgets/currency_hstack.dart';
import 'package:mealknight/widgets/custom_image.view.dart';
import 'package:mealknight/widgets/tags/fav.positioned.dart';
import 'package:mealknight/widgets/tags/product_tags.dart';
import 'package:velocity_x/velocity_x.dart';

class FoodHorizontalProductListItem extends StatelessWidget {
  //
  const FoodHorizontalProductListItem(
    this.product, {
    this.onPressed,
    required this.qtyUpdated,
    this.height,
    Key? key,
  }) : super(key: key);

  //
  final Product product;
  final Function(Product)? onPressed;
  final Function(Product, int)? qtyUpdated;
  final double? height;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return GestureDetector(
      onTap:  onPressed == null ? null : () => onPressed!(product),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 10),
        child: Container(
          width: 300,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                width: 2, color: AppColor.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Stack(
                children: [
                  Container(
                    child:ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      child: AspectRatio(
                        aspectRatio: 21 / 9,
                        child:
                            CustomImage(
                              imageUrl: product.photo,
                              width: height != null ? (height! / 1.6) : height,
                              height: height,
                            ),
                      ),
                    ), ),

                  Positioned(
                    child:  FavPositiedView(product,size: 35,),
                    top: 5,
                    right: 10,
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                style:TextStyle(
                                    color:AppColor.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Wrap(
                                        children: [
                                          //price
                                          CurrencyHStack(
                                            [
                                              currencySymbol.text.fontFamily(AppFonts.appFont).color(AppColor.primary).sm.make(),

                                              (product.showDiscount
                                                      ? product.discountPrice.currencyValueFormat()
                                                      : product.price.currencyValueFormat())
                                                  .text.fontFamily(AppFonts.appFont)
                                                  .lg
                                              .color(AppColor.primary)
                                                  .semiBold
                                                  .make(),
                                            ],
                                            crossAlignment: CrossAxisAlignment.end,
                                          ),
                                          5.widthBox,
                                          //discount price
                                          CustomVisibilty(
                                            visible: product.showDiscount,
                                            child: CurrencyHStack(
                                              [
                                                currencySymbol.text.fontFamily(AppFonts.appFont).color(AppColor.primary).lineThrough.xs.make(),
                                                product.price
                                                    .currencyValueFormat()
                                                    .text.fontFamily(AppFonts.appFont)
                                                    .lineThrough
                                                .color(AppColor.primary)
                                                    .lg
                                                    .medium
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ],),
                      ),
                     Row(
                       children: [
                         Text(
                              "${product.rating}",
                             style: TextStyle(
                                 color:AppColor.primaryColor,
                                 fontSize: 25,
                                 fontWeight: FontWeight.w700)
                         ),
                         Image.asset(
                           AppImages.goldenStar,
                           fit: BoxFit.cover,width: 25,
                         )
                       ],
                     )
                    ],
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
