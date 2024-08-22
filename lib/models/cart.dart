import 'dart:convert';
import 'package:mealknight/models/option.dart';
import 'package:mealknight/models/product.dart';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    this.price,
    this.product,
    this.options,
    this.optionsIds,
    this.selectedQty,
    this.heatLevel,
  });

  //
  int? selectedQty;
  int? heatLevel;
  double? price;
  Product? product;
  List<Option>? options;
  List<int>? optionsIds;

  //

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      selectedQty: json["selected_qty"] ?? 1,
      heatLevel: json["heat_level"] ?? -1,
      price:
          json["price"] == null ? 0.00 : double.parse(json["price"].toString()),
      product: Product.fromJson(json["product"]),
      options: json["options"] == null
          ? null
          : List<Option>.from(
              json["options"].map((x) => Option.fromJson(x)),
            ),
      optionsIds: json["options_ids"] == null
          ? null
          : List<int>.from(json["options_ids"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "selected_qty": selectedQty,
        "heat_level": heatLevel,
        "price": (product?.price ?? 0) * (selectedQty ?? 0),
        "discount_price": (product?.discountPrice ?? 0) * (selectedQty ?? 0),
        "product": product?.toJson(),
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "options_ids": optionsIds,
        "options_flatten": optionsSentence,
      };

  //
  String get optionsSentence {
    var optionsSelected = "";
    final optionsLength = options?.length ?? 0;
    options?.asMap().forEach((index, option) {
      optionsSelected += option.name;
      if (optionsLength > (index) + 1) {
        optionsSelected += ", ";
      }
    });
    return optionsSelected;
  }

  String heatLevelInfo() {
    if (heatLevel == 0) {
      return "Mild";
    } else if (heatLevel == 1) {
      return "Medium";
    } else if (heatLevel == 2) {
      return "Hot";
    }
    return "";
  }
}
