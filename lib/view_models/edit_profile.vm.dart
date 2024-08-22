import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/requests/auth.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

import '../utils/utils.dart';

class EditProfileViewModel extends MyBaseViewModel {
  User? currentUser;
  File? newPhoto;

  //the textediting controllers
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController phoneTEC = new TextEditingController();
  Country? selectedCountry;
  String? accountPhoneNumber;
  String? selectedImage;

  //
  AuthRequest _authRequest = AuthRequest();
  final picker = ImagePicker();

  EditProfileViewModel(BuildContext context) {
    this.viewContext = context;
    try {
      this.selectedCountry = Country.parse(
        AuthServices.currentUser!.countryCode!,
      );
    } catch (error) {
      this.selectedCountry = Country.parse("us");
    }
  }

  void initialise() async {
    //
    currentUser = await AuthServices.getCurrentUser();
    nameTEC.text = currentUser!.name;
    emailTEC.text = currentUser!.email;
    String rawPhone = currentUser!.rawPhone ?? currentUser!.phone;
    //remove non mobile number characters
    rawPhone = rawPhone.replaceAll(RegExp(r"[^0-9]"), "");
    phoneTEC.text = rawPhone;
    notifyListeners();
  }

  //
  // void changePhoto() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     newPhoto = File(pickedFile.path);
  //   } else {
  //     newPhoto = null;
  //   }
  //
  //   notifyListeners();
  // }

  //
  showCountryDialPicker() {
    showCountryPicker(
      context: viewContext,
      showPhoneCode: true,
      onSelect: countryCodeSelected,
    );
  }

  countryCodeSelected(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  //
  processUpdate() async {
    if (selectedImage != null) {
      final pickedFile = await Utils.imageToFile(imageName: selectedImage!);
      newPhoto = File(pickedFile.path);
    } else {
      final pickedFile =
          await Utils.imageToFile(imageName: "${AppImages.loginUser}");
      newPhoto = File(pickedFile.path);
    }
    //
    if (formKey.currentState!.validate()) {
      //
      setBusy(true);

      //
      var phoneNumber = "${phoneTEC.text}";

      final apiResponse = await _authRequest.updateProfile(
        photo: newPhoto,
        name: nameTEC.text,
        email: emailTEC.text,
        phone: phoneNumber,
        countryCode: selectedCountry?.countryCode,
      );

      //
      setBusy(false);

      //update local data if all good
      if (apiResponse.allGood) {
        //everything works well
        await AuthServices.saveUser(apiResponse.body["user"], reload: false);
      }

      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Profile Update".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                Navigator.of(viewContext).pop();
                Navigator.of(viewContext).pop(true);
              }
            : null,
      );
    }
  }
}
