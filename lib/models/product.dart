import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:dartx/dartx.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/models/digital_file.dart';
import 'package:mealknight/models/option.dart';
import 'package:mealknight/models/option_group.dart';
import 'package:mealknight/models/tag.dart';
import 'package:mealknight/models/vendor.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.name,
    this.barcode,
    required this.description,
    required this.price,
    this.sellPriceNew,
    required this.discountPrice,
    this.capacity,
    this.unit,
    this.packageCount,
    required this.featured,
    required this.plusOption,
    required this.isFavourite,
    required this.deliverable,
    required this.digital,
    required this.digitalFiles,
    required this.isActive,
    required this.vendorId,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedDate,
    required this.photo,
    required this.vendor,
    required this.optionGroups,
    required this.availableQty,
    this.selectedQty = 0,
    required this.photos,
    required this.rating,
    required this.reviewsCount,
    this.ageRestricted = false,
    this.tags,
  }) {
    heroTag = "${dynamic.randomAlphaNumeric(15)}$id";
  }

  int id;
  String? heroTag;
  String name;
  String? barcode;
  String description;
  double price;
  double? sellPriceNew;
  double discountPrice;
  String? capacity;
  String? unit;
  String? packageCount;
  int featured;
  int plusOption;
  bool isFavourite;
  int deliverable;
  int digital;
  int isActive;
  int vendorId;
  int? categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedDate;
  String photo;
  Vendor vendor;
  List<OptionGroup> optionGroups = [];
  List<String> photos;
  List<Option>? selectedOptions = [];
  List<DigitalFile>? digitalFiles = [];
  List<Tag>? tags = [];

  int? availableQty;
  int selectedQty = 0;

  double? rating;
  int reviewsCount;
  bool ageRestricted;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      barcode: json["barcode"],
      description: HtmlUnescape().convert(json["description"] ?? ""),
      price: double.parse(json["price"].toString()),
      discountPrice: json["discount_price"] == null
          ? 0.00
          : double.parse(json["discount_price"].toString()),
      capacity: json["capacity"]?.toString(),
      unit: json["unit"],
      packageCount: json["package_count"]?.toString(),
      featured:
          json["featured"] == null ? 0 : int.parse(json["featured"].toString()),
      plusOption: json["plus_option"] == null
          ? 0
          : int.parse(json["plus_option"].toString()),
      isFavourite: json["is_favourite"],
      deliverable: json["deliverable"] == null
          ? 0
          : int.parse(json["deliverable"].toString()),
      digital:
          json["digital"] == null ? 0 : int.parse(json["digital"].toString()),
      isActive: json["is_active"] == null
          ? 0
          : int.parse(json["is_active"].toString()),
      vendorId: int.parse(json["vendor_id"].toString()),
      categoryId: json["category_id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      formattedDate: json["formatted_date"],
      photo: json["photo"],
      vendor: Vendor.fromJson(json["vendor"]),
      optionGroups: json["option_groups"] == null
          ? []
          : List<OptionGroup>.from(
              json["option_groups"].map((x) => OptionGroup.fromJson(x)),
            ),
      digitalFiles: json["digital_files"] == null
          ? null
          : List<DigitalFile>.from(
              json["digital_files"].map((x) => DigitalFile.fromJson(x)),
            ),

      // photos
      photos: json["photos"] == null
          ? []
          : List<String>.from(
              json["photos"].map((x) => x),
            ),
      //
      availableQty: json["available_qty"] == null
          ? null
          : int.parse(json["available_qty"].toString()),
      selectedQty: json["selected_qty"] == null
          ? 0
          : int.parse(json["selected_qty"].toString()),
      //
      rating: json["rating"] == null
          ? null
          : double.parse(json["rating"].toString()),
      reviewsCount: json["reviews_count"] == null
          ? 0
          : int.parse(json["reviews_count"].toString()),
      ageRestricted: json["age_restricted"] ?? false,
      tags: json["tags"] == null
          ? []
          : List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "description": description,
        "price": price,
        "discount_price": discountPrice,
        "capacity": capacity,
        "unit": unit,
        "package_count": packageCount,
        "featured": featured,
        "is_favourite": isFavourite,
        "deliverable": deliverable,
        "digital": digital,
        "is_active": isActive,
        "vendor_id": vendorId,
        "category_id": categoryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "photo": photo,
        "vendor": vendor.toJson(),
        "option_groups":
            List<dynamic>.from(optionGroups.map((x) => x.toJson())),
        "digital_files": digitalFiles == null
            ? null
            : List<dynamic>.from(digitalFiles!.map((x) => x.toJson())),
        "available_qty": availableQty,
        "selected_qty": selectedQty,
        "rating": rating,
        "reviews_count": reviewsCount,
        "age_restricted": ageRestricted,
        "tags": tags == null
            ? null
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
      };

  //getters
  get showDiscount => (discountPrice > 0.00) && (discountPrice < price);

  get canBeDelivered => deliverable == 1;

  bool get hasStock => availableQty == null || availableQty! > 0;

  double get sellPrice {
    return showDiscount ? discountPrice : price;
  }

  double get totalPrice {
    return sellPrice * (selectedQty);
  }

  bool get isDigital {
    return digital == 1;
  }

  int get discountPercentage {
    if (discountPrice < price) {
      // return 100 - (100 * ((price - discountPrice) / price) ?? 0).floor();
      try {
        return 100 - (100 * (discountPrice / price)).floor();
      } catch (e) {
        return 0;
      }
    } else {
      return 0;
    }
  }

  bool optionGroupRequirementCheck() {
    if (optionGroups.isEmpty) {
      return false;
    }
    //check if the option groups with required setting has an option selected
    OptionGroup? optionGroupRequired =
        optionGroups.firstOrNullWhere((e) => e.required == 1);

    if (optionGroupRequired == null || (optionGroups.length <= 1)) {
      return false;
    } else {
      return true;
    }
  }
}
