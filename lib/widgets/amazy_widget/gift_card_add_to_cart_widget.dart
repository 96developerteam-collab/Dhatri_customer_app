import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/in-app-purchase_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/AllGiftCardsModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';
class GiftCardAddToCartWidget extends StatefulWidget {
  final GiftCardsUIModel giftCardsUIModel;

  GiftCardAddToCartWidget(this.giftCardsUIModel);

  @override
  _GiftCardAddToCartWidgetState createState() =>
      _GiftCardAddToCartWidgetState();
}

class _GiftCardAddToCartWidgetState extends State<GiftCardAddToCartWidget> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  int quantity = 1;
  int selectedVariationIndex = 0;

  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    if (Platform.isIOS) {
      inAppPurchaseController = Get.find();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: DraggableScrollableSheet(
            initialChildSize: 0.60,
            minChildSize: 0.5,
            maxChildSize: 1,
            builder: (_, scrollController2) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0.r),
                      topRight: Radius.circular(25.0.r),
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: scrollController2,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xffDADADA),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30.r),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              Center(
                                child: Text(
                                  Platform.isIOS ?  "In-App Purchase".tr : 'Add to Cart'.tr,
                                  style: AppStyles.kFontBlack15w4,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppStyles.darkBlueColor,
                                      ),
                                    ),
                                    child:  Image.network(
                                      AppConfig.assetPath +
                                          '/' +
                                          '${widget.giftCardsUIModel.thumbnailImage}',
                                      height: 70.w,
                                      width: 70.w,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (BuildContext context,
                                          Object exception,
                                          StackTrace?
                                          stackTrace) {
                                        return Image.asset(
                                          AppConfig.appLogo,
                                          height: 70.w,
                                          width: 70.w,
                                          errorBuilder:
                                              (BuildContext
                                          context,
                                              Object
                                              exception,
                                              StackTrace?
                                              stackTrace) {
                                            return Text(
                                                'Error fetching Image'
                                                    .tr);
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(5.w),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${currencyController.setCurrentSymbolPosition(amount: (double.tryParse(((widget.giftCardsUIModel.skus![selectedVariationIndex].sellingPrice??0) * currencyController.conversionRate.value).toString()) ?? 0).toStringAsFixed(2))}',
                                            style: AppStyles.kFontPink15w5
                                                .copyWith(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            '${"SKU".tr}: ${widget.giftCardsUIModel.sku??""}',
                                            style: AppStyles
                                                .kFontBlack14w5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    
                                          Text(
                                            'In Stock'.tr,
                                            style: AppStyles
                                                .kFontBlack14w5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                              10.verticalSpace,
                              Container(
                                margin: EdgeInsets.all(5.w),
                                child: Text(
                                  '${"Price".tr}: ',
                                  style: AppStyles.kFontBlack14w5,
                                ),
                              ),
                              Container(
                                child: CustomRadioButton(
                                  buttonLables: widget.giftCardsUIModel.skus?.map((v)=> (v.sellingPrice??0).toString()).toList()??[],
                                  buttonValues: widget.giftCardsUIModel.skus?.map((v)=> (v.sellingPrice??0).toString()).toList()??[],
                                  radioButtonValue: (value, index) async {
                                    setState(() {
                                      selectedVariationIndex = index;
                                    });
                                  },
                                  horizontal: true,
                                  enableShape: false,
                                  buttonSpace: 0,
                                  buttonColor: Colors.white,
                                  selectedColor:
                                  AppStyles.pinkColor,
                                  elevation: 3,
                                  buttonHeight: 30.h,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),



                        if (Platform.isAndroid)
                          Column(
                            children: [
                              Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quantity'.tr,
                                    style: AppStyles.kFontBlack15w4,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Icon(
                                          Icons.remove,
                                          color: AppStyles.greyColorDark,
                                          size: 25.w,
                                        ),
                                        onTap: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        },
                                      ),
                                      SizedBox(width: 10.w),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: AppStyles.lightBlueColorAlt,
                                          border: Border.all(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                              width: 1),
                                        ),
                                        padding: EdgeInsets.all(10.w),
                                        child: Text(
                                          quantity.toString(),
                                          style: AppStyles.kFontBlack15w4,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      GestureDetector(
                                        child: Icon(
                                          Icons.add,
                                          color: AppStyles.greyColorDark,
                                          size: 25.w,
                                        ),
                                        onTap: () {
                                          if (quantity >= 20) {
                                            SnackBars().snackBarWarning(
                                                "Can't add more than".tr +
                                                    ' ${quantity} ' +
                                                    'Products'.tr);
                                          } else {
                                            setState(() {
                                              quantity++;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PinkButtonWidget(
                              height: 40.h,
                              width: 130.h,
                              btnText: Platform.isIOS
                                  ? "Buy now".tr
                                  : 'Add to Cart'.tr,
                              btnOnTap: () async {

                                Map<String, dynamic> data = {
                                  "product_id": widget.giftCardsUIModel.skus?[selectedVariationIndex].productId,
                                  "product_sku_id": widget.giftCardsUIModel.skus?[selectedVariationIndex].productSkuId,
                                  "qty": 1,
                                  "price": widget.giftCardsUIModel.skus?[selectedVariationIndex].sellingPrice,
                                  "seller_id": 1,
                                  "product_type": "gift_card",
                                  "gift_card_type": widget
                                      .giftCardsUIModel.skus?[selectedVariationIndex].type,
                                  "checked": 1,
                                  "in_app_purchase_id": widget
                                      .giftCardsUIModel
                                      .skus
                                      ?[selectedVariationIndex]
                                      .inAppPurchase
                                };

                                  if (Platform.isIOS) {
                                    inAppPurchaseController
                                        .onInAppPurchaseProduct(
                                            productInfo: data);
                                  } else {

                                    // final CartController cartController =
                                    //     Get.put(CartController());
                                    final CartController cartController = Get.find();
                                    await cartController
                                        .addToCart(data)
                                        .then((value) {
                                      if (value) {
                                        Future.delayed(Duration(seconds: 3),
                                            () {
                                          Get.back(closeOverlays: false);
                                        });
                                      }
                                    });

                                  }

                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
