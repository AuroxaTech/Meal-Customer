import 'package:mealknight/models/product.dart';

class OrderProduct {
  OrderProduct({
    required this.id,
    required this.quantity,
    required this.heatLevel,
    required this.price,
    required this.discountPrice,
    this.options,
    required this.orderId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedDate,
    required this.product,
    required this.reviewed,
    this.isSelected = false,
  });

  int id;
  int quantity;
  int heatLevel;
  double price;
  double discountPrice;
  String? options;
  int orderId;
  int productId;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedDate;
  Product? product;
  bool reviewed;
  bool isSelected;

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        id: json["id"],
        reviewed: json["reviewed"] ?? false,
        quantity: json["quantity"] == null
            ? 1
            : int.parse(json["quantity"].toString()),
        heatLevel: json["heat_level"] ?? 0,
        price: double.parse(json["price"].toString()),
        discountPrice: json["discount_price"] == null
            ? 0.00
            : double.parse(json["discount_price"].toString()),
        options: json["options"],
        orderId: int.parse(json["order_id"].toString()),
        productId: int.parse(json["product_id"].toString()),
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["updated_at"]),
        formattedDate: json["formatted_date"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reviewed": reviewed,
        "quantity": quantity,
        "heat_level": heatLevel,
        "price": price,
        "discount_price": discountPrice,
        "options": options,
        "order_id": orderId,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "product": product?.toJson(),
      };

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

  OrderProduct copy() {
    return OrderProduct(
        id: id,
        quantity: quantity,
        heatLevel: heatLevel,
        price: price,
        discountPrice: discountPrice,
        orderId: orderId,
        productId: productId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        formattedDate: formattedDate,
        product: product,
        reviewed: reviewed,
        options: options);
  }
}
