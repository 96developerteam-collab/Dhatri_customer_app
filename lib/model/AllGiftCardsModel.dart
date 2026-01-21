import 'package:amazcart/utils/app_utilities.dart';

class AllGiftCardsModel {
  List<GiftCardsUIModel>? giftCards;
  String? seller;
  String? message;

  AllGiftCardsModel({this.giftCards, this.seller, this.message});

  AllGiftCardsModel.fromJson(Map<String, dynamic> json) {
    if (json['giftcards'] != null) {
      giftCards = <GiftCardsUIModel>[];
      json['giftcards'].forEach((v) {
        giftCards!.add(GiftCardsUIModel.fromJson(v));
      });
    }
    seller = json['seller'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.giftCards != null) {
      data['giftcards'] = this.giftCards!.map((v) => v.toJson()).toList();
    }
    data['seller'] = this.seller;
    data['message'] = this.message;
    return data;
  }
}

class GiftCardsUIModel {
  int? id;
  String? name;
  String? sku;
  double? sellingPrice;
  String? thumbnailImage;
  double? discount;
  int? discountType;
  DateTime? giftCardStartDate;
  DateTime? giftCardEndDate;
  String? description;
  int? status;
  double? avgRating;
  int? shippingId;
  String? type;
  List<Skus>? skus;

  GiftCardsUIModel(
      {this.id,
        this.name,
        this.sku,
        this.sellingPrice,
        this.thumbnailImage,
        this.discount,
        this.discountType,
        this.giftCardStartDate,
        this.giftCardEndDate,
        this.description,
        this.status,
        this.avgRating,
        this.shippingId,
        this.type,
        this.skus});

  GiftCardsUIModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    sellingPrice = AppUtilities.convertToDouble(item: json['selling_price']);
    thumbnailImage = json['thumbnail_image'];
    discount = AppUtilities.convertToDouble(item:json['discount']);
    discountType = json['discount_type'];
    giftCardStartDate = json['start_date'] != null ? DateTime.parse(json['start_date']) : null;
    giftCardEndDate = json['end_date'] != null ? DateTime.parse(json['end_date']) : null;
    description = json['description'];
    status = json['status'];
    avgRating = AppUtilities.convertToDouble(item:json['avg_rating']);
    shippingId = json['shipping_id'];
    type = json['type'];
    if (json['skus'] != null) {
      skus = <Skus>[];
      json['skus'].forEach((v) {
        skus!.add(Skus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['selling_price'] = this.sellingPrice;
    data['thumbnail_image'] = this.thumbnailImage;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['start_date'] = this.giftCardStartDate == null ?
    null :
    "${giftCardStartDate!.year.toString().padLeft(4,'0')}-${giftCardStartDate!.month.toString().padLeft(2,'0')}-${giftCardStartDate!.day.toString().padLeft(2,'0')}";
    data['end_date'] =this.giftCardEndDate == null ?
    null :
    "${giftCardEndDate!.year.toString().padLeft(4,'0')}-${giftCardEndDate!.month.toString().padLeft(2,'0')}-${giftCardEndDate!.day.toString().padLeft(2,'0')}";

    data['description'] = this.description;
    data['status'] = this.status;
    data['avg_rating'] = this.avgRating;
    data['shipping_id'] = this.shippingId;
    data['type'] = this.type;
    if (this.skus != null) {
      data['skus'] = this.skus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Skus {
  int? id;
  int? userId;
  int? productId;
  int? productSkuId;
  int? productStock;
  double? purchasePrice;
  double? sellingPrice;
  int? status;
  String? inAppPurchase;
  String? type;

  Skus(
      {this.id,
        this.userId,
        this.productId,
        this.productSkuId,
        this.productStock,
        this.purchasePrice,
        this.sellingPrice,
        this.status,
        this.inAppPurchase,
        this.type,
      });

  Skus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productSkuId = json['product_sku_id'];
    productStock = json['product_stock'];
    purchasePrice = AppUtilities.convertToDouble(item:json['purchase_price']);
    sellingPrice = AppUtilities.convertToDouble(item:json['selling_price']);
    status = json['status'];
    inAppPurchase = json['in_app_purchase'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['product_sku_id'] = this.productSkuId;
    data['product_stock'] = this.productStock;
    data['purchase_price'] = this.purchasePrice;
    data['selling_price'] = this.sellingPrice;
    data['status'] = this.status;
    data['in_app_purchase'] = this.inAppPurchase;
    data['type'] = this.type;
    return data;
  }
}
