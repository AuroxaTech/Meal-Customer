import 'package:cool_alert/cool_alert.dart';
import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_ui_settings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/models/payment_method.dart';
import 'package:mealknight/requests/order.request.dart';
import 'package:mealknight/services/app.service.dart';
import 'package:mealknight/services/chat.service.dart';
import 'package:mealknight/view_models/checkout_base.vm.dart';
import 'package:mealknight/view_models/vendor_details.vm.dart';
import 'package:mealknight/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:mealknight/widgets/bottomsheets/driver_rating.bottomsheet.dart';
import 'package:mealknight/widgets/bottomsheets/vendor_rating.bottomsheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetailsViewModel extends CheckoutBaseViewModel {
  Order order;
  OrderRequest orderRequest = OrderRequest();
  bool viewMap = false;

  OrderDetailsViewModel(BuildContext context, this.order) {
    this.viewContext = context;
  }

  initialise() {
    fetchOrderDetails();
    fetchPaymentOptions();
    _initSquarePayment();
  }

  Future<void> _initSquarePayment() async {
    //await InAppPayments.setSquareApplicationId('sandbox-sq0idb-qoPHaU30q6ny7fH9bJIxxw');
    await InAppPayments.setSquareApplicationId('sq0idp-gFY4lprof3-akMvW1gkNFg');
  }

  void callVendor() {
    launchUrlString("tel:${order.vendor?.phone}");
  }

  void callDriver() {
    launchUrlString("tel:${order.driver?.phone}");
  }

  void callRecipient() {
    launchUrlString("tel:${order.recipientPhone}");
  }

  chatVendor() {
    //
    Map<String, PeerUser> peers = {
      '${order.userId}': PeerUser(
        id: '${order.userId}',
        name: order.user.name,
        image: order.user.photo,
      ),
      'vendor_${order.vendor?.id}': PeerUser(
        id: "vendor_${order.vendor?.id}",
        name: order.vendor?.name ?? "",
        image: order.vendor?.logo,
      ),
    };
    //
    final chatEntity = ChatEntity(
      onMessageSent: ChatService.sendChatMessage,
      mainUser: peers['${order.userId}']!,
      peers: peers,
      //don't translate this
      path: "orders/${order.code}/customerVendor/chats",
      title: "Chat with vendor".tr(),
      supportMedia: AppUISettings.canCustomerChatSupportMedia,
    );
    //
    Navigator.of(viewContext).pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  chatDriver() {
    //
    Map<String, PeerUser> peers = {
      '${order.userId}': PeerUser(
        id: '${order.userId}',
        name: order.user.name,
        image: order.user.photo,
      ),
      '${order.driver?.id}': PeerUser(
          id: "${order.driver?.id}",
          name: order.driver?.name ?? "Driver".tr(),
          image: order.driver?.photo),
    };
    //
    final chatEntity = ChatEntity(
      mainUser: peers['${order.userId}']!,
      peers: peers,
      //don't translate this
      path: 'orders/' + order.code + "/customerDriver/chats",
      title: "Chat with driver".tr(),
      onMessageSent: ChatService.sendChatMessage,
      supportMedia: AppUISettings.canCustomerChatSupportMedia,
    );
    Navigator.of(viewContext).pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  void fetchOrderDetails() async {
    refreshController.refreshCompleted();
    notifyListeners();
    setBusy(true);
    try {
      order = await orderRequest.getOrderDetails(id: order.id);
      vendorDetailsViewModel =
          await VendorDetailsViewModel(viewContext, order.vendor);
      notifyListeners();
      vendorDetailsViewModel!.getCurrentLocation();

      notifyListeners();
      Future.delayed(const Duration(seconds: 5), () {
        viewMap = true;
        notifyListeners();
      });
      notifyListeners();
      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }

  refreshDataSet() {
    fetchOrderDetails();
  }

  //
  rateVendor() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return VendorRatingBottomSheet(
          order: order,
          onSubmitted: () {
            //
            Navigator.of(viewContext).pop();
            fetchOrderDetails();
          },
        );
      },
    );
  }

  //
  rateDriver() async {
    await Navigator.push(
        viewContext,
        MaterialPageRoute(
          builder: (context) => DriverRatingBottomSheet(
            order: order,
            onSubmitted: () {
              //
              Navigator.of(viewContext).pop();
              fetchOrderDetails();
            },
          ),
        ));
  }

  //
  trackOrder() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.orderTrackingRoute,
      arguments: order,
    );
  }

  cancelOrder() async {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.info,
      text: "Call your restaurant to cancel the order",
    );
    /*if (order.canCancel) {
      showModalBottomSheet(
        context: viewContext,
        isScrollControlled: true,
        builder: (context) {
          return OrderCancellationBottomSheet(
            order: order,
            onSubmit: (String reason) {
              Navigator.of(viewContext).pop();
              processOrderCancellation(reason);
            },
          );
        },
      );
    } else {
      CoolAlert.show(
        showCancelBtn: false,
        context: viewContext,
        title: "Order Cancellation ".tr(),
        text:
            "Please note that you will receive a refund only for the delivery charge and the tax on the delivery charge. Refunds will not be issued for the cost of food items."
                .tr(),
        type: CoolAlertType.confirm,
        onConfirmBtnTap: () async {
          Navigator.of(viewContext).pop();
          showModalBottomSheet(
            context: viewContext,
            isScrollControlled: true,
            builder: (context) {
              return OrderCancellationBottomSheet(
                order: order,
                onSubmit: (String reason) {
                  Navigator.of(viewContext).pop();
                  processOrderCancellation(reason);
                },
              );
            },
          );
        },
      );
    }*/
  }

  //
  processOrderCancellation(String reason) async {
    setBusyForObject(order, true);
    try {
      final responseMessage = await orderRequest.updateOrder(
        id: order.id,
        status: "cancelled",
        reason: reason,
      );
      //
      order.status = "cancelled";
      //message
      viewContext.showToast(
        msg: responseMessage,
        bgColor: Colors.green,
        textColor: Colors.white,
      );

      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setError(error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
    setBusyForObject(order, false);
  }

  void showVerificationQRCode() async {
    showDialog(
      context: viewContext,
      builder: (context) {
        return Dialog(
          child: VStack(
            [
              QrImageView(
                data: order.verificationCode,
                version: QrVersions.auto,
                size: viewContext.percentWidth * 40,
              ).box.makeCentered(),
              "${order.verificationCode}".text.medium.xl2.makeCentered().py4(),
              "Verification Code".tr().text.light.sm.makeCentered().py8(),
            ],
          ).p20(),
        );
      },
    );
  }

  void shareOrderDetails() async {
    Share.share(
        "%s is sharing an order code with you. Track order with this code: %s"
            .tr()
            .fill(
      [
        order.user.name,
        order.code,
      ],
    ));
  }

  openPaymentMethodSelection() async {
    //
    setBusyForObject(order.paymentStatus, true);
    await fetchPaymentOptions(vendorId: order.vendorId);
    setBusyForObject(order.paymentStatus, false);
    await
        //
        showModalBottomSheet(
      context: viewContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (contex) {
        return PaymentMethodsView(this)
            .p20()
            .scrollVertical()
            .box
            .color(contex.theme.colorScheme.background)
            .topRounded()
            .make();
      },
    );
  }

  changeSelectedPaymentMethod(
    PaymentMethod? paymentMethod, {
    bool callTotal = true,
  }) async {
    //
    Navigator.of(viewContext).pop();
    setBusyForObject(order.paymentStatus, true);
    try {
      //
      ApiResponse apiResponse = await orderRequest.updateOrderPaymentMethod(
        id: order.id,
        paymentMethodId: paymentMethod?.id,
        status: "pending",
      );

      //
      order = Order.fromJson(apiResponse.body["order"]);
      if (!["wallet", "cash"].contains(paymentMethod?.slug)) {
        if (paymentMethod?.slug == "offline") {
          openExternalWebpageLink(order.paymentLink);
        } else {
          openWebpageLink(order.paymentLink);
        }
      } else {
        toastSuccessful("${apiResponse.body['message']}");
      }

      //notify wallet view to update, just incase wallet was use for payment
      AppService().refreshWalletBalance.add(true);
    } catch (error) {
      toastError("$error");
    }
    setBusyForObject(order.paymentStatus, false);
  }

  /**
   * An event listener to start card entry flow
   */
  Future<void> onStartCardEntryFlow(viewContext) async {
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
      String nonce = result.nonce;
      final apiResponse = await checkoutRequest.makeOrderPayment(
          orderId: order.code, paymentSourceId: nonce);
      print(apiResponse.data);
      // payment finished successfully
      // you must call this method to close card entry
      // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
      //Reload order after payment
      initialise();
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
}
