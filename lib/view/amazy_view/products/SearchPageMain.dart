import 'dart:async';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazy_view/products/category/ProductsByCategory.dart';
import 'package:amazcart/view/amazy_view/products/product/product_details.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/appbar_back_button.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/amazy_widget/cart_icon_widget.dart';
import 'package:amazcart/widgets/amazy_widget/custom_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:math' as math;

import '../../../controller/search_controllers.dart';
import '../../../model/NewModel/LiveSearchModel.dart';
import '../../../model/NewModel/Product/ProductModel.dart';
import 'tags/ProductsByTags.dart';

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
    source!.dispose();
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
           backgroundColor: Color(0xff476C3B),

              titleSpacing: 0,
              expandedHeight: 70.h,
              automaticallyImplyLeading: false,
              toolbarHeight: 80.h,
              stretch: false,
              pinned: true,
              floating: false,
              forceElevated: false,
              elevation: 0,
              actions: [
                Container(),
              ],
              centerTitle: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                AppBarBackButton(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40.h,
                      child: TextField(
                        controller: _searchController.keywordCtrl.value,
                        autofocus: true,
                        enabled: true,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        style:  AppStyles.appFont.copyWith(fontSize: 12.fontSize, color: AppStyles.greyColorDark,),
                        onChanged: onSearchChanged,
                        cursorColor: AppStyles.pinkColor,
                        decoration: CustomInputBorder()
                            .inputDecorationAppBar(
                              '${AppConfig.appName}',
                            )
                            .copyWith(
                              alignLabelWithHint: true,
                              hintStyle: AppStyles.appFont.copyWith(fontSize: 12.fontSize, color: AppStyles.blackColor,),
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
                              prefixIcon: CustomGradientOnChild(
                                child: Icon(
                                  Icons.search,
                                  size: 20.w,
                                  color: AppStyles.pinkColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(8),
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CartIconWidget(),
                  SizedBox(width: 8),
                ],
              ),
            ),

            Obx(() {
              if (_searchController.isLoading.value) {
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomLoadingWidget(),
                    ],
                  ),
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
                            int totalRating = 0;
                            double averageRating = 0.0;

                            if((prod.reviews??[]).isNotEmpty){
                              for(int i = 0; i < (prod.reviews?.length??0); i++){
                                totalRating += prod.reviews?[i].rating ?? 0;
                              }
                              averageRating = totalRating/(prod.reviews?.length??0);
                            }


                            return GridViewProductWidget(
                              productModel: prod,
                              averageRating: averageRating,
                            );
                      },
                      sourceList: source!,
                    ),
                    key: const Key('homePageLoadMoreKey'),
                  );
                } else {
                  return SliverFillRemaining(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        (_searchController.liveSearchModel.value.tags?.length??0) > 0
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
                                    vertical: 4.0, horizontal: 15.w),
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
                                          size: 16.fontSize,
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
                    )
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
