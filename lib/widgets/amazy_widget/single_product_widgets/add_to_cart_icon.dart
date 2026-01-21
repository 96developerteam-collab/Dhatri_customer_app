import 'dart:io';
import 'dart:math';

import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/in-app-purchase_controller.dart';
import '../../../view/amazy_view/products/product/product_details.dart';
import '../../amazcart_widget/snackbars.dart';


class CartIcon extends StatefulWidget {
  final ProductModel productModel;
  CartIcon(this.productModel);

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  bool _isAddingToCart = false;

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final CartController cartController = Get.find();

  double getPriceForCart() {

    String tempPrice = ((widget.productModel.hasDeal != null ? (widget.productModel.hasDeal?.discount ?? 0) > 0
        ? currencyController.calculatePrice(widget.productModel ?? ProductModel())
        : currencyController.calculatePrice(widget.productModel ?? ProductModel())
        : currencyController.calculatePrice(widget.productModel ?? ProductModel()))
        .toString());

    tempPrice = tempPrice.replaceAll(currencyController.appCurrency.value, "");
    tempPrice = tempPrice.removeAllWhitespace;

    return double.tryParse(tempPrice)??0;

  }

  double getGiftCardPriceForCart() {
    dynamic productPrice = 0.0;
    if ((widget.productModel.giftCardEndDate?.millisecondsSinceEpoch ?? 0) <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = widget.productModel.giftCardSellingPrice;
    } else {
      if (widget.productModel.discountType == 0 ||
          widget.productModel.discountType == "0") {
        productPrice = ((widget.productModel.giftCardSellingPrice ?? 0) -
            (((widget.productModel.discount ?? 0) / 100) * (widget.productModel.giftCardSellingPrice ?? 1.0)));
      } else {
        productPrice = ((widget.productModel.giftCardSellingPrice ?? 0) - (widget.productModel?.discount ?? 0));
      }
    }
    return double.tryParse(productPrice.toString())??0;
  }

  late InAppPurchaseController inAppPurchaseController;


  @override
  void initState() {

    if(Platform.isIOS){
      inAppPurchaseController = Get.find();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {

        setState(() {
          _isAddingToCart = true;
        });


        if (widget.productModel.productType == ProductType.PRODUCT) {



          if ((widget.productModel.variantDetails??[]).length == 0) {

              if (widget.productModel.stockManage == 1) {
                if ((widget.productModel.skus?.first.productStock??0) > 0) {
                  if ((widget.productModel.product?.minimumOrderQty??0) >
                      (widget.productModel.skus?.first.productStock??0)) {
                    SnackBars().snackBarWarning('No more stock'.tr);
                  } else {

                    Map<String,dynamic> data = {
                      'product_id': widget.productModel.skus?.first.id,
                      'qty': 1,
                      'price': getPriceForCart(),
                      'seller_id': widget.productModel.userId,
                      'product_type': 'product',
                      'checked': true,
                      "in_app_purchase_id" : widget.productModel.skus?.first.inAppPurchaseId

                    };

                    if(Platform.isIOS && (widget.productModel.product?.isPhysical == 0 || widget.productModel.productType == ProductType.GIFT_CARD)){
                      /// For in-app purchase
                      inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                    }else {

                      await cartController.addToCart(data).then((value) {
                        if (value) {
                          SnackBars()
                              .snackBarSuccess('Card Added successfully'.tr);
                        }
                      });
                    }

                  }
                } else {
                  SnackBars().snackBarWarning('No more stock'.tr);
                }
              } else {
                //** Not manage stock */

                Map<String,dynamic> data = {
                  'product_id': widget.productModel.skus!.first.id,
                  'qty': 1,
                  'price': getPriceForCart(),
                  'seller_id': widget.productModel.userId,
                  'product_type': 'product',
                  'checked': true,
                  "in_app_purchase_id" : widget.productModel.skus?.first.inAppPurchaseId
                };

                if(Platform.isIOS && (widget.productModel.product?.isPhysical == 0 || widget.productModel.productType == ProductType.GIFT_CARD)){
                  /// For in-app purchase
                  inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                }else {
                  await cartController.addToCart(data).then((value) {
                    if (value) {
                      Future.delayed(Duration(seconds: 3), () {
                        print(Get.isBottomSheetOpen);
                      });
                    }
                  });
                }
              }
              setState(() {
                _isAddingToCart = false;
              });


            }
          else {

            setState(() {
                _isAddingToCart = false;
              });
            Get.to(() => ProductDetails(productID: widget.productModel.id),
                  preventDuplicates: false);
          }

          setState(() {
              _isAddingToCart = false;
            });

        } else {

            Map<String,dynamic> data = {
              'product_id': widget.productModel.id,
              'qty': 1,
              'price': getGiftCardPriceForCart(),
              'seller_id': 1,
              'shipping_method_id': 1,
              'product_type': 'gift_card',
              "in_app_purchase_id" : widget.productModel.skus?.first.inAppPurchaseId

            };

            if(Platform.isIOS && (widget.productModel.product?.isPhysical == 0 || widget.productModel.productType == ProductType.GIFT_CARD)){
              /// For in-app purchase
              inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
            }else {
              await cartController.addToCart(data);
            }
            setState(() {
              _isAddingToCart = false;
            });

        }
      },
      child: Platform.isIOS && (widget.productModel.product?.isPhysical == 0 || widget.productModel.productType == ProductType.GIFT_CARD) ?
    Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: AppStyles.pinkColor,
      ),
      child: Text("Buy".tr,style: TextStyle(fontSize: 14.fontSize, color: Colors.white, fontWeight: FontWeight.w500)),
    )  : Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppStyles.pinkColor,
          borderRadius: BorderRadius.circular(5.r),
        ),
        width: 25.w,
        height: 25.w,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _isAddingToCart
              ? Container(
                  height: 20.w,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                )
              : Image.asset(
                  'assets/images/icon_cart_grey.png',
                  width: 20.w,
                  height: 20.w,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
