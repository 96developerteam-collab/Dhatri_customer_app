import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/OrderProductElement.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/account/orders/OrderCancelWidget.dart';
import 'package:amazcart/view/amazcart_view/account/orders/OrderTrack.dart';
import 'package:amazcart/view/amazcart_view/account/orders/RefundAndDisputes/OrderToReturn.dart';
import 'package:amazcart/view/amazcart_view/account/reviews/WriteReview.dart';
import 'package:amazcart/view/amazcart_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/widgets/amazcart_widget/CustomDate.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/amazcart_widget/AppBarWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:amazcart/model/DeliveryProcess.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';

import '../../products/product/ProductDetails.dart';

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
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Bill to'.tr,
                        style: AppStyles.kFontGrey12w5,
                      ),
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
                      SizedBox(
                        height: 10.h,
                      ),
                      //SHIP TO
                      Text(
                        widget.order?.deliveryType == "home_delivery"
                            ? 'Ship to'.tr
                            : "Collect from".tr,
                        style: AppStyles.kFontGrey12w5,
                      ),
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

                /// PACKAGE
                Container(
                  color: Colors.white,
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(right: 8.0.w),
                                    child: Image.asset(
                                      'assets/images/icon_delivery-parcel.png',
                                      width: 17.w,
                                      height: 17.w,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Package'.tr +
                                              ': ' +
                                              '${widget.order?.packages?[packageIndex].packageCode}',
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        currencyController.vendorType.value ==
                                                "single"
                                            ? SizedBox.shrink()
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Sold by'.tr +
                                                        ': ' +
                                                        '${widget.order?.packages?[packageIndex].seller?.firstName}',
                                                    style: AppStyles
                                                        .kFontBlack12w4,
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                ],
                                              ),
                                        Text(
                                          widget.order?.packages?[packageIndex]
                                                  .shippingDate ??
                                              '',
                                          style: AppStyles.kFontBlack12w4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   child: Text(
                                  //     deliverStateName(widget.order!.packages![packageIndex]),
                                  //     textAlign: TextAlign.center,
                                  //     style: AppStyles.kFontDarkBlue12w5
                                  //         .copyWith(
                                  //             fontStyle: FontStyle.italic),
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
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
                                      return Container(
                                        margin:
                                            EdgeInsets.only(left: 20.w, top: 5.h),
                                        decoration: BoxDecoration(
                                          color: AppStyles.appBackgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.r)),
                                        ),
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
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(left: 20.w, top: 5.h),
                                          decoration: BoxDecoration(
                                            color: AppStyles.appBackgroundColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.r)),
                                          ),
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

                              ///Order cancellation

                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 15.h),
                                  child: Obx(() {
                                    if (nowOrderIsCanceled.value) {
                                      return Container(
                                        alignment: Alignment.center,
                                        width: 122.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.r),
                                            ),
                                            border: Border.all(
                                                color:
                                                    AppStyles.greyColorDark)),
                                        child: Text('Order Cancelled'.tr,
                                            textAlign: TextAlign.center,
                                            style: AppStyles.kFontGrey14w5),
                                      );
                                    } else if (widget.order?.isConfirmed == 1 &&
                                        widget.order?.isCompleted == 0) {
                                      return Container(
                                        alignment: Alignment.center,
                                        width: 122.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.r),
                                            ),
                                            border: Border.all(
                                                color:
                                                    AppStyles.greyColorDark)),
                                        child: Text('Confirmed'.tr,
                                            textAlign: TextAlign.center,
                                            style: AppStyles.kFontGrey14w5),
                                      );
                                    } else if (widget.order?.isConfirmed == 1 &&
                                        widget.order?.isCompleted == 1) {
                                      return Container(
                                        alignment: Alignment.center,
                                        width: 122.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.r),
                                            ),
                                            border: Border.all(
                                                color:
                                                    AppStyles.greyColorDark)),
                                        child: Text('Completed'.tr,
                                            textAlign: TextAlign.center,
                                            style: AppStyles.kFontGrey14w5),
                                      );
                                    }
                                    return InkWell(
                                      onTap: () async {
                                        log("Before nowOrderIsCanceled ::: ${nowOrderIsCanceled.value}");

                                        var result = await Get.bottomSheet(
                                          OrderCancelWidget(
                                            packageId: widget.order
                                                ?.packages?[packageIndex].id,
                                            order: widget.order,
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          persistent: true,
                                        );
                                        if (result == true) {
                                          nowOrderIsCanceled.value = true;
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 122.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.r),
                                            ),
                                            border: Border.all(
                                                color:
                                                    AppStyles.greyColorDark)),
                                        child: Text('Cancel'.tr,
                                            textAlign: TextAlign.center,
                                            style: AppStyles.kFontGrey14w5),
                                      ),
                                    );
                                  })),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    widget.order?.packages?[packageIndex]
                                                .isReviewed ==
                                            0
                                        ? checkReview(widget
                                                .order!.packages![packageIndex])
                                            ? InkWell(
                                                onTap: () {
                                                  Get.to(() => WriteReview(
                                                        package: widget.order!
                                                                .packages![
                                                            packageIndex],
                                                        sellerID: widget
                                                            .order!
                                                            .packages![
                                                                packageIndex]
                                                            .sellerId,
                                                        orderID: widget
                                                            .order
                                                            ?.packages?[
                                                                packageIndex]
                                                            .orderId,
                                                        packageID: widget
                                                            .order
                                                            ?.packages?[
                                                                packageIndex]
                                                            .id,
                                                      ));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 122.w,
                                                  height: 32.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5.r),
                                                      ),
                                                      border: Border.all(
                                                          color: AppStyles
                                                              .pinkColor)),
                                                  child: Text(
                                                    'Write a Review'.tr,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        AppStyles.kFontPink15w5,
                                                  ),
                                                ),
                                              )
                                            : Container()
                                        : Container(),
                                  ],
                                ),
                              ),

                              ///Track
                              Container(
                                height: 30.h,
                                margin: EdgeInsets.only(top: 10.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => OrderTrack(
                                              order: widget.order!,
                                              package: widget.order!
                                                  .packages![packageIndex],
                                              processes:
                                                  DeliveryProcess.delivery,
                                            ));
                                      },
                                      child: Container(
                                        height: 30.h,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/icon_delivery-parcel_pink.png',
                                              width: 18.w,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text('Track your order'.tr,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontGrey14w5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    // InkWell(
                                    //   onTap: () {},
                                    //   child: Row(
                                    //     children: [
                                    //       Image.asset(
                                    //         'assets/images/icon_chat_bot_pink.png',
                                    //         width: 18,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Text('Chat now'.tr,
                                    //           textAlign: TextAlign.center,
                                    //           style: AppStyles.kFontGrey14w5),
                                    //     ],
                                    //   ),
                                    // ),
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
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20.0.w, horizontal: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order?.orderNumber?.capitalizeFirst ?? '',
                        style: AppStyles.kFontDarkBlue14w5,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'Placed on'.tr +
                            ': ${CustomDate().formattedDateTime(widget.order?.createdAt)}',
                        style: AppStyles.kFontGrey12w5,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      widget.order?.isConfirmed == 1
                          ? InkWell(
                              onTap: () async {
                                List<OrderProductElement> products = [];

                                widget.order?.packages?.forEach((element) {
                                  products.addAll(element.products!);
                                });
                                Get.to(() => OrderToReturn(
                                      products: products,
                                      orderId: widget.order?.id,
                                    ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 122.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(
                                        color: AppStyles.greyColorDark)),
                                child: Text('Open Dispute'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.kFontGrey14w5),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
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
                        height: 10.h,
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
}
