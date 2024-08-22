class BillingAddress {
  String addressLine1;
  String addressLine2;
  String locality;
  String administrativeDistrictLevel1;
  String postalCode;
  String country;

  BillingAddress(
      {required this.addressLine1,
      required this.addressLine2,
      required this.locality,
      required this.administrativeDistrictLevel1,
      required this.postalCode,
      required this.country});

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
        addressLine1: json["address_line_1"] ?? "",
        addressLine2: json["address_line_2"] ?? "",
        locality: json["locality"] ?? "",
        administrativeDistrictLevel1:
            json["administrative_district_level_1"] ?? "",
        postalCode: json["postal_code"] ?? "",
        country: json["country"] ?? "",
      );
}
