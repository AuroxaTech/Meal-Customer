import 'package:flutter/material.dart';
import 'package:mealknight/models/flash_sale.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/flash_sale.vm.dart';
import 'package:mealknight/views/pages/flash_sale/flash_sale.page.dart';
import 'package:mealknight/views/pages/flash_sale/widgets/flash_sale.item_view.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/custom_listed.list_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../widgets/section.title.dart';

class FlashSaleView extends StatefulWidget {
  const FlashSaleView(this.vendorType, {super.key});

  final VendorType vendorType;

  @override
  State<FlashSaleView> createState() => _FlashSaleViewState();
}

class _FlashSaleViewState extends State<FlashSaleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlashSaleViewModel>.reactive(
      viewModelBuilder: () =>
          FlashSaleViewModel(context, vendorType: widget.vendorType),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        if (vm.isBusy) {
          return const BusyIndicator().p20().centered();
        } else if (vm.flashSales.isEmpty) {
          return UiSpacer.emptySpace();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiSpacer.verticalSpace(space: 10),
            const SectionTitle("Flash Sales").pOnly(left: 12, bottom: 8),
            ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: flashSalesListView(context, vm),
            ).h(90),
          ],
        );
      },
    );
  }

  //
  List<Widget> flashSalesListView(
    BuildContext context,
    FlashSaleViewModel vm,
  ) {
    List<Widget> list = [];
    List<FlashSale> flashSales = vm.flashSales;

    for (var flashSale in flashSales) {
      if (flashSale.items == null ||
          flashSale.items!.isEmpty ||
          flashSale.isExpired) {
        list.add(UiSpacer.emptySpace());
        continue;
      }
      // Widget title = HStack(
      //   [
      //     Icon(
      //       FlutterIcons.sale_mco,
      //       color: Utils.textColorByColor(AppColor.closeColor),
      //     ),
      //     UiSpacer.hSpace(10),
      //     VStack(
      //       [
      //         "${flashSale.name}"
      //             .text
      //             .semiBold
      //             .lg
      //             .color(Utils.textColorByTheme())
      //             .make(),
      //         UiSpacer.vSpace(1),
      //         HStack(
      //           [
      //             "TIME LEFT:"
      //                 .tr()
      //                 .text
      //                 .light
      //                 .sm
      //                 .color(Utils.textColorByTheme())
      //                 .make(),
      //             UiSpacer.hSpace(6),
      //             SlideCountdown(
      //               textStyle: TextStyle(
      //                 fontSize: 11,
      //                 color: Utils.textColorByColor(AppColor.closeColor),
      //               ),
      //               duration: flashSale.countDownDuration,
      //               separatorType: SeparatorType.symbol,
      //               slideDirection: SlideDirection.up,
      //               onDone: () {
      //                 vm.notifyListeners();
      //               },
      //             ),
      //           ],
      //         ),
      //       ],
      //     ).expand(),
      //     UiSpacer.hSpace(10),
      //     //
      //     "SEE ALL"
      //         .tr()
      //         .text
      //         .color(Utils.textColorByColor(AppColor.closeColor))
      //         .make()
      //         .onTap(
      //           () => openFlashSaleItems(context, flashSale),
      //         ),
      //   ],
      // ).p12().box.color(AppColor.closeColor).make().wFull(context);
      //categories list
      Widget items = CustomListedListView(
        noScrollPhysics: false,
        scrollDirection: Axis.horizontal,
        items: (flashSale.items ?? []).map(
          (flashSaleItem) {
            return FittedBox(
              child: FlashSaleItemListItem(flashSaleItem),
            ).pOnly(right: 5, left: 12);
          },
        ).toList(),
      ).h(80);

      list.add(VStack(
        [
          // title,
          items.py4(),
        ],
      ));
    }

    return list;
  }

  openFlashSaleItems(BuildContext context, FlashSale flashsale) {
    context.nextPage(FlashSaleItemsPage(flashsale));
  }
}
