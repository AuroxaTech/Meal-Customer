import 'dart:convert';

import 'package:mealknight/extensions/dynamic.dart';

import 'category.dart';
import 'delivery_address.dart';
import 'delivery_slot.dart';
import 'fee.dart';
import 'menu.dart';
import 'package_type_pricing.dart';
import 'vendor_type.dart';

class Vendor {
  Vendor({
    required this.id,
    required this.vendorTypeId,
    required this.vendorType,
    required this.name,
    required this.description,
    required this.baseDeliveryFee,
    required this.deliveryFee,
    required this.deliveryRange,
    required this.tax,
    required this.phone,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.comission,
    required this.pickup,
    required this.delivery,
    required this.rating,
    required this.reviewsCount,
    required this.chargePerKm,
    required this.isOpen,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedDate,
    required this.logo,
    required this.featureImage,
    required this.menus,
    required this.categories,
    required this.packageTypesPricing,
    required this.fees,
    required this.cities,
    required this.states,
    required this.countries,
    required this.deliverySlots,
    required this.canRate,
    required this.allowScheduleOrder,
    required this.hasSubcategories,
    required this.minOrder,
    required this.maxOrder,
    required this.prepareTime,
    required this.deliveryTime,
    required this.minPrepareTime,
    required this.maxPrepareTime,
    required this.isFavorite,
    this.heroTag,
    this.distance = 0,
    this.travelTime = 0,
  }) {
    heroTag ??= "${dynamic.randomAlphaNumeric(25)}$id";
  }

  int id;
  int vendorTypeId;
  VendorType vendorType;
  String? heroTag;
  String name;
  String description;
  double baseDeliveryFee;
  double deliveryFee;
  double deliveryRange;

  //double? distance;
  String tax;
  String phone;
  String email;
  String address;
  String latitude;
  String longitude;
  double? comission;
  double? minOrder;
  double? maxOrder;
  int pickup;
  int delivery;
  int rating;
  int reviewsCount;
  int chargePerKm;
  bool isOpen;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedDate;
  String logo;
  String featureImage;
  List<Menu> menus;
  List<Category> categories;
  List<PackageTypePricing> packageTypesPricing;
  List<DeliverySlot> deliverySlots;
  List<Fee> fees;
  List<String> cities;
  List<String> states;
  List<String> countries;
  bool canRate;
  bool allowScheduleOrder;
  bool hasSubcategories;
  String? prepareTime;
  String? deliveryTime;
  int minPrepareTime;
  int maxPrepareTime;
  bool isFavorite;
  double distance = 0;
  int travelTime = 0;

  factory Vendor.fromRawJson(String str) => Vendor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vendor.fromJson(Map<String, dynamic> json) {
    Vendor vendor = Vendor(
      id: json["id"],
      vendorTypeId: json["vendor_type_id"],
      vendorType: VendorType.fromJson(json["vendor_type"]),
      name: json["name"],
      description: json["description"] ?? "",
      baseDeliveryFee: json["base_delivery_fee"] == null
          ? 0.00
          : double.parse(json["base_delivery_fee"].toString()),
      deliveryFee: json["delivery_fee"] == null
          ? 0.00
          : double.parse(json["delivery_fee"].toString()),
      deliveryRange: json["delivery_range"] == null
          ? 0
          : double.parse(json["delivery_range"].toString()),
      //distance: double.tryParse(json["distance"].toString()),
      tax: json["tax"],
      phone: json["phone"],
      email: json["email"],
      address: json["address"] ?? "",
      latitude: json["latitude"] ?? "0.00",
      longitude: json["longitude"] ?? "0.00",
      comission: json["comission"] == null
          ? 0
          : double.parse(json["comission"].toString()),
      pickup: json["pickup"] == null ? 0 : int.parse(json["pickup"].toString()),
      delivery:
          json["delivery"] == null ? 0 : int.parse(json["delivery"].toString()),
      rating: json["rating"] == null ? 5 : int.parse(json["rating"].toString()),
      reviewsCount: json["reviews_count"],
      chargePerKm: json["charge_per_km"] == null
          ? 0
          : int.parse(json["charge_per_km"].toString()),
      isOpen: json["is_open"] ?? true,
      isActive: json["is_active"] == null
          ? 0
          : int.parse(json["is_active"].toString()),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      formattedDate: json["formatted_date"],
      logo: json["logo"],
      featureImage: json["feature_image"],
      menus: json["menus"] == null
          ? []
          : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
              json["categories"].map((x) => Category.fromJson(x))),
      packageTypesPricing: json["package_types_pricing"] == null
          ? []
          : List<PackageTypePricing>.from(json["package_types_pricing"]
              .map((x) => PackageTypePricing.fromJson(x))),
      //cities
      cities: json["cities"] == null
          ? []
          : List<String>.from(json["cities"].map((e) => e["name"])),
      states: json["states"] == null
          ? []
          : List<String>.from(json["states"].map((e) => e["name"])),
      countries: json["cities"] == null
          ? []
          : List<String>.from(json["countries"].map((e) => e["name"])),
      //
      deliverySlots: json["slots"] == null
          ? []
          : List<DeliverySlot>.from(
              json["slots"].map((x) => DeliverySlot.fromJson(x))),
      fees: json["fees"] == null
          ? []
          : List<Fee>.from(json["fees"].map((x) => Fee.fromJson(x))),

      //
      canRate: json["can_rate"],
      hasSubcategories: json["has_sub_categories"] ?? false,
      allowScheduleOrder: json["allow_schedule_order"] ?? false,

      minOrder:
          (json["min_order"] == null || json["min_order"].toString().isEmpty)
              ? null
              : (double.parse(json["min_order"].toString())),
      maxOrder:
          (json["max_order"] == null || json["max_order"].toString().isEmpty)
              ? null
              : (double.parse(json["max_order"].toString())),
      //
      prepareTime:
          json["min_prepare_time"] != null && json["max_prepare_time"] != null
              ? "${json["min_prepare_time"]}-${json["max_prepare_time"]}"
              : json['prepare_time'] != null
                  ? json['prepare_time'].toString()
                  : "20-30",
      deliveryTime: json["delivery_time"] != null
          ? json["delivery_time"].toString()
          : "30",
      minPrepareTime: int.parse((json["min_prepare_time"] ?? "20").toString()),
      maxPrepareTime: int.parse((json["max_prepare_time"] ?? "30").toString()),
      isFavorite: json['is_favourite'] != null && json['is_favourite'] is bool
          ? json['is_favourite']
          : false,
    );

