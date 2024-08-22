import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mealknight/widgets/custom_dropdown_button.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/address.dart';
import '../models/payment_card.dart';
import '../models/user.dart';
import '../requests/auth.request.dart';
import '../requests/cards.request.dart';
import '../services/auth.service.dart';
import '../services/toast.service.dart';
import '../services/validator.service.dart';
import '../views/pages/payment/custom_webview.page.dart';
import '../widgets/custom_text_form_field.dart';
import 'base.view_model.dart';
import 'dart:math';
import 'dart:typed_data';

class PaymentViewModel extends MyBaseViewModel {
  CardsRequest cardsRequest = CardsRequest();
  AuthRequest authRequest = AuthRequest();
  List<PaymentCard> paymentCards = [];
  final ValueNotifier<PaymentCard?> defaultCard =
      ValueNotifier<PaymentCard?>(null);
  late User user;

  void initialise() async {
    await _initSquarePayment();
    user = await AuthServices.getCurrentUser(force: true);
    loadSavedCards();
  }

  Future<void> loadSavedCards() async {
    setBusy(true);
    paymentCards = await cardsRequest.getCards(user);
    setBusy(false);
    defaultCard.value = paymentCards
        .firstOrNullWhere((e) => e.id == user.squareupDefaultCardId);
  }

  Future<void> disableCard(PaymentCard card) async {
    setBusy(true);
    final apiResponse = await cardsRequest.disableCard(card.id);
    setBusy(false);
    Future.delayed(Duration(seconds: 3), () {
      loadSavedCards();
    });
  }

