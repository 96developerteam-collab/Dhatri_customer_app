import 'dart:convert';
import 'dart:developer';

import 'CategoryData.dart';

CategoryMain categoryFromJson(String str) =>
    CategoryMain.fromJson(json.decode(str));

String categoryToJson(CategoryMain data) => json.encode(data.toJson());

class CategoryMain {
  CategoryMain({
    this.data,
  });

  List<CategoryData>? data;

  factory CategoryMain.fromJson(Map<String, dynamic> json){

    try {
      return CategoryMain(
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
      );
    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");
      return CategoryMain(data: []);
    }
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