    return vendor;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_type_id": vendorTypeId,
        "vendor_type": vendorType.toJson(),
        "name": name,
        "description": description,
        "base_delivery_fee": baseDeliveryFee,
        "delivery_fee": deliveryFee,
        "delivery_range": deliveryRange,
        "tax": tax,
        "phone": phone,
        "email": email,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "comission": comission,
        "min_order": minOrder,
        "max_order": maxOrder,
        "pickup": pickup,
        "delivery": delivery,
        "rating": rating,
        "reviews_count": reviewsCount,
        "charge_per_km": chargePerKm,
        "is_open": isOpen,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "logo": logo,
        "feature_image": featureImage,
        "can_rate": canRate,
        "allow_schedule_order": allowScheduleOrder,
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "package_types_pricing":
            List<dynamic>.from(packageTypesPricing.map((x) => x.toJson())),
        "slots": List<dynamic>.from(deliverySlots.map((x) => x.toJson())),
        "fees": List<dynamic>.from(fees.map((x) => x.toJson())),
        //
        "prepare_time": prepareTime,
        "delivery_time": deliveryTime,
        "min_prepare_time": minPrepareTime,
        "max_prepare_time": maxPrepareTime,
        "is_favourite": isFavorite,
      };

  //
  bool get allowOnlyDelivery => delivery == 1 && pickup == 0;

  bool get allowOnlyPickup => delivery == 0 && pickup == 1;

  bool get isServiceType => vendorType.slug == "service";

  bool get isPharmacyType => vendorType.slug == "pharmacy";

  //
  bool canServiceLocation(DeliveryAddress deliveryaddress) {
    String findCountry = "${deliveryaddress.country}".toLowerCase();
    String findState = "${deliveryaddress.state}".toLowerCase();
    String findCity = "${deliveryaddress.city}".toLowerCase();
    //cities,states & countries
    if (countries.isNotEmpty) {
      final foundCountry = countries.firstWhere(
        (element) => element.toLowerCase() == findCountry,
        orElse: () => "",
      );

      //
      if (foundCountry != findCountry) {
        print("Country found");
        return true;
      }
    }

    //states
    if (states.isNotEmpty) {
      final foundState = states.firstWhere(
        (element) =>
            element.toLowerCase() == "${deliveryaddress.state}".toLowerCase(),
        orElse: () => "",
      );

      //
      if (foundState != findState) {
        print("state found");
        return true;
      }
    }

    //cities
    if (cities.isNotEmpty) {
      final foundCity = cities.firstWhere(
        (element) {
          return element.toLowerCase() == findCity;
        },
        orElse: () => "",
      );

      //
      if (foundCity != findCity) {
        print("city found");
        return true;
      }
    }
    return false;
  }

  Vendor copy() {
    return Vendor(
      id: id,
      vendorTypeId: vendorTypeId,
      vendorType: vendorType,
      heroTag: heroTag,
      name: name,
      description: description,
      baseDeliveryFee: baseDeliveryFee,
      deliveryFee: deliveryFee,
      deliveryRange: deliveryRange,
      tax: tax,
      phone: phone,
      email: email,
      address: address,
      latitude: latitude,
      longitude: longitude,
      comission: comission,
      minOrder: minOrder,
      maxOrder: maxOrder,
      pickup: pickup,
      delivery: delivery,
      rating: rating,
      reviewsCount: reviewsCount,
      chargePerKm: chargePerKm,
      isOpen: isOpen,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      formattedDate: formattedDate,
      logo: logo,
      featureImage: featureImage,
      menus: menus,
      categories: categories,
      packageTypesPricing: packageTypesPricing,
      deliverySlots: deliverySlots,
      fees: fees,
      cities: cities,
      states: states,
      countries: countries,
      canRate: canRate,
      allowScheduleOrder: allowScheduleOrder,
      hasSubcategories: hasSubcategories,
      prepareTime: prepareTime,
      deliveryTime: deliveryTime,
      minPrepareTime: minPrepareTime,
      maxPrepareTime: maxPrepareTime,
      isFavorite: isFavorite,
      distance: distance,
      travelTime: travelTime,
    );
  }
}
