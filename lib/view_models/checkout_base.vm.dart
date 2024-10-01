// import 'package:cool_alert/cool_alert.dart';
// import 'package:dartx/dartx.dart';
// import 'package:flutter/material.dart';
// import 'package:mealknight/constants/app_routes.dart';
// import 'package:mealknight/constants/app_strings.dart';
// import 'package:mealknight/extensions/string.dart';
// import 'package:mealknight/models/checkout.dart';
// import 'package:mealknight/models/delivery_address.dart';
// import 'package:mealknight/models/payment_method.dart';
// import 'package:mealknight/requests/checkout.request.dart';
// import 'package:mealknight/requests/delivery_address.request.dart';
// import 'package:mealknight/requests/vendor.request.dart';
// import 'package:mealknight/requests/payment_method.request.dart';
// import 'package:mealknight/services/app.service.dart';
// import 'package:mealknight/services/cart.service.dart';
// import 'package:mealknight/services/checkout.service.dart';
// import 'package:mealknight/view_models/payment.view_model.dart';
// import 'package:mealknight/view_models/vendor_details.vm.dart';
// import 'package:mealknight/widgets/bottomsheets/delivery_address_picker.bottomsheet.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:square_in_app_payments/in_app_payments.dart';
// import 'package:square_in_app_payments/models.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../models/payment_card.dart';
// import 'vendor_distance.vm.dart';
//
// class CheckoutBaseViewModel extends PaymentViewModel {
//   CheckoutRequest checkoutRequest = CheckoutRequest();
//   DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
//   PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
//   VendorDetailsViewModel? vendorDetailsViewModel;
//
//   VendorRequest vendorRequest = VendorRequest();
//   TextEditingController driverTipTEC = TextEditingController();
//   TextEditingController noteTEC = TextEditingController();
//   DeliveryAddress? deliveryAddress;
//   bool isPickup = false;
//   bool isScheduled = false;
//   List<String> availableTimeSlots = [];
//   bool delievryAddressOutOfRange = false;
//   bool canSelectPaymentOption = true;
//   bool viewMap = false;
//   CheckOut? checkout;
//   bool calculateTotal = true;
//   List<Map> calFees = [];
//   double discount = 0.0;
//   double totalPrice = 0.0;
//
//   //
//   List<PaymentMethod> paymentMethods = [];
//   PaymentMethod? selectedPaymentMethod;
//   PaymentCard? paymentCard;
//
//   String nonce = "";
//
//   void initialise() async {
//     super.initialise();
//     checkout ??= CheckOut();
//     vendorDetailsViewModel = VendorDetailsViewModel(
//         viewContext, checkout!.cartItems!.first.product!.vendor);
//     print(checkout);
//     isPickup = VendorDistanceViewModel().isPickup.value;
//     VendorDistanceViewModel().isPickup.addListener(_onPickupChanged);
//
//     vendorDetailsViewModel?.getCurrentLocation();
//     print(
//         "currentLocation ==========${vendorDetailsViewModel?.currentLocation}");
//     fetchVendorDetails();
//     prefetchDeliveryAddress();
//     fetchPaymentOptions();
//     updateTotalOrderSummary();
//   }
//
//   void _onPickupChanged() {
//     isPickup = VendorDistanceViewModel().isPickup.value;
//     notifyListeners();
//   }
//
//   //
//   fetchVendorDetails() async {
//     //
//     vendor = CartServices.productsInCart[0].product?.vendor;
//
//     //
//     setBusy(true);
//     try {
//       vendor = await vendorRequest.vendorDetails(
//         vendor!.id,
//         params: {
//           "type": "brief",
//         },
//       );
//       setVendorRequirement();
//     } catch (error) {
//       print("Error Getting Vendor Details ==> $error");
//     }
//     setBusy(false);
//   }
//
//   setVendorRequirement() {
//     if (vendor!.allowOnlyDelivery) {
//       isPickup = false;
//     } else if (vendor!.allowOnlyPickup) {
//       isPickup = true;
//     }
//   }
//
//   void changeSelectedDeliveryType() {
//     VendorDistanceViewModel().onUpdatePickup(!isPickup);
//   }
//
//   //start of schedule related
//   changeSelectedDeliveryDate(String string, int index) {
//     checkout?.deliverySlotDate = string;
//     availableTimeSlots = vendor!.deliverySlots[index].times;
//     notifyListeners();
//   }
//
//   changeSelectedDeliveryTime(String time) {
//     checkout?.deliverySlotTime = time;
//     notifyListeners();
//   }
//
//   //end of schedule related
//   //
//   prefetchDeliveryAddress() async {
//     setBusyForObject(deliveryAddress, true);
//     //
//     try {
//       //
//       checkout!.deliveryAddress = deliveryAddress =
//           await deliveryAddressRequest.preselectedDeliveryAddress(
//         vendorId: vendor?.id,
//       );
//
//       if (checkout?.deliveryAddress != null) {
//         //
//         checkDeliveryRange();
//         updateTotalOrderSummary();
//       }
//     } catch (error) {
//       print("Error Fetching preselected Address ==> $error");
//     }
//     setBusyForObject(deliveryAddress, false);
//   }
//
//   //
//   fetchPaymentOptions({int? vendorId}) async {
//     setBusyForObject(paymentMethods, true);
//     try {
//       paymentMethods = await paymentOptionRequest.getPaymentOptions(
//         vendorId: vendorId ?? vendor?.id,
//       );
//       //
//       if (paymentMethods.isNotEmpty) {
//         onChangePaymentMethod(paymentMethods.first);
//       }
//       updatePaymentOptionSelection();
//       clearErrors();
//     } catch (error) {
//       print("Regular Error getting payment methods ==> $error");
//     }
//     setBusyForObject(paymentMethods, false);
//   }
//
//   //
//   fetchTaxiPaymentOptions() async {
//     setBusyForObject(paymentMethods, true);
//     try {
//       paymentMethods = await paymentOptionRequest.getTaxiPaymentOptions();
//       //
//       updatePaymentOptionSelection();
//       clearErrors();
//     } catch (error) {
//       print("Taxi Error getting payment methods ==> $error");
//     }
//     setBusyForObject(paymentMethods, false);
//   }
//
//   updatePaymentOptionSelection() {
//     if (checkout != null && checkout!.total <= 0.00) {
//       canSelectPaymentOption = false;
//     } else {
//       canSelectPaymentOption = true;
//     }
//     //
//     if (!canSelectPaymentOption) {
//       final selectedPaymentMethod = paymentMethods.firstOrNullWhere(
//         (e) => e.isCash == 1,
//       );
//       onChangePaymentMethod(selectedPaymentMethod, callTotal: false);
//     }
//   }
//
//   //
//   Future<DeliveryAddress> showDeliveryAddressPicker() async {
//     //
//     final mDeliveryAddress = await showModalBottomSheet(
//       context: viewContext,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return DeliveryAddressPicker(
//           onSelectDeliveryAddress: (deliveryAddress) {
//             this.deliveryAddress = deliveryAddress;
//             checkout?.deliveryAddress = deliveryAddress;
//             //
//             checkDeliveryRange();
//             updateTotalOrderSummary();
//             //
//             notifyListeners();
//             Navigator.of(viewContext).pop(deliveryAddress);
//           },
//         );
//       },
//     );
//     return mDeliveryAddress;
//   }
//
//   togglePickupStatus(bool? value) {
//     if (vendor!.allowOnlyPickup) {
//       value = true;
//     } else if (vendor!.allowOnlyDelivery) {
//       value = false;
//     }
//     isPickup = value ?? false;
//     //remove delivery address if pickup
//     if (isPickup) {
//       checkout?.deliveryAddress = null;
//     } else {
//       checkout?.deliveryAddress = deliveryAddress;
//     }
//     updateTotalOrderSummary();
//     notifyListeners();
//   }
//
//   toggleScheduledOrder(bool? value) async {
//     isScheduled = value ?? false;
//     checkout?.isScheduled = isScheduled;
//     //remove delivery address if pickup
//     checkout?.pickupDate = null;
//     checkout?.deliverySlotDate = "";
//     checkout?.pickupTime = null;
//     checkout?.deliverySlotTime = "";
//
//     await Jiffy.setLocale(LocalizeAndTranslate.getLocale().languageCode);
//
//     notifyListeners();
//   }
//
//   //
//   void checkDeliveryRange() {
//     delievryAddressOutOfRange =
//         vendor!.deliveryRange < (deliveryAddress!.distance ?? 0);
//     if (deliveryAddress?.canDeliver != null) {
//       delievryAddressOutOfRange = (deliveryAddress?.canDeliver ?? false) ==
//           false; //if vendor has set delivery range
//     }
//     notifyListeners();
//   }
//
//   //
//   isSelected(PaymentMethod paymentMethod) {
//     return paymentMethod.id == selectedPaymentMethod?.id;
//   }
//
//   onChangePaymentMethod(
//     PaymentMethod? paymentMethod, {
//     bool callTotal = true,
//   }) {
//     selectedPaymentMethod = paymentMethod;
//     checkout?.paymentMethod = paymentMethod;
//     if (callTotal) {
//       updateTotalOrderSummary();
//     }
//     notifyListeners();
//   }
//
//   //update total/order amount summary
//   updateTotalOrderSummary() async {
//     //delivery fee
//     if (!isPickup) {
//       //selected delivery address is within range
//       if (!delievryAddressOutOfRange) {
//         //vendor charges per km
//         setBusy(true);
//         try {
//           double orderDeliveryFee = await checkoutRequest.orderSummary(
//             deliveryAddressId: deliveryAddress!.id!,
//             vendorId: vendor!.id,
//           );
//
//           //adding base fee
//           checkout?.deliveryFee = orderDeliveryFee;
//         } catch (error) {
//           if (vendor?.chargePerKm == 1 && deliveryAddress?.distance != null) {
//             checkout?.deliveryFee =
//                 vendor!.deliveryFee * deliveryAddress!.distance!;
//           } else {
//             checkout?.deliveryFee = vendor!.deliveryFee;
//           }
//
//           //adding base fee
//           checkout?.deliveryFee += vendor!.baseDeliveryFee;
//         }
//
//         //
//         setBusy(false);
//       } else {
//         checkout?.deliveryFee = 0.00;
//       }
//     } else {
//       checkout!.deliveryFee = 0.00;
//     }
//     discount = 0;
//     totalPrice = 0;
//     notifyListeners();
//     checkout?.cartItems?.forEach((element) {
//       totalPrice =
//           totalPrice + (element.product!.price * element.product!.selectedQty);
//     });
//     print("checkout $checkout");
//     discount = totalPrice - checkout!.subTotal;
//     notifyListeners();
//     //handle coupon for delivery
//     if (checkout!.coupon != null && checkout!.coupon!.for_delivery) {
//       checkout!.discount = CheckoutService.generateOrderDiscount(
//         checkout!.coupon,
//         checkout!.subTotal,
//         checkout!.deliveryFee,
//       );
//     }
//     //checkout!.discount = checkout!.subTotal - discount;
//
//     //tax
//     checkout!.tax = (double.parse(vendor!.tax) / 100) * checkout!.subTotal;
//     checkout!.total = (checkout!.subTotal - checkout!.discount) +
//         checkout!.deliveryFee +
//         checkout!.tax;
//     calFees = [];
//     for (var fee in vendor!.fees) {
//       double calFee = 0;
//       if (fee.isPercentage) {
//         checkout!.total += calFee = fee.getRate(checkout!.subTotal);
//       } else {
//         checkout!.total += calFee = fee.value;
//       }
//
//       calFees.add({
//         "id": fee.id,
//         "name": fee.name,
//         "amount": calFee,
//       });
//     }
//     //
//     updateCheckoutTotalAmount();
//     updatePaymentOptionSelection();
//     notifyListeners();
//     Future.delayed(const Duration(seconds: 5), () {
//       viewMap = true;
//       notifyListeners();
//     });
//     notifyListeners();
//   }
//
//   //
//   bool pickupOnlyProduct() {
//     //
//     final product = CartServices.productsInCart.firstOrNullWhere(
//       (e) => !e.product?.canBeDelivered,
//     );
//
//     return product != null;
//   }
//
//   //
//   updateCheckoutTotalAmount() {
//     checkout!.totalWithTip =
//         checkout!.total + (driverTipTEC.text.toDoubleOrNull() ?? 0);
//   }
//
//   //
//   placeOrder({bool ignore = false}) async {
//     /*CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.success,
//         title: "Checkout".tr(),
//         text: "Test",
//         confirmBtnText: "Ok".tr(),
//         barrierDismissible: false,
//         onConfirmBtnTap: () {
//           print("Testing");
//
//           //showOrdersTab(context: viewContext);
//
//           if (Navigator.of(viewContext).canPop()) {
//             Navigator.of(viewContext).popUntil(
//               (route) => route.settings.name == AppRoutes.homeRoute || route.isFirst,
//             );
//           }
//         });*/
//     //
//
//     ///commented on may 22
//     if (isScheduled && checkout!.deliverySlotDate.isEmptyOrNull) {
//       //
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Delivery Date".tr(),
//         text: "Please select your desire order date".tr(),
//       );
//     } else if (isScheduled && checkout!.deliverySlotTime.isEmptyOrNull) {
//       //
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Delivery Time".tr(),
//         text: "Please select your desire order time".tr(),
//       );
//     } else if (!isPickup && pickupOnlyProduct()) {
//       //
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Product".tr(),
//         text:
//             "There seems to be products that can not be delivered in your cart"
//                 .tr(),
//       );
//     } else if (!isPickup && deliveryAddress == null) {
//       //
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Delivery address".tr(),
//         text: "Please select delivery address".tr(),
//       );
//     } else if (delievryAddressOutOfRange && !isPickup) {
//       //
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Delivery address".tr(),
//         text: "Delivery address is out of vendor delivery range".tr(),
//       );
//     } else if (selectedPaymentMethod == null) {
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Payment Methods".tr(),
//         text: "Please select a payment method".tr(),
//       );
//     } else if (!ignore && !verifyVendorOrderAmountCheck()) {
//       print("Failed");
//     }
//     //process the new order
//     else {
//       processOrderPlacement();
//       //_onStartCardEntryFlow();
//     }
//   }
//
//   /**
//    * An event listener to start card entry flow
//    */
//   Future<void> _onStartCardEntryFlow() async {
//     await InAppPayments.startCardEntryFlow(
//         onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
//         onCardEntryCancel: _onCancelCardEntryFlow);
//   }
//
//   /**
//    * Callback when card entry is cancelled and UI is closed
//    */
//   void _onCancelCardEntryFlow() {
//     // Handle the cancel callback
//   }
//
//   /**
//    * Callback when successfully get the card nonce details for processig
//    * card entry is still open and waiting for processing card nonce details
//    */
//   void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
//     try {
//       // take payment with the card nonce details
//       // you can take a charge
//       nonce = result.nonce;
//       await processOrderPlacement();
//       // payment finished successfully
//       // you must call this method to close card entry
//       // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
//       InAppPayments.completeCardEntry(
//           onCardEntryComplete: _onCardEntryComplete);
//     } on Exception catch (ex) {
//       // payment failed to complete due to error
//       // notify card entry to show processing error
//       InAppPayments.showCardNonceProcessingError(ex.toString());
//     }
//   }
//
//   /**
//    * Callback when the card entry is closed after call 'completeCardEntry'
//    */
//   void _onCardEntryComplete() {
//     // Update UI to notify user that the payment flow is finished successfully
//   }
//
//   //
//   processOrderPlacement() async {
//     //process the order placement
//     setBusy(true);
//     //set the total with discount as the new total
//     CoolAlert.show(
//       context: viewContext,
//       type: CoolAlertType.loading,
//       title: "Please wait".tr(),
//       text: "Please wait placing order...".tr(),
//       barrierDismissible: false,
//     );
//
//     checkout!.total = checkout!.totalWithTip;
//     //
//     print('processOrderPlacement');
//     final apiResponse = await checkoutRequest.newOrder(
//       checkout!,
//       isPickup: isPickup,
//       tip: driverTipTEC.text,
//       note: noteTEC.text,
//       fees: calFees,
//     );
//
//     String? orderId = apiResponse.body["code"];
//     if (null != orderId && (null != paymentCard || null != defaultCard.value)) {
//       print("New Order Id => $orderId");
//       print("Making card Payment");
//       final apiResponse = await checkoutRequest.makeOrderPayment(
//           orderId: orderId,
//           paymentSourceId: (paymentCard ?? defaultCard.value!).id);
//       print(apiResponse.body);
//     } else {
//       print("Order Id is empty");
//     }
//
//     //notify wallet view to update, just incase wallet was use for payment
//     AppService().refreshWalletBalance.add(true);
//
//     //not error
//     if (apiResponse.allGood) {
//       //cash payment
//
//       final paymentLink = apiResponse.body["link"].toString();
//       if (!paymentLink.isEmptyOrNull) {
//         Navigator.of(viewContext).pop();
//         showOrdersTab(context: viewContext);
//         dynamic result;
//         // if (["offline", "razorpay"]
//         if (["offline"].contains(checkout!.paymentMethod?.slug ?? "offline")) {
//           result = await openExternalWebpageLink(paymentLink);
//         } else {
//           result = await openWebpageLink(paymentLink);
//         }
//         print("Result from payment ==> $result");
//       }
//       //cash payment
//       else {
//         CoolAlert.show(
//             context: viewContext,
//             type: CoolAlertType.success,
//             title: "Checkout".tr(),
//             text: apiResponse.message,
//             confirmBtnText: "Ok".tr(),
//             barrierDismissible: false,
//             onConfirmBtnTap: () {
//               //Restarting the app
//
//               //Navigator.of(viewContext).pop(true);
//               showOrdersTab(context: viewContext);
//
//               /*if (Navigator.of(viewContext).canPop()) {
//                 Navigator.of(viewContext).popUntil(
//                   (route) => route == AppRoutes.homeRoute || route.isFirst,
//                 );
//               }*/
//             });
//       }
//     } else {
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Checkout".tr(),
//         text: apiResponse.message,
//       );
//     }
//     setBusy(false);
//   }
//
//   //
//   showOrdersTab({
//     required BuildContext context,
//   }) {
//     //clear cart items
//     CartServices.clearCart();
//     //switch tab to orders
//     AppService().changeHomePageIndex(index: 1);
//     //pop until home page
//     Future.delayed(const Duration(seconds: 1), () {
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(viewContext).popUntil(
//           (route) =>
//               route.settings.name == AppRoutes.homeRoute || route.isFirst,
//         );
//       }
//     });
//   }
//
//   //
//   bool verifyVendorOrderAmountCheck() {
//     //if vendor set min/max order
//     final orderVendor = checkout?.cartItems?.first.product?.vendor ?? vendor;
//     //if order is less than the min allowed order by this vendor
//     //if vendor is currently open for accepting orders
//
//     if (!vendor!.isOpen && !(checkout!.isScheduled ?? false) && !isPickup) {
//       //vendor is closed
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Vendor is not open".tr(),
//         text: "Vendor is currently not open to accepting order at the moment"
//             .tr(),
//       );
//       return false;
//     } else if (orderVendor?.minOrder != null &&
//         orderVendor!.minOrder! > checkout!.subTotal) {
//       ///
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Minimum Order Value".tr(),
//         text: "Order value/amount is less than vendor accepted minimum order"
//                 .tr() +
//             "${AppStrings.currencySymbol} ${orderVendor.minOrder}"
//                 .currencyFormat(),
//       );
//       return false;
//     }
//     //if order is more than the max allowed order by this vendor
//     else if (orderVendor?.maxOrder != null &&
//         orderVendor!.maxOrder! < checkout!.subTotal) {
//       //
//       CoolAlert.show(
//         context: viewContext,
//         type: CoolAlertType.error,
//         title: "Maximum Order Value".tr(),
//         text: "Order value/amount is more than vendor accepted maximum order"
//                 .tr() +
//             "${AppStrings.currencySymbol} ${orderVendor.maxOrder}"
//                 .currencyFormat(),
//       );
//       return false;
//     }
//     return true;
//   }
// }
//
// class ChargeException implements Exception {
//   String errorMessage;
//
//   ChargeException(this.errorMessage);
// }

import 'package:cool_alert/cool_alert.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/extensions/string.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/models/payment_method.dart';
import 'package:mealknight/requests/checkout.request.dart';
import 'package:mealknight/requests/delivery_address.request.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/requests/payment_method.request.dart';
import 'package:mealknight/services/app.service.dart';
import 'package:mealknight/services/cart.service.dart';
import 'package:mealknight/services/checkout.service.dart';
import 'package:mealknight/view_models/payment.view_model.dart';
import 'package:mealknight/view_models/vendor_details.vm.dart';
import 'package:mealknight/widgets/bottomsheets/delivery_address_picker.bottomsheet.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/payment_card.dart';
import '../models/vendor.dart';
import 'vendor_distance.vm.dart';

class CheckoutBaseViewModel extends PaymentViewModel {

  CheckoutRequest checkoutRequest = CheckoutRequest();
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
  VendorDetailsViewModel? vendorDetailsViewModel;

  VendorRequest vendorRequest = VendorRequest();
  TextEditingController driverTipTEC = TextEditingController();
  TextEditingController noteTEC = TextEditingController();
  DeliveryAddress? deliveryAddress;
  bool isPickup = false;
  bool isScheduled = false;
  List<String> availableTimeSlots = [];
  bool delievryAddressOutOfRange = false;
  bool canSelectPaymentOption = true;
  bool viewMap = false;
  CheckOut? checkout;
  bool calculateTotal = true;
  List<Map> calFees = [];
  double discount = 0.0;
  double totalPrice = 0.0;

  //
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod? selectedPaymentMethod;
  PaymentCard? paymentCard;

  String nonce = "";

  void initialise() async {
    super.initialise();
    checkout ??= CheckOut();
    vendorDetailsViewModel = VendorDetailsViewModel(
        viewContext, checkout!.cartItems!.first.product!.vendor);
    print(checkout);
    isPickup = VendorDistanceViewModel().isPickup.value;
    VendorDistanceViewModel().isPickup.addListener(_onPickupChanged);

    vendorDetailsViewModel?.getCurrentLocation();
    print(
        "currentLocation ==========${vendorDetailsViewModel?.currentLocation}");
    fetchVendorDetails();
    prefetchDeliveryAddress();
    fetchPaymentOptions();
    updateTotalOrderSummary();
  }

  void _onPickupChanged() {
    isPickup = VendorDistanceViewModel().isPickup.value;
    notifyListeners();
  }

  //
  fetchVendorDetails() async {
    //
    vendor = CartServices.productsInCart[0].product?.vendor;

    //
    setBusy(true);
    try {
      vendor = await vendorRequest.vendorDetails(
        vendor!.id,
        params: {
          "type": "brief",
        },
      );
      setVendorRequirement();
    } catch (error) {
      print("Error Getting Vendor Details ==> $error");
    }
    setBusy(false);
  }

  setVendorRequirement() {
    if (vendor!.allowOnlyDelivery) {
      isPickup = false;
    } else if (vendor!.allowOnlyPickup) {
      isPickup = true;
    }
  }

  void changeSelectedDeliveryType() {
    VendorDistanceViewModel().onUpdatePickup(!isPickup);
  }

  //start of schedule related
  changeSelectedDeliveryDate(String string, int index) {
    checkout?.deliverySlotDate = string;
    availableTimeSlots = vendor!.deliverySlots[index].times;
    notifyListeners();
  }

  changeSelectedDeliveryTime(String time) {
    checkout?.deliverySlotTime = time;
    notifyListeners();
  }

  //end of schedule related
  //
  prefetchDeliveryAddress() async {
    setBusyForObject(deliveryAddress, true);
    //
    try {
      //
      checkout!.deliveryAddress = deliveryAddress =
      await deliveryAddressRequest.preselectedDeliveryAddress(
        vendorId: vendor?.id,
      );
      print("Vendor Id ===> ${vendor?.id}");

      if (checkout?.deliveryAddress != null) {
        checkDeliveryRange();
        updateTotalOrderSummary();
      }
    } catch (error) {
      print("Error Fetching preselected Address ==> $error");
    }
    setBusyForObject(deliveryAddress, false);
  }

  //
  fetchPaymentOptions({int? vendorId}) async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getPaymentOptions(
        vendorId: vendorId ?? vendor?.id,
      );
      //
      if (paymentMethods.isNotEmpty) {
        onChangePaymentMethod(paymentMethods.first);
      }
      updatePaymentOptionSelection();
      clearErrors();
    } catch (error) {
      print("Regular Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  //
  fetchTaxiPaymentOptions() async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getTaxiPaymentOptions();
      //
      updatePaymentOptionSelection();
      clearErrors();
    } catch (error) {
      print("Taxi Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  updatePaymentOptionSelection() {
    if (checkout != null && checkout!.total <= 0.00) {
      canSelectPaymentOption = false;
    } else {
      canSelectPaymentOption = true;
    }
    //
    if (!canSelectPaymentOption) {
      final selectedPaymentMethod = paymentMethods.firstOrNullWhere(
            (e) => e.isCash == 1,
      );
      onChangePaymentMethod(selectedPaymentMethod, callTotal: false);
    }
  }



  //
  Future<DeliveryAddress> showDeliveryAddressPicker() async {
    //
    final mDeliveryAddress = await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeliveryAddressPicker(
          onSelectDeliveryAddress: (deliveryAddress) {
            this.deliveryAddress = deliveryAddress;
            checkout?.deliveryAddress = deliveryAddress;
            //
            checkDeliveryRange();
            updateTotalOrderSummary();
            //
            notifyListeners();
            Navigator.of(viewContext).pop(deliveryAddress);
          },
        );
      },
    );
    return mDeliveryAddress;
  }

  togglePickupStatus(bool? value) {
    if (vendor!.allowOnlyPickup) {
      value = true;
    } else if (vendor!.allowOnlyDelivery) {
      value = false;
    }
    isPickup = value ?? false;
    //remove delivery address if pickup
    if (isPickup) {
      checkout?.deliveryAddress = null;
    } else {
      checkout?.deliveryAddress = deliveryAddress;
    }
    updateTotalOrderSummary();
    notifyListeners();
  }

  toggleScheduledOrder(bool? value) async {
    isScheduled = value ?? false;
    checkout?.isScheduled = isScheduled;
    //remove delivery address if pickup
    checkout?.pickupDate = null;
    checkout?.deliverySlotDate = "";
    checkout?.pickupTime = null;
    checkout?.deliverySlotTime = "";

    await Jiffy.setLocale(LocalizeAndTranslate.getLocale().languageCode);

    notifyListeners();
  }

  //
  void checkDeliveryRange() {
    delievryAddressOutOfRange =
        vendor!.deliveryRange < (deliveryAddress!.distance ?? 0);
    if (deliveryAddress?.canDeliver != null) {
      delievryAddressOutOfRange = (deliveryAddress?.canDeliver ?? false) ==
          false;//if vendor has set delivery range
      print("Vendor deliveryRange ===> ${vendor!.deliveryRange}");
    }
    notifyListeners();
  }

  //
  isSelected(PaymentMethod paymentMethod) {
    return paymentMethod.id == selectedPaymentMethod?.id;
  }

  onChangePaymentMethod(
      PaymentMethod? paymentMethod, {
        bool callTotal = true,
      }) {
    selectedPaymentMethod = paymentMethod;
    checkout?.paymentMethod = paymentMethod;
    if (callTotal) {
      updateTotalOrderSummary();
    }
    notifyListeners();
  }

  //update total/order amount summary
  updateTotalOrderSummary() async {
    //delivery fee
    if (!isPickup) {
      //selected delivery address is within range
      if (!delievryAddressOutOfRange) {
        //vendor charges per km
        setBusy(true);
        try {
          double orderDeliveryFee = await checkoutRequest.orderSummary(
            deliveryAddressId: deliveryAddress!.id!,
            vendorId: vendor!.id,
          );

          //adding base fee
          checkout?.deliveryFee = orderDeliveryFee;
        } catch (error) {
          if (vendor?.chargePerKm == 1 && deliveryAddress?.distance != null) {
            checkout?.deliveryFee =
                vendor!.deliveryFee * deliveryAddress!.distance!;
          } else {
            checkout?.deliveryFee = vendor!.deliveryFee;
          }

          //adding base fee
          checkout?.deliveryFee += vendor!.baseDeliveryFee;
        }

        //
        setBusy(false);
      } else {
        checkout?.deliveryFee = 0.00;
      }
    } else {
      checkout!.deliveryFee = 0.00;
    }
    discount = 0;
    totalPrice = 0;
    notifyListeners();
    checkout?.cartItems?.forEach((element) {
      totalPrice =
          totalPrice + (element.product!.price * element.product!.selectedQty);
    });
    print("checkout $checkout");
    discount = totalPrice - checkout!.subTotal;
    notifyListeners();
    //handle coupon for delivery
    if (checkout!.coupon != null && checkout!.coupon!.for_delivery) {
      checkout!.discount = CheckoutService.generateOrderDiscount(
        checkout!.coupon,
        checkout!.subTotal,
        checkout!.deliveryFee,
      );
    }
    //checkout!.discount = checkout!.subTotal - discount;

    //tax
    checkout!.tax = (double.parse(vendor!.tax) / 100) * checkout!.subTotal;
    checkout!.total = (checkout!.subTotal - checkout!.discount) +
        checkout!.deliveryFee +
        checkout!.tax;
    calFees = [];
    for (var fee in vendor!.fees) {
      double calFee = 0;
      if (fee.isPercentage) {
        checkout!.total += calFee = fee.getRate(checkout!.subTotal);
      } else {
        checkout!.total += calFee = fee.value;
      }

      calFees.add({
        "id": fee.id,
        "name": fee.name,
        "amount": calFee,
      });
    }
    //
    updateCheckoutTotalAmount();
    updatePaymentOptionSelection();
    notifyListeners();
    Future.delayed(const Duration(seconds: 5), () {
      viewMap = true;
      notifyListeners();
    });
    notifyListeners();
  }

  //
  bool pickupOnlyProduct() {
    //
    final product = CartServices.productsInCart.firstOrNullWhere(
          (e) => !e.product?.canBeDelivered,
    );

    return product != null;
  }

  //
  updateCheckoutTotalAmount() {
    checkout!.totalWithTip =
        checkout!.total + (driverTipTEC.text.toDoubleOrNull() ?? 0);
  }
  //
  placeOrder({bool ignore = false}) async {

    print("Payment Method =====> ${ selectedPaymentMethod?.name}");
    if (isScheduled && checkout!.deliverySlotDate.isEmptyOrNull) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery Date".tr(),
        text: "Please select your desired order date".tr(),
      );
      return; // Ensure it stops here
    } else if (isScheduled && checkout!.deliverySlotTime.isEmptyOrNull) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery Time".tr(),
        text: "Please select your desired order time".tr(),
      );
      return; // Ensure it stops here
    } else if (!isPickup && pickupOnlyProduct()) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Product".tr(),
        text:
        "There seems to be products that cannot be delivered in your cart"
            .tr(),
      );
      return; // Ensure it stops here
    } else if (!isPickup && deliveryAddress == null) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery address".tr(),
        text: "Please select a delivery address".tr(),
      );
      return; // Ensure it stops here
    }
    else if (!isPickup && delievryAddressOutOfRange) {
      print("isPickup: $isPickup");
      print("delievryAddressOutOfRange: $delievryAddressOutOfRange");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Delivery address".tr(),
        text: "Delivery address is out of vendor delivery range".tr(),
      );
      return; // Stop further execution if the delivery address is out of range
    }
    else if (selectedPaymentMethod?.name != "Wallet Balance"){
      if (( paymentCard == null ||
          defaultCard.value == null))
    {
      print("Payment Card =====> $paymentCard");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Payment Methods".tr(),
        text: "Please select a payment method".tr(),
      );
      return; // Ensure it stops here
    }}
    else if (!ignore && !verifyVendorOrderAmountCheck()) {
      print("Failed");
      return; // Ensure it stops here
    }
    //process the new order
    else {
      processOrderPlacement();
      //_onStartCardEntryFlow();
    }
  }

  /**
   * An event listener to start card entry flow
   */
  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
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
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      nonce = result.nonce;
      await processOrderPlacement();
      // payment finished successfully
      // you must call this method to close card entry
      // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
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

  //
  processOrderPlacement() async {
    //process the order placement
    setBusy(true);

    // Show loading dialog
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.loading,
      title: "Please wait",
      text: "Please wait while placing order...",
      barrierDismissible: false,
    );

    checkout!.total = checkout!.totalWithTip;

    print('processOrderPlacement');
    final apiResponse = await checkoutRequest.newOrder(
      checkout!,
      isPickup: isPickup,
      tip: driverTipTEC.text,
      note: noteTEC.text,
      fees: calFees,
    );

    // Close the loading dialog before proceeding
    Navigator.of(viewContext).pop();

    // If there's an order ID and a payment card or default card, proceed with payment
    String? orderId = apiResponse.body["code"];
    if (null != orderId && (null != paymentCard || null != defaultCard.value)) {
      print("New Order Id => $orderId");
      print("Making card Payment");

      final apiResponse = await checkoutRequest.makeOrderPayment(
        orderId: orderId,
        paymentSourceId: (paymentCard ?? defaultCard.value!).id,
      );
      print(apiResponse.body);
    } else {
      print("Order Id is empty");
    }

    // Notify wallet view to update, just in case the wallet was used for payment
    AppService().refreshWalletBalance.add(true);

    // If the order placement was successful
    if (apiResponse.allGood) {
      final paymentLink = apiResponse.body["link"].toString();

      if (!paymentLink.isEmptyOrNull) {
        showOrdersTab(context: viewContext);
        dynamic result;

        if (["offline"].contains(checkout!.paymentMethod?.slug ?? "offline")) {
          result = await openExternalWebpageLink(paymentLink);
        } else {
          result = await openWebpageLink(paymentLink);
        }
        print("Result from payment ==> $result");
      } else {
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.success,
          title: "Checkout".tr(),
          text: apiResponse.message,
          confirmBtnText: "Ok".tr(),
          barrierDismissible: false,
          onConfirmBtnTap: () {
            showOrdersTab(context: viewContext);
          },
        );
      }
    } else {
      // Show error alert if something goes wrong
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Checkout".tr(),
        text: apiResponse.message,
      );
    }

    setBusy(false);
  }


  //
  showOrdersTab({
    required BuildContext context,
  }) {
    //clear cart items
    CartServices.clearCart();
    //switch tab to orders
    AppService().changeHomePageIndex(index: 1);
    //pop until home page
    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(viewContext).popUntil(
              (route) =>
          route.settings.name == AppRoutes.homeRoute || route.isFirst,
        );
      }
    });
  }

  //
  bool verifyVendorOrderAmountCheck() {
    //if vendor set min/max order
    final orderVendor = checkout?.cartItems?.first.product?.vendor ?? vendor;
    //if order is less than the min allowed order by this vendor
    //if vendor is currently open for accepting orders

    if (vendor == null || !vendor!.isOpen && !(checkout!.isScheduled ?? false) && !isPickup) {
      //vendor is closed
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Vendor is not open".tr(),
        text: "Vendor is currently not open to accepting orders at the moment"
            .tr(),
      );
      return false;
    } else if (orderVendor?.minOrder != null &&
        orderVendor!.minOrder! > checkout!.subTotal) {
      ///
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Minimum Order Value".tr(),
        text: "Order value/amount is less than vendor accepted minimum order"
            .tr() +
            "${AppStrings.currencySymbol} ${orderVendor.minOrder}"
                .currencyFormat(),
      );
      return false;
    }
    //if order is more than the max allowed order by this vendor
    else if (orderVendor?.maxOrder != null &&
        orderVendor!.maxOrder! < checkout!.subTotal) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Maximum Order Value".tr(),
        text: "Order value/amount is more than vendor accepted maximum order"
            .tr() +
            "${AppStrings.currencySymbol} ${orderVendor.maxOrder}"
                .currencyFormat(),
      );
      return false;
    }
    return true;
  }
}

class ChargeException implements Exception {
  String errorMessage;

  ChargeException(this.errorMessage);
}
