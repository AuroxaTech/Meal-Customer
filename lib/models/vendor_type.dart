import 'dart:convert';

VendorType vendorTypeFromJson(String str) =>
    VendorType.fromJson(json.decode(str));

String vendorTypeToJson(VendorType data) => json.encode(data.toJson());

class VendorType {
  VendorType({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
    this.slug,
    this.isActive,
    this.inOrder,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.formattedDate,
    required this.logo,
    this.websiteHeader,
    required this.hasBanners,
  });

  int id;
  String name;
  String color;
  String description;
  String? slug;
  int? isActive;
  int? inOrder;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? formattedDate;
  String logo;
  String? websiteHeader;
  bool hasBanners;

  factory VendorType.fromJson(Map<String, dynamic> json) => VendorType(
    id: json["id"] ?? -1,
    name: json["name"] ?? "",
    color: json["color"] ?? "#ffffff",
    description: json["description"] ?? "",
    slug: json["slug"],
    isActive: json["is_active"],
    inOrder: json["in_order"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    formattedDate: json["formatted_date"],
    logo: json["logo"] ?? "",
    websiteHeader: json["website_header"],
    hasBanners: json["has_banners"] == 1,
      );

  bool get isProduct {
    return ["food", "grocery", "commerce", "e-commerce"]
        .contains(slug?.toLowerCase());
  }

  bool get isService => ["service", "services"].contains(slug?.toLowerCase());
  bool get isBooking => ["booking", "bookings"].contains(slug?.toLowerCase());

  bool get isGrocery => slug == "grocery";

  bool get isFood => slug == "food";

  bool get isCommerce =>
      ["commerce", "e-commerce"].contains(slug?.toLowerCase());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "slug": slug,
        "is_active": isActive,
        "logo": logo,
        "has_banners": hasBanners ? 1 : 0,
      };

  //
  bool get authRequired {
    return ["taxi", "parcel", "package"].contains(slug);
  }
}
