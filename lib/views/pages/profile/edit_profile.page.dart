import 'package:cached_network_image/cached_network_image.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/services/validator.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/view_models/edit_profile.vm.dart';
import 'package:mealknight/view_models/register.view_model.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:mealknight/widgets/busy_indicator.dart';
import 'package:mealknight/widgets/buttons/custom_button.dart';
import 'package:mealknight/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "Edit Profile".tr(),
          elevation: 0,
          appBarColor: context.theme.colorScheme.background,
          appBarItemColor: AppColor.primaryColor,
          backgroundColor: Color(0xffeefffd),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //
                  Stack(
                    children: [
                      //
                      model.currentUser == null
                          ? BusyIndicator()
                          : model.selectedImage == null
                              ? CachedNetworkImage(
                                  imageUrl: model.currentUser?.photo ?? "",
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return BusyIndicator();
                                  },
                                  errorWidget: (context, imageUrl, progress) {
                                    return Image.asset(
                                      AppImages.user,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                  .box
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make()
                              : Image.asset(
                                  model.selectedImage!,
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                  .box
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make(),

                      //
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          FlutterIcons.camera_ant,
                          size: 16,
                        )
                            .p8()
                            .box
                            .color(context.theme.colorScheme.background)
                            .roundedFull
                            .shadow
                            .make()
                            .onInkTap(()=>openImageSelectionPopup(model)),
                      ),
                    ],
                  ).box.makeCentered(),

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
                        ).py12(),
                        //
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
                                  .make(),
                            ],
                          ).px8().onInkTap(model.showCountryDialPicker),
                          labelText: "Phone",
                          keyboardType: TextInputType.phone,
                          textEditingController: model.phoneTEC,
                          validator: FormValidator.validatePhone,
                        ).py12(),

                        //
                        CustomButton(
                          title: "Update Profile".tr(),
                          loading: model.isBusy,
                          onPressed: model.processUpdate,
                        ).centered().py12(),
                      ],
                    ),
                  ).py20(),
                ],
              ).p20().scrollVertical()),
        );
      },
    );
  }

  openImageSelectionPopup(EditProfileViewModel model){
    int selectedIndex = -1;

    List<Item> imagelist = [
      Item(title: 'assets/images/boy1.png', isSelected: false),
      Item(title: 'assets/images/boy2.png', isSelected: false),
      Item(title: 'assets/images/boy3.png', isSelected: false),
      Item(title: 'assets/images/boy4.png', isSelected: false),
      Item(title: 'assets/images/girl1.png', isSelected: false),
      Item(title: 'assets/images/girl2.png', isSelected: false),
      Item(title: 'assets/images/girl3.png', isSelected: false),
      Item(title: 'assets/images/girl4.png', isSelected: false),
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
