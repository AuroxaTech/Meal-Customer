import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/services/navigation.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchBarInput extends StatelessWidget {
  const SearchBarInput({
    this.hintText,
    this.onTap,
    this.onFilterPressed,
    this.onSubmitted,
    this.readOnly = true,
    this.showFilter = false,
    this.search,
    this.searchTEC,
    super.key,
  });

  final String? hintText;
  final Function? onTap;
  final Function? onFilterPressed;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final Search? search;
  final bool showFilter;
  final TextEditingController? searchTEC;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        TextFormField(
          readOnly: readOnly,
          onTap: () {
            if (search != null) {
              //pages
              final page = NavigationService().searchPageWidget(search!);
              context.nextPage(page);
            } else if (onTap != null) {
              onTap!();
            }
          },
          controller: searchTEC,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText ?? "Search".tr(),
            hintStyle: TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14),
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AppImages.searchImage,
                  width: 10, height: 10, fit: BoxFit.contain),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            filled: true,
            fillColor: Colors.transparent,
          ),
        )
            .box
            .color(Colors.transparent)
            //.outerShadowSm
            .roundedSM
            .clip(Clip.antiAlias)
            .make()
            .expand(),
        if (showFilter)
          HStack(
            [
              UiSpacer.horizontalSpace(),
              //filter icon
              IconButton(
                onPressed: null,
                color: context.theme.colorScheme.background,
                icon: Image.asset(AppImages.sortIcon),
              )
                  .onInkTap(
                    onFilterPressed != null ? () => onFilterPressed!() : () {},
                  )
                  .material(color: context.theme.colorScheme.background)
                  .box
                  .color(context.theme.colorScheme.background)
                  .outerShadowSm
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .make(),
            ],
          ),
      ],
    );
  }
}

class SearchBarInputWithBorder extends StatelessWidget {
  const SearchBarInputWithBorder({
    this.hintText,
    this.onTap,
    this.onFilterPressed,
    this.onSubmitted,
    this.readOnly = true,
    this.showFilter = false,
    this.search,
    this.searchTEC,
    super.key,
  });

  final String? hintText;
  final Function? onTap;
  final Function? onFilterPressed;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final Search? search;
  final bool showFilter;
  final TextEditingController? searchTEC;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 2, color: AppColor.primaryColor),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, 3),
                      blurRadius: 1,
                      spreadRadius: 1)
                ],
              ),
              child: TextFormField(
                readOnly: readOnly,
                onTap: () {
                  if (search != null) {
                    //pages
                    final page = NavigationService().searchPageWidget(search!);
                    context.nextPage(page);
                  } else if (onTap != null) {
                    onTap!();
                  }
                },
                onChanged: onSubmitted,
                controller: searchTEC,
                onFieldSubmitted: onSubmitted,
                decoration: InputDecoration(
                  hintText: hintText ?? "Search".tr(),
                  hintStyle: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(AppImages.searchImage,
                        width: 10, height: 10, fit: BoxFit.contain),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              )),
        ),
        if (showFilter) ...[
          UiSpacer.horizontalSpace(),
          ClipOval(
            // ClipOval widget to clip the child inside a circle
            child: Container(
              color: Colors.white,
              width: 62,
              height: 62,
              child: IconButton(
                onPressed: null,
                color: context.theme.colorScheme.background,
                icon: Image.asset('assets/icons/sort_icon.png'),
              )
                  .onInkTap(
                    onFilterPressed != null ? () => onFilterPressed!() : () {},
                  )
                  .material(color: context.theme.colorScheme.background)
                  .box
                  .color(context.theme.colorScheme.background)
                  .outerShadowSm
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .make(),
            ),
          ),
        ],
      ],
    );
  }
}
