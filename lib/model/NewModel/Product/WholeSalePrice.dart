class WholeSalePrice {
  WholeSalePrice({
    this.id,
    this.productId,
    this.skuId,
    this.minQty,
    this.maxQty,
    this.sellingPrice,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? productId;
  int? skuId;
  int? minQty;
  int? maxQty;
  double? sellingPrice;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory WholeSalePrice.fromJson(Map<String, dynamic> json) => WholeSalePrice(
        id: json["id"],
        productId: json["product_id"],
        skuId: json["sku_id"],
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        sellingPrice: json["selling_price"] == null 
            ? 0.0 
            : double.tryParse("${json["selling_price"]}") ?? 0.0,
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "sku_id": skuId,
        "min_qty": minQty,
        "max_qty": maxQty,
        "selling_price": sellingPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
