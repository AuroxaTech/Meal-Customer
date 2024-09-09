import 'billing_address.dart';

class PaymentCard {
  String id;
  String cardBrand;
  String last4;
  int expMonth;
  int expYear;
  String cardholderName;
  BillingAddress? billingAddress;
  String fingerprint;
  String customerId;
  String merchantId;
  String referenceId;
  bool enabled;
  String cardType;
  String prepaidType;
  String bin;
  String createdAt;
  int version;

  PaymentCard({
    required this.id,
    required this.cardBrand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.cardholderName,
    this.billingAddress,
    required this.fingerprint,
    required this.customerId,
    required this.merchantId,
    required this.referenceId,
    required this.enabled,
    required this.cardType,
    required this.prepaidType,
    required this.bin,
    required this.createdAt,
    required this.version,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    print("Payment Cards ====> ${json.toString()}");
    return PaymentCard(
      id: json["id"],
      cardBrand: json["card_brand"] ?? "",
      last4: json["last_4"] ?? "",
      expMonth: json["exp_month"] ?? 0,
      expYear: json["exp_year"] ?? 0,
      cardholderName: json["cardholder_name"] ?? "",
      billingAddress: json["billing_address"] == null
          ? null
          : BillingAddress.fromJson(json["billing_address"]),
      fingerprint: json["fingerprint"] ?? "",
      customerId: json["customer_id"] ?? "",
      merchantId: json["merchant_id"] ?? "",
      referenceId: json["reference_id"] ?? "",
      enabled: json["enabled"] ?? false,
      cardType: json["card_type"] ?? "",
      prepaidType: json["prepaid_type"] ?? "",
      bin: json["bin"] ?? "",
      createdAt: json["created_at"] ?? "",
      version: json["version"] ?? 0,
    );
  }
}
