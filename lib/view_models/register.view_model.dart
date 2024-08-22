import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/requests/auth.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/widgets/bottomsheets/account_verification_entry.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterViewModel extends MyBaseViewModel {
  //
  AuthRequest _authRequest = AuthRequest();

  // FirebaseAuth auth = FirebaseAuth.instance;
  //the textediting controllers
  TextEditingController nameTEC =
      TextEditingController(text: !kReleaseMode ? "John Doe" : "");
  TextEditingController emailTEC =
      TextEditingController(text: !kReleaseMode ? "john@mail.com" : "");
  TextEditingController phoneTEC =
      TextEditingController(text: !kReleaseMode ? "557484181" : "");
  TextEditingController passwordTEC =
      TextEditingController(text: !kReleaseMode ? "password" : "");
  TextEditingController referralCodeTEC = TextEditingController();
  Country? selectedCountry;
  String? accountPhoneNumber;
  bool agreed = false;
  bool otpLogin = AppStrings.enableOTPLogin;
  String? selectedImage;

  File? newPhoto;

  RegisterViewModel(BuildContext context) {
    this.viewContext = context;
    this.selectedCountry = Country.parse("us");
  }

  void initialise() async {
    try {
      String countryCode = await Utils.getCurrentCountryCode();
      this.selectedCountry = Country.parse(countryCode);
    } catch (error) {
      this.selectedCountry = Country.parse("us");
    }
  }

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

  void processRegister() async {
    //Argentina (AR) [+54]
    String tmp = selectedCountry!.displayName
        .split(' ')
        .last
        .split('[')
        .last
        .split(']')
        .first;
    accountPhoneNumber = "$tmp${phoneTEC.text}";
    print('accountPhoneNumber==$accountPhoneNumber');
    //
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate() && agreed) {
      print("AppStrings.isFirebaseOtp=${AppStrings.isFirebaseOtp}");
      print("AppStrings.isCustomOtp=${AppStrings.isCustomOtp}");
      if (AppStrings.isFirebaseOtp) {
        processFirebaseOTPVerification();
      } else if (AppStrings.isCustomOtp) {
        processCustomOTPVerification();
      } else {
        print("finishAccountRegistration 000");
        finishAccountRegistration();
      }
    }
  }

  //PROCESSING VERIFICATION
  processFirebaseOTPVerification() async {
    setBusy(true);
    //firebase authentication
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: accountPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("processFirebaseOTPVerification called=========1");
        // firebaseVerificationId = credential.verificationId;
        // verifyFirebaseOTP(credential.smsCode);
        finishAccountRegistration();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("processFirebaseOTPVerification called=========2 ${e.message}");
        print("processFirebaseOTPVerification called=========3 ${e.code}");
        if (e.code == 'invalid-phone-number') {
          viewContext.showToast(
              msg: "Invalid Phone Number".tr(), bgColor: Colors.red);
        } else {
          viewContext.showToast(
              msg: e.message ?? "Failed".tr(), bgColor: Colors.red);
        }
        //
        setBusy(false);
      },
      codeSent: (String verificationId, int? resendToken) async {
        firebaseVerificationId = verificationId;
        showVerificationEntry();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout called");
      },
    );
    print("processFirebaseOTPVerification called=========4");
  }

  processCustomOTPVerification() async {
    setBusy(true);
    try {
      setBusy(false);
      print("processCustomOTPVerification called=========1");
      await _authRequest.sendOTP(accountPhoneNumber!);
      print("processCustomOTPVerification called=========2");
      showVerificationEntry();
    } catch (error) {
      print("processCustomOTPVerification called=========3==$error");
      setBusy(false);
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
  }

  //
  void showVerificationEntry() async {
    //
    print("showVerificationEntry called=========2");
    setBusy(false);
    //
    await Navigator.push(
        viewContext,
        MaterialPageRoute(
          builder: (context) => AccountVerificationEntry(
            isPhonenumber: true,
            vm: this,
            phone: accountPhoneNumber!,
            onSubmit: (smsCode) {
              if (AppStrings.isFirebaseOtp) {
                verifyFirebaseOTP(smsCode);
              } else if (AppStrings.isCustomOtp) {
                verifyCustomOTP(smsCode);
              } else {
                print("finishAccountRegistration 000");
                finishAccountRegistration();
              }
              Navigator.of(viewContext).pop();
            },
            onResendCode: () async {
              try {
                final response = await _authRequest.sendOTP(
                  accountPhoneNumber!,
                );
                toastSuccessful("${response.message}");
              } catch (error) {
                viewContext.showToast(msg: "$error", bgColor: Colors.red);
              }
            },
          ),
        ));
  }

  //
  void verifyFirebaseOTP(String smsCode) async {
    //
    setBusyForObject(firebaseVerificationId, true);

    // Sign the user in (or link) with the credential
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId!,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      await finishAccountRegistration();
    } catch (error) {
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(firebaseVerificationId, false);
  }

  void verifyCustomOTP(String smsCode) async {
    //
    print("verifyCustomOTP ============================1");
    setBusyForObject(firebaseVerificationId, true);
    // Sign the user in (or link) with the credential
    try {
      print("verifyCustomOTP ============================2");
      await _authRequest.verifyOTP(accountPhoneNumber!, smsCode);
      await finishAccountRegistration();
      print("verifyCustomOTP ============================3");
    } catch (error) {
      print("verifyCustomOTP ============================4=$error");
      viewContext.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(firebaseVerificationId, false);
  }

  //

  Future<void> finishAccountRegistration() async {
    print("finishAccountRegistration ============================1");
    if (selectedImage != null) {
      final pickedFile = await Utils.imageToFile(imageName: selectedImage!);
      newPhoto = File(pickedFile.path);
    } else {
      final pickedFile =
          await Utils.imageToFile(imageName: "${AppImages.loginUser}");
      newPhoto = File(pickedFile.path);
    }
    setBusy(true);
    var phoneNumber = "+${selectedCountry?.phoneCode}${phoneTEC.text}";

    print("finishAccountRegistration ============================2");
    final apiResponse = await _authRequest.registerRequest(
        name: nameTEC.text,
        email: emailTEC.text,
        phone: phoneNumber,
        countryCode: selectedCountry!.countryCode,
        password: passwordTEC.text,
        code: referralCodeTEC.text,
        photo: newPhoto);

    print("finishAccountRegistration ============================3");
    setBusy(false);

    try {
      print("finishAccountRegistration ============================4");
      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Registration Failed".tr(),
          text: apiResponse.message,
        );
        print("finishAccountRegistration ============================5");
      } else {
        //everything works well
        //firebase auth
        print("finishAccountRegistration ============================6");
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();

        Navigator.of(viewContext)
            .pushNamed(AppRoutes.newDeliveryAddressesRoute, arguments: true);
        // Navigator.of(viewContext).pushNamedAndRemoveUntil(
        //   AppRoutes.homeRoute,
        //       (Route<dynamic> route) => false,
        // );
      }
    } on FirebaseAuthException catch (error) {
      print("finishAccountRegistration ============================7");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error.message}",
      );
    } catch (error) {
      print("finishAccountRegistration ============================8");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: error is Map ? "${error['message'] ?? error}" : "$error",
      );
    }
  }

  void openLogin() async {
    Navigator.of(viewContext).pop();
  }
}

class Item {
  String title;
  bool isSelected;

  Item({required this.title, this.isSelected = false});
}
