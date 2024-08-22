import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/search.vm.dart';
import 'package:mealknight/widgets/inputs/search_bar.input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader(
    this.model, {
    Key? key,
    this.subtitle,
    this.showCancel = true,
  }) : super(key: key);

  final SearchViewModel model;
  final bool showCancel;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //Appbar
        HStack(
          [
            VStack(
              [
                Text(
                  "Search",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                    color: AppColor.primaryColor,
                  ),
                ),
                Visibility(
                  visible: subtitle != null,
                  child: "$subtitle".text.make(),
                ),
                // Visibility(
                //   visible: subtitle == null,
                //   child: "Ordered by Nearby first".tr().text.make(),
                // ),
              ],
            ).expand(),

            //
            showCancel
                ? Icon(
                    FlutterIcons.close_ant,
                  ).p4().onInkTap(() {
                    Navigator.of(context).pop();
                  })
                : UiSpacer.emptySpace(),
          ],
        ).pOnly(bottom: 10),
        //
        SearchBarInputWithBorder(
          readOnly: false,
          showFilter: true,
          searchTEC: model.searchTEC,
          onSubmitted: (keyword) {
            model.keyword = keyword;
            model.startSearch();
          },
          onFilterPressed: () => model.showFilterOptions(),
        ),

        //search history, horizontal list
        Visibility(
          visible: model.searchHistory.isNotEmpty,
          child: VStack(
            [
              "Search History".tr().text.make(),
              UiSpacer.verticalSpace(space: 0.02),
              HStack(
                [
                  for (var history in model.searchHistory)
                    history.text
                        .color(Theme.of(context).primaryColor)
                        .make()
                        .p4()
                        .onInkTap(
                      () {
                        model.searchTEC.text = history;
                        model.keyword = history;
                        model.startSearch();
                      },
                    ),
                ],
              ),
            ],
          ).pOnly(top: 20),
        ),
      ],
    );
  }
}
