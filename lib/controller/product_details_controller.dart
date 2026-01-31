import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:amazcart/config/config.dart';

import 'package:amazcart/model/NewModel/Product/ProductDetailsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductSkus.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/Review.dart';
import 'package:amazcart/model/NewModel/ShippingMethod/ShippingMethodElement.dart';
import 'package:amazcart/model/NewModel/Product/SellerSkuModel.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

class ProductDetailsController extends GetxController {
  var products = ProductDetailsModel().obs;

  var isLoading = false.obs;

  var productId = 0.obs;

  // ignore: deprecated_member_use
  var productReviews = <Review>[].obs;

  // ignore: deprecated_member_use
  var giftCardReviews = <Review>[].obs;

  var visibleSKU = ProductSku().obs;

  var productSKU = SkuData().obs;

  var isSkuLoading = false.obs;

  var finalPrice = 0.0.obs;
  var productPrice = 0.0.obs;

  dynamic discount;
  dynamic discountType;

  var itemQuantity = 1.obs;
  String? inAppPurchaseId;

  var minOrder = 1.obs;
  var maxOrder = 1.obs;

  var productSkuID = 0.obs;

  var shippingID = 0.obs;

  Map getSKU = {};

  var stockManage = 0.obs;
  var stockCount = 0.obs;
  var isCartLoading = false.obs;

  var shippingValue = ShippingMethodElement().obs;

