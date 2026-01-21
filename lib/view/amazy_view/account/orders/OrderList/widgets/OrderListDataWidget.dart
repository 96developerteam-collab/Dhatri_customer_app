import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../AppConfig/app_config.dart';
import '../../../../../../controller/settings_controller.dart';
import '../../../../../../model/NewModel/Order/OrderData.dart';
import '../../../../../../../model/NewModel/Order/Package.dart';

import '../../../../../../model/NewModel/Product/ProductType.dart';
import '../../../../../../utils/styles.dart';
import '../../../../../../widgets/amazy_widget/CustomDate.dart';
import '../../OrderDetails.dart';

class OrderAllToPayListDataWidget extends StatelessWidget {
  OrderAllToPayListDataWidget({this.order});
  final OrderData? order;

  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());

  String deliverStateName(Package package) {
    var deliveryStatus = 'Pending';
    package.processes?.forEach((element) {
      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name ?? "Pending";
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  String orderStatusGet(OrderData order) {
    var orderStatus;

    if (order.isCancelled == 0 &&
        order.isCompleted == 0 &&
        order.isConfirmed == 0 &&
        order.isPaid == 0) {
      orderStatus = 'Pending'.tr;
    } else {
      if (order.isCancelled == 1) {
        orderStatus = "Cancelled".tr;
      }
      if (order.isCompleted == 1) {
        orderStatus = 'Completed'.tr;
      }
      if (order.isConfirmed == 1) {
        orderStatus = 'Confirmed'.tr;
      }
      if (order.isPaid == 1) {
        orderStatus = 'Paid'.tr;
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        log("OrderDetails ::::: ${order?.toJson()}");
        Get.to(() => OrderDetails(
          order: order,
        ));

      },
      child: Container(
        color: context.theme.cardColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order?.orderNumber?.capitalizeFirst ?? '',
                          style: AppStyles.kFontBlack15w4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15.w,
                          color: AppStyles.blackColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.2,
                    ),
                    Text(
                      'Placed on'.tr +
                          ': ' +
                          CustomDate().formattedDateTime(order?.createdAt),
                      style: AppStyles.kFontBlack12w4,
                    ),
                    SizedBox(
                      height: 5.2.h,
                    ),
                  ],
                ),
                Expanded(child: Container()),
                // Text(
                //   '${orderStatusGet(order!)}',
                //   style: AppStyles.kFontBlack12w4,
                // ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: order?.packages?.length,
                itemBuilder: (context, packageIndex) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_delivery-parcel.png',
                                        width: 17.w,
                                        height: 17.w,
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        order?.packages?[packageIndex].packageCode ?? '',
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                  currencyController.vendorType.value ==
                                      "single"
                                      ? SizedBox.shrink()
                                      : Padding(
                                    padding: EdgeInsets.only(
                                        left: 26.0.w, top: 5.h),
                                    child: Text('Sold by'.tr + ': ' + '${order?.packages?[packageIndex].seller?.firstName}',
                                      style: AppStyles.kFontBlack14w5,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 26.0.w, top: 5.h),
                                    child: Text(
                                      order?.packages?[packageIndex].shippingDate ?? '',
                                      style: AppStyles.kFontBlack12w4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   deliverStateName(order!.packages![packageIndex]),
                            //   textAlign: TextAlign.center,
                            //   style: AppStyles.kFontDarkBlue12w5
                            //       .copyWith(fontStyle: FontStyle.italic),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: AppStyles.appBackgroundColor,
                                height: 2.h,
                                thickness: 2,
                              );
                            },
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 26.0.w),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order?.packages?[packageIndex].products?.length ?? 0,
                            itemBuilder: (context, productIndex) {
                              if (order?.packages?[packageIndex].products?[productIndex].type == ProductType.GIFT_CARD) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                        child: Container(
                                            height: 80.w,
                                            width: 80.w,
                                            child: FancyShimmerImage(
                                              imageUrl: AppConfig.assetPath + '/' + '${order?.packages?[packageIndex].products?[productIndex].giftCard?.thumbnailImage}',
                                              boxFit: BoxFit.contain,
                                              errorWidget: FancyShimmerImage(
                                                imageUrl:
                                                "${AppConfig.assetPath}/backend/img/default.png",
                                                boxFit: BoxFit.contain,
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order?.packages?[packageIndex].products?[productIndex].giftCard?.name ?? '',
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Obx(() {
                                                    return Text(
                                                      '${currencyController.setCurrentSymbolPosition(amount: ((order?.packages?[packageIndex].products?[productIndex].price??0) * currencyController.conversionRate.value).toString())}',
                                                      style: AppStyles
                                                          .kFontPink15w5,
                                                    );
                                                  }),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                        child: Container(
                                          height: 80.w,
                                          width: 80.w,
                                          child: FancyShimmerImage(
                                            imageUrl: order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.sku?.variantImage !=
                                                null
                                                ? '${AppConfig.assetPath}/${order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.sku?.variantImage}'
                                                : '${AppConfig.assetPath}/${order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.product?.product?.thumbnailImageSource}',
                                            boxFit: BoxFit.contain,
                                            errorWidget: FancyShimmerImage(
                                              imageUrl:
                                              "${AppConfig.assetPath}/backend/img/default.png",
                                              boxFit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.product?.productName ?? '',
                                                style: AppStyles.kFontBlack14w5,
                                              ),

                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                NeverScrollableScrollPhysics(),
                                                itemCount: order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.productVariations?.length ?? 0,
                                                itemBuilder:
                                                    (context, variantIndex) {
                                                  // if (order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attribute?.name == 'Color') {
                                                  //   return Padding(
                                                  //     padding: const EdgeInsets
                                                  //             .symmetric(
                                                  //         vertical: 4.0),
                                                  //     child: Text(
                                                  //       'Color: ${order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue?.color?.name??''}',
                                                  //       style: AppStyles
                                                  //           .kFontBlack12w4,
                                                  //     ),
                                                  //   );
                                                  // }
                                                  // else {

                                                  var attributeValue = order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue;
                                                  var attribute = order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attribute;

                                                  return Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        vertical: 4.0.h),
                                                    child: Text(
                                                      '${attribute?.name??''}: ${attributeValue?.name??attributeValue?.value??''}',
                                                      style: AppStyles
                                                          .kFontBlack12w4,
                                                    ),
                                                  );

                                                },
                                              ),

                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Obx(() {
                                                            return Text(
                                                              '${currencyController.setCurrentSymbolPosition(amount: ((order?.packages?[packageIndex].products?[productIndex].price??0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                                                              style: AppStyles
                                                                  .kFontPink15w5,
                                                            );
                                                          }),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            '(${order?.packages?[packageIndex].products?[productIndex].qty}x)',
                                                            style: AppStyles
                                                                .kFontBlack14w5,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  // Text(
                                                  //   '=\$${orderController.orderListModel.value.orders[index].packages[packageIndex].products[productIndex].totalPrice}',
                                                  //   style: AppStyles
                                                  //       .kFontBlack14w5,
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${order?.packages?.length} ' +
                      'Package'.tr +
                      ',' +
                      'Total'.tr +
                      ': ' +
                      currencyController.setCurrentSymbolPosition(amount: ((order?.grandTotal??0) * currencyController.conversionRate.value).toStringAsFixed(2)),
                  style: AppStyles.kFontBlack14w5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
