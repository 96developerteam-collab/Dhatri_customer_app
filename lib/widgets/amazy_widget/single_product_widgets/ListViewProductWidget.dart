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
import 'package:amazcart/widgets/amazcart_widget/StarCounterWidget.dart';

class ListViewProductWidget extends StatefulWidget {
  final ProductModel? productModel;

  ListViewProductWidget({this.productModel});

  @override
  _ListViewProductWidgetState createState() => _ListViewProductWidgetState();
}

class _ListViewProductWidgetState extends State<ListViewProductWidget> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  double getPriceForCart() {
    return double.parse((widget.productModel!.hasDeal != null
            ? widget.productModel!.hasDeal!.discount! > 0
                ? currencyController.calculatePrice(widget.productModel!)
                : currencyController.calculatePrice(widget.productModel!)
            : currencyController.calculatePrice(widget.productModel!))
        .toString());
  }

  double getGiftCardPriceForCart() {
    dynamic productPrice = 0.0;
    if ((widget.productModel?.giftCardEndDate?.millisecondsSinceEpoch??0 )<
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = widget.productModel!.giftCardSellingPrice;
    } else {
      if (widget.productModel?.discountType == 0 ||
          widget.productModel!.discountType == "0") {
        productPrice = (widget.productModel!.giftCardSellingPrice! -
            ((widget.productModel!.discount! / 100) *
                widget.productModel!.giftCardSellingPrice!));
      } else {
        productPrice = (widget.productModel!.giftCardSellingPrice! -
            widget.productModel!.discount!);
      }
    }
    return double.parse(productPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0, 3),
                blurRadius: 6,
                spreadRadius: 0,
              )
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (widget.productModel!.productType == ProductType.PRODUCT) {
                Get.to(
                  () => ProductDetails(
                    productID: widget.productModel!.product!.id,
                  ),
                );
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: 120.h,
                    width: 120.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    child:
                        widget.productModel!.productType == ProductType.PRODUCT
                            ? FancyShimmerImage(
                                imageUrl: AppConfig.assetPath +
                                    '/' +
                                    widget.productModel!.product!
                                        .thumbnailImageSource!,
                                boxFit: BoxFit.contain,
                                errorWidget: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/backend/img/default.png",
                                  boxFit: BoxFit.contain,
                                ),
                              )
                            : FancyShimmerImage(
                                imageUrl: AppConfig.assetPath +
                                    '/' +
                                    widget.productModel!.giftCardThumbnailImage!,
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
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                (widget.productModel?.productType.toString() == ProductType.PRODUCT.toString() )?
                               "${widget.productModel?.product?.productName.toString().capitalizeFirst}"
                                    : "${widget.productModel?.giftCardName}",
                                style: AppStyles.appFontMedium.copyWith(
                                  fontSize: 12.fontSize
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        widget.productModel?.hasDeal != null
                            ? (widget.productModel?.hasDeal?.discount??0) > 0
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    runSpacing: 2,
                                    spacing: 2,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      Text(
                                        currencyController.calculatePrice(widget.productModel!),
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 12.fontSize,
                                          color: AppStyles.pinkColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        currencyController.calculateMainPrice(widget.productModel!),
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.appFontBook.copyWith(
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
                                        currencyController.calculatePrice(widget.productModel!),
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 12.fontSize,
                                          color: AppStyles.pinkColor,
                                          fontWeight: FontWeight.bold,
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
                                  Text(
                                    currencyController.calculatePrice(widget.productModel!),
                                    style: AppStyles.appFontBook.copyWith(
                                      fontSize: 12.fontSize,
                                      color: AppStyles.pinkColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    currencyController.calculateMainPrice(widget.productModel!),
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.appFontBook.copyWith(
                                      fontSize: 12.fontSize,
                                      color: AppStyles.greyColorDark,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (widget.productModel?.avgRating??0) > 0
                                  ? StarCounterWidget(
                                      value: widget.productModel?.avgRating??0.toDouble(),
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
                              (widget.productModel?.avgRating??0) > 0
                                  ? Text(
                                      '(${widget.productModel!.avgRating.toString()})',
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
                              Expanded(child: Container()),
                              CartIcon(widget.productModel!),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.productModel!.productType == ProductType.GIFT_CARD
            ? Positioned(
                top: 5,
                right: 0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: widget.productModel!.giftCardEndDate!
                              .compareTo(DateTime.now()) >
                          0
                      ? Container(
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(5)),
                            color: AppStyles.pinkColor,
                          ),
                          child: Text(
                            widget.productModel?.discountType == "0" ||
                                    widget.productModel?.discountType == 0
                                ? '-${widget.productModel?.discount.toString()}% '
                                : '${((widget.productModel?.discount??0) * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                            textAlign: TextAlign.center,
                            style: AppStyles.appFontBook.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              )
            : Positioned(
                top: 5,
                left: 0,
                child: widget.productModel?.hasDeal != null
                    ? (widget.productModel?.hasDeal?.discount??0) > 0
                        ? Container(
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5)),
                              color: AppStyles.pinkColor,
                            ),
                            child: Text(
                              widget.productModel?.hasDeal?.discountType == 0
                                  ? '${widget.productModel?.hasDeal?.discount.toString()}% '
                                  : '${((widget.productModel?.hasDeal?.discount??0) * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                              textAlign: TextAlign.center,
                              style: AppStyles.appFontBook.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Container()
                    : widget.productModel!.discountStartDate != null &&
                            currencyController.endDate.millisecondsSinceEpoch <
                                DateTime.now().millisecondsSinceEpoch
                        ? Container()
                        : (widget.productModel?.discount??0) > 0
                            ? Container(
                                padding: EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5)),
                                  color: AppStyles.pinkColor,
                                ),
                                child: Text(
                                  widget.productModel!.discountType == "0"
                                      ? '-${widget.productModel!.discount.toString()}% '
                                      : '${(widget.productModel!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFontBook.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : Container(),
              ),
      ],
    );
  }
}