  Future fetchProductDetails(id) async {
    try {
      Uri userData = Uri.parse(URLs.WHOLESALE_PRODUCT_DETAILS + '/$id');
      print("Making request to: $userData");
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("RESPONSE STATUS: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      var jsonString = jsonDecode(response.body);


      if (jsonString['message'] != 'not found') {
        return ProductDetailsModel.fromJson(jsonString);
      } else {
        Get.back();
        SnackBars().snackBarWarning('not found');
      }
    } catch (e, t) {
      print(e);
      print(t);
    }
    return ProductDetailsModel();
  }

  Future<ProductDetailsModel> getProductDetails2(id) async {

    print("getProductDetails2 method invoked for the product id: $id");

    try {
      isCartLoading(true);
      var data = await fetchProductDetails(id);

      if (data != null) {
        products.value = data;

        productReviews.value = data.data.reviews?.where((element) => element.type == ProductType.PRODUCT)
            .toList()??[];
        visibleSKU.value = products.value.data?.product?.skus?.first??ProductSku();

        if (products.value.data?.discountStartDate != null &&
            products.value.data?.discountStartDate != '') {
          var endDate =
              DateTime.parse('${products.value.data?.discountEndDate}');
          if (endDate.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
            discount = 0;
          } else {
            discount = products.value.data?.discount;
          }
        } else {
          discount = products.value.data?.discount;
        }
        discountType = products.value.data?.discountType;
        minOrder.value = products.value.data?.product?.minimumOrderQty??1;
        maxOrder.value = products.value.data?.product?.maxOrderQty ?? 1;
        // shippingID.value =
        //     products.value.data.product.shippingMethods.first.shippingMethodId;

        itemQuantity.value = products.value.data?.product?.minimumOrderQty??1;

        if ((products.value.data?.variantDetails?.length??0) > 0) {
          await skuGet();
        } else {
          stockManage.value = products.value.data?.stockManage??0;
          stockCount.value = products.value.data?.skus?.first.productStock??0;
          visibleSKU.value = products.value.data?.product?.skus?.first??ProductSku();
        }
        //productSkuID.value = products.value.data!.skus!.first.id!;
        calculatePrice();
        return products.value;
      } else {
        products.value = ProductDetailsModel();
        return products.value;
      }
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      isCartLoading(false);
      return ProductDetailsModel();
    } finally {
      isCartLoading(false);
    }
    // return ProductDetailsModel();
  }

  Future skuGet() async {
    for (var i = 0; i < products.value.data!.variantDetails!.length; i++) {
      getSKU.addAll({
        'id[$i]':
            "${products.value.data!.variantDetails![i].attrValId?.first}-${products.value.data!.variantDetails![i].attrId}"
      });
    }
    getSKU.addAll({
      'product_id': products.value.data!.id,
      'user_id': products.value.data!.userId
    });
    await getSkuWisePrice(getSKU);
  }

  Future getSkuWisePrice(Map data) async {
    try {
      isSkuLoading(true);
      DIO.Response response;
      DIO.Dio dio = new DIO.Dio();
      var formData = DIO.FormData();
      data.forEach((k, v) {
        formData.fields.add(MapEntry(k, v.toString()));
      });

      log("Url -> ${URLs.PRODUCT_PRICE_SKU_WISE}");
      log("query -> $data");

      response = await dio.post(
        URLs.PRODUCT_PRICE_SKU_WISE,
        options: DIO.Options(
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
        queryParameters: {
          "lang" : AppLocalizations.getLanguageCode()
        }
      );
      if (response.data == "0") {
        SnackBars().snackBarWarning('Product not available');
        getProductDetails2(data['product_id']).then((value) {
          itemQuantity.value = products.value.data?.product?.minimumOrderQty??1;
          productId.value = data['product_id'];
          shippingValue.value = products.value.data?.product?.shippingMethods?.first??ShippingMethodElement();
        });
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);
        discount = returnData['data']['product']['discount'];
        discountType = returnData['data']['product']['discount_type'];
        // visibleSKU.value = ProductSkus.fromJson(returnData['data']['sku']);
        productSKU.value = SkuData.fromJson(returnData['data']);
        productSkuID.value = returnData['data']['id'];
        inAppPurchaseId = returnData['data']['sku']['in_app_purchase']??'';

        stockManage.value = products.value.data?.stockManage??0;
        stockCount.value = productSKU.value.productStock;
        itemQuantity.value = products.value.data?.product?.minimumOrderQty??1;
        calculatePriceAfterSku();
      }
    } catch (e, t) {
      isSkuLoading(false);
      print(e.toString());
      print(t.toString());
    } finally {
      isSkuLoading(false);
    }
  }

  void calculatePrice() {
    double basePrice = 0.0;
    bool isWholesale = false;

    // Check availability of Wholesale Price
    if (visibleSKU.value.wholeSalePrices != null &&
        visibleSKU.value.wholeSalePrices!.isNotEmpty) {
      print("DEBUG: visibleSKU wholeSalePrices: ${visibleSKU.value.wholeSalePrices?.length}");
      for (var wholesale in visibleSKU.value.wholeSalePrices!) {
        if (itemQuantity.value >= wholesale.minQty! &&
            itemQuantity.value <= (wholesale.maxQty ?? double.infinity)) {
          basePrice = wholesale.sellingPrice!;
          isWholesale = true;
          print("DEBUG: Applied wholesale price: $basePrice for qty: ${itemQuantity.value}");
          break;
        }
      }
    } else {
      print("DEBUG: visibleSKU wholeSalePrices is NULL or EMPTY");
    }

    // Default to SKU selling price if no wholesale range matches
    if (!isWholesale) {
      basePrice = products.value.data!.skus!.first.sellingPrice!;
    }

    if (products.value.data!.hasDeal != null) {
      if (products.value.data!.hasDeal!.discountType == 0) {
        finalPrice.value = basePrice -
            ((products.value.data!.hasDeal!.discount! / 100) * basePrice);
        productPrice.value = basePrice -
            ((products.value.data!.hasDeal!.discount! / 100) * basePrice);
      } else {
        finalPrice.value = basePrice - products.value.data!.hasDeal!.discount!;
        productPrice.value = basePrice - products.value.data!.hasDeal!.discount!;
      }
    } else {
      if (discount > 0) {
        ///percentage - type
        if (discountType == "0" || discountType == 0) {
          finalPrice.value = basePrice - ((discount / 100) * basePrice);
          productPrice.value = basePrice - ((discount / 100) * basePrice);
        } else {
          finalPrice.value = basePrice - discount;
          productPrice.value = basePrice - discount;
        }
      } else {
        ///no discount
        finalPrice.value = basePrice;
        productPrice.value = basePrice;
      }
    }
    // Ensure finalPrice reflects the UNIT price
    finalPrice.value = productPrice.value;
    print("DEBUG: finalPrice (unit): ${finalPrice.value}, qty: ${itemQuantity.value}");
  }

  void calculatePriceAfterSku() {
    double basePrice = 0.0;
    bool isWholesale = false;

    if (productSKU.value.sku?.wholeSalePrices != null &&
        productSKU.value.sku!.wholeSalePrices!.isNotEmpty) {
      print("DEBUG: productSKU wholeSalePrices: ${productSKU.value.sku?.wholeSalePrices?.length}");
      for (var wholesale in productSKU.value.sku!.wholeSalePrices!) {
        if (itemQuantity.value >= wholesale.minQty! &&
            itemQuantity.value <= (wholesale.maxQty ?? double.infinity)) {
          basePrice = wholesale.sellingPrice!;
          isWholesale = true;
          print("DEBUG: Applied wholesale price (SKU): $basePrice for qty: ${itemQuantity.value}");
          break;
        }
      }
    } else {
      print("DEBUG: productSKU wholeSalePrices is NULL or EMPTY");
    }

    // Default to SkuData's selling price if no wholesale range matches
    if (!isWholesale) {
      basePrice = productSKU.value.sellingPrice.toDouble();
    }

    if (products.value.data!.hasDeal != null) {
      if (products.value.data!.hasDeal!.discountType == 0) {
        finalPrice.value = basePrice -
            ((products.value.data!.hasDeal!.discount! / 100) * basePrice);
        productPrice.value = basePrice -
            ((products.value.data!.hasDeal!.discount! / 100) * basePrice);
      } else {
        finalPrice.value = basePrice - products.value.data!.hasDeal!.discount!;
        productPrice.value = basePrice - products.value.data!.hasDeal!.discount!;
      }
    } else {
      if (discount > 0) {
        ///percentage - type
        if (discountType == "0") {
          finalPrice.value = basePrice - ((discount / 100) * basePrice);
          productPrice.value = basePrice - ((discount / 100) * basePrice);
        } else {
          finalPrice.value = basePrice - discount;
          productPrice.value = basePrice - discount;
        }
      } else {
         ///no discount
        finalPrice.value = basePrice;
        productPrice.value = basePrice;
      }
    }
    // Ensure finalPrice reflects the UNIT price
    finalPrice.value = productPrice.value;
    print("DEBUG: finalPrice (unit, SKU): ${finalPrice.value}, qty: ${itemQuantity.value}");
  }

  void cartIncrease() {
    if (maxOrder.value != null) {
      if (itemQuantity.value < maxOrder.value) {
        itemQuantity.value++;
      }
    } else {
      itemQuantity.value++;
    }
    calculatePrice();
  }

  void cartDecrease() {
    if (itemQuantity.value > minOrder.value) {
      itemQuantity.value--;
      calculatePrice();
    }
  }

  @override
  void onInit() {
    // getProductDetails();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
