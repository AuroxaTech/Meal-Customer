import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/login.view_model.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class OtpSubmitPage extends StatefulWidget {
  const OtpSubmitPage({this.required = false, super.key});

  final bool required;

  @override
  State<OtpSubmitPage> createState() => _OtpSubmitPageState();
}

class _OtpSubmitPageState extends State<OtpSubmitPage> {
  bool isPhoneNumber = true;

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
            body: SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                  padding:
                      EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
                  child: VStack(
                    [
                      //
                      VStack(
                        [
                          "Enter OTP"
                              .text
                              .xl3
                              .fontFamily(AppFonts.appFont)
                              .color(AppColor.primaryColor)
                              .semiBold
                              .make()
                              .pOnly(bottom: 12),
                          OTPTextField(
                            length: 6,
                            otpFieldStyle: OtpFieldStyle(
                              borderColor: AppColor.primaryColor,
                              disabledBorderColor: AppColor.primaryColor,
                              enabledBorderColor: AppColor.primaryColor,
                              backgroundColor: Colors.white,
                              errorBorderColor: AppColor.primaryColor,
                              focusBorderColor: AppColor.primaryColor,
                            ),
                            width: MediaQuery.of(context).size.width - 30,
                            hasError: false,
                            fieldWidth: 50,
                            style: const TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (pin) {
                              if (kDebugMode) {
                                print("Completed: $pin");
                              }
                            },
                          ),
                        ],
                      )
                          .wFull(context)
                          .px20()
                          .pOnly(top: Vx.dp20, bottom: Vx.dp20),
                      if (!isPhoneNumber)
                        VStack([
                          HStack([
                            UiSpacer.expandedSpace(),
                            "Call\nMe"
                                .text
                                .color(AppColor.primaryColor)
                                .fontFamily(AppFonts.appFont)
                                .center
                                .make()
                                .px(30)
                                .py(5)
                                .centered()
                                .box
                                .withRounded(value: 10)
                                .border(color: AppColor.primaryColor, width: 2)
                                .make()
                                .px(20)
                                .py(10)
                                .onTap(() {
                              setState(() {
                                if (isPhoneNumber == true) {
                                  isPhoneNumber = false;
                                } else {
                                  isPhoneNumber = true;
                                }
                              });
                            }),
                            "Resend\n60s"
                                .text
                                .color(Colors.white)
                                .fontFamily(AppFonts.appFont)
                                .center
                                .make()
                                .centered()
                                .px(20)
                                .py(5)
                                .box
                                .withRounded(value: 10)
                                .color(AppColor.primaryColor)
                                .make()
                                .px(20)
                                .py(10)
                                .onTap(() {}),
                            UiSpacer.expandedSpace(),
                          ]),
                          HStack([
                            UiSpacer.expandedSpace(),
                            "Go\nBack"
                                .text
                                .color(AppColor.primaryColor)
                                .fontFamily(AppFonts.appFont)
                                .center
                                .make()
                                .px(30)
                                .py(5)
                                .centered()
                                .box
                                .withRounded(value: 10)
                                .border(color: AppColor.primaryColor, width: 2)
                                .make()
                                .px(20)
                                .py(10)
                                .centered()
                                .onTap(() {
                              setState(() {
                                if (isPhoneNumber == true) {
                                  isPhoneNumber = false;
                                } else {
                                  isPhoneNumber = true;
                                }
                              });
                            }),
                            UiSpacer.expandedSpace(),
                          ])
                        ])
                      else
                        HStack([
                          UiSpacer.expandedSpace(),
                          "Go\nBack"
                              .text
                              .color(AppColor.primaryColor)
                              .fontFamily(AppFonts.appFont)
                              .center
                              .make()
                              .px(30)
                              .py(5)
                              .centered()
                              .box
                              .withRounded(value: 10)
                              .border(color: AppColor.primaryColor, width: 2)
                              .make()
                              .px(20)
                              .py(10)
                              .onTap(() {
                            setState(() {
                              if (isPhoneNumber == true) {
                                isPhoneNumber = false;
                              } else {
                                isPhoneNumber = true;
                              }
                            });
                          }),
                          "Resend\n60s"
                              .text
                              .color(Colors.white)
                              .fontFamily(AppFonts.appFont)
                              .center
                              .make()
                              .centered()
                              .px(20)
                              .py(5)
                              .box
                              .withRounded(value: 10)
                              .color(AppColor.primaryColor)
                              .make()
                              .px(20)
                              .py(10)
                              .onTap(() {}),
                          UiSpacer.expandedSpace(),
                        ]),

                      Spacer(),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
