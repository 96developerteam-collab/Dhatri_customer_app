import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/order_refund_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../model/MyPurchasedGiftCards.dart';
import '../../../../../widgets/amazy_widget/AppBarWidget.dart';
import '../../../../../widgets/amazy_widget/CustomDate.dart';
import '../../../../../widgets/amazy_widget/custom_loading_widget.dart';
import 'RefundDetails.dart';

class MyRefundsAndDisputes extends StatefulWidget {
  @override
  _MyRefundsAndDisputesState createState() => _MyRefundsAndDisputesState();
}

class _MyRefundsAndDisputesState extends State<MyRefundsAndDisputes> {
  final OrderRefundController orderRefundController =
  Get.put(OrderRefundController());

  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());

  String refundOrderstatusGet(Order order) {
    var refundOrderstatus;

    if (order.isCancelled == 0 &&
        order.isCompleted == 0 &&
        order.isConfirmed == 0 &&
        order.isPaid == 0) {
      refundOrderstatus = 'Pending'.tr;
    } else {
      if (order.isCancelled == 1) {
        refundOrderstatus = "Cancelled".tr;
      } else if (order.isCompleted == 1) {
        refundOrderstatus = 'Completed'.tr;
      } else if (order.isConfirmed == 1) {
        refundOrderstatus = 'Confirmed'.tr;
      } else if (order.isPaid == 1) {
        refundOrderstatus = 'Paid'.tr;
      }
    }
    return refundOrderstatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Refunds and Disputes'.tr, showCart: false),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Light green
              Color(0xFFF1F8F4), // Greenish-white
              Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: Obx(
          () {
            if (orderRefundController.isAllOrderLoading.value) {
              return Center(
                child: CustomLoadingWidget(),
              );
            } else {
              if (orderRefundController.refundOrderListModel.value.refundOrders ==
                      null ||
                  orderRefundController
                          .refundOrderListModel.value.refundOrders?.length ==
                      0) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.receipt,
                          color: Color(0xFF4CAF50),
                          size: 40.w,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'No Refund Orders'.tr,
                        textAlign: TextAlign.center,
                        style: AppStyles.appFontBold.copyWith(
                          fontSize: 18.sp,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'You have no refund requests at the moment'.tr,
                        textAlign: TextAlign.center,
                        style: AppStyles.appFontBook.copyWith(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12.h);
                },
                itemCount: orderRefundController
                        .refundOrderListModel.value.refundOrders?.length ??
                    0,
                itemBuilder: (context, index) {
                  var refundOrder = orderRefundController
                      .refundOrderListModel.value.refundOrders![index];
                  var status = refundOrder.checkConfirmed ?? '';
                  Color statusColor = status.toLowerCase().contains('approved')
                      ? Colors.green
                      : status.toLowerCase().contains('rejected')
                          ? Colors.red
                          : Colors.orange;

                  return InkWell(
                    onTap: () {
                      Get.to(() => RefundDetails(refundOrder: refundOrder));
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF0F9F4), // Light greenish-white
                            Color(0xFFFFFFFF), // Pure white
                            Color(0xFFF5FFF9), // Very light green tint
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFE8F5E9).withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE8F5E9),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            refundOrder.order?.orderNumber
                                                    ?.toUpperCase() ??
                                                '',
                                            style: AppStyles.appFontBold.copyWith(
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12.sp,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'Refund Requested on'.tr +
                                            ': ' +
                                            CustomDate().formattedDateTime(
                                                refundOrder.createdAt),
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: statusColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    status.tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 12.sp,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Refund Details
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: refundOrder.refundDetails?.length ?? 0,
                              itemBuilder: (context, packageIndex) {
                                var refundDetail =
                                    refundOrder.refundDetails![packageIndex];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Package Info
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.inventory_2_outlined,
                                            size: 16.sp,
                                            color: Color(0xFF4CAF50),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            refundDetail.orderPackage
                                                    ?.packageCode ??
                                                '',
                                            style: AppStyles.appFontBold.copyWith(
                                              fontSize: 13.sp,
                                              color: Color(0xFF4CAF50),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (currencyController.vendorType.value !=
                                          "single")
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 24.w,
                                            top: 4.h,
                                          ),
                                          child: Text(
                                            'Sold by'.tr +
                                                ': ' +
                                                '${refundDetail.seller?.firstName ?? ''}',
                                            style: AppStyles.appFontBook.copyWith(
                                              fontSize: 12.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 12.h),

                                      // Products
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 12.h),
                                        itemCount:
                                            refundDetail.refundProducts?.length ??
                                                0,
                                        itemBuilder: (context, productIndex) {
                                          var product = refundDetail
                                              .refundProducts![productIndex];
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: Container(
                                                  height: 70.w,
                                                  width: 70.w,
                                                  child: FancyShimmerImage(
                                                    imageUrl: AppConfig
                                                            .assetPath +
                                                        '/' +
                                                        '${product.sellerProductSku?.product?.product?.thumbnailImageSource}',
                                                    boxFit: BoxFit.cover,
                                                    errorWidget: Image.asset(
                                                      "assets/images/placeholder.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product
                                                              .sellerProductSku
                                                              ?.product
                                                              ?.productName ??
                                                          '',
                                                      style: AppStyles.appFontMedium
                                                          .copyWith(
                                                        fontSize: 13.sp,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    // Variations
                                                    ...(product
                                                                .sellerProductSku
                                                                ?.productVariations ??
                                                            [])
                                                        .map((v) => Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 2.h),
                                                              child: Text(
                                                                '${v.attribute?.name ?? ''}: ${v.attributeValue?.name ?? v.attributeValue?.value ?? ''}',
                                                                style: AppStyles
                                                                    .appFontBook
                                                                    .copyWith(
                                                                  fontSize: 11.sp,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    SizedBox(height: 6.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          currencyController
                                                              .setCurrentSymbolPosition(
                                                            amount: ((product
                                                                            .returnAmount ??
                                                                        0) *
                                                                    currencyController
                                                                        .conversionRate
                                                                        .value)
                                                                .toStringAsFixed(
                                                                    2),
                                                          ),
                                                          style: AppStyles
                                                              .appFontBold
                                                              .copyWith(
                                                            fontSize: 14.sp,
                                                            color: Color(
                                                                0xFF4CAF50),
                                                          ),
                                                        ),
                                                        SizedBox(width: 6.w),
                                                        Text(
                                                          '(${product.returnQty}x)',
                                                          style: AppStyles
                                                              .appFontBook
                                                              .copyWith(
                                                            fontSize: 12.sp,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
