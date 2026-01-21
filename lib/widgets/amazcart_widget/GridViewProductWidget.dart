import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/products/product/ProductDetails.dart';
import 'package:amazcart/widgets/amazcart_widget/StarCounterWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/add_cart_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/in-app-purchase_controller.dart';

class GridViewProductWidget extends StatefulWidget {
  final ProductModel? productModel;

  GridViewProductWidget({this.productModel});

  @override
  _GridViewProductWidgetState createState() => _GridViewProductWidgetState();
}

class _GridViewProductWidgetState extends State<GridViewProductWidget> {
  final GeneralSettingsController _generalSettingsController =
      Get.put(GeneralSettingsController());

  @override
  Widget build(BuildContext context) {
    try {
      return GestureDetector(
        onTap: () async {
          if (widget.productModel?.productType == ProductType.PRODUCT) {
            Get.to(
                () => ProductDetails(productID: widget.productModel?.id ?? 0),
                preventDuplicates: false);
          }
        },
        child: Container(
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
                        widget.productModel?.productType !=
                                ProductType.GIFT_CARD
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

                        widget.productModel?.productType ==
                                ProductType.GIFT_CARD
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: (widget.productModel?.giftCardEndDate
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
                                                  widget.productModel
                                                                  ?.discountType ==
                                                              "0" ||
                                                          widget.productModel
                                                                  ?.discountType ==
                                                              0
                                                      ? '-${widget.productModel?.discount.toString()}% '
                                                      : '-${((widget.productModel?.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)}',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 12.fontSize,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Text(
                                                  widget.productModel
                                                                  ?.discountType ==
                                                              "0" ||
                                                          widget.productModel
                                                                  ?.discountType ==
                                                              0
                                                      ? '-${widget.productModel?.discount.toString()}% '
                                                      : '-${((widget.productModel?.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)} ',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 12.fontSize,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              )
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: widget.productModel?.hasDeal != null
                                      ? (widget.productModel?.hasDeal
                                                      ?.discount ??
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
                                                      widget
                                                                  .productModel
                                                                  ?.hasDeal
                                                                  ?.discountType ==
                                                              0
                                                          ? '${widget.productModel?.hasDeal?.discount.toString()}% '
                                                          : ' -${((widget.productModel?.hasDeal?.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles.appFont
                                                          .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 12.fontSize,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  : Text(
                                                      widget
                                                                  .productModel
                                                                  ?.hasDeal
                                                                  ?.discountType ==
                                                              0
                                                          ? '-${widget.productModel?.hasDeal?.discount.toString()}% '
                                                          : '-${((widget.productModel?.hasDeal?.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)} ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles.appFont
                                                          .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 12.fontSize,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                            )
                                          : Container()
                                      : widget.productModel
                                                      ?.discountStartDate !=
                                                  null &&
                                              _generalSettingsController.endDate
                                                      .millisecondsSinceEpoch <
                                                  DateTime.now()
                                                      .millisecondsSinceEpoch
                                          ? Container()
                                          : (widget.productModel?.discount ??
                                                      0) >
                                                  0
                                              ? Container(
                                                  padding: EdgeInsets.all(4.fontSize),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppStyles.pinkColor,
                                                  ),
                                                  child: _generalSettingsController
                                                              .currencySymbolPosition ==
                                                          'left_with_space'
                                                      ? Text(
                                                          widget.productModel
                                                                      ?.discountType ==
                                                                  "0"
                                                              ? '-${widget.productModel?.discount.toString()}% '
                                                              : ' -${((widget.productModel?.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppStyles
                                                              .appFont
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 12.fontSize,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : Text(
                                                          widget.productModel
                                                                      ?.discountType ==
                                                                  "0"
                                                              ? '-${widget.productModel?.discount.toString()}% '
                                                              : '-${((widget.productModel?.discount ?? 1) * _generalSettingsController.conversionRate.value).toStringAsFixed(2)} ',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppStyles
                                                              .appFont
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 12.fontSize,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                )
                                              : Container(),
                                ),
                              ),
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
                          widget.productModel?.productType ==
                                  ProductType.PRODUCT
                              ? widget.productModel?.productName.toString() ??
                                  ''
                              : widget.productModel?.giftCardName.toString() ??
                                  '',
                          style: AppStyles.appFont.copyWith(
                            color: AppStyles.blackColor,
                            fontSize: 12.fontSize,
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 5.h),
                        widget.productModel?.hasDeal != null
                            ? (widget.productModel?.hasDeal?.discount ?? 0) > 0
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    runSpacing: 2,
                                    spacing: 2,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      if (_generalSettingsController
                                              .currencySymbolPosition ==
                                          'left_with_space')
                                        Text(
                                          ' ${_generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())}',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.appFont.copyWith(
                                            fontSize: 12.fontSize,
                                            color: AppStyles.pinkColor,
                                          ),
                                        ),
                                      if (_generalSettingsController
                                              .currencySymbolPosition !=
                                          'left_with_space')
                                        Text(
                                          '${_generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())}',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.appFont.copyWith(
                                            fontSize: 12.fontSize,
                                            color: AppStyles.pinkColor,
                                          ),
                                        ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      if (!(widget.productModel?.hasDiscount ==
                                          'no'))
                                        Text(
                                          '${_generalSettingsController.calculateMainPrice(widget.productModel ?? ProductModel())}',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.appFont.copyWith(
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
                                      if (_generalSettingsController
                                              .currencySymbolPosition ==
                                          'left_with_space')
                                        Text(
                                          '${_generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())}',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.appFont.copyWith(
                                            fontSize: 12.fontSize,
                                            color: AppStyles.pinkColor,
                                          ),
                                        ),
                                      if (_generalSettingsController
                                              .currencySymbolPosition !=
                                          'left_with_space')
                                        Text(
                                          '${_generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())}',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.appFont.copyWith(
                                            fontSize: 12.fontSize,
                                            color: AppStyles.pinkColor,
                                          ),
                                        ),
                                    ],
                                  )
                            : Wrap(
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
                                      '${_generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())}',
                                      style: AppStyles.appFont.copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.pinkColor,
                                      ),
                                    ),
                                  if (_generalSettingsController
                                          .currencySymbolPosition !=
                                      'left_with_space')
                                    Text(
                                      '${_generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())}',
                                      style: AppStyles.appFont.copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.pinkColor,
                                      ),
                                    ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  if (!(widget.productModel?.hasDiscount ==
                                      'no'))
                                    Text(
                                      '${_generalSettingsController.calculateMainPrice(widget.productModel ?? ProductModel())}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        fontSize: 12.fontSize,
                                        color: AppStyles.greyColorDark,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                (widget.productModel?.avgRating ?? 0) > 0
                                    ? StarCounterWidget(
                                        value: widget.productModel?.avgRating ??
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
                                (widget.productModel?.avgRating ?? 0) > 0
                                    ? Text(
                                        '(${widget.productModel?.avgRating.toString()})',
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

                            AddCartWidget(productModel: widget.productModel ?? ProductModel()),


                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
