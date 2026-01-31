import 'WholeSalePrice.dart';

class ProductSku {
  ProductSku({
    this.id,
    this.productId,
    this.sku,
    this.purchasePrice,
    this.sellingPrice,
    this.additionalShipping,
    this.variantImage,
    this.status,
    this.productStock,
    this.trackSku,
    this.weight,
    this.length,
    this.breadth,
    this.height,
    this.wholeSalePrices,
  });

  dynamic id;
  dynamic productId;
  String? sku;
  double? purchasePrice;
  double? sellingPrice;
  double? additionalShipping;
  String? variantImage;
  dynamic status;
  dynamic productStock;
  String? trackSku;
  String? weight;
  String? length;
  String? breadth;
  String? height;
  List<WholeSalePrice>? wholeSalePrices;

  factory ProductSku.fromJson(Map<String, dynamic> json) => ProductSku(
        id: json["id"],
        productId: json["product_id"],
        sku: json["sku"],
        purchasePrice: double.tryParse("${json["purchase_price"]}") ?? 0,
        sellingPrice: double.tryParse("${json["selling_price"]}") ?? 0,
        additionalShipping:
            double.tryParse("${json["additional_shipping"]}") ?? 0,
        variantImage:
            json["variant_image"] == null ? null : json["variant_image"],
        status: json["status"],
        productStock: json['product_stock'],
        trackSku: json["track_sku"],
        weight: json["weight"],
        length: json["length"],
        breadth: json["breadth"],
        height: json["height"],
        wholeSalePrices: (json["whole_sale_prices"] ?? json["wholesale_prices"] ?? json["wholesale_price"]) == null
            ? []
            : List<WholeSalePrice>.from((json["whole_sale_prices"] ?? json["wholesale_prices"] ?? json["wholesale_price"])
                .map((x) => WholeSalePrice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "sku": sku,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "additional_shipping": additionalShipping,
        "variant_image": variantImage == null ? null : variantImage,
        "status": status,
        "product_stock": productStock,
        "track_sku": trackSku,
        "weight": weight,
        "length": length,
        "breadth": breadth,
        "height": height,
        "whole_sale_prices": wholeSalePrices == null
            ? null
            : List<dynamic>.from(wholeSalePrices!.map((x) => x.toJson())),
      };
}
