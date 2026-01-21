import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Filter/FilterAttributeElement.dart';

import '../Filter/FilterColor.dart';

SingleCategory singleCategoryFromJson(String str) =>
    SingleCategory.fromJson(json.decode(str));

String singleCategoryToJson(SingleCategory data) => json.encode(data.toJson());

class SingleCategory {
  SingleCategory({
    this.data,
    this.attributes,
    this.color,
    this.brands,
    this.lowestPrice,
    this.heightPrice,
  });

  CategoryData? data;
  List<FilterAttributeElement>? attributes;
  FilterColor? color;
  List<BrandData>? brands;
  num? lowestPrice;
  num? heightPrice;

  factory SingleCategory.fromJson(Map<String, dynamic> json){

    try {
      return SingleCategory(
        data: CategoryData.fromJson(json["data"]),
        attributes: json["attributes"] == null ? null : List<FilterAttributeElement>.from(json["attributes"].map((x) => FilterAttributeElement.fromJson(x))),
        color: json["color"] == null ? null : FilterColor.fromJson(json["color"]),
        brands: json["brands"] == null ? null : List<BrandData>.from(json["brands"].map((x) => BrandData.fromJson(x))),
        lowestPrice: num.tryParse("${json["lowest_price"]}")??0,
        heightPrice: num.tryParse("${json["height_price"]}")??0,
      );
    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");
      return SingleCategory();
    }
  }

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "attributes": List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "color": color?.toJson(),
        "categories": List<dynamic>.from(brands!.map((x) => x.toJson())),
        "lowest_price": lowestPrice,
        "height_price": heightPrice,
      };
}