import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/review_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/account/reviews/WriteReview2.dart';
import 'package:amazcart/view/amazy_view/products/product/product_details.dart';
import 'package:amazcart/widgets/amazy_widget/AppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/CustomDate.dart';
import 'package:amazcart/widgets/amazy_widget/StarCounterWidget.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../model/NewModel/Product/ProductType.dart';

class MyReviews extends StatefulWidget {
  final int? tabIndex;

  MyReviews({this.tabIndex});

  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());

  int index = 0;

  List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        'Waiting for Review'.tr,
        style: AppStyles.kFontBlack14w5,
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      child: Text(
        'Review History'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
  ];

  @override
  void initState() {
    index = widget.tabIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex ?? 0,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          backgroundColor: AppStyles.appBackgroundColor,
          appBar: AppBarWidget(title: 'My Review'.tr,showCart: false),
          body: Column(
            children: [
              TabBar(
                labelColor: AppStyles.blackColor,
                labelPadding: EdgeInsets.zero,
                tabs: tabs,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                indicatorColor: AppStyles.pinkColor,
                unselectedLabelColor: AppStyles.greyColorDark,
                automaticIndicatorColorAdjustment: true,
                indicatorSize: TabBarIndicatorSize.label,
              ),
              10.verticalSpace,
              Expanded(
                child: TabBarView(
                  children: [
                    getWaitingForReview(),
                    getMyReviewList(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget getWaitingForReview() {
    final ReviewController reviewController = Get.put(ReviewController());

    reviewController.waitingForReviews();

    return Obx(() {
      if (reviewController.isWaitingReviewLoading.value) {
        return Center(
          child: CustomLoadingWidget(),
        );
      } else {
        if (reviewController.waitingReview.value.packages == null ||
            reviewController.waitingReview.value.packages?.length == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 25.w,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'All Order reviewed. Thank you!'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.kFontPink15w5.copyWith(
                  fontSize: 16.fontSize,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      }
      return Container(
        child: ListView.builder(
          itemCount: reviewController.waitingReview.value.packages?.length??0,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // List<int> prod = [];
                      // reviewController
                      //     .waitingReview.value.packages[index].products
                      //     .forEach((element) {
                      //   prod.add(element.sellerProductSku.productId);
                      // });
                      // print(prod);

                      Get.to(() => WriteReview2(
                        package: reviewController
                            .waitingReview.value.packages![index],
                        sellerID: reviewController.waitingReview.value.packages?[index].sellerId??0,
                        orderID: reviewController.waitingReview.value.packages?[index].orderId??0,
                        packageID: reviewController.waitingReview.value.packages?[index].id??0,
                        productID: reviewController.waitingReview.value.packages?[index].id??0,
                        type: '',
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/icon_delivery-parcel.png',
                                  width: 17.w,
                                  height: 17.w,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  reviewController.waitingReview.value
                                      .packages?[index].packageCode ??
                                      '',
                                  style: AppStyles.kFontBlack15w4,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 26.0, top: 5),
                              child: Text(
                                'Placed on'.tr +
                                    ': ' +
                                    CustomDate()
                                        .formattedDateTime(reviewController
                                        .waitingReview
                                        .value
                                        .packages?[index]
                                        .createdAt
                                        ?.toLocal())
                                        .toString(),
                                style: AppStyles.kFontBlack12w4,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Write Review'.tr,
                              style: AppStyles.kFontPink15w5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.w,
                              color: AppStyles.pinkColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 24.0),
                      itemCount: reviewController.waitingReview.value.packages?[index].products?.length??0,
                      itemBuilder: (context, productsIndex) {
                        if (reviewController
                            .waitingReview
                            .value
                            .packages?[index]
                            .products?[productsIndex]
                            .type ==
                            ProductType.GIFT_CARD) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppStyles.appBackgroundColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.r)),
                                  child: Container(
                                      height: 80.w,
                                      width: 80.w,
                                      child: Image.network(
                                        AppConfig.assetPath +
                                            '/' +
                                            '${reviewController.waitingReview.value.packages?[index].products?[productsIndex].giftCard?.thumbnailImage}',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  width: 15.w,
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
                                          reviewController
                                              .waitingReview
                                              .value
                                              .packages?[index]
                                              .products?[productsIndex]
                                              .giftCard
                                              ?.name ??
                                              '',
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${currencyController.setCurrentSymbolPosition(amount: ((reviewController.waitingReview.value.packages?[index].products?[productsIndex].price??0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                                                      style: AppStyles
                                                          .kFontPink15w5,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      '(${reviewController.waitingReview.value.packages?[index].products?[productsIndex].qty}x)',
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
                                          height: 5.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: AppStyles.appBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.w, horizontal: 10.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                                child: Container(
                                    height: 80.w,
                                    width: 80.w,
                                    child: Image.network(
                                      AppConfig.assetPath +
                                          '/' +
                                          '${reviewController.waitingReview.value.packages?[index].products?[productsIndex].sellerProductSku?.product?.product?.thumbnailImageSource}',
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewController
                                            .waitingReview
                                            .value
                                            .packages?[index]
                                            .products?[productsIndex]
                                            .sellerProductSku
                                            ?.product
                                            ?.productName ??
                                            '',
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: reviewController
                                            .waitingReview
                                            .value
                                            .packages?[index]
                                            .products?[productsIndex]
                                            .sellerProductSku
                                            ?.productVariations
                                            ?.length??0,
                                        itemBuilder: (context, variantIndex) {

                                          var attribute = reviewController.waitingReview.value.packages?[index].products?[productsIndex].sellerProductSku?.productVariations?[variantIndex].attribute;
                                          var attributeValue = reviewController.waitingReview.value.packages?[index].products?[productsIndex].sellerProductSku?.productVariations?[variantIndex].attributeValue;


                                          return Text(
                                            '${attribute?.name??''}: ${attributeValue?.name??attributeValue?.value??''}',
                                            style: AppStyles.kFontBlack12w4,
                                          );

                                        },
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${currencyController.setCurrentSymbolPosition(amount: ((reviewController.waitingReview.value.packages?[index].products?[productsIndex].price??0) * currencyController.conversionRate.value).toStringAsFixed(2))}',
                                                    style:
                                                    AppStyles.kFontPink15w5,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    '(${reviewController.waitingReview.value.packages?[index].products?[productsIndex].qty}x)',
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
                                        height: 5.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: 10.w,
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget getMyReviewList() {
    final ReviewController reviewController = Get.put(ReviewController());

    reviewController.myReviews();

    return Obx(() {
      if (reviewController.isMyReviewLoading.value) {
        return Center(
          child: CustomLoadingWidget(),
        );
      } else {
        if (reviewController.myReview.value.reviews == null ||
            reviewController.myReview.value.reviews?.length == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 25.w,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'No reviews Found'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.kFontPink15w5.copyWith(
                  fontSize: 16.fontSize,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      }
      return Container(
        child: ListView.builder(
          itemCount: reviewController.myReview.value.reviews?.length??0,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/icon_delivery-parcel.png',
                                  width: 17.w,
                                  height: 17.w,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(reviewController.myReview.value.reviews?[index].packageCode ??'',
                                  style: AppStyles.kFontBlack15w4,
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
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 26.0),
                      itemCount: reviewController.myReview.value.reviews?[index].reviews?.length??0,
                      itemBuilder: (context, reviewsIndex) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sold by'.tr +
                                  ' ' +
                                  '${reviewController.myReview.value.reviews?[index].reviews?[reviewsIndex].seller?.firstName}',
                              style: AppStyles.kFontBlack15w4,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (reviewController
                                    .myReview
                                    .value
                                    .reviews?[index]
                                    .reviews?[reviewsIndex]
                                    .type ==
                                    ProductType.PRODUCT) {
                                  Get.to(() => ProductDetails(
                                      productID: reviewController
                                          .myReview
                                          .value
                                          .reviews?[index]
                                          .reviews?[reviewsIndex]
                                          .product
                                          ?.id));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppStyles.appBackgroundColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.r)),
                                ),
                                padding: EdgeInsets.all(5.w),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: 80.w,
                                        width: 80.w,
                                        child: reviewController
                                            .myReview
                                            .value
                                            .reviews?[index]
                                            .reviews?[reviewsIndex]
                                            .type ==
                                            ProductType.GIFT_CARD
                                            ? FancyShimmerImage(
                                          imageUrl: AppConfig.assetPath +
                                              '/' +
                                              '${reviewController.myReview.value.reviews?[index].reviews?[reviewsIndex].giftcard?.thumbnailImage}',
                                          boxFit: BoxFit.cover,
                                          errorWidget: FancyShimmerImage(
                                            imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                            boxFit: BoxFit.contain,
                                          ),
                                        )
                                            : FancyShimmerImage(
                                          imageUrl: AppConfig.assetPath +
                                              '/' +
                                              '${reviewController.myReview.value.reviews?[index].reviews?[reviewsIndex].product?.product?.thumbnailImageSource}',
                                          boxFit: BoxFit.cover,
                                          errorWidget: FancyShimmerImage(
                                            imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                            boxFit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            reviewController
                                                .myReview
                                                .value
                                                .reviews?[index]
                                                .reviews?[reviewsIndex]
                                                .type ==
                                                ProductType.GIFT_CARD
                                                ? Text(
                                              reviewController
                                                  .myReview
                                                  .value
                                                  .reviews?[index]
                                                  .reviews?[
                                              reviewsIndex]
                                                  .giftcard
                                                  ?.name ??
                                                  '',
                                              style: AppStyles
                                                  .kFontBlack14w5
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            )
                                                : Text(
                                              reviewController
                                                  .myReview
                                                  .value
                                                  .reviews?[index]
                                                  .reviews?[
                                              reviewsIndex]
                                                  .product
                                                  ?.productName ??
                                                  '',
                                              style: AppStyles
                                                  .kFontBlack14w5
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            StarCounterWidget(
                                              size: 16,
                                              value: reviewController
                                                  .myReview
                                                  .value
                                                  .reviews?[index]
                                                  .reviews?[reviewsIndex]
                                                  .rating
                                                  .toDouble(),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              reviewController
                                                  .myReview
                                                  .value
                                                  .reviews?[index]
                                                  .reviews?[reviewsIndex]
                                                  .review ??
                                                  '',
                                              style: AppStyles.kFontBlack14w5,
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            reviewController
                                                .myReview
                                                .value
                                                .reviews?[index]
                                                .reviews?[reviewsIndex]
                                                .images
                                                ?.length !=
                                                0
                                                ? Wrap(
                                              alignment:
                                              WrapAlignment.start,
                                              runSpacing: 10,
                                              spacing: 10,
                                              children: List.generate(
                                                  reviewController
                                                      .myReview
                                                      .value
                                                      .reviews?[index]
                                                      .reviews?[
                                                  reviewsIndex]
                                                      .images
                                                      ?.length ??
                                                      0, (imgIndex) {
                                                return ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          5.r)),
                                                  child: Container(
                                                    height: 40.w,
                                                    width: 40.w,
                                                    child: Image.network(
                                                      AppConfig
                                                          .assetPath +
                                                          '/' +
                                                          '${reviewController.myReview.value.reviews?[index].reviews?[reviewsIndex].images?[imgIndex].image}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            )
                                                : Container(),
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
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        );
                      }),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
