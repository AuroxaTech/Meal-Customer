import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/view_models/vendor_rating.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorRatingBottomSheet extends StatelessWidget {
  const VendorRatingBottomSheet({
    super.key,
    required this.onSubmitted,
    required this.order,
  });

  final Order order;
  final Function onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorRatingViewModel>.reactive(
      viewModelBuilder: () =>
          VendorRatingViewModel(context, order, onSubmitted),
      builder: (context, vm, child) {
        return BasePage(
          body: VStack(
            [
              //
              Image.asset(
                AppImages.vendor,
              ).centered(),
              //
              "Did you like provided service by %s ?"
                  .tr()
                  .fill([order.vendor!.name])
                  .text
                  .center
                  .xl
                  .semiBold
                  .makeCentered()
                  .py12(),
              //
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.yellow[700],
                ),
                onRatingUpdate: (rating) {
                  vm.updateRating(rating.toInt().toString());
                },
              ).centered().py12(),

              //
              CustomTextFormField(
                minLines: 3,
                maxLines: 4,
                textEditingController: vm.reviewTEC,
                labelText: "Comment".tr(),
              ).py12(),

              //
              SafeArea(
                child: CustomButton(
                  title: "Submit".tr(),
                  onPressed: vm.submitRating,
                  loading: vm.isBusy,
                ).centered().py16(),
              ),
            ],
          ).p20().scrollVertical(),
        ).hTwoThird(context).pOnly(bottom: context.mq.viewInsets.bottom);
      },
    );
  }
}
