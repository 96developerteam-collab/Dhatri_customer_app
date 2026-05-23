import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cancelled_order_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/account/orders/OrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../model/NewModel/Order/OrderData.dart';
import '../../../../model/NewModel/Order/Package.dart';
import '../../../../model/NewModel/Product/ProductType.dart';
import '../../../../widgets/amazy_widget/AppBarWidget.dart';
import '../../../../widgets/amazy_widget/custom_loading_widget.dart';
import '../../../../widgets/amazy_widget/CustomDate.dart';

class MyCancellations extends StatefulWidget {
  @override
  _MyCancellationsState createState() => _MyCancellationsState();
}

class _MyCancellationsState extends State<MyCancellations> {
  final CancelledOrderController cancelledController =
      Get.put(CancelledOrderController());

  final GeneralSettingsController _currencyController =
      Get.put(GeneralSettingsController());

  String deliverStateName(Package package) {
    var deliveryStatus = '';
    package.processes?.forEach((element) {
      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name ?? '';
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
      } else if (order.isCompleted == 1) {
        orderStatus = 'Completed'.tr;
      } else if (order.isConfirmed == 1) {
        orderStatus = 'Confirmed'.tr;
      } else if (order.isPaid == 1) {
        orderStatus = 'Paid'.tr;
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Cancelled Orders'.tr,
        showCart: false,
      ),
      body: Obx(
        () {
          if (cancelledController.isAllOrderLoading.value) {
            return Center(
              child: CustomLoadingWidget(),
            );
          } else {
            if (cancelledController.cancelledOrderListModel.value.orders ==
                    null ||
                cancelledController
                        .cancelledOrderListModel.value.orders?.length ==
                    0) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.exclamation,
                      color: AppStyles.pinkColor,
                      size: 25.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'No Cancelled Orders'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontPink15w5.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              physics: BouncingScrollPhysics(),
              itemCount: cancelledController
                  .cancelledOrderListModel.value.orders!.length,
              itemBuilder: (context, index) {
                var order = cancelledController
                    .cancelledOrderListModel.value.orders![index];

                Color statusColor = Color(0xFFFF9800); // Orange by default (Pending)
                final statusText = orderStatusGet(order);
                if (statusText.toLowerCase() == "cancelled".tr.toLowerCase() ||
                    statusText.toLowerCase() == "cancelled".toLowerCase()) {
                  statusColor = Color(0xFFE53935); // Red
                } else if (statusText.toLowerCase() == "completed".tr.toLowerCase() ||
                    statusText.toLowerCase() == "completed".toLowerCase()) {
                  statusColor = Color(0xFF4CAF50); // Green
                }

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  elevation: 1,
                  shadowColor: Colors.black.withOpacity(0.04),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => OrderDetails(
                                  order: order,
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          order.orderNumber!.capitalizeFirst!,
                                          style: AppStyles.appFontMedium.copyWith(
                                            fontSize: 16.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12.w,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Placed on'.tr +
                                          ': ' +
                                          (order.createdAt != null
                                              ? CustomDate().formattedDateTime(
                                                  order.createdAt!.toLocal())
                                              : ''),
                                      style: AppStyles.appFontBook.copyWith(
                                        fontSize: 12.fontSize,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                      color: statusColor.withOpacity(0.4),
                                      width: 1.w),
                                ),
                                child: Text(
                                  statusText,
                                  style: AppStyles.appFontMedium.copyWith(
                                    fontSize: 12.fontSize,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.15),
                          height: 24.h,
                          thickness: 1,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: order.packages?.length ?? 0,
                          itemBuilder: (context, packageIndex) {
                            var package = order.packages![packageIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sold by'.tr +
                                      ': ${package.seller?.firstName ?? "Seller"}',
                                  style: AppStyles.appFontBook.copyWith(
                                    fontSize: 13.fontSize,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: package.products?.length ?? 0,
                                  itemBuilder: (context, productIndex) {
                                    var product =
                                        package.products![productIndex];
                                    String name = "";
                                    String imageUrl = "";
                                    double price = 0.0;

                                    if (product.type == ProductType.GIFT_CARD) {
                                      name = product.giftCard?.name ?? "";
                                      imageUrl =
                                          '${AppConfig.assetPath}/${product.giftCard?.thumbnailImage ?? ""}';
                                      price = product.giftCard?.sellingPrice ??
                                          0.0;
                                    } else {
                                      name = product.sellerProductSku?.product
                                              ?.productName ??
                                          "";
                                      imageUrl =
                                          '${AppConfig.assetPath}/${product.sellerProductSku?.product?.product?.thumbnailImageSource ?? ""}';
                                      price = product.price ?? 0.0;
                                    }

                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            child: Container(
                                              height: 70.w,
                                              width: 70.w,
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Container(
                                                  color: Colors.grey[100],
                                                  child: Icon(Icons.image,
                                                      color: Colors.grey[400]),
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
                                                  name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppStyles
                                                      .appFontMedium
                                                      .copyWith(
                                                    fontSize: 14.fontSize,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  '${_currencyController.appCurrency.value}${((price) * _currencyController.conversionRate.value).toStringAsFixed(2)} x ${product.qty}',
                                                  style: AppStyles.appFontMedium
                                                      .copyWith(
                                                    fontSize: 14.fontSize,
                                                    color: Color(0xFF2E7D32),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.15),
                          height: 24.h,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 14.fontSize,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                      text:
                                          '${order.packages?.length ?? 0} ${"Package".tr}, '),
                                  TextSpan(
                                    text:
                                        '${"Total".tr}: ${_currencyController.appCurrency.value}${(order.grandTotal! * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 14.fontSize,
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}
