import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_ui_settings.dart';
import 'package:mealknight/services/cart.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/app_routes.dart';

class PageCartAction extends StatefulWidget {
  const PageCartAction({
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 12,
    this.iconSize = 24,
    this.badgeSize = 14,
    this.padding = 10,
    super.key,
  });

  final Color color;
  final Color textColor;
  final double badgeSize;
  final double iconSize;
  final double fontSize;
  final double padding;

  @override
  State<PageCartAction> createState() => _PageCartActionState();
}

class _PageCartActionState extends State<PageCartAction> {
  @override
  void initState() {
    super.initState();
    CartServices.getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return !AppUISettings.showCart
        ? UiSpacer.emptySpace()
        : StreamBuilder(
            stream: CartServices.cartItemsCountStream.stream,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Icon(
                FlutterIcons.shopping_cart_fea,
                color: widget.color,
                size: widget.iconSize,
              )
                  .badge(
                    count: snapshot.data,
                    size: widget.badgeSize,
                    color: widget.color,
                    textStyle: context.textTheme.bodyLarge?.copyWith(
                      fontSize: widget.fontSize,
                      color: widget.textColor,
                    ),
                  )
                  .centered()
                  .box
                  .p8
                  .color(context.primaryColor)
                  .roundedFull
                  .make()
                  .pOnly(
                    right: Utils.isArabic ? 0 : widget.padding,
                    left: Utils.isArabic ? widget.padding : 0,
                  )
                  .onInkTap(
                () async {
                  Navigator.pushNamed(context, AppRoutes.cartRoute);
                },
              );
            },
          );
  }
}
