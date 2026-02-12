import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  void logToFile(String label, String data) async {
    // Also log to console for easy access
    print('--- $label ---\n$data\n');
    
    try {
      final directory = await getExternalStorageDirectory();
      String path = '${directory?.path}/amazkart_product_logs.txt';
      if (Platform.isIOS) {
         final dir = await getApplicationDocumentsDirectory();
         path = '${dir.path}/amazkart_product_logs.txt';
      }
      final file = File(path);
      String logEntry = '\n--- $label (${DateTime.now()}) ---\n$data\n';
      await file.writeAsString(logEntry, mode: FileMode.append);
      // print('Logged $label to $path');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }
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
      Uri userData = Uri.parse(URLs.ALL_PRODUCTS + '/$id?lang=${AppLocalizations.getLanguageCode()}');

      var response = await http.get(
        userData,

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      logToFile('RAW_RESPONSE', response.body);

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

    try {
      isCartLoading(true);
      var data = await fetchProductDetails(id);

      if (data != null) {
        products.value = data;
        logToFile('UI_DATA_SENT', jsonEncode(data.toJson()));
        
        // Specific Wholesale Data Log
        int wholeSaleCount = data.data.skus?.first.wholeSalePrices?.length ?? 0;
        logToFile('WHOLESALE_CHECK', 'Found $wholeSaleCount wholesale prices in first SKU');

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
        minOrder.value = (products.value.data?.product?.minimumOrderQty ?? 1) < 1 
            ? 1 
            : products.value.data?.product?.minimumOrderQty!;
        maxOrder.value = products.value.data?.product?.maxOrderQty ?? 1;
        // shippingID.value =
        //     products.value.data.product.shippingMethods.first.shippingMethodId;

        itemQuantity.value = minOrder.value;

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
          itemQuantity.value = minOrder.value;
          productId.value = data['product_id'];
          shippingValue.value = products.value.data?.product?.shippingMethods?.first??ShippingMethodElement();
        });
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);
        logToFile('VARIANT_RAW_RESPONSE', jsonEncode(returnData['data']));
        discount = returnData['data']['product']['discount'];
        discountType = returnData['data']['product']['discount_type'];
        // visibleSKU.value = ProductSkus.fromJson(returnData['data']['sku']);
        productSKU.value = SkuData.fromJson(returnData['data']);
        productSkuID.value = returnData['data']['id'];

        // Map wholesale prices from initial fetch if missing in variant response
        if (productSKU.value.sku?.wholeSalePrices == null || productSKU.value.sku!.wholeSalePrices!.isEmpty) {
          try {
            var initialSku = products.value.data?.skus?.firstWhere(
                (element) => element.id.toString() == productSkuID.value.toString());
            if (initialSku != null && initialSku.wholeSalePrices != null && initialSku.wholeSalePrices!.isNotEmpty) {
              productSKU.value.sku?.wholeSalePrices = initialSku.wholeSalePrices;
              logToFile('WHOLESALE_MAPPING', 'Successfully mapped ${initialSku.wholeSalePrices!.length} prices from initial fetch');
            }
          } catch (e) {
            logToFile('WHOLESALE_MAPPING_ERROR', e.toString());
          }
        }
        productSKU.refresh();

        logToFile('VARIANT_UI_DATA_SENT', jsonEncode(productSKU.value.toJson()));
        inAppPurchaseId = returnData['data']['sku']['in_app_purchase']??'';

        stockManage.value = products.value.data?.stockManage??0;
        stockCount.value = productSKU.value.productStock;
        itemQuantity.value = minOrder.value;
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
    double basePrice = products.value.data!.skus!.first.sellingPrice!;

    if ((products.value.data!.skus!.first.wholeSalePrices?.length ?? 0) > 0) {
      for (var tier in products.value.data!.skus!.first.wholeSalePrices!) {
        if (itemQuantity.value >= tier.minQty! && (tier.maxQty == null || itemQuantity.value <= tier.maxQty!)) {
          basePrice = tier.sellingPrice!;
          break;
        }
      }
    }

    if (products.value.data!.hasDeal != null) {
      if (products.value.data!.hasDeal!.discountType == 0) {
        double discAmount = ((products.value.data!.hasDeal!.discount ?? 0) / 100) * basePrice;
        finalPrice.value = basePrice - discAmount;
        productPrice.value = basePrice - discAmount;
      } else {
        finalPrice.value = basePrice - (products.value.data!.hasDeal!.discount ?? 0).toDouble();
        productPrice.value = basePrice - (products.value.data!.hasDeal!.discount ?? 0).toDouble();
      }
    } else {
      if (discount != null && discount > 0) {
        if (discountType == "0" || discountType == 0) {
          double discAmount = ((discount as num).toDouble() / 100) * basePrice;
          finalPrice.value = basePrice - discAmount;
          productPrice.value = basePrice - discAmount;
        } else {
          finalPrice.value = basePrice - (discount as num).toDouble();
          productPrice.value = basePrice - (discount as num).toDouble();
        }
      } else {
        finalPrice.value = basePrice;
        productPrice.value = basePrice;
      }
    }
  }

  void calculatePriceAfterSku() {
    double basePrice = (productSKU.value.sellingPrice as num).toDouble();

    if ((productSKU.value.sku?.wholeSalePrices?.length ?? 0) > 0) {
      for (var tier in productSKU.value.sku!.wholeSalePrices!) {
        if (itemQuantity.value >= tier.minQty! && (tier.maxQty == null || itemQuantity.value <= tier.maxQty!)) {
          basePrice = tier.sellingPrice!;
          break;
        }
      }
    }

    if (products.value.data!.hasDeal != null) {
      if (products.value.data!.hasDeal!.discountType == 0) {
        double discAmount = ((products.value.data!.hasDeal!.discount ?? 0) / 100) * basePrice;
        finalPrice.value = basePrice - discAmount;
        productPrice.value = basePrice - discAmount;
      } else {
        finalPrice.value = basePrice - (products.value.data!.hasDeal!.discount ?? 0).toDouble();
        productPrice.value = basePrice - (products.value.data!.hasDeal!.discount ?? 0).toDouble();
      }
    } else {
      if (discount != null && discount > 0) {
        if (discountType == "0") {
          double discAmount = ((discount as num).toDouble() / 100) * basePrice;
          finalPrice.value = basePrice - discAmount;
          productPrice.value = basePrice - discAmount;
        } else {
          finalPrice.value = basePrice - (discount as num).toDouble();
          productPrice.value = basePrice - (discount as num).toDouble();
        }
      } else {
        finalPrice.value = basePrice;
        productPrice.value = basePrice;
      }
    }
  }

  void cartIncrease() {
    if (maxOrder.value != null) {
      if (itemQuantity.value < maxOrder.value) {
        itemQuantity.value++;
      }
    } else {
      itemQuantity.value++;
    }

    if ((products.value.data?.variantDetails?.length ?? 0) > 0) {
      calculatePriceAfterSku();
    } else {
      calculatePrice();
    }
    finalPrice.value = productPrice.value * itemQuantity.value;
  }

  void cartDecrease() {
    if (itemQuantity.value > minOrder.value) {
      itemQuantity.value--;
      if ((products.value.data?.variantDetails?.length ?? 0) > 0) {
        calculatePriceAfterSku();
      } else {
        calculatePrice();
      }
      finalPrice.value = productPrice.value * itemQuantity.value;
    }
  }

  void updateQuantity(String qty) {
    if (qty.isEmpty) {
      return;
    }
    int? newQty = int.tryParse(qty);
    if (newQty == null) {
      return;
    }

    if (stockManage.value == 1) {
      if (newQty > stockCount.value) {
        itemQuantity.value = stockCount.value;
        SnackBars().snackBarWarning('Stock not available.');
      } else if (newQty < minOrder.value) {
         SnackBars().snackBarWarning("Can't add less than" + ' ${minOrder.value} ' + 'Products');
          itemQuantity.value = minOrder.value;
      } else {
        itemQuantity.value = newQty;
      }
    } else {
      if (maxOrder.value != null) {
        if (newQty > maxOrder.value) {
           SnackBars().snackBarWarning("Can't add more than" + ' ${maxOrder.value} ' + 'Products');
            itemQuantity.value = maxOrder.value;
        } else if (newQty < minOrder.value) {
             SnackBars().snackBarWarning("Can't add less than" + ' ${minOrder.value} ' + 'Products');
            itemQuantity.value = minOrder.value;
        } else {
          itemQuantity.value = newQty;
        }
      } else {
         if (newQty < minOrder.value) {
             SnackBars().snackBarWarning("Can't add less than" + ' ${minOrder.value} ' + 'Products');
            itemQuantity.value = minOrder.value;
        } else {
          itemQuantity.value = newQty;
        }
      }
    }
    if ((products.value.data?.variantDetails?.length ?? 0) > 0) {
      calculatePriceAfterSku();
    } else {
      calculatePrice();
    }
    finalPrice.value = productPrice.value * itemQuantity.value;
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
