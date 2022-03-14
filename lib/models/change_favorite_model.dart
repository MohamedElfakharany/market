// To parse this JSON data, do
//
//     final changeFavoritesModel = changeFavoritesModelFromJson(jsonString);

import 'dart:convert';

ChangeFavoritesModel changeFavoritesModelFromJson(String str) => ChangeFavoritesModel.fromJson(json.decode(str));

String changeFavoritesModelToJson(ChangeFavoritesModel data) => json.encode(data.toJson());

class ChangeFavoritesModel {
  ChangeFavoritesModel({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory ChangeFavoritesModel.fromJson(Map<String, dynamic> json) => ChangeFavoritesModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
