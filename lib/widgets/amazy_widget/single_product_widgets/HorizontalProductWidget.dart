import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/add_to_cart_icon.dart';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/NewModel/Product/ProductModel.dart';
import '../../../model/NewModel/Product/ProductType.dart';
import '../../../view/amazy_view/products/product/product_details.dart';
import 'package:amazcart/widgets/amazy_widget/StarCounterWidget.dart';

class HorizontalProductWidget extends StatefulWidget {
  final ProductModel? productModel;
  final double averageRating;
  HorizontalProductWidget({this.productModel, required this.averageRating});
  @override
  _HorizontalProductWidgetState createState() =>
      _HorizontalProductWidgetState();
}

class _HorizontalProductWidgetState extends State<HorizontalProductWidget> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  double getPriceForCart() {
    return double.parse((widget.productModel?.hasDeal != null
            ? (widget.productModel?.hasDeal?.discount??0) > 0
                ? currencyController.calculatePrice(widget.productModel!)
                : currencyController.calculatePrice(widget.productModel!)
            : currencyController.calculatePrice(widget.productModel!))
        .toString());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () async {
          if (widget.productModel!.productType == ProductType.PRODUCT) {
            Get.to(() => ProductDetails(productID: widget.productModel!.id),
                preventDuplicates: false);
          }
        },
        child: Container(
          width: 170.w,
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0, 3),
                blurRadius: 6.r,
                spreadRadius: 0,
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                5.verticalSpace,
                Expanded(
                  child: Container(
                    height: 160.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        widget.productModel?.productType != ProductType.GIFT_CARD
                            ? FancyShimmerImage(
                          imageUrl: widget.productModel?.product
                              ?.thumbnailImageSource !=
                              null
                              ? "${AppConfig.assetPath}/${widget.productModel?.product?.thumbnailImageSource}"
                              : "${AppConfig.assetPath}/backend/img/default.png",
                          boxFit: BoxFit.contain,
                          errorWidget: FancyShimmerImage(
                            imageUrl:
                            "${AppConfig.assetPath}/backend/img/default.png",
                            boxFit: BoxFit.contain,
                          ),
                        )
                            : FancyShimmerImage(
                          imageUrl: widget.productModel
                              ?.giftCardThumbnailImage !=
                              null
                              ? "${AppConfig.assetPath}/${widget.productModel?.giftCardThumbnailImage}"
                              : "${AppConfig.assetPath}/backend/img/default.png",
                          boxFit: BoxFit.contain,
                          errorWidget: FancyShimmerImage(
                            imageUrl:
                            "${AppConfig.assetPath}/backend/img/default.png",
                            boxFit: BoxFit.contain,
                          ),
                        ),

                        widget.productModel!.productType ==
                            ProductType.GIFT_CARD
                            ? Positioned(
                          top: 0,
                          left: 0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: (widget.productModel?.giftCardEndDate?.compareTo(DateTime.now())??0) > 0
                                ? Container(
                              padding: EdgeInsets.all(4.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r)),
                                color: AppStyles.pinkColor,
                              ),
                              child: Text(
                                widget.productModel!.discountType ==
                                    "0" ||
                                    widget.productModel!
                                        .discountType ==
                                        0
                                    ? '-${widget.productModel?.discount
                                    .toString()}% '
                                    : currencyController.setCurrentSymbolPosition(amount: ((widget.productModel?.discount??0) *
                                    currencyController.conversionRate.value)
                                    .toStringAsFixed(2)),
                                textAlign: TextAlign.center,
                                style: AppStyles.appFontBook.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.fontSize,
                                ),
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        )
                            : Positioned(
                          top: 0,
                          left: 0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: widget.productModel?.hasDeal != null
                                ? (widget.productModel?.hasDeal?.discount??0) > 0
                                ? Container(
                              padding: EdgeInsets.all(4.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r)),
                                color: AppStyles.pinkColor,
                              ),
                              child: Text(
                                widget.productModel!.hasDeal!
                                    .discountType ==
                                    0
                                    ? '${widget.productModel!.hasDeal!.discount
                                    .toString()}% '
                                    : currencyController.setCurrentSymbolPosition(amount: ((widget.productModel?.hasDeal?.discount??0) * currencyController.conversionRate.value).toStringAsFixed(2)),
                                textAlign: TextAlign.center,
                                style: AppStyles.appFontBook
                                    .copyWith(
                                  color: Colors.white,
                                  fontSize: 12.fontSize,
                                ),
                              ),
                            )
                                : Container()
                                : widget.productModel?.discountStartDate !=
                                null &&
                                currencyController.endDate
                                    .millisecondsSinceEpoch <
                                    DateTime
                                        .now()
                                        .millisecondsSinceEpoch
                                ? Container()
                                : (widget.productModel?.discount??0) > 0
                                ? Container(
                              padding: EdgeInsets.all(4.r),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.only(
                                    topLeft:
                                    Radius.circular(
                                        5.r)),
                                color: AppStyles.pinkColor,
                              ),
                              child: Text(
                                widget.productModel!
                                    .discountType ==
                                    "0"
                                    ? '-${widget.productModel?.discount
                                    .toString()}% '
                                    : currencyController.setCurrentSymbolPosition(amount: ((widget.productModel?.discount??0) *
                                    currencyController.conversionRate.value)
                                    .toStringAsFixed(2)),
                                textAlign: TextAlign.center,
                                style: AppStyles.appFontBook
                                    .copyWith(
                                  color: Colors.white,
                                  fontSize: 12.fontSize,
                                ),
                              ),
                            )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.averageRating > 0
                              ? StarCounterWidget(
                            value: widget.averageRating,
                            color: AppStyles.pinkColor,
                            size: 10.w,
                          )
                              : StarCounterWidget(
                            value: 0,
                            color: AppStyles.pinkColor,
                            size: 10.w,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          widget.averageRating > 0
                              ? Text(
                            '(${widget.averageRating.toString()})',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.appFontBook.copyWith(
                              color: AppStyles.greyColorDark,
                              fontSize: 10.fontSize,
                            ),
                          )
                              : Text(
                            '(0)',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.appFontBook.copyWith(
                              color: AppStyles.greyColorDark,
                              fontSize: 10.fontSize,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.h),
                                Text(
                                  widget.productModel!.productType ==
                                      ProductType.PRODUCT
                                      ? widget.productModel!.productName
                                      .toString()
                                      : widget.productModel!.giftCardName
                                      .toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.appFontBold.copyWith(
                                    fontSize: 12.fontSize,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                if (widget.productModel?.mrp != null &&
                                    widget.productModel!.mrp! > 0)
                                  Text(
                                    currencyController.setCurrentSymbolPosition(
                                        amount: (widget.productModel!.mrp! *
                                                currencyController
                                                    .conversionRate.value)
                                            .toStringAsFixed(2)),
                                    style: AppStyles.appFontBook.copyWith(
                                      fontSize: 12.fontSize,
                                      color: AppStyles.greyColorDark,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                SizedBox(height: 5.h),
                                widget.productModel!.hasDeal != null
                                    ? widget.productModel!.hasDeal!.discount! >
                                    0
                                    ? Wrap(
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 2,
                                  spacing: 2,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      currencyController.setCurrentSymbolPosition(amount: currencyController.calculatePrice(
                                          widget
                                              .productModel!)),
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFontBook
                                          .copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.pinkColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${currencyController.calculateMainPrice(
                                          widget.productModel!)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFontBook
                                          .copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.greyColorDark,
                                        decoration:
                                        TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                                    : Wrap(
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 2,
                                  spacing: 2,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      currencyController
                                          .calculatePrice(
                                          widget.productModel!),

                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFontBook
                                          .copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.pinkColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                                    : Wrap(
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 2,
                                  spacing: 2,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                       currencyController
                                          .calculatePrice(widget
                                          .productModel!),
                                      style: AppStyles.appFontBook.copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.pinkColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    // Text(
                                    //   '${currencyController.calculateMainPrice(
                                    //       widget.productModel!)}',
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: AppStyles.appFontBook.copyWith(
                                    //     fontSize: 12.fontSize,
                                    //     color: AppStyles.greyColorDark,
                                    //     decoration:
                                    //     TextDecoration.lineThrough,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // CartIcon(widget.productModel!),
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
  }
}
