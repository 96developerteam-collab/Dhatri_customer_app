import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/AppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../../AppConfig/language/app_localizations.dart';
import '../../../../config/config.dart';
import '../../../../model/NewModel/AllRecommendedModel.dart';
import '../../../../model/NewModel/Product/ProductModel.dart';

class AllTopPickProducts extends StatefulWidget {
  @override
  _AllTopPickProductsState createState() => _AllTopPickProductsState();
}

class _AllTopPickProductsState extends State<AllTopPickProducts> {
  final HomeController controller = Get.put(HomeController());

  AllTopPickProductsLoadMore? source;

  @override
  void initState() {
    source = AllTopPickProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

  final ScrollController scrollController = ScrollController();

  bool isScrolling = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Top Picks Products".tr,
      ),
      floatingActionButton: isScrolling
          ? FloatingActionButton(
              backgroundColor: AppStyles.pinkColor,
              onPressed: () {
                scrollController.animateTo(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              child: Icon(
                Icons.arrow_upward_sharp,
              ),
            )
          : Container(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            FocusScope.of(context).unfocus();
            if (scrollController.offset > 0) {
              setState(() {
                isScrolling = true;
              });
            } else {
              setState(() {
                isScrolling = false;
              });
            }
            return false;
          },
          child: LoadingMoreList<ProductModel>(
            ListConfig<ProductModel>(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: false,
                name: 'Products'.tr,
              ).buildIndicator,
              showGlowLeading: true,
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              controller: scrollController,
              physics: BouncingScrollPhysics(),
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
        ),
      ),
    );
  }
}

class AllTopPickProductsLoadMore extends LoadingMoreBase<ProductModel> {
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
      AllRecommendedModel source;

      if (this.length == 0) {
        result = await _dio.get(
          URLs.ALL_TOP_PICKS + "?lang=${AppLocalizations.getLanguageCode()}",
        );
      } else {
        result = await _dio.get(URLs.ALL_TOP_PICKS + "?lang=${AppLocalizations.getLanguageCode()}", queryParameters: {
          'page': pageIndex,
        });
      }
      print(result.realUri);
      final data = new Map<String, dynamic>.from(result.data);
      source = AllRecommendedModel.fromJson(data);
      productsLength = source.data?.length??0;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.data??[]) {
        this.add(item);
      }

      _hasMore = source.data?.length != 0;
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
