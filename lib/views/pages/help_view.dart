import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/services/validator.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/help_viewmodel.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:mealknight/widgets/help_report_submittion_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpPage extends StatefulWidget {
  HelpPage({
    this.email,
    this.name,
    this.phone,
    Key? key,
  }) : super(key: key);

  final String? email;
  final String? name;
  final String? phone;
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpViewModel>.reactive(
        viewModelBuilder: () => HelpViewModel(context),
        disposeViewModel: true,
        // onViewModelReady: (vm) => vm.initialise(),
        onViewModelReady: (model) {
          model.nameTEC.text = widget.name ?? "";
          model.emailTEC.text = widget.email ?? "";
          model.phoneTEC.text = widget.phone ?? "";
          model.initialise();
        },
        builder: (ctx, vm, child) {
          return BasePage(


            body:  VStack(
            [ Form(
              key: vm.formKey,
              child: VStack(
                [
                  //
                  Row(
                    children: [
                      "Name".text.lg.fontFamily(AppFonts.appFont).color(AppColor.primaryColor).make(),
                      UiSpacer.expandedSpace(),
                    ],
                  ),
                  //
                  CustomTextFormField(
                    textEditingController: vm.nameTEC,
                    validator: FormValidator.validateName,
                  ).py4(),
                  Row(
                    children: [
                      "Phone number".text.lg.fontFamily(AppFonts.appFont).color(AppColor.primaryColor).make(),
                      UiSpacer.expandedSpace(),

                    ],
                  ),
                  //
                  HStack(
                    [HStack(
                      [
                        UiSpacer.horizontalSpace(space: 5),
                        //text
                        ("+" + vm.selectedCountry!.phoneCode)
                            .text.fontFamily(AppFonts.appFont).color(AppColor.primaryColor)
                            .make(),
                      ],
                    ).px8().onInkTap(vm.showCountryDialPicker).box.withRounded(value: 10).height(45).border(color: AppColor.primaryColor,width: 2).make().pOnly(right: 10),
                      CustomTextFormField(
                        hintText: "",
                        keyboardType: TextInputType.phone,
                        textEditingController: vm.phoneTEC,
                        validator: FormValidator.validatePhone,
                        //remove space
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(' '),
                          ), // removes spaces
                        ],

                      ).expand(),
                    ],
                  ).py4(),
                  Row(
                    children: [
                      "Email".text.lg.fontFamily(AppFonts.appFont).color(AppColor.primaryColor).make(),
                      UiSpacer.expandedSpace(),

                    ],
                  ),
                  //
                  CustomTextFormField(

                    keyboardType: TextInputType.emailAddress,
                    textEditingController: vm.emailTEC,
                    validator: FormValidator.validateEmail,
                    //remove space
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(' '),
                      ), // removes spaces
                    ],
                  ).py4(),

                  "Please explain your issue in detail and a customer service rep will reach out to you ASAP.".text.lg.fontFamily(AppFonts.appFont).color(AppColor.primaryColor).make().px8(),
                  //
                  CustomTextFormField(
                    textEditingController: vm.inputTextTEC,
                    validator: FormValidator.validateName,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                  ).py4(),
                  HStack([

                    CustomButton(
                        title:  "Go Back".tr(),
                        color: Colors.white,
                        shapeRadius: 10,titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.appFont,
                      color: AppColor.primaryColor,
                    ),
                        borderColor: AppColor.primaryColor,
                        onPressed:(){
                          Navigator.pop(context);
                        }),
                    UiSpacer.expandedSpace(),
                    CustomButton(
                      title: "Submit".tr(),
                      color: AppColor.primaryColor,
                      shapeRadius: 10,
                      borderColor: AppColor.primaryColor,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReportSuccessfullyView()),
                        );
                      },
                    ),

                  ])

                ],
                crossAlignment: CrossAxisAlignment.end,
              ).p(20),
            ).py20(),
              /* //skip
                HStack([
                  UiSpacer.expandedSpace(),
                  CustomTextButton(
                    title: "Skip".tr(),
                    onPressed: vm.loadNextPage,
                  ),
                ]).safeArea(),*/
            ],
          ).expand().scrollVertical(),
          );
        });
  }
}
