import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/wallet_transaction.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class WalletTransactionListItem extends StatelessWidget {
  const WalletTransactionListItem(this.walletTransaction, {super.key});

  final WalletTransaction walletTransaction;

  @override
  Widget build(BuildContext context) {
    return   VStack(
      [
        //
        UiSpacer.verticalSpace(space: 5),
        HStack(
          [
            (walletTransaction.status.isEmpty
                    ? 'Error'
                    : walletTransaction.status)
                .tr()
                .allWordsCapitilize()
                .text
                .medium
                .sm
                .color(AppColor.getStausColor(walletTransaction.status))
                .make()
                .expand(),
            ("${walletTransaction.isCredit == 1 ? '+' : '-'} ${"${AppStrings.currencySymbol} ${walletTransaction.amount}".currencyFormat()}")
                .text
                .semiBold
                .lg
                .color(
                    walletTransaction.isCredit == 1 ? Colors.green : Colors.red)
                .make()
          ],
        ),
        //
        HStack(
          [
            walletTransaction.reason.text.sm.make().expand(),
            DateFormat.MMMd(LocalizeAndTranslate.getLocale().languageCode)
                .format(walletTransaction.createdAt)
                .text
                .light
                .make()
          ],
        ),
      ],
    ).p8()
        .box
        .outerShadow
        .color(context.cardColor)
        .withRounded(value: 1)
        .clip(Clip.antiAlias)
        .make()
        .px2();
  }
}
