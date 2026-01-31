import 'dart:developer';

import 'package:amazcart/utils/app_utilities.dart';

import 'ProductVariations.dart';
import 'WholeSalePrice.dart';

class Skus {
  Skus({
    this.id,
    this.userId,
    this.productId,
    this.productSkuId,
    this.productStock,
    this.purchasePrice,
    this.sellingPrice,
    this.status,
    this.productVariations,
    this.inAppPurchaseId,
    this.wholeSalePrices,
  });

  int? id;
  int? userId;
  int? productId;
  String? productSkuId;
  int? productStock;
  int? purchasePrice;
  double? sellingPrice;
  int? status;
  List<ProductVariation>? productVariations;
  String? inAppPurchaseId;
  List<WholeSalePrice>? wholeSalePrices;

  factory Skus.fromJson(Map<String, dynamic> json){

    try {
      return Skus(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        productStock: json["product_stock"],
        purchasePrice: json["purchase_price"],
        sellingPrice: AppUtilities.convertToDouble(item: json["selling_price"]),
        status: json["status"],
        productVariations: json["product_variations"] == null ? null :List<ProductVariation>.from(
            json["product_variations"].map((x) =>
                ProductVariation.fromJson(x))),
        inAppPurchaseId: json["in_app_purchase"],
        wholeSalePrices: (json["whole_sale_prices"] ?? json["wholesale_prices"] ?? json["wholesale_price"]) == null
            ? []
            : List<WholeSalePrice>.from((json["whole_sale_prices"] ?? json["wholesale_prices"] ?? json["wholesale_price"])
                .map((x) => WholeSalePrice.fromJson(x))),
      );
    }catch(e,tr){
      log("Skus Error -> $e");
      log("Track -> $tr");
      return Skus();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "product_stock": productStock,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "status": status,
        "product_variations": productVariations == null ? null : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "in_app_purchase" : inAppPurchaseId,
        "whole_sale_prices": wholeSalePrices == null
            ? null
            : List<dynamic>.from(wholeSalePrices!.map((x) => x.toJson())),
      };
}
