import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/services/validator.service.dart';
import 'package:mealknight/view_models/login.view_model.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.formKey,
      child: VStack(
        [
          //
          CustomTextFormField(
            labelText: "Email".tr(),
            keyboardType: TextInputType.emailAddress,
            textEditingController: model.emailTEC,
            validator: FormValidator.validateEmail,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(' '),
              ),
            ],
          ).pOnly(bottom: 12),
          CustomTextFormField(
            labelText: "Password".tr(),
            obscureText: true,
            textEditingController: model.passwordTEC,
            validator: FormValidator.validatePassword,
          ).py12(),

          //
          "Forgot Password ?".tr().text.fontFamily(AppFonts.appFont).underline.make().onInkTap(
                model.openForgotPassword,
              ),
          //
          CustomButton(
            title: "Login".tr(),
            loading: model.isBusy,
            onPressed: model.processLogin,
            shapeRadius: 14,
          ).centered().pOnly(top: 12),
        ],
        crossAlignment: CrossAxisAlignment.end,
      ),
    ).py20();
  }
}
