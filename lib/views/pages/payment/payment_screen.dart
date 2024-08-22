import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../view_models/payment.view_model.dart';
import '../../../widgets/base.page.dart';
import '../../../widgets/payment/payment_card_view.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
        viewModelBuilder: () => PaymentViewModel(),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePage(
            showAppBar: true,
            showLeadingAction: true,
            elevation: 0,
            title: "Payments".tr(),
            centerTitle: true,
            actions: [
              Image.asset(
                "assets/images/paymentcardicon.png",
                height: 50,
                width: 80,
              )
            ],
            appBarColor: context.theme.colorScheme.surface,
            appBarItemColor: AppColor.primaryColor,
            backgroundColor: const Color(0xffeefffd),
            isLoading: model.isBusy,
            body: Column(
              children: [
                "Saved Cards"
                    .tr()
                    .text
                    .lg
                    .fontWeight(FontWeight.w600)
                    .fontFamily(AppFonts.appFont)
                    .color(AppColor.primary)
                    .make()
                    .p20(),
                Expanded(
                  child: ListView(
                    children: [
                      for (var paymentCard in model.paymentCards)
                        PaymentCardView(
                          image: paymentCard.cardBrand.toLowerCase() == "visa"
                              ? "assets/images/visacard.png"
                              : "assets/images/masterCard.png",
                          cardName: paymentCard.cardholderName,
                          number: "**** **** **** ${paymentCard.last4}",
                          expiryDate:
                              "${paymentCard.expMonth.padLeft(2, '0')}/${paymentCard.expYear}",
                          setDefault: paymentCard.id ==
                              model.user.squareupDefaultCardId,
                          onSetAsDefault: () {
                            model.markCardAsDefault(paymentCard);
                          },
                          onDisable:(){
                            model.disableCard(paymentCard);
                          }
                        ),
                      paymentMethodButton(context, onTap: () {
                        model.onStartCardEntryFlow(context);
                      }),
                      10.heightBox,
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget paymentMethodButton(BuildContext context, {VoidCallback? onTap}) {
    return //name
        "Add new payment method"
            .text
            .lg
            .medium
            .center
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .fontWeight(FontWeight.w600)
            .color(AppColor.primary)
            .make()
            .pOnly(top: Vx.dp8, bottom: Vx.dp8)
            .box
            .outerShadow
            .border(width: 2, color: AppColor.primary)
            .color(context.theme.colorScheme.surface)
            .clip(Clip.antiAlias)
            .withRounded(value: 10)
            .make()
            .onInkTap(onTap)
            .p20();
  }
}
