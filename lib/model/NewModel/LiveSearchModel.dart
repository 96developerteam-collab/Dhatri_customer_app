// To parse this JSON data, do
//
//     final liveSearchModel = liveSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Tags/TagData.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

LiveSearchModel liveSearchModelFromJson(String str) =>
    LiveSearchModel.fromJson(json.decode(str));

String liveSearchModelToJson(LiveSearchModel data) =>
    json.encode(data.toJson());

class LiveSearchModel {
  LiveSearchModel({
    this.tags,
    this.products,
    this.categories,
  });

  List<TagData>? tags;
  List<ProductModel>? products;
  List<CategoryData>? categories;

  factory LiveSearchModel.fromJson(Map<String, dynamic> json) =>
      LiveSearchModel(
        tags: json["tags"] != null && json["tags"].isNotEmpty ? List<TagData>.from(json["tags"].map((x) => TagData.fromJson(x))) : null,
        products: json["products"] != null && json["products"].isNotEmpty ? List<ProductModel>.from(
            json["products"].map((x) => ProductModel.fromJson(x))) : null,
        categories:json["categories"] != null && json["categories"].isNotEmpty ? List<CategoryData>.from(json["categories"].map((x) => CategoryData.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "tags": tags != null ? List<dynamic>.from(tags!.map((x) => x)) : null,
        "products": products != null ? List<dynamic>.from(products!.map((x) => x.toJson())) : null,
        "categories": categories != null ? List<dynamic>.from(categories!.map((x) => x.toJson())) : null,
      };
}
