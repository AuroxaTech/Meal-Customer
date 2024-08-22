import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/utils/utils.dart';
import 'base.view_model.dart';

class HelpViewModel extends MyBaseViewModel {
  HelpViewModel(BuildContext context) {
    this.viewContext = context;
    this.selectedCountry = Country.parse("us");
  }

  bool showManuallySelection = false;
  bool showRequestPermission = false;
  TextEditingController controller = TextEditingController();
  DeliveryAddress? deliveryAddress;
  CheckOut? checkout;
  TextEditingController nameTEC =
  new TextEditingController(text: !kReleaseMode ? "John Doe" : "");
  TextEditingController emailTEC =
  new TextEditingController(text: !kReleaseMode ? "john@mail.com" : "");
  TextEditingController phoneTEC =
  new TextEditingController(text: !kReleaseMode ? "557484181" : "");
  TextEditingController inputTextTEC =
  new TextEditingController(text: !kReleaseMode ? "John Doe" : "");
  Country? selectedCountry;
  String? accountPhoneNumber;

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
    //
    accountPhoneNumber = "+${selectedCountry?.phoneCode}${phoneTEC.text}";
    //
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {

    }
  }

/*  loadNextPage() {
    try {
      Navigator.of(viewContext).pop();
      viewContext.nextAndRemoveUntilPage(nextPage);
    } catch (error) {
      print("error: $error");
    }
  }*/
//
}
