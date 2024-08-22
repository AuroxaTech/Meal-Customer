import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/views/shared/go_to_cart.view.dart';
import 'package:mealknight/widgets/cart_page_action.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

class BasePage extends StatefulWidget {
  final bool showAppBar;
  final bool showLeadingAction;
  final bool? extendBodyBehindAppBar;
  final Function? onBackPressed;
  final bool showCart;
  final dynamic title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? fab;
  final FloatingActionButtonLocation? fabLocation;
  final bool isLoading;
  final Color? appBarColor;
  final double? elevation;
  final Color? appBarItemColor;
  final Color? backgroundColor;
  final bool showCartView;
  final bool isBackground;
  final bool? centerTitle;
  final PreferredSize? customAppbar;

  const BasePage({
    this.showAppBar = false,
    this.leading,
    this.showLeadingAction = false,
    this.onBackPressed,
    this.showCart = false,
    this.title = "",
    this.actions,
    required this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.fab,
    this.fabLocation,
    this.isLoading = false,
    this.appBarColor,
    this.appBarItemColor,
    this.backgroundColor,
    this.elevation,
    this.extendBodyBehindAppBar,
    this.showCartView = false,
    this.centerTitle = false,
    this.isBackground = true,
    this.customAppbar,
    super.key,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  double bottomPaddingSize = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizeAndTranslate.getLocale().languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: KeyboardDismisser(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: widget.backgroundColor ?? AppColor.faintBgColor,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
          appBar: widget.customAppbar ??
              (widget.showAppBar
                  ? AppBar(
                      backgroundColor:
                          widget.appBarColor ?? context.primaryColor,
                      elevation: widget.elevation,
                      automaticallyImplyLeading: widget.showLeadingAction,
                      centerTitle: widget.centerTitle,
                      leading: widget.showLeadingAction
                          ? widget.leading ??
                              IconButton(
                                icon: Image.asset(
                                  AppImages.swipeLeft,
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: widget.onBackPressed != null
                                    ? () => widget.onBackPressed!()
                                    : () => Navigator.pop(context),
                              )
                          : null,
                      title: widget.title is Widget
                          ? widget.title
                          : "${widget.title}"
                              .text
                              .size(26)
                              .maxLines(1)
                              .bold
                              .overflow(TextOverflow.ellipsis)
                              .color(widget.appBarItemColor ?? Colors.white)
                              .make(),
                      actions: widget.actions ??
                          [
                            widget.showCart
                                ? const PageCartAction()
                                : UiSpacer.emptySpace(),
                          ],
                    )
                  : null),
          body: Stack(
            children: [
              widget.isBackground
                  ? Image.asset(AppImages.homeBG,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height)
                  : const SizedBox(
                      height: 0.0,
                      width: 0.0,
                    ),
              VStack([
                widget.isLoading
                    ? const LinearProgressIndicator()
                    : UiSpacer.emptySpace(),
                widget.body.pOnly(bottom: bottomPaddingSize).expand(),
              ]),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: widget.showCartView,
                  child: MeasureSize(
                    onChange: (size) {
                      setState(() {
                        bottomPaddingSize = size.height;
                      });
                    },
                    child: const GoToCartView(),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: widget.bottomNavigationBar,
          bottomSheet: widget.bottomSheet,
          floatingActionButton: widget.fab,
          floatingActionButtonLocation: widget.fabLocation,
        ),
      ),
    );
  }
}
