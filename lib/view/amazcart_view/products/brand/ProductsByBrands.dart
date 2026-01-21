import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/model/NewModel/FilterFromCatModel.dart';
import 'package:amazcart/model/NewModel/Brand/SingleBrandModel.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/SearchPageMain.dart';
import 'package:amazcart/widgets/amazcart_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazcart_widget/GridViewProductWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:amazcart/widgets/amazcart_widget/cart_icon_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_input_border.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../../AppConfig/language/app_localizations.dart';
import 'BrandFilterDrawer.dart';

class Hello extends StatefulWidget {
  final int a;

  const Hello({
    Key? key,
    required this.a,
  }) : super(key: key);

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ignore: must_be_immutable
class ProductsByBrands extends StatefulWidget {
  final int brandId;

  ProductsByBrands({required this.brandId});

  @override
  _ProductsByBrandsState createState() => _ProductsByBrandsState();
}

class _ProductsByBrandsState extends State<ProductsByBrands> {
  //final HomeController _homeController = Get.find();
  final HomeController _homeController = Get.put(HomeController());
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();

  Sorting? _selectedSort;

  bool filterSelected = false;

  BrandProductsLoadMore? source;

  @override
  void initState() {
    source = BrandProductsLoadMore(brandId: widget.brandId);
    source?.isSorted = false;
    source?.isFilter = false;

    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();

    super.dispose();
  }

  Future<void> onRefresh() async {
    print('onref');
    _homeController.allBrandProducts.clear();
    _homeController.brandPageNumber.value = 1;
    _homeController.lastBrandPage.value = false;
    await _homeController.getBrandProducts();
  }

  final ScrollController scrollController = ScrollController();

  bool isScrolling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: BrandFilterDrawer(
          brandId: _homeController.brandId.value,
          scaffoldKey: _scaffoldKey,
          source: source!,
        ),
        backgroundColor: AppStyles.appBackgroundColor,
        floatingActionButton: isScrolling
            ? FloatingActionButton(
                backgroundColor: AppStyles.pinkColor,
                onPressed: () {
                  scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Icon(Icons.arrow_upward_sharp, size: 16.w,color: Colors.white),
              )
            : Container(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              FocusScope.of(context).unfocus();
              try {
                if (scrollController.offset > 0) {
                  setState(() {
                    isScrolling = true;
                  });
                } else {
                  setState(() {
                    isScrolling = false;
                  });
                }
              }catch(e){
                log("$e");
              }

              return false;
            },
            child: LoadingMoreCustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              slivers: [

                SliverAppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  stretch: false,
                  pinned: true,
                  floating: false,
                  forceElevated: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  toolbarHeight: 60.h,
                  actions: [
                    CartIconWidget(),
                  ],
                  centerTitle: true,
                  titleSpacing: 0,
                  leading:AppBarBackButton(),
                  title: Obx(() {
                    if (_homeController.isBrandsProductsLoading.value) {
                      return Container();
                    }
                    if (_homeController.brandTitle.value == null) {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => SearchPageMain());
                      },
                      child: Container(
                       // margin: EdgeInsets.symmetric(horizontal: 2),
                        child: TextField(
                          autofocus: true,
                          enabled: false,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.text,
                          style: AppStyles.kFontBlack12w4,
                          decoration: CustomInputBorder()
                              .inputDecoration(
                                '${AppConfig.appName}',
                              )
                              .copyWith(
                                hintStyle: AppStyles.kFontBlack12w4,
                              ),
                        ),
                      ),
                    );
                  }),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  sliver: Obx(() {
                    if (_homeController.isBrandsProductsLoading.value) {
                      return SliverToBoxAdapter(child: Container());
                    } else {
                      if (_homeController.brandAllData.value.data?.allProducts
                              ?.data?.length ==
                          0) {
                        return SliverToBoxAdapter(child: Container());
                      } else {
                        return SliverAppBar(
                          backgroundColor: AppStyles.appBackgroundColor,
                          automaticallyImplyLeading: false,
                          centerTitle: false,
                          titleSpacing: 0,
                          toolbarHeight: 15.w,
                          expandedHeight: 0,
                          forceElevated: false,
                          elevation: 0,
                          primary: true,
                          pinned: true,
                          leading: Container(),
                          actions: [
                            Container(
                              width: 50.w,
                              alignment: Alignment.center,
                              child: Container(),
                            ),
                          ],
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: !filterSelected
                                        ? DropdownButton(
                                      isExpanded: true,

                                            hint: Text('Sort'.tr),
                                            underline: Container(),
                                            value: _selectedSort,
                                            style: AppStyles.kFontBlack14w5,
                                            dropdownColor:
                                            AppStyles.appBackgroundColor,
                                            iconSize: 20.w,
                                            onChanged: (newValue) async {
                                              setState(() {
                                                _selectedSort = newValue;
                                                setState(() {
                                                  source?.sortKey =
                                                      newValue?.sortKey??'';
                                                  source?.isSorted = true;
                                                  source?.isFilter = false;
                                                  source?.refresh(true);
                                                });
                                              });
                                            },
                                            items:
                                                Sorting.sortingData.map((sort) {
                                              return DropdownMenuItem(
                                                child: Text(sort.sortName?.tr ?? '',overflow: TextOverflow.ellipsis,),
                                                value: sort,
                                              );
                                            }).toList(),
                                          )
                                        : DropdownButton(
                                      isExpanded: true,
                                            hint: Text('Sort'.tr),
                                            underline: Container(),
                                            value: _selectedSort,
                                            style: AppStyles.kFontBlack14w5,
                                            dropdownColor:
                                                AppStyles.appBackgroundColor,
                                      iconSize: 20.w,
                                            onChanged: (newValue) async {
                                              print('SORT AFTER FILTER');
                                              setState(() {
                                                _selectedSort = newValue;
                                                setState(() {
                                                  source?.isSorted = true;
                                                  source?.isFilter = true;
                                                  _homeController
                                                          .filterSortKey.value =
                                                      _selectedSort?.sortKey??'';
                                                  source?.refresh(true);
                                                });
                                              });
                                            },
                                            items:
                                                Sorting.sortingData.map((sort) {
                                              return DropdownMenuItem(
                                                child: Text(sort.sortName?.tr ?? '',overflow: TextOverflow.ellipsis,),

                                                value: sort,
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                  ),
                                ),

                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        filterSelected = true;
                                        _selectedSort =
                                            Sorting.sortingData.first;
                                      });
                                      _scaffoldKey.currentState?.openEndDrawer();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.filter_alt_outlined,
                                            size: 16.w,
                                          ),
                                          Text(
                                            'Filter'.tr,
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }),
                ),
                Obx(() {
                  if (_homeController.isBrandsProductsLoading.value) {
                    return SliverToBoxAdapter(child: Container());
                  } else {
                    return SliverToBoxAdapter(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                                    _homeController.brandImage.value.isEmpty ?
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    ) :
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      clipBehavior: Clip.antiAlias,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                        clipBehavior: Clip.antiAlias,
                                        child: FancyShimmerImage(
                                          imageUrl: AppConfig.assetPath +
                                              "/" +
                                              _homeController.brandImage.value,
                                          height: 50.w,
                                          width: 50.w,
                                          boxFit: BoxFit.contain,
                                          errorWidget: FancyShimmerImage(
                                            imageUrl:
                                                "${AppConfig.assetPath}/backend/img/default.png",
                                            boxFit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _homeController.brandTitle.value,
                                        style:
                                            AppStyles.kFontBlack17w5.copyWith(
                                          fontSize: 20.fontSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    );
                  }
                }),
                LoadingMoreSliverList<ProductModel>(
                  SliverListConfig<ProductModel>(
                    indicatorBuilder: BuildIndicatorBuilder(
                      source: source,
                      isSliver: true,
                      name: 'Products'.tr,
                    ).buildIndicator,
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
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
                ),
              ],
            ),
          ),
        ));
  }
}

class BrandProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final int brandId;

  BrandProductsLoadMore({required this.brandId});

  bool? isSorted;
  String sortKey = 'new';
  bool? isFilter;

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
      var source;

      if (!isSorted! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_BRAND + '/$brandId',queryParameters: {
            "lang" : AppLocalizations.getLanguageCode()
          });
        } else {
          result =
              await _dio.get(URLs.ALL_BRAND + '/$brandId', queryParameters: {
            'page': pageIndex,
                "lang" : AppLocalizations.getLanguageCode()
          });
        }
        print('URI IS ${result.realUri}');
        final data = new Map<String, dynamic>.from(result.data);
        source = SingleBrandModel.fromJson(data);
        productsLength = source.data?.allProducts?.data?.length??0;
        print('INITIALIZED BRAND LENGTH $productsLength');
      }
      if (isSorted! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}', queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': brandId,
            'requestItemType': 'brand',
          });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}', queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': brandId,
            'requestItemType': 'brand',
            'page': pageIndex,
          });
        }
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
      }
      if (isFilter! && isSorted!) {
        controller.dataFilterCat.value.filterDataFromCat?.filterType?.removeWhere(
            (element) =>
                element.filterTypeValue?.length == 0 &&
                element.filterTypeId != 'cat');

        controller.dataFilterCat.value.sortBy =
            controller.filterSortKey.value.toString();

        controller.dataFilterCat.value.page = pageIndex.toString();

        if (this.length == 0) {
          log(filterFromCatModelToJson(controller.dataFilterCat.value));
          result = await _dio.post(
            URLs.FILTER_ALL_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}',
            data: filterFromCatModelToJson(controller.dataFilterCat.value),
          );
        } else {
          log(filterFromCatModelToJson(controller.dataFilterCat.value));
          result = await _dio.post(
            URLs.FILTER_ALL_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}',
            data: filterFromCatModelToJson(controller.dataFilterCat.value),
          );
        }
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
      }

      if (pageIndex == 1) {
        this.clear();
      }

      if (!isSorted! && !isFilter!) {
        for (var item in source.data.allProducts.data) {
          this.add(item);
        }
      }
      if (isSorted! && !isFilter!) {
        for (var item in source.data) {
          this.add(item);
        }
      }
      if (isFilter! && isSorted!) {
        for (var item in source.data) {
          this.add(item);
        }
      }

      if (!isSorted! && !isFilter!) {
        _hasMore = source.data.allProducts.total != 0;
      }
      if (isSorted! && !isFilter!) {
        _hasMore = source.total != 0;
      }
      if (isFilter! && isSorted!) {
        _hasMore = source.total != 0;
      }

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
