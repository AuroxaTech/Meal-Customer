import 'dart:io';

import 'package:mealknight/models/cart.dart';
import 'package:mealknight/models/coupon.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/models/payment_method.dart';

class CheckOut {
  double subTotal;
  double discount;
  double orderTotalPrice;
  double deliveryFee;
  double tax;
  double total;
  double totalWithTip;
  String? pickupTime;
  String? pickupDate;
  bool? isScheduled;
  DeliveryAddress? deliveryAddress;
  String deliverySlotDate;
  String deliverySlotTime;
  PaymentMethod? paymentMethod;
  List<Cart>? cartItems;
  File? photo;
  Coupon? coupon;
  String? token;
  double distance;
  int travelTime;

  //
  CheckOut({
    this.subTotal = 0.00,
    this.discount = 0.00,
    this.orderTotalPrice = 0.00,
    this.deliveryFee = 0.00,
    this.tax = 0.00,
    this.total = 0.00,
    this.totalWithTip = 0.00,
    this.distance = 0.00,
    this.travelTime = 0,
    this.deliveryAddress,
    this.isScheduled,
    this.pickupDate,
    this.pickupTime,
    this.paymentMethod,
    this.cartItems,
    this.deliverySlotDate = "",
    this.deliverySlotTime = "",
    this.photo,
    this.coupon,
    this.token,
  });

  //
  double get flexTotal {
    return ((subTotal + deliveryFee) - discount) + tax;
  }
}
