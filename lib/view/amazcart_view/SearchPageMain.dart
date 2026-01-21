import 'dart:async';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/search_controllers.dart';
import 'package:amazcart/model/NewModel/LiveSearchModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazcart_view/products/tags/ProductsByTags.dart';
import 'package:amazcart/widgets/amazcart_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazcart_widget/GridViewProductWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/cart_icon_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:math' as math;

import '../../widgets/amazcart_widget/appbar_back_button.dart';

class SearchPageMain extends StatefulWidget {
  @override
  _SearchPageMainState createState() => _SearchPageMainState();
}

class _SearchPageMainState extends State<SearchPageMain> {
  final SearchControllers _searchController = Get.put(SearchControllers());

  Timer? debounce;

  final keywordFocus = FocusNode();

  RecommendedProductsLoadMore? source;

  onSearchChanged(String text) {
    print(text);
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 1000), () async {
      await _searchController.getData(
          keyword: _searchController.keywordCtrl.value.text, catId: "0");
    });
  }

  @override
  void initState() {
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
      body: GestureDetector(
        onTap: () {
          keywordFocus.unfocus();
        },
        child: LoadingMoreCustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              stretch: false,
              pinned: true,
              floating: false,
              forceElevated: false,
              elevation: 0,
              toolbarHeight: 70.h,
              actions: [
                CartIconWidget(),
              ],
              centerTitle: true,
              titleSpacing: 0,
              leading: AppBarBackButton(),
              title: Container(
                child: TextField(
                  style: AppStyles.appFont.copyWith(
                    fontSize: 12.0.fontSize,
                  ),
                  focusNode: keywordFocus,
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.center,
                  controller: _searchController.keywordCtrl.value,
                  keyboardType: TextInputType.text,
                  decoration: CustomInputBorder()
                      .inputDecoration(
                        '${AppConfig.appName}',
                      )
                      .copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.keywordCtrl.value.clear();
                            _searchController.liveSearchModel.value =
                                LiveSearchModel();
                          },
                          icon: Icon(
                            Icons.cancel,
                            size: 16.w,
                            color: AppStyles.lightGreyColor,
                          ),
                        ),
                      ),
                  onChanged: onSearchChanged,
                ),
              ),
            ),


            Obx(() {
              if (_searchController.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Container(),
                );
              } else {
                if (_searchController.liveSearchModel.value.tags == null) {
                  return LoadingMoreSliverList<ProductModel>(
                    SliverListConfig<ProductModel>(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                      itemBuilder:
                          (BuildContext c, ProductModel prod, int index) {
                        return GridViewProductWidget(
                          productModel: prod,
                        );
                      },
                      sourceList: source!,
                    ),
                    key: const Key('homePageLoadMoreKey'),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 10.w,
                        ),
                        _searchController.liveSearchModel.value.tags!.length > 0
                            ? ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: AppStyles.lightGreyColor,
                                  );
                                },
                                itemCount: _searchController
                                    .liveSearchModel.value.tags!.length,
                                itemBuilder: (context, tagIndex) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4.0.h, horizontal: 15.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Get.to(() => ProductsByTags(
                                                  tagName: _searchController
                                                      .liveSearchModel
                                                      .value
                                                      .tags![tagIndex]
                                                      .name!,
                                                  tagId: _searchController
                                                      .liveSearchModel
                                                      .value
                                                      .tags![tagIndex]
                                                      .id!,
                                                ));
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              children: _searchController
                                                  .highlightOccurrences(
                                                      _searchController
                                                          .liveSearchModel
                                                          .value
                                                          .tags![tagIndex]
                                                          .name!,
                                                      _searchController
                                                          .keywordCtrl
                                                          .value
                                                          .text),
                                              style: AppStyles.appFont.copyWith(
                                                fontSize: 14.fontSize,
                                                color: AppStyles.greyColorLight,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            _searchController
                                                    .keywordCtrl.value.text =
                                                _searchController
                                                    .liveSearchModel
                                                    .value
                                                    .tags![tagIndex]
                                                    .name!;

                                            await _searchController.getData(
                                                keyword: _searchController
                                                    .keywordCtrl.value.text,
                                                catId: "0");
                                          },
                                          child: Transform.rotate(
                                            angle: math.pi * 0.3,
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: AppStyles.greyColorLight,
                                              size: 16.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Container(),
                        Divider(
                          color: AppStyles.lightGreyColor,
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
