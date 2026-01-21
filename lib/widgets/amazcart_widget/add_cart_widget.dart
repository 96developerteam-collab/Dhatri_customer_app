import 'dart:developer';
import 'dart:io';

import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/in-app-purchase_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/cart/AddToCartWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCartWidget extends StatefulWidget {
  final ProductModel? productModel;
  AddCartWidget({this.productModel});

  @override
  State<AddCartWidget> createState() => _AddCartWidgetState();
}

class _AddCartWidgetState extends State<AddCartWidget> {

  bool isLoading = false;

  final GeneralSettingsController _generalSettingsController =
      Get.put(GeneralSettingsController());

  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    if(Platform.isIOS){
      inAppPurchaseController = Get.find();
    }
    super.initState();
  }

  double getPriceForCart() {

    String tempPrice = ((widget.productModel?.hasDeal != null ? (widget.productModel?.hasDeal?.discount ?? 0) > 0
        ? _generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())
        : _generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())
        : _generalSettingsController.calculatePrice(widget.productModel ?? ProductModel()))
        .toString());

    tempPrice = tempPrice.replaceAll(_generalSettingsController.appCurrency.value, "");
    tempPrice = tempPrice.removeAllWhitespace;

    return double.tryParse(tempPrice)??0;
  }

  double getGiftCardPriceForCart() {
    dynamic productPrice = 0.0;
    if ((widget.productModel?.giftCardEndDate?.millisecondsSinceEpoch ?? 0) <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = widget.productModel?.giftCardSellingPrice;
    } else {
      if (widget.productModel?.discountType == 0 ||
          widget.productModel?.discountType == "0") {
        productPrice = ((widget.productModel?.giftCardSellingPrice ?? 0) -
            (((widget.productModel?.discount ?? 0) / 100) * (widget.productModel?.giftCardSellingPrice ?? 1.0)));
      } else {
        productPrice = ((widget.productModel?.giftCardSellingPrice ?? 0) - (widget.productModel?.discount ?? 0));
      }
    }
    return double.tryParse(productPrice.toString())??0;
  }

  @override
  Widget build(BuildContext context) {

    return isLoading
        ? InkWell(
            onTap: null,
            child: Container(
              height: 30.w,
              width: 30.w,
              padding: EdgeInsets.all(6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppStyles.pinkColor,
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
              // width: 30.w,
              // height: 30.h,
            ),
          )
        : InkWell(
            onTap: () async {

             // final LoginController loginController = Get.put(LoginController());

              if (widget.productModel?.productType == ProductType.PRODUCT) {
                  setState(() {
                    isLoading = true;
                  });

                  if ((widget.productModel?.variantDetails??[]).length == 0) {
                    if (widget.productModel?.stockManage == 1) {
                      if ((widget.productModel?.skus?.first.productStock ?? 0) > 0) {
                        if (widget.productModel?.product?.minimumOrderQty >
                            widget.productModel?.skus?.first.productStock) {
                          SnackBars().snackBarWarning('No more stock'.tr);
                        } else {

                          Map<String,dynamic> data = {
                            'product_id': widget.productModel?.skus?.first.id,
                            'qty': 1,
                            'price': getPriceForCart(),
                            'seller_id': widget.productModel?.userId,
                            'product_type': 'product',
                            'checked': true,
                            "in_app_purchase_id" : widget.productModel?.skus?.first.inAppPurchaseId
                          };

                          if(Platform.isIOS && (widget.productModel?.product?.isPhysical == 0 || widget.productModel?.productType == ProductType.GIFT_CARD)){

                            /// For in-app purchase
                            inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                          }else{
                            final CartController cartController = Get.put(
                                CartController());
                            await cartController.addToCart(data);
                          }
                        }
                      } else {
                        SnackBars().snackBarWarning('No more stock'.tr);
                      }
                    }
                    else {

                      log("no stock manage ::::::: check");
                      //** Not manage stock */

                      Map<String,dynamic> data = {
                        'product_id': widget.productModel?.skus?.first.id,
                        'qty': 1,
                        'price': getPriceForCart(),
                        'seller_id': widget.productModel?.userId,
                        'product_type': 'product',
                        'checked': true,
                        "in_app_purchase_id" : widget.productModel?.skus?.first.inAppPurchaseId
                      };

                      if(Platform.isIOS && (widget.productModel?.product?.isPhysical == 0 || widget.productModel?.productType == ProductType.GIFT_CARD)){
                        /// For in-app purchase
                        inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                      }else {
                        final CartController cartController = Get.put(
                            CartController());
                        await cartController.addToCart(data);
                      }
                    }
                  }
                  else {

                    log("Variant product ::");

                    await Get.bottomSheet(
                      AddToCartWidget(widget.productModel?.id??0),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      persistent: true,
                    );
                    Get.delete<ProductDetailsController>();
                  }
                  setState(() {
                    isLoading = false;
                  });

              }
              else {
                  log("widget.productModel product details ::: ${widget.productModel?.toJson()}");
                  Map<String,dynamic> data = {
                    'product_id': widget.productModel?.id,
                    'qty': 1,
                    'price': getGiftCardPriceForCart(),
                    'seller_id': 1,
                    'shipping_method_id': 1,
                    'product_type': 'gift_card',
                    "in_app_purchase_id" : widget.productModel?.skus?.first.inAppPurchaseId
                  };


                  if(Platform.isIOS && (widget.productModel?.product?.isPhysical == 0 || widget.productModel?.productType == ProductType.GIFT_CARD)){
                    /// For in-app purchase
                    inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                  }else {
                    // final CartController cartController =
                    // Get.put(CartController());
                    final CartController cartController = Get.find();
                    await cartController.addToCart(data);
                  }

              }
            },
            child: Platform.isIOS && (widget.productModel?.product?.isPhysical == 0 || widget.productModel?.productType == ProductType.GIFT_CARD) ?
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                color: AppStyles.pinkColor,
              ),
              child: Text("Buy".tr,style: TextStyle(fontSize: 14.fontSize, color: Colors.white, fontWeight: FontWeight.w500)),
            ) :
            Container(
              height: 30.w,
              width: 30.w,
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppStyles.pinkColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/icon_cart.png',
                height: 35.w,
                width: 35.w,
                color: Colors.white,
              ),
              // width: 30.w,
              // height: 30.h,
            ),
          );
  }
}