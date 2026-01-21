// To parse this JSON data, do
//
//     final brand = brandFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'BrandData.dart';

BrandsMain brandFromJson(String str) => BrandsMain.fromJson(json.decode(str));

String brandToJson(BrandsMain data) => json.encode(data.toJson());

class BrandsMain {
  BrandsMain({
    this.data,
  });

  List<BrandData>? data;

  factory BrandsMain.fromJson(Map<String, dynamic> json){

    try {
      return BrandsMain(
        data: List<BrandData>.from(
            json["data"].map((x) => BrandData.fromJson(x))),
      );
    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");

      return BrandsMain(data: []);
    }
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
