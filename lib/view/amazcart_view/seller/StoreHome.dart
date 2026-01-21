import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProductApi.dart';
import 'package:amazcart/model/SellerFilterModel.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProfileModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/MainNavigation.dart';
import 'package:amazcart/view/amazcart_view/SearchPageMain.dart';
import 'package:amazcart/view/amazcart_view/seller/StoreAllProductsPage.dart';
import 'package:amazcart/view/amazcart_view/seller/SellerProfileFilterDrawer.dart';
import 'package:amazcart/view/amazcart_view/seller/StoreHomePage.dart';
import 'package:amazcart/widgets/amazcart_widget/CustomDate.dart';
import 'package:amazcart/widgets/amazcart_widget/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/StarCounterWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../../AppConfig/language/app_localizations.dart';

class StoreHome extends StatefulWidget {
  final int sellerId;

  StoreHome({required this.sellerId});

  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  final SellerProfileController controller = Get.put(SellerProfileController());

  String popUpItem1 = "Home";
  String popUpItem2 = "Share";
  String popUpItem3 = "Search";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SellerProductsLoadMore? source;

  bool filterSelected = false;

  @override
  void initState() {
    if (mounted) {
      getSellerDetails();
    }

    source = SellerProductsLoadMore(sellerId: widget.sellerId);
    source?.isSorted = false;
    source?.isFilter = false;

    super.initState();
  }

  getSellerDetails() async {
    try {
      await controller.getSellerProfile(widget.sellerId).then((value) {
        controller.sellerId.value = widget.sellerId;
      });
    }catch(e){
    }
  }

