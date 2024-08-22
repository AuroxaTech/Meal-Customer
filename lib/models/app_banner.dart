import 'dart:convert';

import 'category.dart';

AppBanner appBannerFromJson(String str) => AppBanner.fromJson(json.decode(str));

String appBannerToJson(AppBanner data) => json.encode(data.toJson());

class AppBanner {
  int? id;
  Category? category;
  String? photo;
  dynamic vendor;
  String? link;

  AppBanner({
    this.id,
    this.category,
    this.photo,
    this.vendor,
    this.link,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) => AppBanner(
        id: json["id"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        photo: json["photo"],
        vendor: json["vendor"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category?.toJson(),
        "photo": photo,
        "vendor": vendor,
        "link": link,
      };
}
