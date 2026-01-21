import 'dart:developer';

import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

class FlashDealDataElement {
  FlashDealDataElement({
    this.id,
    this.flashDealId,
    this.sellerProductId,
    this.discount,
    this.discountType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int? id;
  int? flashDealId;
  int? sellerProductId;
  int? discount;
  int? discountType;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;

  factory FlashDealDataElement.fromJson(Map<String, dynamic> json){

    try {
      return FlashDealDataElement(
        id: json["id"],
        flashDealId: json["flash_deal_id"],
        sellerProductId: json["seller_product_id"],
        discount: json["discount"],
        discountType: json["discount_type"],
        status: json["status"],
       /// createdAt: DateTime.tryParse(json["created_at"]),
        //updatedAt: DateTime.tryParse(json["updated_at"]),
        product: json["product"] != null ? ProductModel.fromJson(json["product"]) : null,
      );
    }catch(e,tr){
      log("FlashDealDataElement Error -> $e");
      log("Track -> $tr");
      return FlashDealDataElement();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "flash_deal_id": flashDealId,
        "seller_product_id": sellerProductId,
        "discount": discount,
        "discount_type": discountType,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
      };
}
