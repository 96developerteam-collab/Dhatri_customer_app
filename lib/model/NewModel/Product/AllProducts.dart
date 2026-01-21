import 'dart:developer';

import 'ProductModel.dart';

class AllProducts {
  AllProducts({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<ProductModel>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory AllProducts.fromJson(Map<String, dynamic> json){
    try {

      List<ProductModel>? tempData =  List<ProductModel>.from((json["data"]??[]).map((x) => ProductModel.fromJson(x)));

    return AllProducts(
        currentPage: json["current_page"],
        // data: List<ProductModel>.from(json["data"].map((x) => ProductModel.fromJson(x))),
         data: tempData,
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        // total: json["total"],
      total: tempData.length??0
      );
    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");
      return AllProducts();
    }
  }

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
