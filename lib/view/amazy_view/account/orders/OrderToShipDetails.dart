import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/account/orders/OrderToShipTrack.dart';
import 'package:amazcart/view/amazy_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazy_view/products/product/product_details.dart';
// import 'package:amazcart/view/products/product/ProductDetails.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/CustomDate.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/amazy_widget/AppBarWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../../model/NewModel/Order/Package.dart';
import '../../../../model/NewModel/Order/OrderData.dart';
import '../../../../model/NewModel/Product/ProductModel.dart';
import '../../../../model/NewModel/Product/ProductType.dart';

class OrderToShipDetails extends StatefulWidget {
  final Package? package;

  OrderToShipDetails({this.package});

  @override
  _OrderToShipDetailsState createState() => _OrderToShipDetailsState();
}

class _OrderToShipDetailsState extends State<OrderToShipDetails> {
  final GeneralSettingsController _currencyController = Get.put(GeneralSettingsController());
  String deliverStateName(Package package) {
    var deliveryStatus = '';
    package.processes!.forEach((element) {
      if (element.id == package.deliveryStatus) {
        deliveryStatus = element.name ?? '';
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  bool checkReview(Package package) {
    // print(package.deliveryStates);
    if (package.deliveryStates!.length != 0) {
      print('${package.processes!.last.id} == ${package.deliveryStatus}');
      if (package.processes!.last.id == package.deliveryStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  RecommendedProductsLoadMore? source;

  @override
  void initState() {
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(title: 'Order Details'.tr,showCart: false,),
      body: LoadingMoreCustomScrollView(
        // rebuildCustomScrollView: true,
        showGlowLeading: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 10,
                ),
                widget.package!.order!.shippingAddress != null &&
                        widget.package!.order!.billingAddress != null
                    ? widget.package!.order!.customer?.customerShippingAddress ==
                            widget.package!.order!.customer?.customerShippingAddress
                        ? Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'Ship and Bill to'.tr,
                                    style: AppStyles.kFontGrey12w5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${widget.package!.order!.billingAddress!.name ?? ""}',
                                    style: AppStyles.kFontBlack14w5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${widget.package?.order?.billingAddress?.phone ?? ""}',
                                    style: AppStyles.kFontBlack12w4,
                                  ),
                                ),
                                Text(
                                  '${widget.package?.order?.billingAddress?.address ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
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
                                  '${widget.package?.order?.billingAddress?.name ?? ""}',
                                  style: AppStyles.kFontBlack14w5,
                                ),
                                Text(
                                  '${widget.package?.order?.billingAddress!.email ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.package?.order?.billingAddress?.phone ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.package?.order?.billingAddress?.address ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //SHIP TO
                                Text(
                                  'Ship to'.tr,
                                  style: AppStyles.kFontGrey12w5,
                                ),
                                Text(
                                  '${widget.package?.order?.shippingAddress?.name ?? ""}',
                                  style: AppStyles.kFontBlack14w5,
                                ),
                                Text(
                                  '${widget.package?.order?.shippingAddress?.email ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.package?.order?.shippingAddress?.phone ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.package?.order?.shippingAddress?.address ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                              ],
                            ),
                          )
                    : Container(),

                ///BILL TO
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/images/icon_delivery-parcel.png',
                                width: 17.w,
                                height: 17.w,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Package' +
                                        ': ' +
                                        widget.package!.packageCode!,
                                    style: AppStyles.kFontBlack14w5,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    widget.package?.shippingDate??'',
                                    style: AppStyles.kFontBlack12w4,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                deliverStateName(widget.package!),
                                textAlign: TextAlign.center,
                                style: AppStyles.kFontDarkBlue12w5
                                    .copyWith(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.package!.products!.length,
                            itemBuilder: (context, productIndex) {
                              return GestureDetector(
                                onTap: () {
                                  if (widget.package!.products![productIndex]
                                          .type ==
                                      ProductType.PRODUCT) {
                                    Get.to(() => ProductDetails(
                                          productID: widget.package!
                                              .products![productIndex].id,
                                        ));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 5),
                                  decoration: BoxDecoration(
                                    color: AppStyles.appBackgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: Container(
                                                  height: 80.w,
                                                  width: 80.w,
                                                  child: Image.network(
                                                    widget
                                                                .package?.products?[productIndex]
                                                                .sellerProductSku?.sku?.variantImage !=
                                                            null
                                                        ? '${AppConfig.assetPath}/${widget.package!.products![productIndex].sellerProductSku?.sku?.variantImage??''}'
                                                        : '${AppConfig.assetPath}/${widget.package!.products![productIndex].sellerProductSku?.product?.product?.thumbnailImageSource??''}',
                                                    fit: BoxFit.contain,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget
                                                          .package!
                                                          .products![
                                                              productIndex]
                                                          .sellerProductSku
                                                          ?.product!
                                                          .productName! ?? '',
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: (widget
                                                          .package!
                                                          .products![
                                                              productIndex]
                                                          .sellerProductSku?.productVariations??[]).length,
                                                      itemBuilder: (context,
                                                          variantIndex) {
                                                        if (widget
                                                                .package!
                                                                .products![
                                                                    productIndex]
                                                                .sellerProductSku
                                                                ?.productVariations![
                                                                    variantIndex]
                                                                .attribute!
                                                                .name ==
                                                            'Color') {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        4.0),
                                                            child: Text(
                                                              'Color'.tr +
                                                                  ': ${widget.package!.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue?.color?.name??''}',
                                                              style: AppStyles
                                                                  .kFontBlack12w4,
                                                            ),
                                                          );
                                                        } else {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        4.0),
                                                            child: Text(
                                                              '${widget.package?.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attribute?.name??''}' +
                                                                  ': ${widget.package?.products?[productIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue?.value??''}',
                                                              style: AppStyles
                                                                  .kFontBlack12w4,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 5,
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
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${(widget.package?.products?[productIndex].price??0 * _currencyController.conversionRate.value).toStringAsFixed(2)}${_currencyController.appCurrency.value}',
                                                                  style: AppStyles
                                                                      .kFontPink15w5,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  '(${widget.package?.products?[productIndex].qty??1}x)',
                                                                  style: AppStyles
                                                                      .kFontBlack14w5,
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
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                        //Track
                        Container(
                          height: 30.h,
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => OrderToShipTrack(
                                        order: widget.package!.order!,
                                        package: widget.package!,
                                      ));
                                },
                                child: Container(
                                  height: 30.h,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_delivery-parcel.png',
                                        width: 18.w,
                                      ),
                                      SizedBox(
                                        width: 5,
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
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///ORDER DETAILS
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       (widget.package?.order?.orderNumber?.capitalizeFirst??''),
                        style: AppStyles.kFontDarkBlue14w5,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Placed on'.tr +
                            ': ${CustomDate().formattedDateTime(widget.package!.createdAt)}',
                        style: AppStyles.kFontGrey12w5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${_currencyController.appCurrency.value} ${(widget.package!.order!.subTotal??0 * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${_currencyController.appCurrency.value} ${(widget.package!.order!.shippingTotal??0 * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Saving'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '-${_currencyController.appCurrency.value} ${(widget.package!.order!.discountTotal??0 * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TAX/GST Amount'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${_currencyController.appCurrency.value} ${(widget.package!.taxAmount! * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Total GST'.tr,
                      //         style: AppStyles.kFontGrey12w5,
                      //       ),
                      //       Text(
                      //         '${_currencyController.appCurrency.value} ${(widget.package.totalGst * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                      //         style: AppStyles.kFontBlack14w5,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                              width: 3,
                            ),
                            Text(
                              '${_currencyController.appCurrency.value} ${(widget.package!.order!.grandTotal! * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontDarkBlue14w5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Paid by'.tr,
                              style: AppStyles.kFontGrey12w5
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${getPaidBy(widget.package!.order!)}',
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
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'You might like'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.appFontMedium.copyWith(
                  color: AppStyles.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.symmetric(horizontal: 8),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Recommended Products'.tr,
              ).buildIndicator,
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext c, ProductModel prod, int index) {

                int totalRating = 0;
                double averageRating = 0.0;

                if((prod.reviews??[]).isNotEmpty){
                  for(int i = 0; i < prod.reviews!.length; i++){
                    totalRating += prod.reviews?[i].rating ?? 0;
                  }
                  averageRating = totalRating/prod.reviews!.length;
                }

                return GridViewProductWidget(
                  productModel: prod,
                  averageRating: averageRating,
                );
              },
              sourceList: source!,
            ),
            key: const Key('homePageLoadMoreKey'),
          ),
        ],
      ),
    );
  }

  calculateGST(List<Package> packages) {
    var gstAmount = 0.0;
    packages.forEach((element) {
      gstAmount += element.totalGst!;
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
