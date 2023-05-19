// To parse this JSON data, do
//
//     final CarDetail = CarDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class CarDetail {
  CarDetail({
    required this.id,
    required this.createdAt,
    required this.carModel,
    required this.carName,
    required this.numberPlate,
    required this.cnic,
  });

  String id;
  DateTime createdAt;
  dynamic carModel;
  String carName;
  String numberPlate;
  String cnic;

  factory CarDetail.fromRawJson(String str) => CarDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CarDetail.fromJson(Map<String, dynamic> json) => CarDetail(
    id: json["id"].toString(),
    createdAt: DateTime.parse(json["created_at"].toString()),
    carModel: json["car_model"].toString(),
    carName: json["car_name"].toString(),
    numberPlate: json["number_plate"].toString(),
    cnic: json["cnic"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "car_model": carModel,
    "car_name": carName,
    "number_plate": numberPlate,
    "cnic": cnic,
  };
}
