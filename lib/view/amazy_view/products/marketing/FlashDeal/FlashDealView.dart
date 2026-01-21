import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/home_controller.dart';

import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/marketing/FlashDeal/flash_deal_controller.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import '../../../../../config/config.dart';
import '../../../../../model/NewModel/FlashDeals/FlashDealModel.dart';
import '../../../../../model/NewModel/Product/ProductModel.dart';

class FlashDealView extends StatefulWidget {
  @override
  State<FlashDealView> createState() => _FlashDealViewState();
}

class _FlashDealViewState extends State<FlashDealView> {
  FlashDealProductsLoadMore? source;
  final FlashDealController controller = Get.put(FlashDealController());

  @override
  void initState() {
    source = FlashDealProductsLoadMore();
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
      body: LoadingMoreCustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverToBoxAdapter(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Obx(() {
                  if (controller.flashProductData.length <= 0) {
                    if (controller.isFlashDealProductsLoading.value) {
                      return Container();
                    }
                    return Container();
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        controller.flashDealImage.value == null
                            ? Container()
                            : FancyShimmerImage(
                                height: 150.h,
                                imageUrl: AppConfig.assetPath +
                                    "/" +
                                    controller.flashDealImage.value,
                                boxFit: BoxFit.cover,
                                errorWidget: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/backend/img/default.png",
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Text(
                                controller.flashDealTitle.value.toUpperCase(),
                                style: AppStyles.kFontWhite14w5.copyWith(
                                  color: Color(
                                    controller.textColor.value,
                                  ),
                                  fontSize: 18,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    gradient: AppStyles.gradient,
                                    borderRadius: BorderRadius.circular(5)),
                                child: SlideCountdownClock(
                                  duration: controller.dealDuration.value,
                                  slideDirection: SlideDirection.up,
                                  shouldShowDays: true,
                                  tightLabel: true,
                                  textStyle: AppStyles.appFontLight.copyWith(
                                      color: Colors.white,
                                    fontSize: 12
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Products'.tr,
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
          ),
        ],
      ),
    );
  }
}

class FlashDealProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final HomeController controller = Get.put(HomeController());

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && length < productsLength) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      var result;
      FlashDealModel source;

      if (this.length == 0) {
        result = await _dio.get(
          URLs.FLASH_DEALS,
        );
      } else {
        result = await _dio.get(URLs.FLASH_DEALS, queryParameters: {
          'page': pageIndex,
        });
      }
      final data = new Map<String, dynamic>.from(result.data);
      source = FlashDealModel.fromJson(data);
      productsLength = source.flashDeal?.allProducts?.data?.length??0;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.flashDeal?.allProducts?.data??[]) {

        if(item.product != null) {
          this.add(item.product!);
        }
      }

      _hasMore = source.flashDeal?.allProducts?.data?.length != 0;
      pageIndex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
