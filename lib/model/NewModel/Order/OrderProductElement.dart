import 'package:amazcart/model/NewModel/Product/GiftCardData.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/SkuProduct.dart';
import 'package:amazcart/utils/app_utilities.dart';

class OrderProductElement {
  OrderProductElement({
    this.id,
    this.packageId,
    this.type,
    this.productSkuId,
    this.qty,
    this.price,
    this.totalPrice,
    this.taxAmount,
    this.sellerProductSku,
    this.giftCard,
  });

  int? id;
  int? packageId;
  ProductType? type;
  int? productSkuId;
  int? qty;
  double? price;
  double? totalPrice;
  double? taxAmount;
  SkuProduct? sellerProductSku;
  GiftCardData? giftCard;

  factory OrderProductElement.fromJson(Map<String, dynamic> json) =>
      OrderProductElement(
        id: json["id"],
        packageId: AppUtilities.convertToInt(item: json["package_id"]),
        type: typeValues.map[json["type"]],
        productSkuId: AppUtilities.convertToInt(item: json["product_sku_id"]),
        qty: AppUtilities.convertToInt(item: json["qty"]),
        price: AppUtilities.convertToDouble(item: json["price"]),
        totalPrice: AppUtilities.convertToDouble(item: json["total_price"]),
        taxAmount:AppUtilities.convertToDouble(item: json["tax_amount"]),
        sellerProductSku: json["seller_product_sku"] == null
            ? null
            : SkuProduct.fromJson(json["seller_product_sku"]),
        giftCard: json["gift_card"] == null
            ? null
            : GiftCardData.fromJson(json["gift_card"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "type": typeValues.reverse[type],
        "product_sku_id": productSkuId,
        "qty": qty,
        "price": price,
        "total_price": totalPrice,
        "tax_amount": taxAmount,
        "seller_product_sku": sellerProductSku?.toJson(),
        "gift_card": giftCard == null ? null : giftCard?.toJson(),
      };
}
