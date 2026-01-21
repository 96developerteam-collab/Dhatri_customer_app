import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/in-app-purchase_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/amazcart_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_color_convert.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';

class AddToCartWidget extends StatefulWidget {
  final int productID;

  AddToCartWidget(this.productID);

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  final ProductDetailsController controller =
      Get.put(ProductDetailsController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  List<bool> selected = [];

  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    print("Get.isBottomSheetOpen: ${Get.isBottomSheetOpen}");

    if(Platform.isIOS){
      inAppPurchaseController = Get.find();
    }

    getProductDetails();
    super.initState();
  }

  Future getProductDetails() async {
    await controller.getProductDetails2(widget.productID).then((value) {
      controller.itemQuantity.value = controller.products.value.data?.product?.minimumOrderQty ?? 1;
      controller.productId.value = widget.productID;

      controller.products.value.data?.variantDetails?.forEach((element) {
        if (element.name == 'Color') {
          element.code?.forEach((element2) {
            selected.add(false);
            selected[0] = true;
          });
        }
      });

      for (var i = 0;
          i < controller.products.value.data!.variantDetails!.length;
          i++) {
        getSKU.addAll({
          'id[$i]': "${controller.products.value.data?.variantDetails?[i].attrValId?.first}-${controller.products.value.data?.variantDetails?[i].attrId}",
        });
      }
      print(getSKU);

  //   controller.skuGet();
    });
  }

