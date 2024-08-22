import 'dart:convert';

ProductReviewStat productReviewStatFromJson(String str) =>
    ProductReviewStat.fromJson(json.decode(str));

String productReviewStatToJson(ProductReviewStat data) =>
    json.encode(data.toJson());

class ProductReviewStat {
  ProductReviewStat({
    required this.count,
    required this.percentage,
    required this.rate,
  });

  int count;
  double percentage;
  double rate;

  factory ProductReviewStat.fromJson(Map<String, dynamic> json) =>
      ProductReviewStat(
        count: json["count"],
        percentage: double.tryParse(json["percentage"].toString()) ?? 0.0,
        rate: double.tryParse(json["rate"].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "percentage": percentage,
        "rate": rate,
      };
}
