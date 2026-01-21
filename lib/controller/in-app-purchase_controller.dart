import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/view/amazcart_view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/config.dart';
import '../view/amazcart_view/account/orders/new_order_module/views/all_order_page.dart';
import '../widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:http/http.dart' as http;


class InAppPurchaseController extends GetxController{

  GetStorage userToken = GetStorage();
  late String token;


  void initialize()async{

      // Enable debug logs before calling `configure`.
      await Purchases.setLogLevel(LogLevel.debug);
      //await Purchases.setLogLevel(LogLevel.verbose);

      /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
      PurchasesConfiguration _config;

      _config = PurchasesConfiguration(revenueCatApiKey)
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();

      await Purchases.configure(_config);

      Purchases.addCustomerInfoUpdateListener((customerInfo) async {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();

        print(customerInfo);
      });

  }
  Future<void> onInAppPurchaseProduct({required Map<String,dynamic> productInfo})async{

    log("productInfo ::::::: $productInfo");

    token = await userToken.read("token")??'';

    if(token.isEmpty){
      await Get.dialog(LoginPage(), useSafeArea: false);
      if(!Get.find<LoginController>().loggedIn.value){
        return;
      }
    }

    log("Running in-app purchase");

    var cartId = await inAppPurchaseAddToCart(body: productInfo);

    ///cancel in-app purchase if cardId is -1
    if(cartId == -1){
      return;
    }

    String iapId = productInfo["in_app_purchase_id"]??'';

    log("In-app purchase id ::: $iapId");

    try{
      CustomerInfo? purchaserInfo = await Purchases.purchaseProduct(iapId).then((data) {
        print('Data received: ${data.toJson()}');

        ///Make an order
        createInAppPurchaseOrder(
        body: {
          "grand_total" : productInfo['price'],
          "cart_id": cartId
        }
        );

      }).catchError(( error,tr) {
        print('Error::::: $error');
        print('Track:::::: $tr');
        SnackBars().snackBarError("Purchase was cancelled".tr);

       ///Delete cart
        deleteInAppPurchaseOrder(cartId: cartId);
      });;

      log("purchaserInfo response ::: ${purchaserInfo?.toJson()}");

    } catch(e,tr){
      log("In-app purchase Error -> $e");
      log("In-app purchase Track -> $tr");
    }
  }


  ///For store product information for in-app purchase
  Future<int> inAppPurchaseAddToCart({required Map<String,dynamic> body})async{

    EasyLoading.show(maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    Map<String,dynamic> requestBody = {
    "qty" : 1,
    "price" : body['price'],
    "product_id" : body['product_id'],
    "seller_id" : body['seller_id'],
    "product_type" : body['product_type'],
    "checked" : body['checked']
    };

    log("API -> ${URLs.inAppPurchaseAddToCart}");

    try{

      Uri userData = Uri.parse(URLs.inAppPurchaseAddToCart);

      var response = await http.post(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody)
      );

      Map<String,dynamic> responseMap = jsonDecode(response.body);

      log("jsonString :::: $responseMap");

      if(response.statusCode == 200){
        return responseMap['cart_id'];
      }else{
        SnackBars().snackBarError("Purchase was cancelled".tr);
        return -1;
      }

    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");
      return -1;
    }finally{
      EasyLoading.dismiss();
    }

  }


  ///For create an order after successfully create an in-app purchase
  Future<void> createInAppPurchaseOrder({required Map<String,dynamic> body})async{

    EasyLoading.show(maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    log("API -> ${URLs.createInAppPurchaseOrder}");

    try{

      Uri userData = Uri.parse(URLs.createInAppPurchaseOrder);

      var response = await http.post(
          userData,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body)
      );

      Map<String,dynamic> responseMap = jsonDecode(response.body);

      log("jsonString :::: $responseMap");

      if(response.statusCode == 200){
        SnackBars().snackBarSuccess("Purchase Successful".tr);
       Get.to(DynamicOrderListTabs())?.then((v)=>Get.back());
      }else{
        SnackBars().snackBarError("Purchase was cancelled".tr);
      }

    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");
    }finally{
      EasyLoading.dismiss();
    }

  }

  ///For delete the product information
  Future<void> deleteInAppPurchaseOrder({required int cartId})async{

    EasyLoading.show(maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    log("API -> ${URLs.deleteInAppPurchaseCart}");

    try{

      Uri userData = Uri.parse(URLs.deleteInAppPurchaseCart);

      var response = await http.post(
          userData,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({"cart_id" : cartId})
      );

      log("Delete in-app purchase cart ::${response.body}");

    }catch(e,tr){
      log("Error -> $e");
      log("Track -> $tr");
    }finally{
      EasyLoading.dismiss();
    }

  }
}