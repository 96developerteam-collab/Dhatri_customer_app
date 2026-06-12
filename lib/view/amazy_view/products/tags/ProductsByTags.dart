import 'dart:developer';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/tag_controller.dart';
import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/tags/TagFilterDrawer.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../../AppConfig/language/app_localizations.dart';
import '../../../../config/config.dart';
import '../../../../model/NewModel/FilterFromCatModel.dart';
import '../../../../model/NewModel/Product/AllProducts.dart';
import '../../../../model/NewModel/Product/ProductModel.dart';
import '../../../../model/NewModel/Tags/TagProductsModel.dart';

class ProductsByTags extends StatefulWidget {
  final String? tagName;
  final int? tagId;

  ProductsByTags({this.tagName, this.tagId});

  @override
  _ProductsByTagsState createState() => _ProductsByTagsState();
}

class _ProductsByTagsState extends State<ProductsByTags> {
  final TagController controller = Get.put(TagController());
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.find();

  final TagController tagController = Get.put(TagController());

  Sorting? _selectedSort;

  bool filterSelected = false;

  TagProductsLoadMore? source;

  @override
  void initState() {
    source = TagProductsLoadMore(widget.tagName!, widget.tagId!);
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
        key: _scaffoldKey,
        backgroundColor: AppStyles.appBackgroundColor,
        body: LoadingMoreCustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBarWidget(true, true),

            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                indicatorBuilder: BuildIndicatorBuilder(
                    source: source, isSliver: true, name: 'Products'.tr)
                    .buildIndicator,
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
        ));
  }
}

class TagProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final String? tagName;
  final int? tagId;

  TagProductsLoadMore(this.tagName, this.tagId);

  final TagController controller = Get.put(TagController());

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;
  bool? isSorted = false;
  bool? isFilter = false;

  @override
  bool get hasMore => (_hasMore && (length < productsLength)) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
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
      await Future.delayed(Duration(milliseconds: 500));
      var result;
      dynamic source;
      print(
          'TAG NAME $tagName -> URL : ${URLs.SINGLE_TAG_PRODUCTS + '/$tagId'}');

      if (this.length == 0) {
        result = await _dio.get(URLs.SINGLE_TAG_PRODUCTS + '/$tagId',
            queryParameters: {"lang": AppLocalizations.getLanguageCode()});
      } else {
        result = await _dio.get(URLs.SINGLE_TAG_PRODUCTS + '/$tagId',
            queryParameters: {
              'page': pageIndex,
              "lang": AppLocalizations.getLanguageCode()
            });
      }
      print(result.data);
      final data = new Map<String, dynamic>.from(result.data);
      source = TagProductsModel.fromJson(data);
      productsLength = source.products?.data?.length ?? 0;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.products.data ?? []) {
        this.add(item);
      }

      _hasMore = source.products.data?.length != 0;
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


