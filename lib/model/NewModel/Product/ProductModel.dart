import 'dart:developer';

import 'package:amazcart/model/NewModel/Product/GalleryImageData.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/model/NewModel/Seller/SellerData.dart';

import '../../../utils/app_utilities.dart';
import 'HasDeal.dart';
import 'ProductData.dart';
import 'Review.dart';
import 'Skus.dart';

class ProductModel {
  ProductModel(
      {this.id,
      this.userId,
      this.productId,
      this.tax,
      this.taxType,
      this.discount,
      this.discountType,
      this.discountStartDate,
      this.discountEndDate,
      this.productName,
      this.slug,
      this.thumImg,
      this.status,
      this.stockManage,
      this.isApproved,
      this.minSellPrice,
      this.maxSellPrice,
      this.totalSale,
      this.avgRating,
      this.maxSellingPrice,
      this.rating,
      this.hasDeal,
      this.hasDiscount,
      this.product,
      this.skus,
      this.reviews,
      this.variantDetails,
      this.flashDeal,
      this.seller,
      this.productType,
      this.giftCardSellingPrice,
      this.giftCardThumbnailImage,
      this.giftCardStartDate,
      this.giftCardEndDate,
      this.giftCardSku,
      this.giftCardName,
      this.giftCardDescription,
      this.giftCardGalleryImages});

  int? id;
  int? userId;
  int? productId;
  num? tax;
  String? taxType;
  double? discount;
  dynamic discountType;
  dynamic discountStartDate;
  dynamic discountEndDate;
  String? productName;
  String? slug;
  dynamic thumImg;
  dynamic status;
  int? stockManage;
  int? isApproved;
  double? minSellPrice;
  num? maxSellPrice;
  int? totalSale;
  double? avgRating;
  double? maxSellingPrice;
  double? rating;
  HasDeal? hasDeal;
  String? hasDiscount;
  Product? product;
  List<Skus>? skus;
  List<Review>? reviews;
  List<ProductVariantDetail>? variantDetails;
  HasDeal? flashDeal;
  SellerData? seller;
  ProductType? productType;
  double? giftCardSellingPrice;
  String? giftCardThumbnailImage;
  DateTime? giftCardStartDate;
  DateTime? giftCardEndDate;
  String? giftCardSku;
  String? giftCardName;
  String? giftCardDescription;
  List<GalleryImageData>? giftCardGalleryImages;

  factory ProductModel.fromJson(Map<String, dynamic> json){

    return ProductModel(
      id: AppUtilities.convertToInt(item: json["id"]),
      userId: AppUtilities.convertToInt(item: json["user_id"]),
      productId: AppUtilities.convertToInt(item: json["product_id"]),
      tax: AppUtilities.convertToDouble(item: json["tax"]),
      taxType: "${json["tax_type"]??0}",
      discount: json["discount"] == null ? null : double.tryParse("${json["discount"]}"),
      discountType: json["discount_type"].toString(),
      discountStartDate: json["discount_start_date"],
      discountEndDate: json["discount_end_date"],
      productName: json["product_name"],
      slug: json["slug"],
      thumImg: json["thum_img"],
      status: json["status"],
      stockManage: AppUtilities.convertToInt(item: json["stock_manage"]),
      isApproved: AppUtilities.convertToInt(item: json["is_approved"]),
      minSellPrice: json["min_sell_price"] == null
          ? null
          : AppUtilities.convertToDouble(item: json["min_sell_price"]),
      maxSellPrice: json["max_sell_price"] == null
          ? null
          : AppUtilities.convertToDouble(item: json["max_sell_price"]),
      totalSale: AppUtilities.convertToInt(item: json["total_sale"]),
      avgRating: AppUtilities.convertToDouble(item: json["avg_rating"]),
      variantDetails: json["variantDetails"] == null
          ? null
          : List<ProductVariantDetail>.from(json["variantDetails"]
          .map((x) => ProductVariantDetail.fromJson(x))),
      maxSellingPrice: json["MaxSellingPrice"] == null
          ? null
          : AppUtilities.convertToDouble(item: json["MaxSellingPrice"]),
      hasDeal: json["hasDeal"] == null || json["hasDeal"] == 0
          ? null
          : HasDeal.fromJson(json["hasDeal"]),
      rating : AppUtilities.convertToDouble(item: json["rating"]),
      hasDiscount: json['hasDiscount'],
      product:
      json["product"] == null ? null : Product.fromJson(json["product"]),
      seller:
      json["seller"] != null && json["seller"].isNotEmpty ? SellerData.fromJson(json["seller"]) : null,
      reviews: json["reviews"] == null
          ? null
          : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      skus: json["skus"] == null ? null : List<Skus>.from(json["skus"].map((x) => Skus.fromJson(x))),
      productType: typeValues.map[json["ProductType"]],
      giftCardSellingPrice: json["selling_price"] == null
          ? null
          : AppUtilities.convertToDouble(item:"${json["selling_price"]}"),
      giftCardThumbnailImage:
      json["thumbnail_image"] == null ? null : json["thumbnail_image"],
      giftCardStartDate: json["start_date"] == null
          ? null
          : DateTime.parse(json["start_date"]),
      giftCardEndDate:
      json["end_date"] == null ? DateTime.now() : DateTime.parse(json["end_date"]),
      giftCardSku: json['sku'] == null ? null : json['sku'],
      giftCardName: json['name'] == null ? null : json['name'],
      giftCardDescription:
      json['description'] == null ? null : json['description'],
      giftCardGalleryImages: json["galary_images"] == null
          ? null
          : List<GalleryImageData>.from(
          json["galary_images"].map((x) => GalleryImageData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "tax": tax,
        "tax_type": taxType,
        "discount": discount,
        "discount_type": discountType,
        "discount_start_date": discountStartDate,
        "discount_end_date": discountEndDate,
        "product_name": productName,
        "slug": slug,
        "thum_img": thumImg,
        "status": status,
        "stock_manage": stockManage,
        "is_approved": isApproved,
        "min_sell_price": minSellPrice,
        "max_sell_price": maxSellPrice,
        "total_sale": totalSale,
        "avg_rating": avgRating,
        "MaxSellingPrice": maxSellingPrice,
        "rating": rating,
        "hasDiscount": hasDiscount,
        "hasDeal": hasDeal == null ? null : hasDeal?.toJson(),
        "flash_deal": flashDeal == null ? null : flashDeal?.toJson(),
        "product": product == null ? null : product?.toJson(),
        "seller": seller == null ? null : seller?.toJson(),
        "skus": skus == null
            ? null
            : List<dynamic>.from(skus!.map((x) => x.toJson())),
        "reviews": reviews == null
            ? null
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "start_date": giftCardStartDate == null
            ? null
            : "${giftCardStartDate!.year.toString().padLeft(4, '0')}-${giftCardStartDate!.month.toString().padLeft(2, '0')}-${giftCardStartDate!.day.toString().padLeft(2, '0')}",
        "end_date": giftCardEndDate == null
            ? null
            : "${giftCardEndDate!.year.toString().padLeft(4, '0')}-${giftCardEndDate!.month.toString().padLeft(2, '0')}-${giftCardEndDate!.day.toString().padLeft(2, '0')}",
        "sku": giftCardSku == null ? null : giftCardSku,
        "name": giftCardName == null ? null : giftCardName,
        "description": giftCardDescription == null ? null : giftCardDescription,
        "galary_images": giftCardGalleryImages == null
            ? null
            : List<dynamic>.from(giftCardGalleryImages!.map((x) => x.toJson())),
      };
}
