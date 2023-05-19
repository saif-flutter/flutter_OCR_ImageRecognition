
import 'dart:convert';

class CnicModel {
  CnicModel({
    required this.cnic,
    required this.carNumberPlate,
  });

  String cnic;
  String carNumberPlate;

  factory CnicModel.fromRawJson(String str) => CnicModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CnicModel.fromJson(Map<String, dynamic> json) => CnicModel(
    cnic: json["cnic"],
    carNumberPlate: json["carNumberPlate"],
  );

  Map<String, dynamic> toJson() => {
    "cnic": cnic,
    "carNumberPlate": carNumberPlate,
  };
}
