import 'dart:developer';
import 'dart:io';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/in-app-purchase_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/AllGiftCardsModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/amazcart_widget/StarCounterWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/gift_card_add_to_cart_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../../controller/login_controller.dart';

class GridViewGiftCardWidget extends StatefulWidget {
  final GiftCardsUIModel giftCardsUIModel;

  GridViewGiftCardWidget({required this.giftCardsUIModel});

  @override
  _GridViewGiftCardWidgetState createState() => _GridViewGiftCardWidgetState();
}

class _GridViewGiftCardWidgetState extends State<GridViewGiftCardWidget> {
  final GeneralSettingsController _generalSettingsController =
      Get.put(GeneralSettingsController());

  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isIOS) {
      inAppPurchaseController = Get.find();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.all(
            Radius.circular(5.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 99.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FancyShimmerImage(
                        imageUrl: widget.giftCardsUIModel.thumbnailImage !=
                                null
                            ? "${AppConfig.assetPath}/${widget.giftCardsUIModel.thumbnailImage}"
                            : "${AppConfig.assetPath}/backend/img/default.png",
                        boxFit: BoxFit.contain,
                        errorWidget: FancyShimmerImage(
                          imageUrl:
                              "${AppConfig.assetPath}/backend/img/default.png",
                          boxFit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: (widget.giftCardsUIModel.giftCardEndDate
                                          ?.compareTo(DateTime.now()) ??
                                      0) >
                                  0
                              ? Container(
                                  padding: EdgeInsets.all(4.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppStyles.pinkColor,
                                  ),
                                  child: _generalSettingsController
                                              .currencySymbolPosition ==
                                          'left_with_space'
                                      ? Text(
                                          widget.giftCardsUIModel
                                                          .discountType ==
                                                      "0" ||
                                                  widget.giftCardsUIModel
                                                          .discountType ==
                                                      0
                                              ? '-${widget.giftCardsUIModel.discount.toString()}% '
                                              : '-${((widget.giftCardsUIModel.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)}',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.appFont.copyWith(
                                            color: Colors.white,
                                            fontSize: 12.fontSize,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          widget.giftCardsUIModel
                                                          .discountType ==
                                                      "0" ||
                                                  widget.giftCardsUIModel
                                                          .discountType ==
                                                      0
                                              ? '-${widget.giftCardsUIModel.discount.toString()}% '
                                              : '-${((widget.giftCardsUIModel.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)} ',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.appFont.copyWith(
                                              color: Colors.white,
                                              fontSize: 12.fontSize,
                                              fontWeight: FontWeight.w500),
                                        ),
                                )
                              : SizedBox.shrink(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.giftCardsUIModel.name ?? '',
                        style: AppStyles.appFont.copyWith(
                          color: AppStyles.blackColor,
                          fontSize: 12.fontSize,
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 5.h),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.start,
                        runSpacing: 2,
                        spacing: 2,
                        runAlignment: WrapAlignment.start,
                        children: [
                          if (_generalSettingsController
                                  .currencySymbolPosition ==
                              'left_with_space')
                            Text(
                              '${_generalSettingsController.setCurrentSymbolPosition(amount: (widget.giftCardsUIModel.skus?.first.sellingPrice ?? 0).toString())}',
                              style: AppStyles.appFont.copyWith(
                                fontSize: 12.fontSize,
                                color: AppStyles.pinkColor,
                              ),
                            ),
                          if (_generalSettingsController
                                  .currencySymbolPosition !=
                              'left_with_space')
                            Text(
                              '${_generalSettingsController.setCurrentSymbolPosition(amount: (widget.giftCardsUIModel.skus?.first.sellingPrice ?? 0).toString())}',
                              style: AppStyles.appFont.copyWith(
                                fontSize: 12.fontSize,
                                color: AppStyles.pinkColor,
                              ),
                            ),
                          SizedBox(
                            width: 3.w,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              (widget.giftCardsUIModel.avgRating ?? 0) > 0
                                  ? StarCounterWidget(
                                      value:
                                          widget.giftCardsUIModel.avgRating ??
                                              0.0,
                                      color: Colors.amber,
                                      size: 12,
                                    )
                                  : StarCounterWidget(
                                      value: 0,
                                      color: Colors.amber,
                                      size: 12,
                                    ),
                              SizedBox(
                                width: 2,
                              ),
                              (widget.giftCardsUIModel.avgRating ?? 0) > 0
                                  ? Text(
                                      '(${widget.giftCardsUIModel.avgRating.toString()})',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        color: AppStyles.greyColorDark,
                                        fontSize: 12.fontSize,
                                      ),
                                    )
                                  : Text(
                                      '(0)',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        color: AppStyles.greyColorDark,
                                        fontSize: 12.fontSize,
                                      ),
                                    ),
                            ],
                          ),
                          Expanded(child: Container()),
                          InkWell(
                              onTap: () async {
                                final LoginController loginController =
                                    Get.put(LoginController());

                                if (loginController.loggedIn.value) {

                                  log("widget.giftCardsUIModel ::: ${widget.giftCardsUIModel.toJson()}");

                                  ///For single gift card
                                  if(widget.giftCardsUIModel.skus?.length == 1) {
                                    Map<String, dynamic> data = {
                                      "product_id": widget.giftCardsUIModel.skus?.first.productId,
                                      "product_sku_id": widget.giftCardsUIModel.skus?.first.productSkuId,
                                      "qty": 1,
                                      "price": widget.giftCardsUIModel.skus
                                          ?.first.sellingPrice,
                                      "seller_id": 1,
                                      "product_type": "gift_card",
                                      "gift_card_type": widget
                                          .giftCardsUIModel.skus?.first.type,
                                      "checked": 1,
                                      "in_app_purchase_id": widget
                                          .giftCardsUIModel
                                          .skus
                                          ?.first
                                          .inAppPurchase
                                    };
                                    if (Platform.isIOS) {
                                      /// For in-app purchase
                                      inAppPurchaseController
                                          .onInAppPurchaseProduct(
                                          productInfo: data);
                                    } else {
                                      // final CartController cartController =
                                      // Get.put(CartController());
                                      final CartController cartController = Get.find();
                                      await cartController.addToCart(data);
                                    }
                                  }
                                  else{
                                    log("This is variant gift card");
                                    await Get.bottomSheet(
                                      GiftCardAddToCartWidget(widget.giftCardsUIModel),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      persistent: true,
                                    );
                                  }

                                } else {
                                  Get.dialog(LoginPage(), useSafeArea: false);
                                }
                              },
                              child: Platform.isIOS
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        color: AppStyles.pinkColor,
                                      ),
                                      child: Text("Buy".tr,
                                          style: TextStyle(
                                              fontSize: 14.fontSize,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  : Container(
                                      height: 30.w,
                                      width: 30.w,
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppStyles.pinkColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/images/icon_cart.png',
                                        height: 35.w,
                                        width: 35.w,
                                        color: Colors.white,
                                      ),
                                      // width: 30.w,
                                      // height: 30.h,
                                    ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, tr) {
      log("Error -> $e");
      log("Track -> $tr");
      return Text("No data".tr);
    }
  }
}
