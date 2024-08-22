
import 'product.dart';
import 'vendor_type.dart';

class Category {
  int id;
  dynamic categoryId;
  String name;
  String? photo;
  List<Product> products;
  List<Category> subcategories;
  VendorType? vendorType;
  String? color;
  bool hasSubcategories;

  Category({
    required this.id,
    this.categoryId,
    required this.name,
    this.photo,
    this.products = const [],
    this.subcategories = const [],
    this.vendorType,
    this.color = "#eeeeee",
    this.hasSubcategories = false,
  });

  factory Category.fromJson(dynamic jsonObject) {
    final category = Category(
      id: jsonObject["id"],
      categoryId: jsonObject["category_id"],
      name: jsonObject["name"],
      photo: jsonObject["photo"],
      color: jsonObject["color"],
    );
    category.hasSubcategories = jsonObject["has_subcategories"] != null
        ? (jsonObject["has_subcategories"] as bool)
        : false;
    category.products = jsonObject["products"] == null
        ? []
        : List<Product>.from(
            jsonObject["products"].map(
              (x) => Product.fromJson(x),
            ),
          );
    category.subcategories = jsonObject["sub_categories"] == null
        ? []
        : List<Category>.from(
            jsonObject["sub_categories"].map(
              (x) => Category.fromJson(x),
            ),
          );
    category.vendorType = jsonObject["vendor_type"] == null
        ? null
        : VendorType.fromJson(
            jsonObject["vendor_type"],
          );

    return category;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "color": color,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "subcategories":
            List<dynamic>.from(subcategories.map((x) => x.toJson())),
        "has_subcategories": hasSubcategories,
      };
}
