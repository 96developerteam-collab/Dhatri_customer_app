import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/account/orders/OrderCancelWidget.dart';
import 'package:amazcart/view/amazy_view/account/orders/RefundAndDisputes/OrderToReturn.dart';
import 'package:amazcart/view/amazy_view/account/orders/OrderTrack.dart';
import 'package:amazcart/view/amazy_view/account/reviews/WriteReview.dart';
import 'package:amazcart/view/amazy_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazy_view/products/product/product_details.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/amazy_widget/AppBarWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:amazcart/model/DeliveryProcess.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../../model/NewModel/Order/OrderData.dart';
import '../../../../model/NewModel/Order/OrderProductElement.dart';
import '../../../../model/NewModel/Order/Package.dart';
import '../../../../model/NewModel/Product/ProductType.dart';
import '../../../../widgets/amazy_widget/CustomDate.dart';


class OrderDetails extends StatefulWidget {
  final OrderData? order;

  OrderDetails({this.order});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());

  String deliverStateName(Package package) {
    var deliveryStatus = 'Pending';
    package.processes?.forEach((element) {
      if (element.id == package.deliveryStatus) {
        deliveryStatus = element.name ?? 'Pending';
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  bool checkReview(Package package) {
    // print(package.deliveryStates);
    if (package.deliveryStates?.length != 0) {
      // print('${package.processes.last.id} == ${package.deliveryStatus}');
      if (package.processes?.last.id == package.deliveryStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  RecommendedProductsLoadMore? source;

  RxBool nowOrderIsCanceled = false.obs;

  @override
  void initState() {
    nowOrderIsCanceled.value = widget.order?.isCancelled == 1;
    source = RecommendedProductsLoadMore();
    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(title: 'Order Details'.tr),
      body: LoadingMoreCustomScrollView(
        reverse: true,
        showGlowLeading: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 10.h,
                ),

                ///BILL TO
                ///BILL TO AND SHIP TO
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_long, color: AppStyles.pinkColor, size: 20.w),
                              SizedBox(width: 8.w),
                              Text(
                                'Bill to'.tr,
                                style: AppStyles.kFontPink15w5.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '${widget.order?.orderAddress?.billingName ?? ""}',
                            style: AppStyles.kFontBlack14w5,
                          ),
                          Text(
                            '${widget.order?.orderAddress?.billingEmail ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          Text(
                            '${widget.order?.orderAddress?.billingPhone ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Address".tr +
                                ': ${widget.order?.orderAddress?.billingAddress ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          Text(
                            "State".tr +
                                ': ${widget.order?.orderAddress?.getBillingState?.name ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          Text(
                            '${widget.order?.orderAddress?.getBillingCity?.name ?? ""}, ${widget.order?.orderAddress?.getBillingCountry?.name ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Divider(color: Colors.grey.shade200, thickness: 1),
                          ),

                          Row(
                            children: [
                              Icon(Icons.local_shipping_outlined, color: AppStyles.pinkColor, size: 20.w),
                              SizedBox(width: 8.w),
                              Text(
                                widget.order?.deliveryType == "home_delivery"
                                    ? 'Ship to'.tr
                                    : "Collect from".tr,
                                style: AppStyles.kFontPink15w5.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '${widget.order?.orderAddress?.shippingName ?? ""}',
                            style: AppStyles.kFontBlack14w5,
                          ),
                          Text(
                            '${widget.order?.orderAddress?.shippingEmail ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          Text(
                            '${widget.order?.orderAddress?.shippingPhone ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Address".tr +
                                ': ${widget.order?.orderAddress?.shippingAddress ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          Text(
                            "State".tr +
                                ': ${widget.order?.orderAddress?.getShippingState?.name ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                          Text(
                            '${widget.order?.orderAddress?.getShippingCity?.name ?? ""}, ${widget.order?.orderAddress?.getShippingCountry?.name ?? ""}',
                            style: AppStyles.kFontBlack12w4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// PACKAGE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.order?.packages?.length ?? 0,
                      itemBuilder: (context, packageIndex) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget
                                      .order
                                      ?.packages?[packageIndex]
                                      .products
                                      ?.length ??
                                      0,
                                  itemBuilder: (context, productIndex) {
                                    if (widget.order?.packages?[packageIndex]
                                        .products?[productIndex].type ==
                                        ProductType.GIFT_CARD) {
                                      return Card(
                                        elevation: 1,
                                        margin:
                                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.r)),
                                        ),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(5)),
                                                    child: Container(
                                                        height: 80.w,
                                                        width: 80.w,
                                                        child: Image.network(
                                                          AppConfig.assetPath +
                                                              '/' +
                                                              '${widget.order?.packages?[packageIndex].products?[productIndex].giftCard?.thumbnailImage}',
                                                          fit: BoxFit.contain,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 15.w,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            widget
                                                                .order
                                                                ?.packages?[
                                                            packageIndex]
                                                                .products?[
                                                            productIndex]
                                                                .giftCard
                                                                ?.name ??
                                                                '',
                                                            style: AppStyles
                                                                .kFontBlack14w5,
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
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Text(
                                                                    '${currencyController.setCurrentSymbolPosition(amount: ((widget.order?.packages?[packageIndex].products?[productIndex].price ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                                                                    style: AppStyles
                                                                        .kFontPink15w5,
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child:
                                                                Container(),
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
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => ProductDetails(
                                            productID: widget
                                                .order
                                                ?.packages?[
                                            packageIndex]
                                                .products?[productIndex]
                                                .sellerProductSku
                                                ?.product
                                                ?.id ??
                                                0,
                                          ));
                                        },
                                        child: Card(
                                          elevation: 1,
                                          margin:
                                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.r)),
                                          ),
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.r)),
                                                      child: Container(
                                                        height: 80.w,
                                                        width: 80.w,
                                                        child:
                                                        FancyShimmerImage(
                                                          imageUrl: widget
                                                              .order
                                                              ?.packages?[
                                                          packageIndex]
                                                              .products?[
                                                          productIndex]
                                                              .sellerProductSku
                                                              ?.sku
                                                              ?.variantImage !=
                                                              null
                                                              ? '${AppConfig.assetPath}/${widget.order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.sku?.variantImage}'
                                                              : '${AppConfig.assetPath}/${widget.order?.packages?[packageIndex].products?[productIndex].sellerProductSku?.product?.product?.thumbnailImageSource}',
                                                          boxFit:
                                                          BoxFit.contain,
                                                          errorWidget:
                                                          FancyShimmerImage(
                                                            imageUrl:
                                                            "${AppConfig.assetPath}/backend/img/default.png",
                                                            boxFit:
                                                            BoxFit.contain,
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
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              widget
                                                                  .order
                                                                  ?.packages?[
                                                              packageIndex]
                                                                  .products?[
                                                              productIndex]
                                                                  .sellerProductSku
                                                                  ?.product
                                                                  ?.productName ??
                                                                  '',
                                                              style: AppStyles
                                                                  .kFontBlack14w5,
                                                            ),
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              itemCount: widget
                                                                  .order
                                                                  ?.packages?[
                                                              packageIndex]
                                                                  .products?[
                                                              productIndex]
                                                                  .sellerProductSku
                                                                  ?.productVariations
                                                                  ?.length ??
                                                                  0,
                                                              itemBuilder: (context,
                                                                  variantIndex) {
                                                                var attributeValue = widget
                                                                    .order
                                                                    ?.packages?[
                                                                packageIndex]
                                                                    .products?[
                                                                productIndex]
                                                                    .sellerProductSku
                                                                    ?.productVariations?[
                                                                variantIndex]
                                                                    .attributeValue;
                                                                var attribute = widget
                                                                    .order
                                                                    ?.packages?[
                                                                packageIndex]
                                                                    .products?[
                                                                productIndex]
                                                                    .sellerProductSku
                                                                    ?.productVariations?[
                                                                variantIndex]
                                                                    .attribute;

                                                                return Padding(
                                                                  padding:  EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                      4.0.h),
                                                                  child: Text(
                                                                    '${attribute?.name ?? ''}'
                                                                        .tr +
                                                                        ': ${attributeValue?.name ?? attributeValue?.value ?? ''}',
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
                                                                  MainAxisAlignment
                                                                      .start,
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
                                                                        Text(
                                                                          '${currencyController.appCurrency.value} ${((widget.order?.packages?[packageIndex].products?[productIndex].price ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2)}',
                                                                          style:
                                                                          AppStyles.kFontPink15w5,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                          5.w,
                                                                        ),
                                                                        Text(
                                                                          '(${widget.order?.packages?[packageIndex].products?[productIndex].qty}x)',
                                                                          style:
                                                                          AppStyles.kFontBlack14w5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                  Container(),
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
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),

                              ///Action Buttons Bar
                              Padding(
                                padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// Left side: Open Dispute / Cancel / Review
                                    Row(
                                      children: [
                                        // Open Dispute Button (if confirmed)
                                        widget.order?.isConfirmed == 1
                                            ? _buildActionButton('Open Dispute'.tr, () async {
                                          List<OrderProductElement> products = [];
                                          widget.order?.packages?.forEach((element) {
                                            products.addAll(element.products!);
                                          });
                                          Get.to(() => OrderToReturn(
                                            products: products,
                                            orderId: widget.order?.id,
                                          ));
                                        }, color: AppStyles.pinkColor)
                                            : Container(),
                                        SizedBox(width: 8.w),
                                        
                                        // Cancellation / Status Chip
                                        Obx(() {
                                          if (nowOrderIsCanceled.value) {
                                            return _buildStatusChip('Order Cancelled'.tr, AppStyles.greyColorDark);
                                          } else if (widget.order?.isConfirmed == 1 && widget.order?.isCompleted == 0) {
                                            return _buildStatusChip('Confirmed'.tr, AppStyles.greyColorDark);
                                          } else if (widget.order?.isConfirmed == 1 && widget.order?.isCompleted == 1) {
                                            return _buildStatusChip('Completed'.tr, AppStyles.greyColorDark);
                                          }
                                          return _buildActionButton('Cancel'.tr, () async {
                                            var result = await Get.bottomSheet(
                                              OrderCancelWidget(
                                                packageId: widget.order?.packages?[packageIndex].id,
                                                order: widget.order,
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              persistent: true,
                                            );
                                            if (result == true) {
                                              nowOrderIsCanceled.value = true;
                                            }
                                          });
                                        }),
                                        SizedBox(width: 8.w),

                                        // Write Review Button
                                        widget.order?.packages?[packageIndex].isReviewed == 0 && checkReview(widget.order!.packages![packageIndex])
                                            ? _buildActionButton('Write Review'.tr, () {
                                          Get.to(() => WriteReview(
                                            package: widget.order!.packages![packageIndex],
                                            sellerID: widget.order!.packages![packageIndex].sellerId,
                                            orderID: widget.order?.packages?[packageIndex].orderId,
                                            packageID: widget.order?.packages?[packageIndex].id,
                                          ));
                                        }, color: AppStyles.pinkColor)
                                            : Container(),
                                      ],
                                    ),

                                    /// Right side: Track Order
                                    Obx(() {
                                      if (nowOrderIsCanceled.value ||
                                          widget.order?.isCompleted == 1 ||
                                          widget.order?.isCancelled == 1) {
                                        return const SizedBox.shrink();
                                      }
                                      return _buildActionButton('Track Order'.tr, () {
                                        Get.to(() => OrderTrack(
                                          order: widget.order!,
                                          package: widget.order!.packages![packageIndex],
                                          processes: DeliveryProcess.delivery,
                                        ));
                                      }, color: AppStyles.pinkColor, isFilled: true);
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),

                SizedBox(
                  height: 10.h,
                ),

                ///ORDER DETAILS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0.w, horizontal: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order?.orderNumber?.capitalizeFirst ?? '',
                            style: AppStyles.kFontDarkBlue14w5.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'Placed on'.tr +
                            ': ${CustomDate().formattedDateTime(widget.order?.createdAt)}',
                        style: AppStyles.kFontGrey12w5,
                      ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.setCurrentSymbolPosition(amount: ((widget.order?.subTotal ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.setCurrentSymbolPosition(amount: ((widget.order?.shippingTotal ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Saving'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.setCurrentSymbolPosition(amount: ((widget.order?.discountTotal ?? 0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TAX/GST/VAT Amount'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.setCurrentSymbolPosition(amount: (widget.order!.taxAmount! * currencyController.conversionRate.value).toStringAsFixed(2))}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(color: Colors.grey.shade300, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Grand total'.tr + ': ',
                              style: AppStyles.kFontBlack14w5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              '${currencyController.setCurrentSymbolPosition(amount: (widget.order!.grandTotal! * currencyController.conversionRate.value).toStringAsFixed(2))}',
                              style: AppStyles.kFontDarkBlue14w5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Paid by'.tr,
                              style: AppStyles.kFontGrey12w5
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              '${getPaidBy(widget.order!)}',
                              style: AppStyles.kFontBlack12w4
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: 15),
          //     child: Text(
          //       'You might like'.tr,
          //       textAlign: TextAlign.center,
          //       style: AppStyles.appFont.copyWith(
          //         color: AppStyles.blackColor,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
          // LoadingMoreSliverList<ProductModel>(
          //   SliverListConfig<ProductModel>(
          //     padding: EdgeInsets.symmetric(horizontal: 8),
          //     indicatorBuilder: BuildIndicatorBuilder(
          //       source: source,
          //       isSliver: true,
          //       name: 'Recommended Products'.tr,
          //     ).buildIndicator,
          //     extendedListDelegate:
          //     SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 5,
          //       mainAxisSpacing: 5,
          //     ),
          //     itemBuilder: (BuildContext c, ProductModel prod, int index) {
          //       return GridViewProductWidget(
          //         productModel: prod,
          //       );
          //     },
          //     sourceList: source!,
          //   ),
          //   key: const Key('homePageLoadMoreKey'),
          // ),
        ],
      ),
    );
  }

  calculateGST(List<Package> packages) {
    var gstAmount = 0.0;
    packages.forEach((element) {
      gstAmount = gstAmount +
          element.totalGst! * currencyController.conversionRate.value;
    });
    return gstAmount.toStringAsFixed(2);
  }

  getPaidBy(OrderData order) {
    if (order.paymentType == 1) {
      return 'Cash On Delivery';
    } else if (order.paymentType == 2) {
      return 'Wallet';
    } else if (order.paymentType == 3) {
      return 'PayPal';
    } else if (order.paymentType == 4) {
      return 'Stripe';
    } else if (order.paymentType == 5) {
      return 'PayStack';
    } else if (order.paymentType == 6) {
      return 'Razorpay';
    } else if (order.paymentType == 7) {
      return 'Bank Payment';
    } else if (order.paymentType == 8) {
      return 'Instamojo';
    } else if (order.paymentType == 9) {
      return 'PayTM';
    } else if (order.paymentType == 10) {
      return 'Midtrans';
    } else if (order.paymentType == 11) {
      return 'PayUMoney';
    } else if (order.paymentType == 12) {
      return 'JazzCash';
    } else if (order.paymentType == 13) {
      return 'Google Pay';
    } else if (order.paymentType == 14) {
      return 'FlutterWave';
    }
  }

  Widget _buildActionButton(String label, VoidCallback onTap, {Color? color, bool isFilled = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isFilled ? (color ?? AppStyles.pinkColor) : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: isFilled ? null : Border.all(color: color ?? AppStyles.greyColorDark),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: isFilled 
              ? AppStyles.appFontMedium.copyWith(color: Colors.white, fontSize: 13.sp)
              : AppStyles.kFontGrey14w5.copyWith(color: color, fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: AppStyles.kFontGrey14w5.copyWith(color: color, fontSize: 12.sp),
      ),
    );
  }
}
