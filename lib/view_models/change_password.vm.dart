import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/requests/auth.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordViewModel extends MyBaseViewModel {
  User? currentUser;

  //the textediting controllers
  TextEditingController currentPasswordTEC = TextEditingController();
  TextEditingController newPasswordTEC = TextEditingController();
  TextEditingController confirmNewPasswordTEC = TextEditingController();

  //
  AuthRequest _authRequest = AuthRequest();
  final picker = ImagePicker();

  ChangePasswordViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  processUpdate() async {
    //
    if (formKey.currentState!.validate()) {
      //
      setBusy(true);

      //
      final apiResponse = await _authRequest.updatePassword(
        password: currentPasswordTEC.text,
        newPassword: newPasswordTEC.text,
        newPasswordConfirmation: confirmNewPasswordTEC.text,
      );

      //
      setBusy(false);

      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Change Password".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                //
                Navigator.of(viewContext).pop();
                Navigator.of(viewContext).pop(true);
              }
            : null,
      );
    }
  }
}