  Map getSKU = {};

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
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
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 1,
            builder: (_, scrollController2) {
              return Obx(() {
                if (controller.isCartLoading.value) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0.r),
                          topRight: Radius.circular(25.0.r),
                        ),
                      ),
                      child: Center(
                        child: CustomLoadingWidget(),
                      ),
                    ),
                  );
                }
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
                                    Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0 ?   "In-App Purchase".tr : 'Add to Cart'.tr,
                                    style: AppStyles.kFontBlack15w4,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Obx(() {
                                  return Row(
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
                                        child: controller.products.value.data
                                                    ?.variantDetails?.length ==
                                                0
                                            ? controller.visibleSKU.value
                                                        .variantImage !=
                                                    null
                                                ? Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        '${controller.visibleSKU.value.variantImage}',
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
                                                  )
                                                : Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        '${controller.products.value.data?.product?.thumbnailImageSource}',
                                                    height: 70.w,
                                                    width: 70.w,
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
                                                  )
                                            : controller.productSKU.value.sku
                                                        ?.variantImage !=
                                                    null
                                                ? Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        '${controller.productSKU.value.sku?.variantImage}',
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
                                                  )
                                                : Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        '${controller.products.value.data?.product?.thumbnailImageSource}',
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
                                              Obx(() {
                                                return Text(
                                                  '${currencyController.setCurrentSymbolPosition(amount: (double.tryParse((controller.finalPrice.value * currencyController.conversionRate.value).toString()) ?? 0).toStringAsFixed(2))}',
                                                  style: AppStyles.kFontPink15w5
                                                      .copyWith(
                                                          fontSize: 18.fontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                );
                                              }),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              controller
                                                          .products
                                                          .value
                                                          .data
                                                          ?.variantDetails
                                                          ?.length ==
                                                      0
                                                  ? Text(
                                                      '${"SKU".tr}: ${controller.visibleSKU.value.sku ?? ''}',
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    )
                                                  : Text(
                                                      '${"SKU".tr}: ${controller.productSKU.value.sku?.sku ?? ''}',
                                                      style: AppStyles
                                                          .kFontBlack14w5),
                                              controller.stockManage.value == 1
                                                  ? Text(
                                                      '${"Stock Available".tr}: ${controller.stockCount.value.toString()}',
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.products.value.data
                                        ?.variantDetails?.length,
                                    itemBuilder: (context, variantIndex) {
                                      ProductVariantDetail variant = controller
                                          .products
                                          .value
                                          .data!
                                          .variantDetails![variantIndex];

                                      // getSKU.addAll({
                                      //   'id[$variantIndex]':
                                      //       "${variant.attrValId.first}-${variant.attrId}",
                                      // });
                                      if (variant.name == 'Color') {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5.w),
                                              child: Text(
                                                '${variant.name?.tr}: ',
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5.w),
                                              child: Wrap(
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                spacing: 10,
                                                runSpacing: 5,
                                                children: List.generate(
                                                    variant.code?.length ?? 0,
                                                    (colorIndex) {
                                                  var bgColor = 0;
                                                  if (!variant.code![colorIndex]
                                                      .contains('#')) {
                                                    bgColor =
                                                        CustomColorConvert()
                                                            .colourNameToHex(
                                                                variant.code![
                                                                    colorIndex]);
                                                  } else {
                                                    bgColor =
                                                        CustomColorConvert()
                                                            .getBGColor(variant
                                                                    .code![
                                                                colorIndex]);
                                                  }
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        selected.clear();
                                                        controller
                                                            .products
                                                            .value
                                                            .data
                                                            ?.variantDetails
                                                            ?.forEach(
                                                                (element) {
                                                          if (element.name ==
                                                              'Color') {
                                                            element.code
                                                                ?.forEach(
                                                                    (element2) {
                                                              selected
                                                                  .add(false);
                                                            });
                                                          }
                                                        });
                                                        selected[colorIndex] =
                                                            !selected[
                                                                colorIndex];
                                                      });
                                                      addValueToMap(
                                                          getSKU,
                                                          'id[$variantIndex]',
                                                          '${variant.attrValId?[colorIndex]}-${variant.attrId}');
                                                      Map data = {
                                                        'product_id': controller
                                                            .products
                                                            .value
                                                            .data
                                                            ?.id,
                                                        'user_id': controller
                                                            .products
                                                            .value
                                                            .data
                                                            ?.userId,
                                                      };
                                                      data.addAll(getSKU);
                                                      await controller
                                                          .getSkuWisePrice(
                                                        data,
                                                      )
                                                          .then((value) {
                                                        if (value == false) {
                                                          setState(() {});
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 50.w,
                                                      height: 50.w,
                                                      padding:
                                                          EdgeInsets.all(5.0.w),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: selected[
                                                                  colorIndex]
                                                              ? AppStyles
                                                                  .pinkColor
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Positioned.fill(
                                                            child: Container(
                                                              width: 30.w,
                                                              height: 30.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                        width: 0.5
                                                                            .w),
                                                                color: Color(
                                                                    bgColor),
                                                              ),
                                                            ),
                                                          ),
                                                          selected[colorIndex]
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                    Icons.done,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16.w,
                                                                    shadows: [
                                                                      Shadow(
                                                                          color: Colors
                                                                              .black,
                                                                          blurRadius:
                                                                              1)
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5.w),
                                              child: Text(
                                                '${variant.name?.tr}: ',
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                            ),
                                            Container(
                                              child: CustomRadioButton(
                                                buttonLables: variant.value,
                                                buttonValues: variant.attrValId,
                                                radioButtonValue:
                                                    (value, index) async {
                                                  addValueToMap(
                                                      getSKU,
                                                      'id[$variantIndex]',
                                                      '$value-${variant.attrId}');
                                                  Map data = {
                                                    'product_id': controller
                                                        .products
                                                        .value
                                                        .data
                                                        ?.id,
                                                    'user_id': controller
                                                        .products
                                                        .value
                                                        .data
                                                        ?.userId,
                                                  };
                                                  data.addAll(getSKU);
                                                  await controller
                                                      .getSkuWisePrice(
                                                    data,
                                                  )
                                                      .then((value) {
                                                    if (value == false) {
                                                      setState(() {});
                                                    }
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
                                                fontSize: 12.fontSize,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),


                          if(controller.products.value.data?.product?.isPhysical == 1)
                            Column(
                              children: [
                                Divider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quantity'.tr,
                                      style: AppStyles.kFontBlack15w4,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            Icons.remove,
                                            color: AppStyles.greyColorDark,
                                            size: 25.w,
                                          ),
                                          onTap: () {
                                            if (controller.itemQuantity.value <=
                                                controller.minOrder.value) {
                                              SnackBars().snackBarWarning(
                                                  "Can't add less than".tr +
                                                      ' ${controller.minOrder.value} ' +
                                                      'Products'.tr);
                                            } else {
                                              controller.cartDecrease();
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
                                                  color: AppStyles.textFieldFillColor,
                                                  width: 1),
                                            ),
                                            padding: EdgeInsets.all(10.w),
                                            child: Obx(() {
                                              return Text(
                                                controller.itemQuantity.value
                                                    .toString(),
                                                style: AppStyles.kFontBlack15w4,
                                              );
                                            })),
                                        SizedBox(width: 10.w),
                                        GestureDetector(
                                          child: Icon(
                                            Icons.add,
                                            color: AppStyles.greyColorDark,
                                            size: 25.w,
                                          ),
                                          onTap: () {

                                            if (controller.stockManage.value == 1) {
                                              if (controller.itemQuantity.value >=
                                                  controller.stockCount.value) {
                                                SnackBars().snackBarWarning(
                                                    'Stock not available.'.tr);
                                              } else {
                                                controller.cartIncrease();
                                              }
                                            } else {
                                              if (controller.maxOrder.value == null) {
                                                controller.cartIncrease();
                                              } else {
                                                if (controller.itemQuantity.value >=
                                                    controller.maxOrder.value) {
                                                  SnackBars().snackBarWarning(
                                                      "Can't add more than".tr +
                                                          ' ${controller.maxOrder.value} ' +
                                                          'Products'.tr);
                                                } else {
                                                  controller.cartIncrease();
                                                }
                                              }
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
                              Obx(() {
                                return controller.stockManage.value == 1
                                    ? PinkButtonWidget(
                                        height: 40.h,
                                        width: 130.w,
                                        btnText: Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0 ? "Buy now".tr : 'Add to Cart'.tr,
                                        btnOnTap: () async {
                                          final LoginController
                                              loginController =
                                              Get.put(LoginController());

                                          if (loginController.loggedIn.value) {
                                            if (controller.stockCount.value >
                                                0) {
                                              if (controller.minOrder.value >
                                                  controller.stockCount.value) {
                                                SnackBars().snackBarWarning(
                                                    'No more stock'.tr);
                                              } else {

                                                Map<String,dynamic> data = {
                                                  'product_id': controller
                                                      .productSkuID.value,
                                                  'qty': controller
                                                      .itemQuantity.value,
                                                  'price': controller
                                                      .productPrice.value,
                                                  'seller_id': controller
                                                      .products
                                                      .value
                                                      .data
                                                      ?.userId,
                                                  'shipping_method_id':
                                                      controller
                                                          .shippingID.value,
                                                  'product_type': 'product',
                                                  'checked': true,
                                                  "in_app_purchase_id" : controller.inAppPurchaseId
                                                };

                                                if(Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0){
                                                  /// For in-app purchase
                                                  inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                                                }else {
                                                  // final CartController
                                                  // cartController =
                                                  // Get.put(CartController());
                                                  final CartController cartController = Get.find();
                                                  await cartController
                                                      .addToCart(data)
                                                      .then((value) {
                                                    if (value) {
                                                      Future.delayed(
                                                          Duration(seconds: 4),
                                                              () {
                                                            Get.back();
                                                          });
                                                    }
                                                  });
                                                }
                                              }
                                            } else {
                                              SnackBars().snackBarWarning(
                                                  'No more stock'.tr);
                                            }
                                          } else {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          }
                                        },
                                      )
                                    : PinkButtonWidget(
                                        height: 40.h,
                                        width: 130.h,
                                        btnText: Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0 ? "Buy now".tr : 'Add to Cart'.tr,
                                        btnOnTap: () async {
                                          final LoginController
                                              loginController = Get.put(LoginController());

                                          if (loginController.loggedIn.value) {

                                            Map<String,dynamic> data = {
                                              'product_id':
                                              controller.productSkuID.value,
                                              'qty':
                                              controller.itemQuantity.value,
                                              'price':
                                              controller.productPrice.value,
                                              'seller_id': controller
                                                  .products.value.data
                                                  ?.userId,
                                              'shipping_method_id':
                                              controller.shippingID.value,
                                              'product_type': 'product',
                                              'checked': true,
                                              "in_app_purchase_id": controller.inAppPurchaseId,
                                            };

                                            if(Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0){

                                              inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);

                                            }else {

                                              print(data);
                                              // final CartController
                                              // cartController =
                                              // Get.put(CartController());

                                              final CartController cartController = Get.find();
                                              await cartController
                                                  .addToCart(data)
                                                  .then((value) {
                                                if (value) {
                                                  Future.delayed(
                                                      Duration(seconds: 3), () {
                                                    print(
                                                        Get.isBottomSheetOpen);
                                                    Get.back(
                                                        closeOverlays: false);
                                                  });
                                                }
                                              }
                                              );
                                            }
                                          } else {
                                            Get.back();
                                            Get.dialog(LoginPage(), useSafeArea: false);
                                          }
                                        },
                                      );
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
