import 'dart:developer';

import 'package:amazcart/utils/app_utilities.dart';

import 'FlashDeal.dart';

class HasDeal {
  HasDeal({
    this.id,
    this.flashDealId,
    this.sellerProductId,
    this.discount,
    this.discountType,
    this.status,
    this.flashDeal,
  });

  int? id;
  int? flashDealId;
  int? sellerProductId;
  double? discount;
  int? discountType;
  int? status;
  FlashDeal? flashDeal;

  factory HasDeal.fromJson(Map<String, dynamic> json){

    try {
      return HasDeal(
        id: json["id"],
        flashDealId: json["flash_deal_id"],
        sellerProductId: json["seller_product_id"],
        discount: AppUtilities.convertToDouble(item: json["discount"]),
        discountType: json["discount_type"],
        status: json["status"],
        flashDeal: json["flash_deal"] == null || json["flash_deal"] == 0
            ? null
            : FlashDeal.fromJson(json["flash_deal"]),
      );
    }catch(e,tr){
      log("HasDeal Error -> $e");
      log("Track -> $tr");
      return HasDeal();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "flash_deal_id": flashDealId,
        "seller_product_id": sellerProductId,
        "discount": discount,
        "discount_type": discountType,
        "status": status,
        "flash_deal": flashDeal == null ? null : flashDeal?.toJson(),
      };
}
