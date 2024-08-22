import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

DeliveryAddress deliveryAddressFromJson(String str) =>
    DeliveryAddress.fromJson(json.decode(str));

String deliveryAddressToJson(DeliveryAddress data) =>
    json.encode(data.toJson());

class DeliveryAddress {
  DeliveryAddress(
      {this.id,
      this.name,
      this.description,
      this.city,
      this.state,
      this.country,
      this.address = "Current Location",
      this.latitude,
      this.longitude,
      this.isDefault,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.formattedDate,
      this.photo,
      this.distance,
      this.canDeliver,
      this.leaveAt,
      this.doorSide,
      this.addressType,
      this.buzzerNo,
      this.apartmentNo});

  int? id;
  String? name;
  String? apartmentNo;
  String? buzzerNo;
  String? description;
  String? address;
  String? city;
  String? state;
  String? country;
  double? latitude;
  double? longitude;
  int? isDefault;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? formattedDate;
  String? photo;
  double? distance;
  bool? canDeliver;
  String? leaveAt;
  String? doorSide;
  String? addressType;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
          id: json["id"],
          name: json["name"],
          description: json["description"] ?? "",
          address: json["address"],
          city: json["city"],
          state: json["state"],
          country: json["country"],
          latitude: double.parse(json["latitude"].toString()),
          longitude: double.parse(json["longitude"].toString()),
          distance: json["distance"] == null
              ? null
              : double.parse(json["distance"].toString()),
          isDefault: int.parse(json["is_default"].toString()),
          userId: int.parse(json["user_id"].toString()),
          createdAt: DateTime.parse(json["created_at"]),
          updatedAt: DateTime.parse(json["updated_at"]),
          formattedDate: json["formatted_date"],
          photo: json["photo"],
          canDeliver: json["can_deliver"],
          leaveAt: json["leave_at_door"],
          //leaveAt: json["leave_at_door"] == null ? '' : json["leave_at_door"] == 0 ? 'Hand it to me directly' : 'Leave at door' ,
          doorSide: json["door_side"],
          addressType: json["address_type"],
          apartmentNo: json['apartment_no'],
          buzzerNo: json['buzzer_no']);

//'Hand it to me directly',
//     'Leave at door',

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "state": state,
        "country": country,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "is_default": isDefault,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "formatted_date": formattedDate,
        "photo": photo,
        "can_deliver": canDeliver,
        "leave_at_door": leaveAt,
        "door_side": doorSide,
        "address_type": addressType
      };

  //
  Map<String, dynamic> toSaveJson() => {
        "name": name,
        "description": description,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "is_default": isDefault,
        "can_deliver": canDeliver,
        "leave_at_door": leaveAt,
        "door_side": doorSide,
        "address_type": addressType,
        'apartment_no': apartmentNo,
        'buzzer_no': buzzerNo
      };

  bool get defaultDeliveryAddress => isDefault == 1;

  LatLng get latLng => LatLng(latitude ?? 0.0, longitude ?? 0.0);

  DeliveryAddress copyWith({
    String? name,
    String? description,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
  }) {
    return new DeliveryAddress(
        id: this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        isDefault: this.isDefault,
        userId: this.userId,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
        formattedDate: this.formattedDate,
        photo: this.photo,
        distance: this.distance,
        canDeliver: this.canDeliver,
        addressType: this.addressType,
        apartmentNo: this.apartmentNo,
        doorSide: this.doorSide);
  }
}
