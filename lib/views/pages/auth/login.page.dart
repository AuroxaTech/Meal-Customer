import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/services/validator.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/login.view_model.dart';
import 'package:mealknight/views/pages/auth/login/email_login.view.dart';
import 'package:mealknight/views/pages/auth/login/social_media.view.dart';
import 'package:mealknight/views/pages/help_view.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'login/scan_login.view.dart';
import 'package:mealknight/constants/app_font.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.required = false, super.key});

  final bool required;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPhoneNumber = true;

  @override
  void initState() {
    super.initState();
    initializedIsPhone();
  }

  initializedIsPhone() {
    if (AppStrings.enableOTPLogin && AppStrings.enableEmailLogin) {
      isPhoneNumber = false;
    }
    if (AppStrings.enableOTPLogin && !AppStrings.enableEmailLogin) {
      isPhoneNumber = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (widget.required) {
              Navigator.of(context).pop();
            }
            return true;
          },
          child: BasePage(
            showLeadingAction: !widget.required,
            showAppBar: !widget.required,
            elevation: 0,
            appBarColor: context.theme.colorScheme.background,
            appBarItemColor: AppColor.primaryColor,
            backgroundColor: const Color(0xffeefffd),
            isLoading: model.isBusy,
            body: VStack(
              [
                //
                VStack(
                  [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      AppImages.appLogowithoutTitle,
                    )
                        .h(150)
                        .w(150)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                        .centered(),
                    "Welcome"
                        .tr()
                        .text
                        .xl3
                        .fontFamily(AppFonts.appFont)
                        .color(AppColor.primaryColor)
                        .semiBold
                        .make()
                        .centered()
                        .pOnly(bottom: 12),

                    //LOGIN Section

                    // if (AppStrings.enableOTPLogin &&
                    //     AppStrings.enableEmailLogin)
                    //   phoneOtpView(model),

                    //only email login
                    // if (AppStrings.enableEmailLogin &&
                    //     !AppStrings.enableOTPLogin)
                    EmailLoginView(model),

                    // //otp login
                    // if (AppStrings.enableOTPLogin &&
                    //     !AppStrings.enableEmailLogin)
                    // phoneOtpView(model),
                  ],
                ).wFull(context).px20().pOnly(top: Vx.dp20),
                //
                // if (AppStrings.enableEmailLogin &&
                //     !AppStrings.enableOTPLogin)
                HStack(
                  [
                    UiSpacer.divider().expand(),
                    "OR"
                        .tr()
                        .text
                        .fontFamily(AppFonts.appFont)
                        .light
                        .make()
                        .px8(),
                    UiSpacer.divider().expand(),
                  ],
                ).py8().px20(),
                // if (AppStrings.enableEmailLogin &&
                //     !AppStrings.enableOTPLogin)
                "New user?"
                    .richText
                    .withTextSpanChildren([
                      " ".textSpan.make(),
                      "Create An Account"
                          .tr()
                          .textSpan
                          .semiBold
                          .fontFamily(AppFonts.appFont)
                          .color(AppColor.primaryColor)
                          .make(),
                    ])
                    .makeCentered()
                    .py12()
                    .onInkTap(model.openRegister),
                // if (AppStrings.enableEmailLogin &&
                //     !AppStrings.enableOTPLogin)
                SocialMediaView(model, bottomPadding: 10),
                // if (AppStrings.enableEmailLogin &&
                //     !AppStrings.enableOTPLogin)
                ScanLoginView(model),
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }

  Widget phoneOtpView(LoginViewModel model) {
    return VStack(
      [
        //
        VStack(
          [
            (isPhoneNumber ? "Enter Phone number" : "Enter email id")
                .text
                .lg
                .fontFamily(AppFonts.appFont)
                .color(AppColor.primaryColor)
                .make(),

            //
            if (isPhoneNumber)
              HStack(
                [
                  CustomTextFormField(
                    prefixIcon: HStack(
                      [
                        //icon/flag
                        Flag.fromString(
                          model.selectedCountry?.countryCode ?? "us",
                          width: 20,
                          height: 20,
                        ),
                        UiSpacer.horizontalSpace(space: 5),
                        //text
                        ("+" + (model.selectedCountry?.phoneCode ?? "1"))
                            .text
                            .fontFamily(AppFonts.appFont)
                            .make(),
                      ],
                    ).px8().onInkTap(model.showCountryDialPicker),
                    hintText: "",
                    keyboardType: TextInputType.phone,
                    textEditingController: model.phoneTEC,
                    validator: FormValidator.validatePhone,
                  ).expand(),
                ],
              ).py12()
            else
              //
              CustomTextFormField(
                keyboardType: TextInputType.number,
                textEditingController: model.phoneTEC,
                validator: FormValidator.validateEmail,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(' '),
                  ),
                ],
              ).py12(),
          ],
        ).wFull(context).pOnly(top: Vx.dp20),
        Row(
          children: [
            UiSpacer.expandedSpace(),
            VStack([
              CustomButton(
                  title: "Receive OTP".tr(),
                  color: AppColor.primaryColor,
                  shapeRadius: 10,
                  borderColor: AppColor.primaryColor,
                  loading: model.busy(model.otpLogin),
                  onPressed: () {
                    model.processOTPLogin(isPhoneNumber);
                  }).w(150),
              CustomButton(
                  title: "${isPhoneNumber ? "Use email" : "Use number"}".tr(),
                  loading: model.isBusy,
                  color: Colors.white,
                  shapeRadius: 10,
                  titleStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.appFont,
                    color: AppColor.primaryColor,
                  ),
                  borderColor: AppColor.primaryColor,
                  onPressed: () {
                    setState(() {
                      if (isPhoneNumber == true) {
                        isPhoneNumber = false;
                      } else {
                        isPhoneNumber = true;
                      }
                    });
                  }).w(150).py12(),
            ])
          ],
        ),
        if (isPhoneNumber)
          CustomButton(
              title: "Need Help",
              loading: model.isBusy,
              color: Colors.white,
              shapeRadius: 10,
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.appFont,
                color: AppColor.primaryColor,
              ),
              borderColor: AppColor.primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              }).w(150).py8()
      ],
    );
  }
}
