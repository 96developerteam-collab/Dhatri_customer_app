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

  final GeneralSettingsController currencyController = Get.find<GeneralSettingsController>();

  String deliverStateName(Package package) {
    var deliveryStatus = 'Pending'.tr;
    package.processes?.forEach((element) {
      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name ?? "Pending";
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "Pending".tr;
      }
    });
    return deliveryStatus;
  }

  String orderStatusGet(OrderData order) {
    var orderStatus = 'Pending'.tr;

    if (order.isCancelled == 1) {
      orderStatus = "Cancelled".tr;
    } else if (order.isCompleted == 1) {
      orderStatus = 'Completed'.tr;
    } else if (order.isConfirmed == 1) {
      orderStatus = 'Confirmed'.tr;
    } else if (order.isPaid == 1) {
      orderStatus = 'Paid'.tr;
    }
    return orderStatus;
  }

  Color getStatusColor(String status) {
    status = status.toLowerCase();
    if (status.contains('pending')) return Colors.orange;
    if (status.contains('cancelled')) return Colors.red;
    if (status.contains('completed') || status.contains('paid') || status.contains('delivered') || status.contains('confirmed')) return Colors.green;
    return AppStyles.pinkColor;
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) return const SizedBox.shrink();
    final status = orderStatusGet(order!);
    final statusColor = getStatusColor(status);

    return InkWell(
      onTap: () {
        log("OrderDetails ::::: ${order?.toJson()}");
        Get.to(() => OrderDetails(order: order));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            // Order Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            order?.orderNumber?.toUpperCase() ?? '',
                            style: AppStyles.appFontBold.copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_forward_ios, size: 12.sp, color: Colors.grey),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Placed on'.tr + ': ' + CustomDate().formattedDateTime(order?.createdAt),
                        style: AppStyles.appFontBook.copyWith(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: AppStyles.appFontMedium.copyWith(fontSize: 12.sp, color: statusColor),
                    ),
                  ),
                ],
              ),
            ),

            // Packages
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: order?.packages?.length ?? 0,
              itemBuilder: (context, packageIndex) {
                final package = order!.packages![packageIndex];
                final pStatus = deliverStateName(package);
                final pStatusColor = getStatusColor(pStatus);

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.05))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   children: [
                          //     Image.asset(
                          //       'assets/images/icon_delivery-parcel.png',
                          //       width: 16.w,
                          //       height: 16.w,
                          //     ),
                          //     SizedBox(width: 8.w),
                          //     Text(
                          //       package.packageCode ?? '',
                          //       style: AppStyles.appFontBold.copyWith(fontSize: 13.sp),
                          //     ),
                          //   ],
                          // ),
                          // Text(
                          //   pStatus,
                          //   style: AppStyles.appFontMedium.copyWith(
                          //     fontSize: 12.sp,
                          //     color: pStatusColor,
                          //     fontStyle: FontStyle.italic,
                          //   ),
                          // ),
                        ],
                      ),
                      if (currencyController.vendorType.value != "single")
                        Padding(
                          padding: EdgeInsets.only(left: 24.w, top: 4.h),
                          child: Text(
                            'Sold by'.tr + ': ' + '${package.seller?.firstName}',
                            style: AppStyles.appFontMedium.copyWith(fontSize: 12.sp, color: Colors.grey[700]),
                          ),
                        ),
                      
                      SizedBox(height: 12.h),

                      // Products
                      ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: package.products?.length ?? 0,
                        itemBuilder: (context, productIndex) {
                          final product = package.products![productIndex];
                          final isGiftCard = product.type == ProductType.GIFT_CARD;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Container(
                                  height: 60.w,
                                  width: 60.w,
                                  child: FancyShimmerImage(
                                    imageUrl: isGiftCard
                                        ? AppConfig.assetPath + '/' + '${product.giftCard?.thumbnailImage}'
                                        : (product.sellerProductSku?.sku?.variantImage != null
                                            ? '${AppConfig.assetPath}/${product.sellerProductSku?.sku?.variantImage}'
                                            : '${AppConfig.assetPath}/${product.sellerProductSku?.product?.product?.thumbnailImageSource}'),
                                    boxFit: BoxFit.cover,
                                    errorWidget: Image.asset("assets/images/placeholder.png", fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isGiftCard ? (product.giftCard?.name ?? '') : (product.sellerProductSku?.product?.productName ?? ''),
                                      style: AppStyles.appFontMedium.copyWith(fontSize: 13.sp),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (!isGiftCard)
                                      ...(product.sellerProductSku?.productVariations ?? []).map((v) => Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Text(
                                          '${v.attribute?.name}: ${v.attributeValue?.name ?? v.attributeValue?.value ?? ''}',
                                          style: AppStyles.appFontBook.copyWith(fontSize: 11.sp, color: Colors.grey),
                                        ),
                                      )).toList(),
                                    SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${currencyController.setCurrentSymbolPosition(amount: ((product.price ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2))} x ${product.qty}',
                                          style: AppStyles.appFontBold.copyWith(fontSize: 13.sp, color: AppStyles.pinkColor),
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

            // Footer
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${order?.packages?.length} ' + 'Package'.tr + ', ' + 'Total'.tr + ': ',
                      style: AppStyles.appFontBook.copyWith(fontSize: 13.sp),
                      children: [
                        TextSpan(
                          text: currencyController.setCurrentSymbolPosition(
                            amount: ((order?.grandTotal ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2),
                          ),
                          style: AppStyles.appFontBold.copyWith(fontSize: 15.sp, color: AppStyles.pinkColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