  Future<void> markCardAsDefault(PaymentCard card) async {
    setBusy(true);
    final apiResponse =
        await authRequest.updateProfile(squareupDefaultCardId: card.id);
    if (apiResponse.allGood) {
      await AuthServices.saveUser(apiResponse.body["user"], reload: false);
      user = await AuthServices.getCurrentUser(force: true);
      defaultCard.value = card;
      print("Default card ${defaultCard.value?.cardholderName}");
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> _initSquarePayment() async {
    //await InAppPayments.setSquareApplicationId('sandbox-sq0idb-qoPHaU30q6ny7fH9bJIxxw');
    await InAppPayments.setSquareApplicationId('sq0idp-gFY4lprof3-akMvW1gkNFg');
  }

  /**
   * An event listener to start card entry flow
   */
  Future<void> onStartCardEntryFlow(BuildContext context) async {
    Address? address = await showDialog<Address?>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController addressLineOne = TextEditingController();
          TextEditingController addressLineTwo = TextEditingController();
          TextEditingController locality = TextEditingController();
          TextEditingController adminArea =
              TextEditingController(text: "Alberta");
          TextEditingController postalCode = TextEditingController();
          TextEditingController country = TextEditingController(text: "CA");
          return Scaffold(
            body: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "Billing Address\n",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomTextFormField(
                            labelText: "Address line 1",
                            textEditingController: addressLineOne,
                            validator: FormValidator.validateEmpty,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            labelText: "Address line 2",
                            textEditingController: addressLineTwo,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            labelText: "City",
                            textEditingController: locality,
                            validator: FormValidator.validateEmpty,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Visibility(
                            visible: false,
                            child: CustomTextFormField(
                              labelText: "Province",
                              textEditingController: adminArea,
                              validator: FormValidator.validateEmpty,
                            ),
                          ),
                          CustomDropdownButton(
                            label: "Province",
                            options: const [
                              "Alberta",
                              "British Columbia",
                              "Manitoba",
                              "New Brunswick",
                              "Newfoundland and Labrador",
                              "Northwest Territories",
                              "Nova Scotia",
                              "Nunavut",
                              "Ontario",
                              "Prince Edward Island",
                              "Quebec",
                              "Saskatchewan",
                              "Yukon"
                            ],
                            onItemSelected: (String? value) {
                              adminArea.text = value ?? "";
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            labelText: "Postal Code",
                            textEditingController: postalCode,
                            validator: FormValidator.validateEmpty,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextFormField(
                            labelText: "Country",
                            textEditingController: country,
                            validator: FormValidator.validateEmpty,
                            //isReadOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {
                          Address adres = Address(
                            addressLine: addressLineOne.text.toString(),
                            featureName: addressLineTwo.text.toString(),
                            locality: locality.text.toString(),
                            adminArea: adminArea.text.toString(),
                            postalCode: postalCode.text.toString(),
                            countryName: country.text.toString(),
                          );
                          Navigator.pop(context, adres);
                        },
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          );
        });

    if (null != address) {
      await InAppPayments.startCardEntryFlow(
          onCardNonceRequestSuccess: (CardDetails result) {
            _onCardEntryCardNonceRequestSuccess(context, result, address);
          },
          onCardEntryCancel: _onCancelCardEntryFlow);
    }
  }

  /**
   * Callback when card entry is cancelled and UI is closed
   */
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  /**
   * Callback when successfully get the card nonce details for processig
   * card entry is still open and waiting for processing card nonce details
   */
  void _onCardEntryCardNonceRequestSuccess(
      BuildContext context, CardDetails result, Address? address) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      String nonce = result.nonce;
      String uuid = generateUuid();
      User user = await AuthServices.getCurrentUser(force: true);
      await cardsRequest.saveCard(
        nonce: nonce,
        uuid: uuid,
        user: user,
        addressLineOne: address?.addressLine ?? "",
        addressLineTwo: address?.featureName ?? "",
        locality: address?.locality ?? "",
        administrativeDistrictLevelOne: address?.adminArea ?? "",
        postalCode: address?.postalCode ?? "",
        country: address?.countryName ?? "",
      );
      // payment finished successfully
      // you must call this method to close card entry
      // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
      Future.delayed(Duration(seconds: 3), () {
        loadSavedCards();
      });
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  /**
   * Callback when the card entry is closed after call 'completeCardEntry'
   */
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
  }

  openEmbededWebpageLink(String url) async {
    //
    try {
      ChromeSafariBrowser browser = MyChromeSafariBrowser();
      await browser.open(
        url: WebUri.uri(Uri.parse(url)),
        options: ChromeSafariBrowserClassOptions(
          android: AndroidChromeCustomTabsOptions(
            shareState: CustomTabsShareState.SHARE_STATE_OFF,
            enableUrlBarHiding: true,
          ),
          ios: IOSSafariOptions(
            barCollapsingEnabled: true,
          ),
        ),
      );
    } catch (error) {
      await launchUrlString(url);
    }
  }

  Future<dynamic> openWebpageLink(
    String url, {
    bool external = false,
    bool embeded = false,
  }) async {
    //
    if (embeded) {
      return openEmbededWebpageLink(url);
    }
    //
    if (!embeded && (Platform.isIOS || external)) {
      await launchUrlString(
        url,
        webViewConfiguration: const WebViewConfiguration(),
      );
      return;
    }
    final result = await Navigator.push(
        viewContext,
        MaterialPageRoute(
          builder: (context) => CustomWebViewPage(
            selectedUrl: url,
          ),
        ));
    return result;
  }

  Future<dynamic> openExternalWebpageLink(String url) async {
    try {
      final result = await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      return result;
    } catch (error) {
      ToastService.toastError("$error");
    }
    return null;
  }

  String generateUuid() {
    final Random random = Random.secure();
    final Uint8List bytes = Uint8List(16);

    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }

    // Set version to 0100
    bytes[6] = (bytes[6] & 0x0f) | 0x40;

    // Set bits 6-7 to 10
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    return _bytesToUuid(bytes);
  }

  String _bytesToUuid(Uint8List bytes) {
    final List<String> hexDigits = bytes.map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).toList();

    return '${hexDigits[0]}${hexDigits[1]}${hexDigits[2]}${hexDigits[3]}'
        '-${hexDigits[4]}${hexDigits[5]}'
        '-${hexDigits[6]}${hexDigits[7]}'
        '-${hexDigits[8]}${hexDigits[9]}'
        '-${hexDigits[10]}${hexDigits[11]}${hexDigits[12]}${hexDigits[13]}${hexDigits[14]}${hexDigits[15]}';
  }
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad(bool? didLoadSuccessfully) {
    super.onCompletedInitialLoad(didLoadSuccessfully);
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}
