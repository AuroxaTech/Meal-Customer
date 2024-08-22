import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/services/validator.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/register.view_model.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    this.email,
    this.name,
    this.phone,
    Key? key,
  }) : super(key: key);

  final String? email;
  final String? name;
  final String? phone;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onViewModelReady: (model) {
        model.nameTEC.text = widget.name ?? "";
        model.emailTEC.text = widget.email ?? "";
        model.phoneTEC.text = widget.phone ?? "";

        model.initialise();
      },
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          elevation: 0,
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: Color(0xffeefffd),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
              child: VStack(
                [
                  GestureDetector(
                    onTap: (){
                     openImageSelectionPopup(model);
                    },
                    child: Container(
                      height: 130,
                      width: 130,
                      // color: Colors.grey,
                      child: Image.asset(
                        model.selectedImage != null && model.selectedImage != ""? model.selectedImage! : AppImages.loginUser,

                        fit: BoxFit.cover,
                      ),
                    ).centered(),
                  ),
                  //
                  VStack(
                    [
                      //
                      "Join Us".tr().text.xl2.fontFamily(AppFonts.appFont).semiBold.make(),
                      "Create an account now".tr().text.fontFamily(AppFonts.appFont).light.make(),

                      //form
                      Form(
                        key: model.formKey,
                        child: VStack(
                          [
                            //
                            CustomTextFormField(
                              labelText: "Name".tr(),
                              textEditingController: model.nameTEC,
                              validator: FormValidator.validateName,
                            ).py12(),
                            //
                            CustomTextFormField(
                              labelText: "Email".tr(),
                              keyboardType: TextInputType.emailAddress,
                              textEditingController: model.emailTEC,
                              validator: FormValidator.validateEmail,
                              //remove space
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(' '),
                                ), // removes spaces
                              ],
                            ).py12(),
                            //
                            HStack(
                              [
                                CustomTextFormField(
                                  prefixIcon: HStack(
                                    [
                                      //icon/flag
                                      Flag.fromString(
                                        model.selectedCountry!.countryCode,
                                        width: 20,
                                        height: 20,
                                      ),
                                      UiSpacer.horizontalSpace(space: 5),
                                      //text
                                      ("+" + model.selectedCountry!.phoneCode)
                                          .text.fontFamily(AppFonts.appFont)
                                          .make(),
                                    ],
                                  ).px8().onInkTap(model.showCountryDialPicker),
                                  labelText: "Phone".tr(),
                                  hintText: "",
                                  keyboardType: TextInputType.phone,
                                  textEditingController: model.phoneTEC,
                                  validator: FormValidator.validatePhone,
                                  //remove space
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(' '),
                                    ), // removes spaces
                                  ],
                                ).expand(),
                              ],
                            ).py12(),
                            //
                            CustomTextFormField(
                              labelText: "Password".tr(),
                              obscureText: true,
                              textEditingController: model.passwordTEC,
                              validator: FormValidator.validatePassword,
                              //remove space
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(' '),
                                ), // removes spaces
                              ],
                            ).py12(),
                            //
                            AppStrings.enableReferSystem
                                ? CustomTextFormField(
                                    labelText: "Referral Code(optional)".tr(),
                                    textEditingController:
                                        model.referralCodeTEC,
                                  ).py12()
                                : UiSpacer.emptySpace(),

                            //terms
                            HStack(
                              [
                                Checkbox(
                                  value: model.agreed,
                                  onChanged: (value) {
                                    model.agreed = value ?? false;
                                    model.notifyListeners();
                                  },
                                ),
                                //
                                "I agree with".tr().text.make(),
                                UiSpacer.horizontalSpace(space: 2),
                                "Terms & Conditions"
                                    .tr()
                                    .text
                                    .color(AppColor.primaryColor)
                                    .bold
                                    .underline
                                    .make()
                                    .onInkTap(model.openTerms)
                                    .expand(),
                              ],
                            ),

                            //
                            CustomButton(
                              title: "Create Account".tr(),
                              loading: model.isBusy,
                              shapeRadius: 14,
                              onPressed: model.processRegister,
                            ).centered().py12(),

                            //register
                            "OR".tr().text.light.makeCentered(),
                            "Already have an Account"
                                .tr()
                                .text
                                .semiBold
                                .makeCentered()
                                .py12()
                                .onInkTap(() {
                              model.openLogin;
                            }),
                          ],
                          crossAlignment: CrossAxisAlignment.end,
                        ),
                      ).py20(),
                    ],
                  ).wFull(context).p20(),

                  //
                ],
              ).scrollVertical(),
            ),
          ),
        );
      },
    );
  }

  openImageSelectionPopup(RegisterViewModel model){
    int selectedIndex = -1;

    List<Item> imagelist = [
      Item(title: 'assets/images/boy1.png'),
      Item(title: 'assets/images/boy2.png'),
      Item(title: 'assets/images/boy3.png'),
      Item(title: 'assets/images/boy4.png'),
      Item(title: 'assets/images/girl1.png'),
      Item(title: 'assets/images/girl2.png'),
      Item(title: 'assets/images/girl3.png'),
      Item(title: 'assets/images/girl4.png'),
    ];
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),

          content: new Container(
              height: MediaQuery.of(context).size.height / 2.5,
              // Specify some width
              width: MediaQuery.of(context).size.width * .7,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: imagelist.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = -1; // Unselect if already selected
                        } else {
                          selectedIndex = index;
                        }
                        model.selectedImage = imagelist[index].title;
                        print("SelectedImage is: ${model.selectedImage}");
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedIndex == index
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.asset(imagelist[index].title),
                      ),
                    ),
                  );
                },
              )),
        );
      },
    );
  }
}
