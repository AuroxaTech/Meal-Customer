import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/cart.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/models/coupon.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/requests/cart.request.dart';
import 'package:mealknight/services/alert.service.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/cart.service.dart';
import 'package:mealknight/services/cart_ui.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/views/pages/checkout/multiple_order_checkout.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CartViewModel extends MyBaseViewModel {
  Order? order;
  CartRequest cartRequest = CartRequest();
  List<Cart> cartItems = [];
  int totalCartItems = 0;
  double subTotalPrice = 0.0;
  double orderTotalPrice = 0.0;
  double discountCartPrice = 0.0;
  double totalCartPrice = 0.0;
  double addonsPrice = 0.0;

  bool canApplyCoupon = false;
  Coupon? coupon;
  TextEditingController couponTEC = TextEditingController();

  CartViewModel(BuildContext context) {
    viewContext = context;
  }

  void initialise() async {
    cartItems = CartServices.productsInCart;
    calculateSubTotal();
  }

  calculateSubTotal() {
    totalCartItems = 0;
    subTotalPrice = 0;
    orderTotalPrice = 0;
    discountCartPrice = 0;
    addonsPrice = 0;

    for (var cartItem in cartItems) {
      totalCartItems += cartItem.product!.selectedQty;
      final totalProductPrice =
          cartItem.product!.price * cartItem.product!.selectedQty;
      final totalProductSellPrice =
          cartItem.product!.sellPrice * cartItem.product!.selectedQty;

      double totalAddonsPrice = 0;
      cartItem.options?.forEach((option) {
        totalAddonsPrice += option.price * cartItem.product!.selectedQty;
      });

      subTotalPrice += totalProductSellPrice;
      orderTotalPrice += totalProductPrice;

      addonsPrice += totalAddonsPrice;

      //discount/coupon
      final foundProduct = coupon?.products.firstOrNullWhere(
        (product) => cartItem.product?.id == product.id,
      );
      final foundVendor = coupon?.vendors.firstOrNullWhere(
        (vendor) => cartItem.product?.vendorId == vendor.id,
      );

      bool skipCalculation = false;

      if (foundProduct?.vendor.vendorType.id == coupon?.vendorTypeId) {
        skipCalculation = false;
      }
      //if vendor type match vendor type
      else if (foundVendor?.vendorType.id == coupon?.vendorTypeId) {
        skipCalculation = false;
      } else if (cartItem.product?.vendor.vendorTypeId ==
          coupon?.vendorTypeId) {
        skipCalculation = false;
      } else {
        skipCalculation = true;
        setErrorForObject(
          "coupon",
          "Coupon can't be used with vendor type".tr(),
        );
      }
      //free delivery coupon
      if (coupon?.for_delivery ?? false) {
        skipCalculation = true;
      }
      if (!skipCalculation && coupon != null) {
        if (foundProduct != null ||
            foundVendor != null ||
            (coupon!.products.isEmpty && coupon!.vendors.isEmpty)) {
          if (coupon?.percentage == 1) {
            discountCartPrice += (coupon!.discount / 100) * totalProductPrice;
          } else {
            discountCartPrice += coupon!.discount;
          }
        }
      }
    }
    //include addons to total and subtotal
    subTotalPrice += addonsPrice;
    orderTotalPrice += addonsPrice;

    //check if coupon is allow with the discount price
    if (coupon != null) {
      try {
        discountCartPrice = coupon!.validateDiscount(
          subTotalPrice,
          discountCartPrice,
        );
        clearErrors();
      } catch (error) {
        discountCartPrice = 0;
        setErrorForObject("coupon", error);
      }
    }
    //
    totalCartPrice = subTotalPrice - discountCartPrice;
    notifyListeners();
  }

  getUpdateItem(int index, int selectedQty) async {
    try {
      if (cartItems.isNotEmpty) {
        cartItems[index].selectedQty = selectedQty;
        cartItems[index].product!.selectedQty = selectedQty;
        notifyListeners();
        await CartServices.saveCartItems(cartItems);

        notifyListeners();
      }
    } catch (error) {
      CartServices.productsInCart = [];
    }
  }

  //
  deleteCartItem(int index) {
    //
    // AlertService.showConfirm()
    AlertService.showConfirm(
      title: "Remove From Cart".tr(),
      text: "Are you sure you want to remove this product from cart?".tr(),
      confirmBtnText: "Yes".tr(),
      onConfirm: () async {
        //
        //remove item/product from cart
        cartItems.removeAt(index);
        await CartServices.saveCartItems(cartItems);
        initialise();

        //close dialog
        //Navigator.of(viewContext).pop(true);
      },
    );
  }

  //
  updateCartItemQuantity(int qty, int index) async {
    final cart = cartItems[index];
    bool addedQty = qty > cart.selectedQty!;
    if (addedQty) {
      int qtyDiff = qty - cart.selectedQty!;
      final canAdd = await CartUIServices.cartItemQtyUpdated(
        viewContext,
        qtyDiff,
        cart,
      );
      if (!canAdd) {
        qty = cart.selectedQty ?? 1;
        pageKey = GlobalKey<State>();
        notifyListeners();
        return;
      }
    }

    cartItems[index].selectedQty = qty;
    await CartServices.saveCartItems(cartItems);
    initialise();
  }

  couponCodeChange(String code) {
    canApplyCoupon = code.isNotEmpty;
    notifyListeners();
  }

  applyCoupon() async {
    setBusyForObject("coupon", true);
    try {
      coupon = await cartRequest.fetchCoupon(couponTEC.text);
      if (coupon!.useLeft <= 0) {
        throw "Coupon use limit exceeded".tr();
      } else if (coupon!.expired) {
        throw "Coupon has expired".tr();
      }
      clearErrors();
      //re-calculate the cart price with coupon
      calculateSubTotal();
    } catch (error) {
      print("error ==> $error");
      setErrorForObject("coupon", error);
      coupon = null;
      calculateSubTotal();
    }
    setBusyForObject("coupon", false);
  }

  checkoutPressed() async {
    bool canOpenCheckout = true;
    if (cartItems.isNotEmpty) {
      if (!AuthServices.authenticated()) {
        final result =
            await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
        if (result == null || result == false) {
          canOpenCheckout = false;
        }
      }

      CheckOut checkOut = CheckOut();
      checkOut.coupon = coupon;
      checkOut.subTotal = subTotalPrice;
      checkOut.orderTotalPrice = orderTotalPrice;
      checkOut.discount = discountCartPrice;
      checkOut.total = totalCartPrice;
      checkOut.totalWithTip = totalCartPrice;
      checkOut.cartItems = cartItems;

      if (canOpenCheckout) {
        dynamic result;
        //check if multiple vendor order was added to cart
        if (AppStrings.enableMultipleVendorOrder &&
            CartServices.isMultipleOrder()) {
          result = await Navigator.push(
              viewContext,
              MaterialPageRoute(
                  builder: (context) =>
                      MultipleOrderCheckoutPage(checkout: checkOut)));
        } else {
          result = await Navigator.of(viewContext).pushNamed(
            AppRoutes.checkoutRoute,
            arguments: checkOut,
          );
          //

          /*  result = Navigator.of(viewContext).pushNamed(
          AppRoutes.orderTrackingRoute,
          arguments: order ?? Order(id: 0, createdAt: DateTime.now(), updatedAt: DateTime.now(), formattedDate: "", user: User(email: "",name: "",photo: "",id: 1,phone: "",role: "",walletAddress: "", countryCode: '')),
        );*/
        }

        if (result != null && result) {
          //
          await CartServices.saveCartItems([]);
          Navigator.of(viewContext).pop(true);
        }
      }
    }
  }
}
