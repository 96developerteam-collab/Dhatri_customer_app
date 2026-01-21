import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderProductElement.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../OrderToShipDetails.dart';

class OrderToShipReceiveWidget extends StatelessWidget {
  OrderToShipReceiveWidget({this.package});
  final Package? package;

  final GeneralSettingsController currencyController = Get.put(GeneralSettingsController());

  String deliverStateName(Package package) {
    var deliveryStatus = 'Pending';
    package.processes?.forEach((element) {

      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name ?? 'Pending';
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  double calculateTotalProductPrice(List<OrderProductElement> products) {
    double priceTotal = 0.0;
    products.forEach((element) {
      priceTotal = priceTotal + (element.totalPrice??0);
    });
    return priceTotal;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => OrderToShipDetails(
                package: package!,
              ));
            },
            child: Row(
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
                            package?.packageCode ?? '',
                            style: AppStyles.kFontBlack14w5,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15.w,
                            color: AppStyles.blackColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 26.0, top: 5),
                        child: Text(
                          package?.shippingDate ?? '',
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  deliverStateName(package!),
                  textAlign: TextAlign.center,
                  style: AppStyles.kFontDarkBlue12w5
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),

          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 26),
              itemCount: package?.products?.length??0,
              itemBuilder: (context, productIndex) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Container(
                            height: 80.w,
                            width: 80.w,
                            child: FancyShimmerImage(
                              imageUrl: package?.products?[productIndex].sellerProductSku?.sku?.variantImage !=
                                  null
                                  ? '${AppConfig.assetPath}/${package?.products?[productIndex].sellerProductSku?.sku?.variantImage}'
                                  : '${AppConfig.assetPath}/${package?.products?[productIndex].sellerProductSku?.product?.product?.thumbnailImageSource}',
                              boxFit: BoxFit.contain,
                              errorWidget: FancyShimmerImage(imageUrl: "${AppConfig.assetPath}/backend/img/default.png",
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package?.products?[productIndex].sellerProductSku?.product?.productName ?? '',
                                style: AppStyles.kFontBlack14w5,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: package?.products?[productIndex].sellerProductSku?.productVariations?.length??0,
                                itemBuilder: (context, variantIndex) {
                                  if (package?.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attribute?.name == 'Color') {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        'Color'.tr + ': ${package?.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue?.value??''}',
                                        style: AppStyles.kFontBlack12w4,
                                      ),
                                    );


                                  }
                                  else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        '${package?.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attribute?.name}' +
                                            ': ${package?.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue?.value}',
                                        style: AppStyles.kFontBlack12w4,
                                      ),
                                    );

                                    return Text("Attribute");
                                  }
                                },
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${currencyController.setCurrentSymbolPosition(amount: ((package?.products?[productIndex].price??0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                                            style: AppStyles.kFontPink15w5,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            '(${package?.products?[productIndex].qty}x)',
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                '${package?.products?.length} ' +
                    'Products'.tr +
                    ',' +
                    'Total'.tr +
                    ': ' +
                    currencyController.setCurrentSymbolPosition(amount: (package!.order!.grandTotal! *
                        currencyController.conversionRate.value)
                        .toStringAsFixed(2)),
                style: AppStyles.kFontBlack14w5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
