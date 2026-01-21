import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/in-app-purchase_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Category/SingleCategory.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductDetailsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/model/NewModel/Product/Review.dart';
import 'package:amazcart/model/NewModel/Product/SellerSkuModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/MainNavigation.dart';
import 'package:amazcart/view/amazcart_view/SearchPageMain.dart';
import 'package:amazcart/view/amazcart_view/account/Account.dart';
import 'package:amazcart/view/amazcart_view/account/SignInOrRegister.dart';
import 'package:amazcart/view/amazcart_view/authentication/LoginPage.dart';
import 'package:amazcart/view/amazcart_view/cart/AddToCartWidget.dart';
import 'package:amazcart/view/amazcart_view/cart/CartMain.dart';
import 'package:amazcart/view/amazcart_view/products/RatingsAndReviews.dart';
import 'package:amazcart/view/amazcart_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazcart_view/products/tags/ProductsByTags.dart';
import 'package:amazcart/view/amazcart_view/seller/StoreHome.dart';
import 'package:amazcart/widgets/amazcart_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazcart_widget/CustomDate.dart';
import 'package:amazcart/widgets/amazcart_widget/GridViewProductWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/HorizontalProductWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/StarCounterWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_clipper.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
// import 'package:amazcart/widgets/amazcart_widget/flutter_swiper/flutter_swiper.dart';
import 'package:badges/badges.dart' as badges;
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../AppConfig/language/app_localizations.dart';
import '../../../../widgets/amazcart_widget/appbar_back_button.dart';
import '../category/ProductsByCategory.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  final int productID;

  ProductDetails({required this.productID});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {


  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();

  final HomeController homeController = Get.put(HomeController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final LoginController _loginController = Get.put(LoginController());

  bool _isLoading = false;

  String popUpItem1 = "Home".tr;

  String popUpItem2 = "Share".tr;

  String popUpItem3 = "Search".tr;

  var shippingValue;

  Future<ProductDetailsModel>? productFuture;

  bool _inWishList = false;
  int? _wishListId;

  var split;
  DateTime? endDate;

  String getDiscountType(ProductModel productModel) {
    String discountType;

    if (productModel.hasDeal != null) {
      if (productModel.hasDeal?.discountType == 0) {
        discountType =
            '(-${productModel.hasDeal?.discount?.toStringAsFixed(2)}%)';
      } else {
        if (currencyController.currencySymbolPosition == "left_with_space") {
          discountType =
              '(-${currencyController.appCurrency.value} ${((productModel.hasDeal?.discount ?? 1) * currencyController.conversionRate.value).toStringAsFixed(2)})';
        } else {
          discountType =
              '(-${((productModel.hasDeal?.discount ?? 1) * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value})';
        }
      }
    } else {
      if ((productModel.discount ?? 0) > 0) {
        if (productModel.discountType == '0') {
          discountType = '(-${productModel.discount?.toStringAsFixed(2)}%)';
        } else {
          if (currencyController.currencySymbolPosition == "left_with_space") {
            discountType =
                '(-${currencyController.appCurrency.value} ${((productModel.discount ?? 1) * currencyController.conversionRate.value).toStringAsFixed(2)})';
          } else {
            discountType =
                '(-${((productModel.discount ?? 1) * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value})';
          }
        }
      } else {
        discountType = '';
      }
    }

    return discountType;
  }

  RecommendedProductsLoadMore? source;

  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {

    if (Platform.isIOS) {
      inAppPurchaseController = Get.find();
    }
    productFuture = fetchProductDetails(widget.productID);
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();
    // Get.delete<ProductDetailsController>();

    super.dispose();
  }

  ProductDetailsModel _productDetailsModel = ProductDetailsModel();

  List<Review> productReviews = [];

  int stockManage = 0;
  int stockCount = 0;

  Future<ProductDetailsModel> fetchProductDetails(id) async {
    try {
      checkWishList();
      print(widget.productID);
      Uri url = Uri.parse(URLs.ALL_PRODUCTS +
          '/$id?lang=${AppLocalizations.getLanguageCode()}');
      print("Url -> ${URLs.ALL_PRODUCTS + '/$id'}");
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("Status Code => ${response.statusCode}");
      print("Response => ${response.body}");
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] != 'not found') {
        _productDetailsModel = ProductDetailsModel.fromJson(jsonString);
        shippingValue =
            _productDetailsModel.data?.product?.shippingMethods?.first;

        productReviews = _productDetailsModel.data?.reviews
                ?.where((element) => element.type == ProductType.PRODUCT)
                .toList() ??
            [];

        // await checkWishList();

        if ((_productDetailsModel.data?.variantDetails?.length ?? 0) > 0) {
          await skuGet();
        } else {
          setState(() {
            stockManage = int.parse(
                _productDetailsModel.data?.stockManage.toString() ?? '');
            stockCount = int.parse(_productDetailsModel
                    .data?.skus?.first.productStock
                    .toString() ??
                '');
          });

          print('StockMAnage $stockManage');
          print('stockCount $stockCount');
        }
        return _productDetailsModel;
      } else {
        Get.back();
        SnackBars().snackBarWarning('not found');
      }
    } catch (e) {
      print(e);
    }
    return ProductDetailsModel();
  }

  Future checkWishList() async {
    print("----------------");
    if (!_loginController.loggedIn.value) {
      return;
    } else {
      final MyWishListController _myWishListController =
          Get.isRegistered<MyWishListController>()
              ? Get.find<MyWishListController>()
              : Get.put(MyWishListController());
      await _myWishListController.getAllWishList().then((v) {
        _myWishListController.wishListProducts.forEach((element) {
          print(element.id);
          if (element.productId == widget.productID) {
            _inWishList = true;
            _wishListId = element.id;
            setState(() {});
          }
        });
      });
    }
  }

  Map getSKU = {};

  Future skuGet() async {
    for (var i = 0;
        i < _productDetailsModel.data!.variantDetails!.length;
        i++) {
      getSKU.addAll({
        'id[$i]':
            "${_productDetailsModel.data?.variantDetails?[i].attrValId?.first}-${_productDetailsModel.data?.variantDetails?[i].attrId}"
      });
    }
    getSKU.addAll({
      'product_id': _productDetailsModel.data?.id,
      'user_id': _productDetailsModel.data?.userId
    });
    print("SKU PRICE GET ${getSKU.toString()}");
    await getSkuWisePrice(getSKU);
  }

  Future getSkuWisePrice(Map data) async {
    print(jsonEncode(data));
    try {
      DIO.Response response;
      DIO.Dio dio = new DIO.Dio();
      var formData = DIO.FormData();
      data.forEach((k, v) {
        formData.fields.add(MapEntry(k, v.toString()));
      });
      response = await dio.post(URLs.PRODUCT_PRICE_SKU_WISE,
          options: DIO.Options(
            followRedirects: false,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
            },
          ),
          data: formData,
          queryParameters: {"lang": AppLocalizations.getLanguageCode()});
      if (response.data == "0") {
        SnackBars().snackBarWarning('Product not available');
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);

        SkuData productSKU = SkuData.fromJson(returnData['data']);

        setState(() {
          stockManage = _productDetailsModel.data?.stockManage ?? 0;
          stockCount = productSKU.productStock;
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  double getPriceForCart() {
    String textString = currencyController
        .calculatePrice(_productDetailsModel.data ?? ProductModel());
    textString =
        textString.replaceAll("${currencyController.appCurrency.value}", '');
    var cartPrice = double.tryParse(textString) ?? 0;

    return cartPrice;
  }

  void openCategory(dynamic category) {
    final HomeController controller = Get.put(HomeController());
    print('CAT $category');
    controller.categoryId.value = category.id;
    controller.categoryIdBeforeFilter.value = category.id;
    controller.allProds.clear();
    controller.subCats.clear();
    controller.lastPage.value = false;
    controller.pageNumber.value = 1;
    controller.category.value = CategoryData();
    controller.catAllData.value = SingleCategory();
    // controller.dataFilter.value =
    //     FilterFromCatModel();
    controller.getCategoryProducts();
    controller.getCategoryFilterData();
    if (controller.dataFilterCat.value.filterDataFromCat != null) {
      controller.dataFilterCat.value.filterDataFromCat?.filterType
          ?.forEach((element) {
        if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
          print(element.filterTypeId);
          element.filterTypeValue?.clear();
        }
      });
    }

    controller.filterRating.value = 0.0;

    Get.to(() => ProductsByCategory(
          categoryId: category.id,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductDetailsModel>(
        future: productFuture,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: TextStyle(fontSize: 18.fontSize),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              return SafeArea(
                top: false,
                child: Scaffold(
                  backgroundColor: AppStyles.appBackgroundColor,
                  body: NestedScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 250.0.h,
                          pinned: true,
                          collapsedHeight: 70.h,
                          toolbarHeight: 60.h,
                          stretch: false,
                          forceElevated: false,
                          titleSpacing: 0,
                          backgroundColor: Colors.white,
                          automaticallyImplyLeading: false,
                          scrolledUnderElevation: 0,
                          title: SliverAppBarTitleWidget(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w, top: 2.h),
                                  child: AppBarBackButton(),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0.w),
                                    child: Text(
                                      _productDetailsModel.data?.productName ??
                                          '',
                                      maxLines: 1,
                                      style: AppStyles.kFontBlack17w5.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Positioned(
                                      child: IconButton(
                                        tooltip: "Cart".tr,
                                        onPressed: () {
                                          Get.to(() => CartMain(false));
                                        },
                                        icon: Container(
                                          width: 45.w,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/icon_cart_white.png',
                                            width: 35.w,
                                            height: 35.w,
                                            color: AppStyles.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 20.w,
                                          height: 20.w,
                                          decoration: BoxDecoration(
                                            color: AppStyles.pinkColor,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Obx(() {
                                            return Text(
                                              '${cartController.cartListSelectedCount.value}',
                                              textAlign: TextAlign.center,
                                              style: AppStyles.kFontWhite12w5,
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10.w),
                                  child: PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                        size: 30.w,
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
                                              '${URLs.HOST}/item/${_productDetailsModel.data?.slug}');
                                          Share.share(
                                              '${URLs.HOST}/product/${_productDetailsModel.data?.seller?.slug}/${_productDetailsModel.data?.slug}',
                                              subject: _productDetailsModel
                                                  .data?.productName);
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
                                            height: 40.h,
                                            value: item,
                                            child: Text(
                                              item,
                                              style: AppStyles.kFontBlack13w5
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      }),
                                ),
                              ],
                            ),
                          ),
                          actions: [Container()],
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            background: Container(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned.fill(
                                    child: (_productDetailsModel.data?.product
                                                    ?.gallaryImages?.length ??
                                                1) >
                                            1
                                        ? Container(
                                            child: Swiper(
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  padding: EdgeInsets.all(
                                                      kToolbarHeight.h),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          PhotoViewerWidget(
                                                            productDetailsModel:
                                                                _productDetailsModel,
                                                            initialIndex: index,
                                                          ));
                                                    },
                                                    child: FancyShimmerImage(
                                                      imageUrl: _productDetailsModel
                                                                  .data
                                                                  ?.product
                                                                  ?.gallaryImages?[
                                                                      index]
                                                                  .imagesSource !=
                                                              null
                                                          ? "${AppConfig.assetPath}/${_productDetailsModel.data?.product?.gallaryImages?[index].imagesSource}"
                                                          : "${AppConfig.assetPath}/backend/img/default.png",
                                                      boxFit: BoxFit.contain,
                                                      errorWidget:
                                                          FancyShimmerImage(
                                                        imageUrl:
                                                            "${AppConfig.assetPath}/backend/img/default.png",
                                                        boxFit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: _productDetailsModel
                                                      .data
                                                      ?.product
                                                      ?.gallaryImages
                                                      ?.length ??
                                                  0,
                                              control: new SwiperControl(
                                                  color: AppStyles.pinkColor),
                                              pagination: SwiperPagination(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10.0.h),
                                                  builder:
                                                      SwiperCustomPagination(
                                                          builder: (BuildContext
                                                                  context,
                                                              SwiperPluginConfig
                                                                  config) {
                                                    return Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child:
                                                          RectSwiperPaginationBuilder(
                                                        color: AppStyles
                                                            .lightBlueColorAlt,
                                                        activeColor:
                                                            AppStyles.pinkColor,
                                                        size: Size(10.0.w, 10.0.w),
                                                        activeSize:
                                                            Size(25.0.w, 10.0.w),
                                                      ).build(context, config),
                                                    );
                                                  })),
                                            ),
                                          )
                                        : Container(
                                            padding:
                                                EdgeInsets.only(left: 15.w,right: 15.w,top: 85.h),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(() => PhotoViewerWidget(
                                                      productDetailsModel:
                                                          _productDetailsModel,
                                                      initialIndex: 0,
                                                    ));
                                              },
                                              child: FancyShimmerImage(
                                                imageUrl: _productDetailsModel
                                                            .data
                                                            ?.product
                                                            ?.thumbnailImageSource !=
                                                        null
                                                    ? "${AppConfig.assetPath}/${_productDetailsModel.data?.product?.thumbnailImageSource}"
                                                    : "${AppConfig.assetPath}/backend/img/default.png",
                                                boxFit: BoxFit.contain,
                                                errorWidget: FancyShimmerImage(
                                                  imageUrl:
                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    top: 30.h,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Container(
                                            width: 45.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              tooltip: "Back".tr,
                                              elevation: 0,
                                              enableFeedback: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: Platform.isIOS ? 5.w : 0),
                                                child: Icon(
                                                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back ,
                                                  color: Colors.white,
                                                  size: 16.w,
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Container(
                                          width: 45.w,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: FloatingActionButton(
                                            heroTag: null,
                                            tooltip: "Cart".tr,
                                            elevation: 0,
                                            enableFeedback: false,
                                            backgroundColor: Colors.transparent,
                                            child: badges.Badge(
                                              badgeStyle: badges.BadgeStyle(
                                                badgeColor: AppStyles.pinkColor,
                                              ),
                                              badgeAnimation:
                                                  badges.BadgeAnimation.fade(
                                                toAnimate: false,
                                              ),
                                              badgeContent: Text(
                                                '${cartController.cartListSelectedCount.value.toString()}',
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: Image.asset(
                                                'assets/images/icon_cart_white.png',
                                                width: 30.w,
                                                height: 30.w,
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => CartMain(false));
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Container(
                                            width: 45.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              tooltip: "Cart".tr,
                                              elevation: 0,
                                              enableFeedback: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Container(
                                                height: 50.h,
                                                child: PopupMenuButton<String>(
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white,
                                                      size: 16.w,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    onSelected: (value) {
                                                      if (value == "Home") {
                                                        Get.offAll(
                                                            MainNavigation(
                                                          navIndex: 0,
                                                        ));
                                                      }
                                                      if (value == "Share") {
                                                        print(
                                                            '${URLs.HOST}/item/${_productDetailsModel.data?.slug}');
                                                        Share.share(
                                                            '${URLs.HOST}/product/${_productDetailsModel.data?.seller?.slug}/${_productDetailsModel.data?.slug}',
                                                            subject:
                                                                _productDetailsModel
                                                                    .data
                                                                    ?.productName);
                                                      }
                                                      if (value == "Search") {
                                                        Get.to(() =>
                                                            SearchPageMain());
                                                      }
                                                    },
                                                    itemBuilder: (context) {
                                                      return [
                                                        '$popUpItem1',
                                                        '$popUpItem2',
                                                        '$popUpItem3',
                                                      ].map((String item) {
                                                        return PopupMenuItem(
                                                          height: 40.h,
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style: AppStyles
                                                                .kFontBlack13w5
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList();
                                                    }),
                                              ),
                                              onPressed: null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                    body: LoadingMoreCustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        if (currencyController
                                                .currencySymbolPosition ==
                                            "left_with_space")
                                          Text(
                                            '${currencyController.appCurrency.value} ${currencyController.calculatePriceWithVariant(_productDetailsModel.data ?? ProductModel())}',
                                            style: AppStyles.kFontPink15w5
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.fontSize),
                                          ),
                                        if (currencyController
                                                .currencySymbolPosition !=
                                            "left_with_space")
                                          Text(
                                            '${currencyController.calculatePriceWithVariant(_productDetailsModel.data ?? ProductModel())}${currencyController.appCurrency.value}',
                                            style: AppStyles.kFontPink15w5
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.fontSize),
                                          ),
                                        Expanded(child: Container()),
                                        Container(
                                          width: 30.w,
                                          height: 30.w,
                                          child: InkWell(
                                            onTap: () async {
                                              final LoginController
                                                  loginController =
                                                  Get.put(LoginController());

                                              if (loginController
                                                  .loggedIn.value) {
                                                final MyWishListController
                                                    wishListController =
                                                    Get.put(
                                                        MyWishListController());
                                                if (_inWishList) {
                                                  await wishListController
                                                      .deleteWishListProduct(
                                                          _wishListId)
                                                      .then((value) {
                                                    setState(() {
                                                      checkWishList();
                                                      _inWishList = false;
                                                    });
                                                  });
                                                } else {
                                                  print('add to wishlist');
                                                  Map data = {
                                                    'seller_product_id':
                                                        _productDetailsModel
                                                            .data?.id,
                                                    'seller_id':
                                                        _productDetailsModel
                                                            .data?.userId,
                                                    'type': 'product',
                                                  };

                                                  await wishListController
                                                      .addProductToWishList(
                                                          data)
                                                      .then((value) {
                                                    setState(() {
                                                      checkWishList();
                                                      _inWishList = true;
                                                    });
                                                  });
                                                }
                                              } else {
                                                Get.dialog(LoginPage(),
                                                    useSafeArea: false);
                                              }
                                            },
                                            child: Icon(
                                              _inWishList
                                                  ? FontAwesomeIcons.solidHeart
                                                  : FontAwesomeIcons.heart,
                                              size: 20.w,
                                              color: _inWishList
                                                  ? AppStyles.pinkColor
                                                  : AppStyles.greyColorLight,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          width: 30.w,
                                          height: 30.w,
                                          child: InkWell(
                                            onTap: () {
                                              print(
                                                  'Link ::: ${URLs.HOST}/product/${_productDetailsModel.data?.seller?.slug}/${_productDetailsModel.data?.slug}');
                                              Share.share(
                                                  '${URLs.HOST}/product/${_productDetailsModel.data?.seller?.slug}/${_productDetailsModel.data?.slug}',
                                                  subject: _productDetailsModel
                                                      .data?.productName);
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.shareAlt,
                                              size: 20.w,
                                              color: AppStyles.greyColorLight,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                      ],
                                    ),
                                    currencyController
                                                .calculateMainPriceWithVariant(
                                                    _productDetailsModel.data ??
                                                        ProductModel()) !=
                                            ""
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    currencyController
                                                        .calculateMainPriceWithVariant(
                                                            _productDetailsModel
                                                                    .data ??
                                                                ProductModel()),
                                                    style: AppStyles
                                                        .kFontGrey14w5
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    getDiscountType(
                                                        _productDetailsModel
                                                                .data ??
                                                            ProductModel()),
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.w),
                                            ],
                                          )
                                        : Container(),
                                    Text(
                                      _productDetailsModel.data?.productName ??
                                          '',
                                      style: AppStyles.kFontBlack15w4.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.fontSize,
                                        letterSpacing: 0.5,
                                        color: Color(0xff242424),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    (_productDetailsModel.data?.rating ?? 0) > 0
                                        ? Row(
                                            children: [
                                              (_productDetailsModel
                                                              .data?.rating ??
                                                          0) >
                                                      0
                                                  ? StarCounterWidget(
                                                      value:
                                                          (_productDetailsModel
                                                                  .data
                                                                  ?.rating ??
                                                              0),
                                                      color: Colors.amber,
                                                      size: 12,
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              (_productDetailsModel
                                                              .data
                                                              ?.reviews
                                                              ?.length ??
                                                          0) >
                                                      0
                                                  ? Text(
                                                      '${_productDetailsModel.data?.rating} (${_productDetailsModel.data?.reviews?.length.toString()})',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyles
                                                          .kFontGrey12w5,
                                                    )
                                                  : Container(),
                                            ],
                                          )
                                        : SizedBox.shrink(),
                                    (_productDetailsModel.data?.rating ?? 0) > 0
                                        ? SizedBox(
                                            height: 15.h,
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),

                              (_productDetailsModel
                                              .data?.variantDetails?.length ??
                                          0) >
                                      0
                                  ? SizedBox(
                                      height: 10.h,
                                    )
                                  : SizedBox.shrink(),
                              //**Variant
                              (_productDetailsModel
                                              .data?.variantDetails?.length ??
                                          0) >
                                      0
                                  ? Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 20.w),
                                      child: InkWell(
                                        onTap: () async {
                                          await Get.bottomSheet(
                                            AddToCartWidget(
                                                _productDetailsModel.data?.id ??
                                                    0),
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            persistent: true,
                                          );
                                          Get.delete<
                                              ProductDetailsController>();
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: 100.w,
                                                child: Text(
                                                  'Variant'.tr,
                                                  style:
                                                      AppStyles.kFontBlack13w5,
                                                )),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      _productDetailsModel
                                                          .data
                                                          ?.variantDetails
                                                          ?.length,
                                                  itemBuilder:
                                                      (context, variantIndex) {
                                                    ProductVariantDetail?
                                                        variant =
                                                        _productDetailsModel
                                                                .data
                                                                ?.variantDetails?[
                                                            variantIndex];
                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Wrap(
                                                            runSpacing: 0,
                                                            spacing: 5,
                                                            children:
                                                                List.generate(
                                                              variant?.value
                                                                      ?.length ??
                                                                  0,
                                                              (index) {
                                                                if (index ==
                                                                    0) {
                                                                  return Text(
                                                                    '${variant?.name}: ${variant?.value?[index]}',
                                                                    style: AppStyles
                                                                        .kFontBlack14w5,
                                                                  );
                                                                }
                                                                return Text(
                                                                  '${variant?.value?[index]}',
                                                                  style: AppStyles
                                                                      .kFontBlack14w5,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 13.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),

                              // //**Delivery & Service
                              // Container(
                              //   color: Colors.white,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 20, vertical: 15),
                              //   child: InkWell(
                              //     onTap: () {
                              //       showModalBottomSheet(
                              //         context: context,
                              //         isScrollControlled: true,
                              //         backgroundColor: Colors.transparent,
                              //         builder: (context) {
                              //           return GestureDetector(
                              //             onTap: () =>
                              //                 Navigator.of(context).pop(),
                              //             child: Container(
                              //               color:
                              //                   Color.fromRGBO(0, 0, 0, 0.001),
                              //               child: GestureDetector(
                              //                 onTap: () {},
                              //                 child: DraggableScrollableSheet(
                              //                   initialChildSize: 0.4,
                              //                   minChildSize: 0.2,
                              //                   maxChildSize: 0.75,
                              //                   builder: (_, scrollController) {
                              //                     return Container(
                              //                       padding:
                              //                           EdgeInsets.symmetric(
                              //                               horizontal: 25,
                              //                               vertical: 10),
                              //                       decoration: BoxDecoration(
                              //                         color: Colors.white,
                              //                         borderRadius:
                              //                             BorderRadius.only(
                              //                           topLeft: const Radius
                              //                               .circular(25.0),
                              //                           topRight: const Radius
                              //                               .circular(25.0),
                              //                         ),
                              //                       ),
                              //                       child: Column(
                              //                         children: [
                              //                           Column(
                              //                             crossAxisAlignment:
                              //                                 CrossAxisAlignment
                              //                                     .center,
                              //                             mainAxisAlignment:
                              //                                 MainAxisAlignment
                              //                                     .center,
                              //                             children: [
                              //                               SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                               InkWell(
                              //                                 onTap: () {
                              //                                   Get.back();
                              //                                 },
                              //                                 child: Container(
                              //                                   width: 40,
                              //                                   height: 5,
                              //                                   decoration:
                              //                                       BoxDecoration(
                              //                                     color: Color(
                              //                                         0xffDADADA),
                              //                                     borderRadius:
                              //                                         BorderRadius
                              //                                             .all(
                              //                                       Radius
                              //                                           .circular(
                              //                                               30),
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                               Text(
                              //                                 'Delivery'.tr,
                              //                                 style: AppStyles
                              //                                     .kFontBlack15w4,
                              //                               ),
                              //                               SizedBox(
                              //                                 height: 20,
                              //                               ),
                              //                             ],
                              //                           ),
                              //                           Expanded(
                              //                             child:
                              //                                 ListView.builder(
                              //                               controller:
                              //                                   scrollController,
                              //                               itemCount:
                              //                                   _productDetailsModel
                              //                                       .data
                              //                                       .product
                              //                                       .shippingMethods
                              //                                       .length,
                              //                               itemBuilder:
                              //                                   (context,
                              //                                       shipIndex) {
                              //                                 return Padding(
                              //                                   padding:
                              //                                       const EdgeInsets
                              //                                               .all(
                              //                                           8.0),
                              //                                   child: Row(
                              //                                     children: [
                              //                                       Container(
                              //                                         width: 5,
                              //                                         height: 5,
                              //                                         color: AppStyles
                              //                                             .darkBlueColor,
                              //                                       ),
                              //                                       SizedBox(
                              //                                         width: 3,
                              //                                       ),
                              //                                       Expanded(
                              //                                         child:
                              //                                             Text(
                              //                                           '${_productDetailsModel.data.product.shippingMethods[shipIndex].shippingMethod.methodName} (${_productDetailsModel.data.product.shippingMethods[shipIndex].shippingMethod.shipmentTime})',
                              //                                         ),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                 );
                              //                               },
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     );
                              //                   },
                              //                 ),
                              //               ),
                              //             ),
                              //           );
                              //         },
                              //       );
                              //     },
                              //     child: Row(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.center,
                              //       children: [
                              //         Container(
                              //             width: 100,
                              //             child: Text(
                              //               'Delivery'.tr,
                              //               style: AppStyles.kFontGrey14w5,
                              //             )),
                              //         SizedBox(
                              //           width: 20,
                              //         ),
                              //         Expanded(
                              //           child: Wrap(
                              //             children: List.generate(
                              //                 _productDetailsModel
                              //                     .data.product.shippingMethods
                              //                     .take(1)
                              //                     .length, (shipIndex) {
                              //               if (shipIndex == 0) {
                              //                 return Text(
                              //                   '${_productDetailsModel.data.product.shippingMethods[shipIndex].shippingMethod.methodName} (${_productDetailsModel.data.product.shippingMethods[shipIndex].shippingMethod.shipmentTime})',
                              //                   style: AppStyles.kFontBlack14w5,
                              //                 );
                              //               }
                              //               return Text(
                              //                 ',${_productDetailsModel.data.product.shippingMethods[shipIndex].shippingMethod.methodName} (${_productDetailsModel.data.product.shippingMethods[shipIndex].shippingMethod.shipmentTime})',
                              //                 style: AppStyles.kFontBlack14w5,
                              //               );
                              //             }),
                              //           ),
                              //         ),
                              //         Icon(
                              //           Icons.arrow_forward_ios,
                              //           size: 13,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Divider(
                              //   color: AppStyles.textFieldFillColor,
                              //   thickness: 1,
                              //   height: 1,
                              // ),

                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 15.h),
                                        child: Text(
                                          'Product Specifications'.tr,
                                          style: AppStyles.kFontGrey14w5,
                                        )),
                                    Divider(
                                      color: AppStyles.textFieldFillColor,
                                      thickness: 1,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _productDetailsModel.data?.product?.brand !=
                                            null
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5.w,
                                                    height: 5.w,
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Brand".tr + ": ",
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                  Text(
                                                    "${_productDetailsModel.data?.product?.brand?.name}",
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** MODEL NUMBER */

                                    _productDetailsModel
                                                .data?.product?.modelNumber !=
                                            null
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5.w,
                                                    height: 5.w,
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Model Number".tr + ": ",
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                  Text(
                                                    "${_productDetailsModel.data?.product?.modelNumber}",
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** AVAILABLITY */

                                    _productDetailsModel.data?.stockManage == 1
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5.w,
                                                    height: 5.w,
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Availability".tr + ": ",
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                  Text(
                                                    "${(_productDetailsModel.data?.skus?.first.productStock ?? 0) > 0 ? "In Stock".tr : "Not in stock".tr}",
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.w,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** SKU */
                                    _productDetailsModel.data?.product?.skus
                                                ?.first.sku !=
                                            null
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5.w,
                                                    height: 5.w,
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Product SKU".tr + ": ",
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                  Text(
                                                    "${_productDetailsModel.data?.product?.skus?.first.sku}",
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** Min Order Quantity */
                                    _productDetailsModel.data?.product
                                                ?.minimumOrderQty !=
                                            null
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5.w,
                                                    height: 5.w,
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Minimum Order Quantity"
                                                            .tr +
                                                        ": ",
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                  Text(
                                                    "${_productDetailsModel.data?.product?.minimumOrderQty}",
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** Max Order Quantity */
                                    _productDetailsModel
                                                .data?.product?.maxOrderQty !=
                                            null
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 5.w,
                                                    height: 5.w,
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Maximum Order Quantity"
                                                            .tr +
                                                        ": ",
                                                    style:
                                                        AppStyles.kFontGrey14w5,
                                                  ),
                                                  Text(
                                                    "${_productDetailsModel.data?.product?.maxOrderQty}",
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** Category */
                                    (_productDetailsModel.data?.product
                                                    ?.categories?.length ??
                                                0) >
                                            0
                                        ? Column(
                                            children: [
                                              Wrap(
                                                spacing: 5,
                                                children: List.generate(
                                                    (_productDetailsModel
                                                                .data
                                                                ?.product
                                                                ?.categories
                                                                ?.length ??
                                                            1) +
                                                        1, (categoryIndex) {
                                                  if (categoryIndex == 0) {
                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Category'.tr + ':',
                                                          style: AppStyles
                                                              .kFontGrey14w5,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return InkWell(
                                                    onTap: () {
                                                      openCategory(
                                                          _productDetailsModel
                                                                  .data
                                                                  ?.product
                                                                  ?.categories?[
                                                              categoryIndex -
                                                                  1]);
                                                    },
                                                    child: Chip(
                                                      backgroundColor: AppStyles
                                                          .lightBlueColorAlt,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r)),
                                                      label: Text(
                                                        '${_productDetailsModel.data?.product?.categories?[categoryIndex - 1].name}',
                                                        style: AppStyles
                                                            .kFontBlack14w5,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    //** TAGS */
                                    (_productDetailsModel.data?.product?.tags
                                                    ?.length ??
                                                0) >
                                            0
                                        ? Column(
                                            children: [
                                              Wrap(
                                                spacing: 5,
                                                children: List.generate(
                                                    (_productDetailsModel
                                                                .data
                                                                ?.product
                                                                ?.tags
                                                                ?.length ??
                                                            0) +
                                                        1, (tagIndex) {
                                                  if (tagIndex == 0) {
                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Tags'.tr + ':',
                                                          style: AppStyles
                                                              .kFontGrey14w5,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                          () => ProductsByTags(
                                                                tagName: _productDetailsModel
                                                                        .data
                                                                        ?.product
                                                                        ?.tags?[
                                                                            tagIndex -
                                                                                1]
                                                                        .name ??
                                                                    '',
                                                                tagId: _productDetailsModel
                                                                        .data
                                                                        ?.product
                                                                        ?.tags?[
                                                                            tagIndex -
                                                                                1]
                                                                        .id ??
                                                                    0,
                                                              ));
                                                    },
                                                    child: Chip(
                                                      backgroundColor: AppStyles
                                                          .lightBlueColorAlt,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r)),
                                                      label: Text(
                                                        '${_productDetailsModel.data?.product?.tags?[tagIndex - 1].name}',
                                                        style: AppStyles
                                                            .kFontBlack14w5,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),

                                    _productDetailsModel
                                                .data?.product?.specification !=
                                            null
                                        ? htmlExpandingWidget(
                                            "${_productDetailsModel.data?.product?.specification ?? ""}")
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),

                              _productDetailsModel.data?.product?.description !=
                                      null
                                  ? Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w, vertical: 10.h),
                                              child: Text(
                                                'Description'.tr,
                                                style: AppStyles.kFontGrey14w5,
                                              )),
                                          Divider(
                                            color: AppStyles.textFieldFillColor,
                                            thickness: 1,
                                            height: 1,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w, vertical: 10.h),
                                            child: htmlExpandingWidget(
                                                "${_productDetailsModel.data?.product?.description ?? ""}"),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),

                              //** Ratings And reviews
                              productReviews.length > 0
                                  ? ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => RatingsAndReviews(
                                                  productReviews:
                                                      productReviews,
                                                ));
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w, vertical: 15.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Ratings & Reviews'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles
                                                      .kFontBlack14w5
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.fontSize,
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'VIEW ALL'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles
                                                          .kFontBlack14w5
                                                          .copyWith(
                                                              color: AppStyles
                                                                  .pinkColor),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 14.fontSize,
                                                      color:
                                                          AppStyles.pinkColor,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: AppStyles.textFieldFillColor,
                                          thickness: 1,
                                          height: 1,
                                        ),
                                        Container(
                                          color: Colors.white,
                                          child: ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                height: 20.h,
                                                thickness: 2,
                                                color: AppStyles
                                                    .appBackgroundColor,
                                              );
                                            },
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w, vertical: 10.h),
                                            shrinkWrap: true,
                                            itemCount:
                                                productReviews.take(4).length,
                                            itemBuilder: (context, index) {
                                              Review review =
                                                  productReviews[index];
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      review.isAnonymous == 1
                                                          ? Text(
                                                              'User'.tr,
                                                              style: AppStyles
                                                                  .kFontGrey12w5
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppStyles
                                                                    .blackColor,
                                                              ),
                                                            )
                                                          : Text(
                                                              '${review.customer?.firstName.toString().capitalizeFirst} ${review.customer?.lastName.toString().capitalizeFirst}',
                                                              style: AppStyles
                                                                  .kFontGrey12w5
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppStyles
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        '- ' +
                                                            CustomDate()
                                                                .formattedDate(
                                                                    review
                                                                        .createdAt),
                                                        style: AppStyles
                                                            .kFontGrey12w5,
                                                      ),
                                                      Expanded(
                                                          child: Container()),
                                                      StarCounterWidget(
                                                        value: int.parse(review
                                                                .rating
                                                                .toString())
                                                            .toDouble(),
                                                        color: AppStyles
                                                            .goldenYellowColor,
                                                        size: 15,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    review.review ?? '',
                                                    style:
                                                        AppStyles.kFontGrey12w5,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              currencyController.vendorType.value == "single"
                                  ? SizedBox.shrink()
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.h),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _productDetailsModel
                                                      .data?.seller?.photo !=
                                                  null
                                              ? Image.network(
                                                  AppConfig.assetPath +
                                                      '/' +
                                                      '${_productDetailsModel.data?.seller?.photo}',
                                                  height: 40.w,
                                                  width: 40.w,
                                                  fit: BoxFit.contain,
                                                  errorBuilder:
                                                      (context, obj, stack) {
                                                    return Image.asset(
                                                      AppConfig.appLogo,
                                                      height: 40.w,
                                                      width: 40.w,
                                                    );
                                                  },
                                                )
                                              : CircleAvatar(
                                                  foregroundColor:
                                                      AppStyles.pinkColor,
                                                  backgroundColor:
                                                      AppStyles.pinkColor,
                                                  radius: 20.r,
                                                  child: Container(
                                                    color: AppStyles.pinkColor,
                                                    child: Image.asset(
                                                      AppConfig.appLogo,
                                                      width: 20.w,
                                                      height: 20.w,
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${_productDetailsModel.data?.seller?.name ?? ""}',
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyles.kFontBlack14w5
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.fontSize),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                        ],
                                      ),
                                    ),

                              Divider(
                                height: 1,
                                thickness: 1,
                                color: AppStyles.textFieldFillColor,
                              ),

                              SizedBox(
                                height: 10.w,
                              ),

                              (_productDetailsModel.data?.product
                                              ?.relatedProducts?.length ??
                                          0) >
                                      0
                                  ? Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w, vertical: 10.h),
                                              child:
                                                  Text('Related Products'.tr)),
                                          Divider(
                                            color: AppStyles.textFieldFillColor,
                                            thickness: 1,
                                            height: 1,
                                          ),
                                          Builder(builder: (context) {
                                            List<ProductModel> relatedProducts =
                                                [];
                                            _productDetailsModel
                                                .data?.product?.relatedProducts
                                                ?.forEach((element) {
                                              if ((element.relatedSellerProducts
                                                          ?.length ??
                                                      0) >
                                                  0) {
                                                relatedProducts.add(element
                                                        .relatedSellerProducts
                                                        ?.first ??
                                                    ProductModel());
                                              }
                                            });
                                            return Container(
                                              height: 220.h,
                                              child: ListView.separated(
                                                  itemCount: relatedProducts
                                                      .toSet()
                                                      .toList()
                                                      .length,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w,
                                                      vertical: 15.h),
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width: 10.w,
                                                    );
                                                  },
                                                  itemBuilder: (context,
                                                      relatedProductIndex) {
                                                    ProductModel prod =
                                                        relatedProducts[
                                                            relatedProductIndex];
                                                    return HorizontalProductWidget(
                                                      productModel: prod,
                                                    );
                                                  }),
                                            );
                                          }),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),

                              _productDetailsModel
                                          .data?.product?.displayInDetails ==
                                      1
                                  ? (_productDetailsModel.data?.product
                                                  ?.upSalesProducts?.length ??
                                              0) >
                                          0
                                      ? Container(
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 10.h),
                                                  child: Text(
                                                      'Up Sales Products'.tr)),
                                              Divider(
                                                color: AppStyles
                                                    .textFieldFillColor,
                                                thickness: 1,
                                                height: 1,
                                              ),
                                              Builder(builder: (context) {
                                                List<ProductModel>
                                                    upSalesProducts = [];
                                                _productDetailsModel.data
                                                    ?.product?.upSalesProducts
                                                    ?.forEach((element) {
                                                  if ((element.upSaleProducts
                                                              ?.length ??
                                                          0) >
                                                      0) {
                                                    upSalesProducts.add(element
                                                            .upSaleProducts
                                                            ?.first ??
                                                        ProductModel());
                                                  }
                                                });
                                                return Container(
                                                  height: 220.h,
                                                  child: ListView.separated(
                                                      itemCount: upSalesProducts
                                                          .toSet()
                                                          .toList()
                                                          .length,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w,
                                                              vertical: 15.w),
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return SizedBox(
                                                          width: 10.w,
                                                        );
                                                      },
                                                      itemBuilder: (context,
                                                          upSalesIndex) {
                                                        ProductModel prod =
                                                            upSalesProducts[
                                                                upSalesIndex];
                                                        return HorizontalProductWidget(
                                                          productModel: prod,
                                                        );
                                                      }),
                                                );
                                              }),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink()
                                  : (_productDetailsModel
                                                  .data
                                                  ?.product
                                                  ?.crossSalesProducts
                                                  ?.length ??
                                              0) >
                                          0
                                      ? Container(
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 10.h),
                                                  child: Text(
                                                      'Cross Sales Products'
                                                          .tr)),
                                              Divider(
                                                color: AppStyles
                                                    .textFieldFillColor,
                                                thickness: 1,
                                                height: 1,
                                              ),
                                              Builder(builder: (context) {
                                                List<ProductModel>
                                                    crossSalesProducts = [];
                                                _productDetailsModel
                                                    .data
                                                    ?.product
                                                    ?.crossSalesProducts
                                                    ?.forEach((element) {
                                                  if ((element.crossSaleProducts
                                                              ?.length ??
                                                          0) >
                                                      0) {
                                                    crossSalesProducts.add(
                                                        element.crossSaleProducts
                                                                ?.first ??
                                                            ProductModel());
                                                  }
                                                });
                                                return Container(
                                                  height: 220.h,
                                                  child: ListView.separated(
                                                      itemCount:
                                                          crossSalesProducts
                                                              .toSet()
                                                              .toList()
                                                              .length,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w,
                                                              vertical: 15.w),
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return SizedBox(
                                                          width: 10.w,
                                                        );
                                                      },
                                                      itemBuilder: (context,
                                                          crossSalesIndex) {
                                                        ProductModel prod =
                                                            crossSalesProducts[
                                                                crossSalesIndex];
                                                        return HorizontalProductWidget(
                                                          productModel: prod,
                                                        );
                                                      }),
                                                );
                                              }),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink(),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Text(
                              'You might like'.tr,
                              textAlign: TextAlign.center,
                              style: AppStyles.appFont.copyWith(
                                color: AppStyles.blackColor,
                                fontSize: 16.fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        LoadingMoreSliverList<ProductModel>(
                          SliverListConfig<ProductModel>(
                            padding: EdgeInsets.all(5.w),
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
                  bottomNavigationBar: Container(
                      height: 66.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10.r,
                            offset: Offset(0.0, 0.3),
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20.w),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => MainNavigation(
                                    navIndex: 0,
                                    hideNavBar: false,
                                  ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/images/icon_nav_home.svg',
                                    color: AppStyles.pinkColor,
                                    width: 25.w,
                                  ),
                                ),
                                Text(
                                  'Home'.tr,
                                  style: AppStyles.kFontPink15w5.copyWith(
                                    fontSize: 12.fontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          currencyController.vendorType.value == "single"
                              ? GestureDetector(
                                  onTap: () {
                                    Get.to(() => CartMain(false));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: SvgPicture.asset(
                                          'assets/images/icon_nav_cart.svg',
                                          color: AppStyles.pinkColor,
                                          width: 25.w,
                                        ),
                                      ),
                                      Text(
                                        'Cart'.tr,
                                        style: AppStyles.kFontPink15w5.copyWith(
                                          fontSize: 12.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    print(
                                        _productDetailsModel.data?.seller?.id);
                                    Get.to(() => StoreHome(
                                          sellerId: _productDetailsModel
                                                  .data?.seller?.id ??
                                              0,
                                        ));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_store_alt.png',
                                        width: 25.w,
                                      ),
                                      Text(
                                        'Store'.tr,
                                        style: AppStyles.kFontPink15w5.copyWith(
                                          fontSize: 12.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_loginController.loggedIn.value) {
                                Get.to(() => Account(enableBackButton: true));
                              } else {
                                Get.to(() =>
                                    SignInOrRegister(enableBackButton: true));
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/images/icon_nav_account.svg',
                                    color: AppStyles.pinkColor,
                                    width: 25.w,
                                  ),
                                ),
                                Text(
                                  'Account'.tr,
                                  style: AppStyles.kFontPink15w5.copyWith(
                                    fontSize: 12.fontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          ClipPath(
                            clipper: AppLocalizations.isRtl()
                                ? SkewCutBottomLeft()
                                : SkewCutRight(),
                            child: _isLoading
                                ? Container(
                                    alignment: Alignment.center,
                                    width: Get.width * 0.40,
                                    decoration: BoxDecoration(
                                      color: AppStyles.pinkColor,
                                    ),
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {

                                          setState(() {
                                            _isLoading = true;
                                          });
                                          if (_productDetailsModel.data?.variantDetails?.length ==
                                              0) {
                                            if (stockManage == 1) {
                                              if (stockCount > 0) {
                                                if (_productDetailsModel
                                                    .data
                                                    ?.product
                                                    ?.minimumOrderQty >
                                                    _productDetailsModel
                                                        .data
                                                        ?.skus
                                                        ?.first
                                                        .productStock) {
                                                  SnackBars().snackBarWarning(
                                                      'No more stock'.tr);
                                                } else {
                                                  Map<String,dynamic> data = {
                                                    'product_id':
                                                    _productDetailsModel
                                                        .data?.skus?.first.id,
                                                    'qty': 1,
                                                    'price': getPriceForCart(),
                                                    'seller_id':
                                                    _productDetailsModel
                                                        .data?.userId,
                                                    'product_type': 'product',
                                                    'checked': true,
                                                    "in_app_purchase_id" :  _productDetailsModel
                                                        .data?.skus?.first.inAppPurchaseId,
                                                  };

                                                  if(Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0){

                                                    inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);

                                                  }else{
                                                    // final CartController cartController = Get.put(CartController());
                                                    final CartController cartController = Get.find();
                                                    await cartController.addToCart(data).then((value) {
                                                      if (value) {
                                                        SnackBars().snackBarSuccess(
                                                            'Card Added successfully'
                                                                .tr);
                                                      }
                                                    });
                                                  }



                                                }
                                              } else {
                                                SnackBars().snackBarWarning(
                                                    'No more stock'.tr);
                                              }
                                            } else {
                                              Map<String, dynamic> data = {
                                                'product_id': _productDetailsModel
                                                    .data?.skus?.first.id,
                                                'qty': 1,
                                                'price': getPriceForCart(),
                                                'seller_id': _productDetailsModel
                                                    .data?.userId,
                                                'product_type': 'product',
                                                'checked': true,
                                                "in_app_purchase_id" :  _productDetailsModel
                                                    .data?.skus?.first.inAppPurchaseId,
                                              };


                                              if(Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0){
                                                inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                                              }else{

                                              // final CartController
                                              // cartController =
                                              // Get.put(CartController());
                                                final CartController cartController = Get.find();
                                              await cartController.addToCart(data);
                                              }
                                            }
                                          } else {
                                            if (stockManage == 1) {
                                              if (stockCount >= 1) {
                                                await Get.bottomSheet(
                                                  AddToCartWidget(
                                                      _productDetailsModel
                                                          .data?.id ??
                                                          0),
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                  Colors.transparent,
                                                  persistent: true,
                                                );
                                              }
                                            } else {
                                              print('click');
                                              await Get.bottomSheet(
                                                AddToCartWidget(
                                                    _productDetailsModel
                                                        .data?.id ??
                                                        0),
                                                isScrollControlled: true,
                                                backgroundColor:
                                                Colors.transparent,
                                                persistent: true,
                                              );
                                              Get.delete<
                                                  ProductDetailsController>();
                                            }
                                          }
                                          setState(() {
                                            _isLoading = false;
                                          });

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: Get.width * 0.40,
                                      decoration: BoxDecoration(
                                        color: AppStyles.pinkColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.w),
                                        child: stockManage == 1
                                            ? Text(
                                                stockCount >= 1
                                                    ? Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0 ?  "Buy now".tr :"Add to Cart".tr
                                                    : "Out of Stock".tr,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontWhite14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0 ?  "Buy now".tr :"Add to Cart".tr,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontWhite14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      )),
                ),
              );
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: CustomLoadingWidget(),
          );
        });
  }

  ExpandableNotifier htmlExpandingWidget(text) {

    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expandable(
              controller: ExpandableController.of(context),
              collapsed: Container(
                height: 50.h,
                width: Get.width,
                // child: Html(
                //   data: '''$text''',
                //   style: {
                //     "td": Style(
                //       width: Width(double.infinity),
                //       fontSize: FontSize(13.fontSize),
                //         fontWeight: FontWeight.w500
                //       // width: double.infinity,
                //     ),
                //
                //     "h1": Style(
                //         // width: Width(double.infinity),
                //         fontSize: FontSize(13.fontSize),
                //         fontWeight: FontWeight.w500
                //       // width: double.infinity,
                //     ),
                //
                //     "p": Style(
                //         // width: Width(double.infinity),
                //         fontSize: FontSize(13.fontSize),
                //         fontWeight: FontWeight.w500
                //       // width: double.infinity,
                //     ),
                //   },
                // ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: HtmlWidget(
                    text,
                    textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              expanded: Container(
                // child: Html(
                //   data: '''$text''',
                //   style: {
                //     "td": Style(
                //       width: Width(double.infinity),
                //         fontSize: FontSize(13.fontSize),
                //       fontWeight: FontWeight.w500
                //
                //       // width: double.infinity,
                //     ),
                //   },
                // ),
                child: HtmlWidget(
                    text,
                  textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    var controller = ExpandableController.of(context);
                    return TextButton(
                      child: Text(
                        !controller!.expanded ? "View more".tr : "Show less".tr,
                        style: AppStyles.kFontGrey12w5,
                      ),
                      onPressed: () {
                        controller.toggle();
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PhotoViewerWidget extends StatefulWidget {
  final ProductDetailsModel productDetailsModel;
  final int initialIndex;

  PhotoViewerWidget({required this.productDetailsModel, this.initialIndex = 0});

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> {
  int currentIndex = 0;
  PageController? pageController;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = pageController!.initialPage;
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(AppConfig.assetPath +
                    '/' +
                    '${widget.productDetailsModel.data?.product?.gallaryImages?[index].imagesSource}'),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.productDetailsModel.data?.product
                            ?.gallaryImages?[index].id ??
                        0),
              );
            },
            itemCount:
                widget.productDetailsModel.data?.product?.gallaryImages?.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0.w,
                height: 20.0.w,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 0).toInt(),
                ),
              ),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.white,
            ),
            pageController: pageController,
            onPageChanged: onPageChanged,
            enableRotation: false,
          ),
        ),
        Positioned(
          top: Get.statusBarHeight * 0.3,
          left: 10.w,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  )),
              Text(
                  "${widget.productDetailsModel.data?.productName?.capitalizeFirst ?? ""}",
                  style: AppStyles.kFontBlack14w5),
            ],
          ),
        ),
        Positioned(
          bottom: Get.bottomBarHeight * 0.3,
          left: 0,
          right: 0,
          child: Container(
            height: Get.height * 0.1,
            width: 100.w,
            child: ListView.separated(
                itemCount: widget.productDetailsModel.data?.product
                        ?.gallaryImages?.length ??
                    0,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10.w);
                },
                itemBuilder: (context, imageIndex) {
                  return GestureDetector(
                    onTap: () {
                      pageController?.jumpToPage(imageIndex);
                    },
                    child: Container(
                      width: 60.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: imageIndex == currentIndex
                            ? Colors.red
                            : Colors.white,
                      )),
                      child: FancyShimmerImage(
                        imageUrl: AppConfig.assetPath +
                            '/' +
                            '${widget.productDetailsModel.data?.product?.gallaryImages?[imageIndex].imagesSource}',
                        boxFit: BoxFit.contain,
                        errorWidget: FancyShimmerImage(
                          imageUrl:
                              "${AppConfig.assetPath}/backend/img/default.png",
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