  @override
  void dispose() {
    source?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SellerProfileFilterDrawer(
          sellerId: widget.sellerId,
          scaffoldKey: _scaffoldKey,
          source: source,
        ),
        backgroundColor: AppStyles.appBackgroundColor,
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CustomLoadingWidget());
          } else {
            return DefaultTabController(
              length: controller.myTabs.length,
              child: Builder(builder: (context) {
                final TabController tabController =
                    DefaultTabController.of(context);
                tabController.addListener(() {
                  if (!tabController.indexIsChanging) {}
                });
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 90.h,
                        floating: false,
                        pinned: true,
                        backgroundColor: AppStyles.pinkColor,
                        toolbarHeight: 60.h,
                        leading: AppBarBackButton(
                          color: Colors.white,
                        ),
                        title: SliverAppBarTitleWidget(
                          child: controller.seller.value.seller?.sellerAccount !=
                                  null
                              ? Text(
                                  controller.seller.value.seller?.sellerAccount?.sellerShopDisplayName ??
                                      "${controller.seller.value.seller?.firstName??''} ${controller.seller.value.seller?.lastName??""}",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.kFontWhite14w5.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.fontSize),
                                )
                              : Text(
                                  "${controller.seller.value.seller?.firstName??""} ${controller.seller.value.seller?.lastName??""}",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.kFontWhite14w5.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.fontSize),
                                ),
                        ),
                        actions: [
                          PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 16.w,
                              ),
                              padding: EdgeInsets.zero,
                              onSelected: (value) {
                                if (value == "Home") {
                                  Get.offAll(MainNavigation(
                                    navIndex: 0,
                                  ));
                                }
                                if (value == "Share") {
                                  print(
                                      '${URLs.HOST}/seller-profile/${controller.seller.value.seller?.slug}');
                                  Share.share(
                                      '${URLs.HOST}/seller-profile/${controller.seller.value.seller?.slug}',
                                      subject:
                                          controller.seller.value.seller?.slug);
                                }
                                if (value == "Search") {
                                  Get.to(() => SearchPageMain());
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  '$popUpItem1',
                                  '$popUpItem2',
                                  '$popUpItem3',
                                ].map((String item) {
                                  return PopupMenuItem(
                                    value: item,
                                    height: 40.h,
                                    child: Text(
                                      item.tr,
                                      style: AppStyles.kFontBlack13w5.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList();
                              }),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.bottomCenter,
                            children: [
                              controller.seller.value.seller?.sellerAccount !=
                                      null
                                  ? Positioned.fill(
                                      child: Image.network(
                                        controller.seller.value.seller?.sellerAccount?.banner == null ? '' : "${AppConfig.assetPath + '/' + controller.seller.value.seller?.sellerAccount?.banner}",
                                        fit: BoxFit.cover,
                                        errorBuilder: (_,__,___)=> SvgPicture.asset(
                                          "assets/images/account_appbar_bg.svg",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  : Positioned.fill(
                                      child: SvgPicture.asset(
                                        'assets/images/account_appbar_bg.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: 80.0.h,
                        floating: false,
                        pinned: false,
                        backgroundColor: Colors.white,
                        actions: [
                          Container(),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.seller.value.seller?.avatar == ""
                                    ? Container(
                                        width: 70.w,
                                        height: 70.w,
                                        child: Image.network(
                                          "${AppConfig.assetPath}/backend/img/default.png",
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(5.r),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          width: 70.w,
                                          height: 70.w,
                                          child: Image.network(
                                            "${AppConfig.assetPath + '/' + '${controller.seller.value.seller?.avatar}'}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.seller.value.seller
                                                    ?.sellerAccount !=
                                                null
                                            ? controller
                                                    .seller
                                                    .value
                                                    .seller
                                                    ?.sellerAccount
                                                    ?.sellerShopDisplayName ??
                                                "${controller.seller.value.seller?.firstName}"
                                            : "${controller.seller.value.seller?.firstName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.kFontBlack14w5
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.fontSize),
                                      ),
                                      Row(
                                        children: [
                                          controller.seller.value.seller
                                                      ?.sellerAccount !=
                                                  null
                                              ? controller
                                                          .seller
                                                          .value
                                                          .seller
                                                          ?.sellerAccount
                                                          ?.isTrusted ==
                                                      1
                                                  ? Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              width: 70.w,
                                                              child:
                                                                  CustomPaint(
                                                                painter:
                                                                    SkewBgWhite(),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              2.w),
                                                                  child: Text(
                                                                    'Trusted'.tr,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: AppStyles.kFontWhite14w5.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            13.fontSize),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox.shrink()
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      controller.seller.value.seller
                                                  ?.sellerAccount !=
                                              null
                                          ? Text(
                                              '${"Member Since".tr} ${CustomDate().formattedDate(controller.seller.value.seller?.sellerAccount?.createdAt)}',
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyles.kFontBlack14w5
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14.fontSize),
                                            )
                                          : SizedBox.shrink(),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          StarCounterWidget(
                                            value: controller.sellerRating.value
                                                .toDouble(),
                                            size: 14.h,

                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          controller.seller.value.seller
                                                      ?.sellerReviews !=
                                                  null
                                              ? Text(
                                                  '${controller.sellerRating.value}/5 (${controller.seller.value.seller?.sellerReviews?.length} Review)',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppStyles
                                                      .kFontBlack14w5
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 14.fontSize),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  // pinnedHeaderSliverHeightBuilder: () {
                  //   return pinnedHeaderHeight;
                  // },
                  body: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.h,
                      ),
                      TabBar(
                        controller: controller.tabController,
                        labelColor: AppStyles.blackColor,
                        labelPadding: EdgeInsets.zero,
                        tabs: controller.myTabs,
                        labelStyle: AppStyles.kFontBlack13w4,
                        indicatorColor: AppStyles.pinkColor,
                        unselectedLabelColor: AppStyles.greyColorDark,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: controller.tabController,
                          children: <Widget>[
                            StoreHomePage(),
                            StoreAllProductsPage(
                              scaffoldKey: _scaffoldKey,
                              sellerId: widget.sellerId,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
            );
          }
        }));
  }
}

class SkewBgWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    // paint.color = Color(0xffffffff);
    paint.color = AppStyles.pinkColor;
    path = Path();
    path.lineTo(size.width * 0.06, size.height * 0.06);
    path.cubicTo(size.width * 0.06, size.height * 0.06, size.width,
        size.height * 0.06, size.width, size.height * 0.06);
    path.cubicTo(size.width, size.height * 0.06, size.width * 0.96,
        size.height * 1.06, size.width * 0.96, size.height * 1.06);
    path.cubicTo(size.width * 0.96, size.height * 1.06, size.width * 0.01,
        size.height * 1.06, size.width * 0.01, size.height * 1.06);
    path.cubicTo(size.width * 0.01, size.height * 1.06, size.width * 0.06,
        size.height * 0.06, size.width * 0.06, size.height * 0.06);
    path.cubicTo(size.width * 0.06, size.height * 0.06, size.width * 0.06,
        size.height * 0.06, size.width * 0.06, size.height * 0.06);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SellerProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final int sellerId;

  SellerProductsLoadMore({required this.sellerId});

  bool? isSorted;
  String sortKey = 'new';
  bool? isFilter;

  // final SellerProfileController controller = Get.put(SellerProfileController());

  final SellerProfileController controller = Get.put(SellerProfileController());

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
      //to show loading more clearly, in your app,remove this
      await Future.delayed(Duration(milliseconds: 500));
      var result;
      var source;

      if (!isSorted! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SELLER_PROFILE + '/$sellerId?lang=${AppLocalizations.getLanguageCode()}');
        } else {
          result = await _dio
              .get(URLs.SELLER_PROFILE + '/$sellerId', queryParameters: {
            'page': pageIndex,
            "lang" : AppLocalizations.getLanguageCode()
          });
        }
        print('URI IS ${result.realUri}');
        final data = new Map<String, dynamic>.from(result.data);
        source = SellerProfileModel.fromJson(data);
        productsLength = source.seller?.sellerProductsApi?.data?.length??0;
        print('INITIALIZED PRODUCT LENGTH $productsLength');
      }

      if (isSorted! && !isFilter!) {

        try {
        if (this.length == 0) {

            result = await _dio.get(URLs.SORT_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}', queryParameters: {
              'sort_by': sortKey,
              'paginate': 9,
              'requestItem': sellerId,
              'requestItemType': 'seller',
            });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}', queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': sellerId,
            'requestItemType': 'seller',
            'page': pageIndex,
          });
        }

        }on DioException catch(e,tr){
          log("Url -> ${e.response?.realUri}");
          log("Error -> ${e.message}");
          log("Track -> $tr");
        }

       // print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = SellerProductsApi.fromJson(data);
        productsLength = data['meta']['total'];
        print('SORT BY PRODUCT LENGTH $productsLength');
      }
      if (isFilter! && isSorted!) {
        controller.sellerFilter.value.filterType?.removeWhere((element) =>
            element.filterTypeValue?.length == 0 &&
            element.filterTypeId != 'cat');

        controller.sellerFilter.value.sortBy =
            controller.filterSortKey.value.toString();

        controller.sellerFilter.value.page = pageIndex;

        print(sellerFilterModelToJson(controller.sellerFilter.value));

        if (this.length == 0) {
          print(controller.sellerFilter.toJson());
          result = await _dio.post(
            URLs.FILTER_SELLER_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}',
            data: sellerFilterModelToJson(controller.sellerFilter.value),
          );
        } else {
          print(controller.sellerFilter.toJson());
          result = await _dio.post(
            URLs.FILTER_SELLER_PRODUCTS + '?lang=${AppLocalizations.getLanguageCode()}',
            data: sellerFilterModelToJson(controller.sellerFilter.value),
          );
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = SellerProductsApi.fromJson(data['products']);
        productsLength = data['products']['total'];
        print('FILTERED $productsLength');
      }

      if (pageIndex == 1) {
        this.clear();
      }

      if (!isSorted! && !isFilter!) {
        for (var item in source.seller.sellerProductsApi.data) {
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
        _hasMore = source.seller.sellerProductsApi.data != 0;
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
