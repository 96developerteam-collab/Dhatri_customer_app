import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductDetailsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductSkus.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/model/NewModel/Product/SellerSkuModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/authentication/LoginPage.dart';
import 'package:amazcart/view/amazy_view/cart/CartMain.dart';
import 'package:amazcart/view/amazy_view/products/RatingsAndReviews.dart';
import 'package:amazcart/view/amazy_view/products/category/ProductsByCategory.dart';
import 'package:amazcart/view/amazy_view/products/tags/ProductsByTags.dart';
import 'package:amazcart/view/amazy_view/seller/StoreHome.dart';
import 'package:amazcart/widgets/amazy_widget/CustomDate.dart';
import 'package:amazcart/widgets/amazy_widget/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/amazy_widget/StarCounterWidget.dart';
import 'package:amazcart/widgets/amazy_widget/custom_color_convert.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazy_widget/custom_radio_button.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/HorizontalProductWidget.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:badges/badges.dart' as badges;
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

import '../../../../AppConfig/language/app_localizations.dart';
import '../../../../config/config.dart';
import '../../../../controller/in-app-purchase_controller.dart';
import '../../../../model/NewModel/Product/ProductModel.dart';
import '../../../../model/NewModel/Product/ProductType.dart';
import '../../../../model/NewModel/Product/Review.dart';

class ProductDetails extends StatefulWidget {
  final int? productID;
  // final double averageRating;

  ProductDetails({this.productID}); //required this.averageRating,

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CartController cartController = Get.find();
  final ProductDetailsController controller =
      Get.put(ProductDetailsController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  final LoginController _loginController = Get.put(LoginController());

  List<bool> selected = [];

  Future<ProductDetailsModel>? getProductFuture;

  ProductDetailsModel _productDetailsModel = ProductDetailsModel();

  List<Review> productReviews = [];

  int stockManage = 0;
  int stockCount = 0;

  double totalRating = 0.0;
  double averageRating = 0.0;

  bool _inWishList = false;
  int? _wishListId;

  var shippingValue;

  Future<ProductDetailsModel> getProductDetails() async {

    try{
      await controller.getProductDetails2(widget.productID).then((value) async {

    // Convert to JSON
    final jsonData = const JsonEncoder.withIndent('  ').convert(value);

    print("loaded data:\n$jsonData");
        log("lodded data :::3 ${value}");
        _productDetailsModel = value;
        controller.itemQuantity.value =
            controller.products.value.data?.product?.minimumOrderQty??1;
        controller.productId.value = widget.productID!;

        // controller.shippingValue.value =
        //     controller.products.value.data.product.shippingMethods.first;

        controller.products.value.data?.variantDetails?.forEach((element) {
          if (element.name == 'Color') {
            element.code?.forEach((element2) {
              selected.add(false);
              selected[0] = true;
            });
          }
        });

        for (var i = 0;
        i < (controller.products.value.data?.variantDetails?.length??0);
        i++) {
          getSKU.addAll({
            'id[$i]':
            "${controller.products.value.data!.variantDetails![i].attrValId!.first}-${controller.products.value.data!.variantDetails![i].attrId}",
          });
        }

        productReviews = (_productDetailsModel.data?.reviews??[]).where((element) => element.type == ProductType.PRODUCT).toList();

        if(productReviews.isNotEmpty){
          for(int i = 0; i < productReviews.length; i++){
            totalRating += productReviews[i].rating!;
          }
          averageRating = (totalRating / productReviews.length).toDouble();
          print('object ::: $totalRating ::: ${productReviews.length} ::: $averageRating');
        }


        await checkWishList().then((value) async {
          if ((_productDetailsModel.data?.variantDetails?.length??0) > 0) {
            await skuGet();
          } else {
            setState(() {
              stockManage =_productDetailsModel.data?.stockManage??0;
              stockCount = _productDetailsModel.data?.skus?.first.productStock??0;
            });

            controller.productSKU.value.sku = _productDetailsModel.data?.product?.skus?.first??ProductSku();
          }
        });
      });
    }catch(e,tr){
      log("Error ::: $e");
      log("Track ::: $tr");
    }
    return _productDetailsModel;
  }

  Future skuGet() async {
    for (var i = 0; i < _productDetailsModel.data!.variantDetails!.length; i++) {
      getSKU.addAll({
        'id[$i]': "${_productDetailsModel.data!.variantDetails![i].attrValId!.first}-${_productDetailsModel.data!.variantDetails![i].attrId}"
      });
    }
    getSKU.addAll({
      'product_id': _productDetailsModel.data!.id,
      'user_id': _productDetailsModel.data!.userId
    });
    await getSkuWisePrice(getSKU);
  }

  Future getSkuWisePrice(Map data) async {
    try {
      DIO.Response response;
      DIO.Dio dio = new DIO.Dio();
      var formData = DIO.FormData();
      data.forEach((k, v) {
        formData.fields.add(MapEntry(k, v.toString()));
      });
      response = await dio.post(
        URLs.PRODUCT_PRICE_SKU_WISE + "?lang=${AppLocalizations.getLanguageCode()}",
        options: DIO.Options(
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );
      if (response.data == "0") {
        SnackBars().snackBarWarning('Product not available'.tr);
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);

        SkuData productSKU = SkuData.fromJson(returnData['data']);

        setState(() {
          stockManage = _productDetailsModel.data!.stockManage!;
          stockCount = productSKU.productStock;
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  Future checkWishList() async {
    if (!_loginController.loggedIn.value) {
      return;
    } else {
      final MyWishListController _myWishListController =
          Get.put(MyWishListController());

      _myWishListController.wishListProducts.forEach((element) {
        if (element.id == widget.productID) {
          setState(() {
            _inWishList = true;
            _wishListId = element.id;
          });
        }
      });
    }
  }

  Map getSKU = {};

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  String getDiscountType(ProductModel productModel) {
    String discountType;

    if (productModel.hasDeal != null) {
      if (productModel.hasDeal?.discountType == 0) {
        discountType =
            '(-${productModel.hasDeal!.discount!.toStringAsFixed(2)}%)';
      } else {
        discountType =
            '(-${(productModel.hasDeal!.discount! * _settingsController.conversionRate.value).toStringAsFixed(2)}${_settingsController.appCurrency.value})';
      }
    } else {
      if ((productModel.discount??0) > 0) {
        if (productModel.discountType == '0') {
          discountType = '(-${productModel.discount!.toStringAsFixed(2)}%)';
        } else {
          discountType =
              '(-${(productModel.discount! * _settingsController.conversionRate.value).toStringAsFixed(2)}${_settingsController.appCurrency.value})';
        }
      } else {
        discountType = '';
      }
    }

    return discountType;
  }

  double getPriceForCart() {
    String textString = _settingsController.calculatePrice(_productDetailsModel.data ?? ProductModel());
    textString =
        textString.replaceAll("${_settingsController.appCurrency.value}", '');
    var cartPrice = double.tryParse(textString) ?? 0;

    return cartPrice;
  }

  void openCategory(dynamic category) {
    Get.to(() => ProductsByCategory(
          categoryId: category.id,
        ));
  }

  late InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    if (Platform.isIOS) {
      inAppPurchaseController = Get.find();
    }
    getProductFuture = getProductDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   return FutureBuilder<ProductDetailsModel>(
       future: getProductFuture,
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.done) {
           if (snapshot.hasError) {
             return Center(
               child: Text(
                 '${snapshot.error} occurred',
                 style: TextStyle(fontSize: 18.fontSize),
               ),
             );
           } else if (snapshot.hasData) {
             return Scaffold(
               backgroundColor: Colors.white,
               body: NestedScrollView(
                // physics: NeverScrollableScrollPhysics(),
                 headerSliverBuilder:
                     (BuildContext context, bool innerBoxIsScrolled) {
                   return <Widget>[
                     SliverAppBar(
                       expandedHeight: 250.0.h,
                       pinned: true,
                       collapsedHeight: 70.h,
                       stretch: false,
                       forceElevated: false,
                       titleSpacing: 0,
                       scrolledUnderElevation: 0,
                       backgroundColor: Colors.white,
                       automaticallyImplyLeading: false,
                       title: SliverAppBarTitleWidget(
                         child: Row(
                           children: [
                             Padding(
                               padding: EdgeInsets.only(left: 10.w, top: 2),
                               child: IconButton(
                                 tooltip: "Back".tr,
                                 icon: Icon(
                                   Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
                                   color: Colors.black,
                                   size: 18.w,
                                 ),
                                 onPressed: () {
                                   Get.back();
                                 },
                               ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 8.0),
                                 child: Text(
                                   _productDetailsModel.data?.productName??'',
                                   maxLines: 1,
                                   style: AppStyles.kFontBlack17w5
                                       .copyWith(fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             SizedBox(
                               width: 10,
                             ),
                             Container(
                               margin: EdgeInsets.only(right: 10),
                               child: FloatingActionButton(
                                 heroTag: null,
                                 tooltip: "Wishlist".tr,
                                 elevation: 0,
                                 enableFeedback: false,
                                 backgroundColor: Colors.transparent,
                                 child: Container(
                                   width: 30.w,
                                   height: 30.w,
                                   child: InkWell(
                                     onTap: () async {
                                       final LoginController loginController =
                                       Get.put(LoginController());

                                       if (loginController.loggedIn.value) {
                                         final MyWishListController
                                         wishListController =
                                         Get.put(MyWishListController());
                                         if (_inWishList) {
                                           await wishListController
                                               .deleteWishListProduct(
                                               _wishListId)
                                               .then((value) {
                                             setState(() {
                                               _inWishList = false;
                                             });
                                           });
                                         } else {
                                           Map data = {
                                             'seller_product_id':
                                             _productDetailsModel.data!.id,
                                             'seller_id': _productDetailsModel
                                                 .data!.seller!.id,
                                             'type': 'product',
                                           };

                                           await wishListController
                                               .addProductToWishList(data)
                                               .then((value) {
                                             setState(() {
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
                                       color: AppStyles.pinkColor,
                                     ),
                                   ),
                                 ),
                                 onPressed: null,
                               ),
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
                                 child: (_productDetailsModel.data?.product?.gallaryImages?.length??0) >
                                     1
                                     ? Container(
                                   child: Swiper(
                                     itemBuilder: (BuildContext context,
                                         int index) {
                                       return Container(
                                         padding: EdgeInsets.all(
                                             kToolbarHeight),
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
                                             imageUrl:
                                             "${AppConfig
                                                 .assetPath}/${_productDetailsModel
                                                 .data!.product!
                                                 .gallaryImages![index]
                                                 .imagesSource}",
                                             boxFit: BoxFit.contain,
                                             errorWidget:
                                             FancyShimmerImage(
                                               imageUrl:
                                               "${AppConfig
                                                   .assetPath}/backend/img/default.png",
                                               boxFit: BoxFit.contain,
                                             ),
                                           ),
                                         ),
                                       );
                                     },
                                     itemCount: _productDetailsModel.data!
                                         .product!.gallaryImages!.length,
                                     control: new SwiperControl(
                                         color: AppStyles.pinkColor),
                                     pagination: SwiperPagination(
                                         builder: SwiperCustomPagination(
                                             builder:
                                                 (BuildContext context,
                                                 SwiperPluginConfig
                                                 config) {
                                               return Align(
                                                 alignment:
                                                 Alignment.bottomCenter,
                                                 child:
                                                 RectSwiperPaginationBuilder(
                                                   color: AppStyles
                                                       .lightBlueColorAlt,
                                                   activeColor:
                                                   AppStyles.pinkColor,
                                                   size: Size(10.0, 10.0),
                                                   activeSize: Size(10.0, 10.0),
                                                 ).build(context, config),
                                               );
                                             })),
                                   ),
                                 )
                                     : Container(
                                   padding:
                                   EdgeInsets.all(kToolbarHeight),
                                   child: InkWell(
                                     onTap: () {
                                       Get.to(() =>
                                           PhotoViewerWidget(
                                             productDetailsModel:
                                             _productDetailsModel,
                                             initialIndex: 0,
                                           ));
                                     },
                                     child: FancyShimmerImage(
                                       imageUrl:
                                       "${AppConfig
                                           .assetPath}/${_productDetailsModel.data?.product?.thumbnailImageSource}",
                                       boxFit: BoxFit.contain,
                                       errorWidget: FancyShimmerImage(
                                         imageUrl:
                                         "${AppConfig
                                             .assetPath}/backend/img/default.png",
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
                                           horizontal: 10),
                                       child: Container(
                                         width: 45.w,
                                         decoration: BoxDecoration(
                                           color: AppStyles.pinkColor.withOpacity(0.15),
                                           shape: BoxShape.circle,
                                         ),
                                         child: FloatingActionButton(
                                           heroTag: null,
                                           tooltip: "Back".tr,
                                           elevation: 0,
                                           enableFeedback: false,
                                           backgroundColor: Colors.transparent,
                                           child: Icon(
                                             Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
                                             color: AppStyles.pinkColor,
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
                                     Padding(
                                       padding: EdgeInsets.symmetric(
                                           horizontal: 10),
                                       child: Container(
                                         width: 45.w,
                                         decoration: BoxDecoration(
                                           color: AppStyles.pinkColor.withOpacity(0.15),
                                           shape: BoxShape.circle,
                                         ),
                                         child: FloatingActionButton(
                                           heroTag: null,
                                           tooltip: "Wishlist".tr,
                                           elevation: 0,
                                           enableFeedback: false,
                                           backgroundColor: Colors.transparent,
                                           child: Container(
                                             width: 30.w,
                                             height: 30.w,
                                             child: InkWell(
                                               onTap: () async {
                                                 final LoginController
                                                 loginController = Get.put(
                                                     LoginController());

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
                                                         _inWishList = false;
                                                       });
                                                     });
                                                   } else {
                                                     Map data = {
                                                       'seller_product_id':
                                                       _productDetailsModel
                                                           .data!.id,
                                                       'seller_id':
                                                       _productDetailsModel
                                                           .data!.seller!.id,
                                                       'type': 'product',
                                                     };

                                                     await wishListController
                                                         .addProductToWishList(
                                                         data)
                                                         .then((value) {
                                                       setState(() {
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
                                                     ? FontAwesomeIcons
                                                     .solidHeart
                                                     : FontAwesomeIcons.heart,
                                                 size: 20.w,
                                                 color: _inWishList
                                                     ? AppStyles.pinkColor
                                                     : AppStyles
                                                     .greyColorLight,
                                               ),
                                             ),
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
                       child: Padding(
                         padding: EdgeInsets.symmetric(
                             horizontal: 20.0, vertical: 4),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Expanded(
                                   child: Text(
                                     _productDetailsModel.data?.productName??'',
                                     style: AppStyles.appFontBold.copyWith(
                                       fontSize: 22.fontSize,
                                     ),
                                   ),
                                 ),
                                 Container(
                                   width: 40.w,
                                   height: 40.w,
                                   padding: EdgeInsets.all(5.w),
                                   decoration: BoxDecoration(
                                     color: AppStyles.pinkColor.withOpacity(0.15),
                                     shape: BoxShape.circle,
                                   ),
                                   child: InkWell(
                                     onTap: () {
                                       Share.share(
                                           '${URLs
                                               .HOST}/product/${_productDetailsModel
                                               .data?.slug??''}',
                                           subject: _productDetailsModel
                                               .data?.productName??'');
                                     },
                                     child: Icon(
                                       FontAwesomeIcons.shareNodes,
                                       size: 16.w,
                                       color: AppStyles.pinkColor,
                                     ),
                                   ),
                                 ),
                               ],
                             ),

                             _settingsController.vendorType.value == "single"
                                 ? _productDetailsModel.data?.stockManage == 1
                                 ? (_productDetailsModel.data?.skus?.first
                                 .productStock??0) >
                                 0
                                 ? Container(
                               margin: EdgeInsets.only(right: 5.w),
                               padding: EdgeInsets.symmetric(
                                 horizontal: 8,
                                 vertical: 4,
                               ),
                               color: Colors.green,
                               child: Text(
                                 "In Stock".tr,
                                 style: AppStyles.appFontBold
                                     .copyWith(
                                   fontSize: 12.fontSize,
                                   color: Colors.white,
                                 ),
                               ),
                             )
                                 : Container(
                               margin: EdgeInsets.only(right: 5.w),
                               padding: EdgeInsets.symmetric(
                                 horizontal: 8,
                                 vertical: 4,
                               ),
                               color: Colors.red,
                               child: Text(
                                 "Not in Stock".tr,
                                 style: AppStyles.appFontBold
                                     .copyWith(
                                   fontSize: 12.fontSize,
                                   color: Colors.white,
                                 ),
                               ),
                             )
                                 : SizedBox.shrink()
                                 : Row(
                               children: [
                                 _productDetailsModel.data?.stockManage ==
                                     1
                                     ? (_productDetailsModel.data?.skus?.first.productStock??0) >
                                     0
                                     ? Container(
                                   margin: EdgeInsets.only(
                                       right: 5.w),
                                   padding:
                                   EdgeInsets.symmetric(
                                     horizontal: 8,
                                     vertical: 4,
                                   ),
                                   color: Colors.green,
                                   child: Text(
                                     "In Stock".tr,
                                     style: AppStyles
                                         .appFontBold
                                         .copyWith(
                                       fontSize: 12.fontSize,
                                       color: Colors.white,
                                     ),
                                   ),
                                 )
                                     : Container(
                                   margin: EdgeInsets.only(
                                       right: 5.w),
                                   padding:
                                   EdgeInsets.symmetric(
                                     horizontal: 8,
                                     vertical: 4,
                                   ),
                                   color: Colors.red,
                                   child: Text(
                                     "Not in Stock".tr,
                                     style: AppStyles
                                         .appFontBold
                                         .copyWith(
                                       fontSize: 12.fontSize,
                                       color: Colors.white,
                                     ),
                                   ),
                                 )
                                     : SizedBox.shrink(),
                                 Row(
                                   children: [
                                     Text(
                                       "Store".tr + ": ",
                                       style: AppStyles.appFontBold
                                           .copyWith(
                                         fontSize: 16.fontSize,
                                       ),
                                     ),
                                     Text(
                                       "${_productDetailsModel.data?.seller?.name ?? ""}",
                                       style: AppStyles.appFontBold
                                           .copyWith(
                                         fontSize: 16.fontSize,
                                         color: AppStyles.pinkColor,
                                       ),
                                     ),
                                   ],
                                 ),
                                 Expanded(
                                   child: Container(),
                                 ),
                               ],
                             ),

                             SizedBox(
                               height: 10,
                             ),

                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top: 2.0),
                                   child:
                                   (_productDetailsModel.data?.avgRating ?? 0) >
                                       0
                                       ? StarCounterWidget(
                                     value: _productDetailsModel.data
                                         ?.avgRating ?? 0,
                                     color: AppStyles.pinkColor,
                                     size: 14.fontSize,
                                   )
                                       : StarCounterWidget(
                                     value: averageRating,
                                     color: AppStyles.pinkColor,
                                     size: 14.w,
                                   ),
                                 ),
                                 SizedBox(
                                   width: 5,
                                 ),
                                 (_productDetailsModel.data?.reviews?.length??0) <= 0
                                     ? Text(
                                   '${(_productDetailsModel.data?.avgRating ??
                                       0).toString()} (${_productDetailsModel.data?.reviews?.length??0
                                       .toString()} ${"Review".tr})',
                                   overflow: TextOverflow.ellipsis,
                                   style: AppStyles.appFontBook.copyWith(
                                     fontSize: 14.fontSize,
                                     color: AppStyles.greyColorBook,
                                   ),
                                 )
                                     : Container(),
                                 Expanded(child: Container()),

                                 if(!(Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0))
                                   Text(
                                   "Select Quantity".tr,
                                   style: AppStyles.appFontBook.copyWith(
                                     fontSize: 14.fontSize,
                                     color: AppStyles.greyColorBook,
                                   ),
                                 ),
                               ],
                             ),

                             SizedBox(
                               height: 10,
                             ),

                             Container(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       mainAxisAlignment:
                                       MainAxisAlignment.center,
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                          if (_productDetailsModel.data?.mrp != null &&
                                              _productDetailsModel.data!.mrp! > 0)
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 5.h),
                                              child: Text(
                                                _settingsController.setCurrentSymbolPosition(
                                                    amount: (_productDetailsModel.data!.mrp! *
                                                        _settingsController
                                                            .conversionRate.value)
                                                        .toStringAsFixed(2)),
                                                style: AppStyles.appFontBook.copyWith(
                                                  fontSize: 14.fontSize,
                                                  color: AppStyles.greyColorDark,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ),
                                         Obx(() {
                                           return Text(
                                             _settingsController.setCurrentSymbolPosition(amount: (controller.finalPrice.value * _settingsController.conversionRate.value).toStringAsFixed(2)),
                                             style: AppStyles.appFontBold
                                                 .copyWith(
                                               height: 1,
                                               fontSize: 26.fontSize,
                                             ),
                                           );
                                         }),
                                         _settingsController
                                             .calculateMainPriceWithVariant(
                                             _productDetailsModel.data??ProductModel()) !=
                                             ""
                                             ? Row(
                                           children: [
                                             Text(
                                               _settingsController
                                                   .calculateMainPriceWithVariant(
                                                   _productDetailsModel
                                                       .data!),
                                               style: AppStyles
                                                   .appFontBook
                                                   .copyWith(
                                                 height: 1,
                                                 color: AppStyles
                                                     .greyColorBook,
                                                 decoration:
                                                 TextDecoration
                                                     .lineThrough,
                                               ),
                                             ),
                                             SizedBox(
                                               width: 5,
                                             ),
                                             Text(
                                               getDiscountType(
                                                   _productDetailsModel
                                                       .data!),
                                               textHeightBehavior:
                                               ui.TextHeightBehavior(
                                                 applyHeightToFirstAscent:
                                                 false,
                                                 applyHeightToLastDescent:
                                                 false,
                                               ),
                                               style: AppStyles
                                                   .appFontBook
                                                   .copyWith(
                                                 height: 1,
                                                 color:
                                                 Color(0xff5c7185),
                                               ),
                                             ),
                                           ],
                                         )
                                             : SizedBox.shrink(),
                                       ],
                                     ),
                                   ),

                                   if(!(Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0))
                                   Container(
                                     padding: EdgeInsets.symmetric(
                                         horizontal: 8, vertical: 7),
                                     decoration: BoxDecoration(
                                         color: AppStyles.pinkColor.withOpacity(0.15),
                                         shape: BoxShape.rectangle,
                                         borderRadius:
                                         BorderRadius.circular(7.r)),
                                     child: Obx(() {
                                       return Row(
                                         children: [
                                           InkWell(
                                             onTap: () {
                                               if (controller
                                                   .itemQuantity.value <=
                                                   controller.minOrder.value) {
                                                 SnackBars().snackBarWarning(
                                                     "Can't add less than".tr +
                                                         ' ${controller.minOrder
                                                             .value} ' +
                                                         'Products'.tr);
                                               } else {
                                                 controller.cartDecrease();
                                               }
                                             },
                                             child: Icon(
                                               FontAwesomeIcons
                                                   .solidSquareMinus,
                                               color: Color(0xff5c7185),
                                               size: 20.w,
                                             ),
                                           ),
                                           SizedBox(
                                             width: 40,
                                           ),
                                           Text(
                                             "${controller.itemQuantity.value
                                                 .toString()}",
                                             style: AppStyles.appFontBold
                                                 .copyWith(
                                               fontSize: 18.fontSize,
                                               color: AppStyles.pinkColor,
                                             ),
                                           ),
                                           SizedBox(
                                             width: 40,
                                           ),
                                           InkWell(
                                             onTap: () {
                                               if (controller
                                                   .stockManage.value ==
                                                   1) {
                                                 if (controller
                                                     .itemQuantity.value >=
                                                     controller
                                                         .stockCount.value) {
                                                   SnackBars().snackBarWarning(
                                                       'Stock not available.'.tr);
                                                 } else {
                                                   controller.cartIncrease();
                                                 }
                                               } else {
                                                 if (controller.itemQuantity.value >= controller.maxOrder.value) {
                                                   SnackBars()
                                                       .snackBarWarning(
                                                       "Can't add more than"
                                                           .tr +
                                                           ' ${controller
                                                               .maxOrder
                                                               .value} ' +
                                                           'Products'.tr);
                                                 } else {
                                                   controller.cartIncrease();
                                                 }
                                                                                              }
                                             },
                                             child: Icon(
                                               FontAwesomeIcons
                                                   .solidSquarePlus,
                                               color: Color(0xff5c7185),
                                               size: 20.w,
                                             ),
                                           ),
                                         ],
                                       );
                                     }),
                                   ),
                                 ],
                               ),
                             ),

                             ((controller.products.value.data?.variantDetails??[]).length) >
                                 0
                                 ? SizedBox(
                               height: 10,
                             )
                                 : SizedBox.shrink(),

                             ListView.separated(
                                 shrinkWrap: true,
                                 padding: EdgeInsets.zero,
                                 physics: NeverScrollableScrollPhysics(),
                                 itemCount: (controller.products.value.data?.variantDetails??[]).length,
                                 separatorBuilder: (context, seperatedIndx) {
                                   return SizedBox(
                                     height: 10,
                                   );
                                 },
                                 itemBuilder: (context, variantIndex) {
                                   ProductVariantDetail variant = controller
                                       .products
                                       .value
                                       .data!
                                       .variantDetails![variantIndex];
                                   if (variant.name == 'Color') {
                                     return Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.center,
                                       mainAxisAlignment:
                                       MainAxisAlignment.center,
                                       children: [
                                         Container(
                                           margin: EdgeInsets.all(5),
                                           child: Text(
                                             '${variant.name}: ',
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: Color(0xff5c7185),
                                               fontSize: 18.fontSize,
                                             ),
                                           ),
                                         ),
                                         Expanded(
                                           child: Container(
                                             margin: EdgeInsets.all(5),
                                             child: Wrap(
                                               alignment: WrapAlignment.start,
                                               crossAxisAlignment:
                                               WrapCrossAlignment.center,
                                               spacing: 5,
                                               runSpacing: 5,
                                               children: List.generate(
                                                   variant.code!.length,
                                                       (colorIndex) {
                                                     var bgColor = 0;
                                                     if (!variant
                                                         .code![colorIndex]
                                                         .contains('#')) {
                                                       bgColor =
                                                           CustomColorConvert()
                                                               .colourNameToHex(
                                                               variant.code![
                                                               colorIndex]);
                                                     } else {
                                                       bgColor =
                                                           CustomColorConvert()
                                                               .getBGColor(
                                                               variant
                                                                   .code![
                                                               colorIndex]);
                                                     }
                                                     return GestureDetector(
                                                       onTap: () async {
                                                         setState(() {
                                                           selected.clear();
                                                           controller
                                                               .products
                                                               .value
                                                               .data!
                                                               .variantDetails!
                                                               .forEach((
                                                               element) {
                                                             if (element.name ==
                                                                 'Color') {
                                                               element.code!
                                                                   .forEach(
                                                                       (
                                                                       element2) {
                                                                     selected
                                                                         .add(
                                                                         false);
                                                                   });
                                                             }
                                                           });
                                                           selected[colorIndex] =
                                                           !selected[
                                                           colorIndex];
                                                         });
                                                         addValueToMap(
                                                             getSKU,
                                                             'id[$variantIndex]',
                                                             '${variant
                                                                 .attrValId![colorIndex]}-${variant
                                                                 .attrId}');
                                                         Map data = {
                                                           'product_id': controller
                                                               .products
                                                               .value
                                                               .data!
                                                               .id,
                                                           'user_id': controller
                                                               .products
                                                               .value
                                                               .data!
                                                               .userId,
                                                         };
                                                         data.addAll(getSKU);
                                                         await controller
                                                             .getSkuWisePrice(
                                                           data,
                                                         )
                                                             .then((value) {
                                                           if (value == false) {
                                                             setState(() {});
                                                           }
                                                         });
                                                       },
                                                       child: Container(
                                                         width: 30.w,
                                                         height: 30.w,
                                                         alignment:
                                                         Alignment.center,
                                                         padding:
                                                         const EdgeInsets.all(
                                                             2.0),
                                                         decoration: BoxDecoration(
                                                           border: Border.all(
                                                             color: selected[
                                                             colorIndex]
                                                                 ? AppStyles
                                                                 .pinkColor
                                                                 : Colors
                                                                 .transparent,
                                                           ),
                                                           shape: BoxShape
                                                               .circle,
                                                         ),
                                                         child: Stack(
                                                           children: [
                                                             Positioned.fill(
                                                               child: Container(
                                                                 width: 30.w,
                                                                 height: 30.w,
                                                                 decoration:
                                                                 BoxDecoration(
                                                                   shape: BoxShape
                                                                       .circle,
                                                                   color: Color(
                                                                       bgColor),
                                                                 ),
                                                               ),
                                                             ),
                                                           ],
                                                         ),
                                                       ),
                                                     );
                                                   }),
                                             ),
                                           ),
                                         ),
                                       ],
                                     );
                                   } else {
                                     return Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.center,
                                       mainAxisAlignment:
                                       MainAxisAlignment.center,
                                       children: [
                                         Container(
                                           margin: EdgeInsets.all(5),
                                           child: Text(
                                             '${variant.name?.tr}:    ',
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: Color(0xff5c7185),
                                               fontSize: 18.fontSize,
                                             ),
                                           ),
                                         ),
                                         Expanded(
                                           child: Container(
                                             child: CustomRadioButton(
                                               buttonLables: variant.value!,
                                               buttonValues: variant.attrValId!,
                                               radioButtonValue:
                                                   (value, index) async {
                                                 addValueToMap(
                                                     getSKU,
                                                     'id[$variantIndex]',
                                                     '$value-${variant
                                                         .attrId}');
                                                 Map data = {
                                                   'product_id': controller
                                                       .products.value.data!.id,
                                                   'user_id': controller
                                                       .products
                                                       .value
                                                       .data!
                                                       .userId,
                                                 };
                                                 data.addAll(getSKU);
                                                 await controller
                                                     .getSkuWisePrice(
                                                   data,
                                                 )
                                                     .then((value) {
                                                   if (value == false) {
                                                     setState(() {});
                                                   }
                                                 });
                                               },
                                               horizontal: true,
                                               enableShape: true,
                                               textColor: AppStyles.pinkColor,
                                               selectedTextColor: Colors.white,
                                               buttonColor:
                                               AppStyles.pinkColor.withOpacity(0.15),
                                               selectedColor:
                                               AppStyles.pinkColor,
                                               elevation: 0,
                                             ),
                                           ),
                                         ),
                                       ],
                                     );
                                   }
                                 }),

                             ((_productDetailsModel.data?.variantDetails??[]).length) >
                                 0
                                 ? SizedBox(
                               height: 10,
                             )
                                 : SizedBox.shrink(),

                             // ** Product Specifications

                             Container(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     padding:
                                     EdgeInsets.symmetric(vertical: 15.w),
                                     child: Text(
                                       'Product Specifications'.tr,
                                       style: AppStyles.appFontBook.copyWith(
                                         color: AppStyles.greyColorBook,
                                         fontSize: 12.fontSize
                                       ),
                                     ),
                                   ),
                                   Divider(
                                     color: AppStyles.textFieldFillColor,
                                     thickness: 1,
                                     height: 1,
                                   ),
                                 ],
                               ),
                             ),
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 15.h),
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
                                             width: 5,
                                           ),
                                           Text(
                                             "Brand".tr + ": ",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                           Text(
                                             "${_productDetailsModel.data?.product?.brand?.name??0}",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles.greyColorBook,
                                               fontSize: 12.fontSize
                                             ),
                                           ),
                                         ],
                                       ),
                                       SizedBox(
                                         height: 15,
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
                                             width: 5,
                                           ),
                                           Text(
                                             "Model Number".tr + ": ",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                           Text(
                                             "${_productDetailsModel.data?.product?.modelNumber??''}",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                         ],
                                       ),
                                       SizedBox(
                                         height: 15,
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
                                             width: 5,
                                           ),
                                           Text(
                                             "Availability".tr + ": ",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                           Text(
                                             "${_productDetailsModel.data!.skus!
                                                 .first.productStock! > 0
                                                 ? "In Stock".tr
                                                 : "Not in stock".tr}",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                         ],
                                       ),
                                       SizedBox(
                                         height: 15,
                                       ),
                                     ],
                                   )
                                       : SizedBox.shrink(),

                                   //** SKU */
                                   _productDetailsModel
                                       .data?.product?.skus?.first.sku !=
                                       null
                                       ? Column(
                                     children: [
                                       Row(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.center,
                                         children: [
                                           Container(
                                             width: 5,
                                             height: 5,
                                             color:
                                             AppStyles.darkBlueColor,
                                           ),
                                           SizedBox(
                                             width: 5,
                                           ),
                                           Text(
                                             "Product SKU".tr + ": ",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                           Obx(() {
                                             return Text(
                                               "${controller.productSKU.value
                                                   .sku?.sku??''}",
                                               style: AppStyles
                                                   .appFontBook
                                                   .copyWith(
                                                 color: AppStyles
                                                     .greyColorBook,
                                                   fontSize: 12.fontSize
                                               ),
                                             );
                                           }),
                                         ],
                                       ),
                                       SizedBox(
                                         height: 15,
                                       ),
                                     ],
                                   )
                                       : SizedBox.shrink(),

                                   //** Min Order Quantity */
                                   _productDetailsModel
                                       .data?.product?.minimumOrderQty !=
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
                                             width: 5,
                                           ),
                                           Text(
                                             "Minimum Order Quantity".tr +
                                                 ": ",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                           Text(
                                             "${_productDetailsModel.data?.product?.minimumOrderQty??''}",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                         ],
                                       ),
                                       SizedBox(
                                         height: 15,
                                       ),
                                     ],
                                   )
                                       : SizedBox.shrink(),

                                   //** Max Order Quantity */
                                   _productDetailsModel.data?.product?.maxOrderQty !=
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
                                             width: 5,
                                           ),
                                           Text(
                                             "Maximum Order Quantity".tr +
                                                 ": ",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                           Text(
                                             "${_productDetailsModel.data?.product?.maxOrderQty??1}",
                                             style: AppStyles.appFontBook
                                                 .copyWith(
                                               color: AppStyles
                                                   .greyColorBook,
                                                 fontSize: 12.fontSize
                                             ),
                                           ),
                                         ],
                                       ),
                                       SizedBox(
                                         height: 15,
                                       ),
                                     ],
                                   )
                                       : SizedBox.shrink(),

                                   //** Category */
                                   (_productDetailsModel.data?.product?.categories?.length??0) >
                                       0
                                       ? Column(
                                     children: [
                                       Wrap(
                                         spacing: 5,
                                         children: List.generate(
                                             _productDetailsModel
                                                 .data!
                                                 .product!
                                                 .categories!
                                                 .length +
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
                                                       .appFontBook
                                                       .copyWith(
                                                     color: AppStyles
                                                         .greyColorBook,
                                                       fontSize: 12.fontSize
                                                   ),
                                                 ),
                                                 SizedBox(
                                                   width: 5,
                                                 ),
                                               ],
                                             );
                                           }
                                           return InkWell(
                                             onTap: () {
                                               openCategory(
                                                   _productDetailsModel
                                                       .data!
                                                       .product!
                                                       .categories![
                                                   categoryIndex -
                                                       1]);
                                             },
                                             child: Chip(
                                               backgroundColor: AppStyles
                                                   .pinkColorAlt,
                                               shape:
                                               RoundedRectangleBorder(
                                                   borderRadius:
                                                   BorderRadius
                                                       .circular(
                                                       5.r)),
                                               label: Text(
                                                 '${_productDetailsModel.data!
                                                     .product!
                                                     .categories![categoryIndex -
                                                     1].name}',
                                                 style: AppStyles
                                                     .appFontBook
                                                     .copyWith(
                                                   color: AppStyles
                                                       .pinkColor,
                                                 ),
                                               ),
                                             ),
                                           );
                                         }),
                                       ),
                                       SizedBox(
                                         height: 15,
                                       ),
                                     ],
                                   )
                                       : SizedBox.shrink(),

                                   //** TAGS */
                                   (_productDetailsModel
                                       .data?.product?.tags?.length??0) >
                                       0
                                       ? Column(
                                     children: [
                                       Wrap(
                                         spacing: 5,
                                         children: List.generate(
                                             _productDetailsModel
                                                 .data!
                                                 .product!
                                                 .tags!
                                                 .length +
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
                                                       .appFontBook
                                                       .copyWith(
                                                     color: AppStyles
                                                         .greyColorBook,
                                                       fontSize: 12.fontSize
                                                   ),
                                                 ),
                                                 SizedBox(
                                                   width: 5,
                                                 ),
                                               ],
                                             );
                                           }
                                           return InkWell(
                                             onTap: () {
                                               Get.to(
                                                       () =>
                                                       ProductsByTags(
                                                         tagName: _productDetailsModel
                                                             .data!
                                                             .product!
                                                             .tags![
                                                         tagIndex -
                                                             1]
                                                             .name!,
                                                         tagId: _productDetailsModel
                                                             .data!
                                                             .product!
                                                             .tags![
                                                         tagIndex -
                                                             1]
                                                             .id!,
                                                       ));
                                             },
                                             child: Chip(
                                               backgroundColor: AppStyles
                                                   .pinkColorAlt,
                                               shape:
                                               RoundedRectangleBorder(
                                                   borderRadius:
                                                   BorderRadius
                                                       .circular(
                                                       5.r)),
                                               label: Text(
                                                 '${_productDetailsModel.data!
                                                     .product!.tags![tagIndex -
                                                     1].name}',
                                                 style: AppStyles
                                                     .appFontBook
                                                     .copyWith(
                                                   color: AppStyles
                                                       .pinkColor,
                                                     fontSize: 12.fontSize
                                                 ),
                                               ),
                                             ),
                                           );
                                         }),
                                       ),
                                       SizedBox(
                                         height: 15,
                                       ),
                                     ],
                                   )
                                       : SizedBox.shrink(),

                                   _productDetailsModel
                                       .data?.product?.specification !=
                                       null
                                       ? htmlExpandingWidget(
                                       "${_productDetailsModel.data!.product!
                                           .specification ?? ""}")
                                       : SizedBox.shrink(),
                                 ],
                               ),
                             ),

                             _productDetailsModel.data?.product?.description !=
                                 null
                                 ? Container(
                               child: Column(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(
                                         vertical: 10),
                                     child: Text(
                                       'Description'.tr,
                                       style: AppStyles.appFontBook
                                           .copyWith(
                                         color: AppStyles.greyColorBook,
                                           fontSize: 12.fontSize
                                       ),
                                     ),
                                   ),
                                   Divider(
                                     color: AppStyles.textFieldFillColor,
                                     thickness: 1,
                                     height: 1,
                                   ),
                                   Container(
                                     padding: EdgeInsets.symmetric(
                                         vertical: 10),
                                     child: htmlExpandingWidget(
                                         "${_productDetailsModel.data!.product!
                                             .description ?? ""}"),
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
                               EdgeInsets.symmetric(vertical: 10),
                               children: [
                                 InkWell(
                                   onTap: () {
                                     Get.to(() =>
                                         RatingsAndReviews(
                                           productReviews:
                                           productReviews,
                                         ));
                                   },
                                   child: Container(
                                     color: Colors.white,
                                     padding: EdgeInsets.symmetric(
                                         horizontal: 20, vertical: 15),
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
                                         horizontal: 20, vertical: 10),
                                     shrinkWrap: true,
                                     itemCount:
                                     productReviews
                                         .take(4)
                                         .length,
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
                                             height: 10,
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
                                                     fontSize: 12.fontSize
                                                 ),
                                               )
                                                   : Text(
                                                 review.customer!
                                                     .firstName
                                                     .toString()
                                                     .capitalizeFirst! +
                                                     ' ' +
                                                     review.customer!.lastName.toString().capitalizeFirst! ??
                                                     "",
                                                 style: AppStyles
                                                     .kFontGrey12w5
                                                     .copyWith(
                                                   fontWeight:
                                                   FontWeight
                                                       .bold,
                                                   color: AppStyles
                                                       .blackColor,
                                                     fontSize: 12.fontSize
                                                 ),
                                               ),
                                               SizedBox(
                                                 width: 5,
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
                                                 size: 15.w,
                                               ),
                                             ],
                                           ),
                                           SizedBox(
                                             height: 5,
                                           ),
                                           Text(
                                             review.review??'',
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
                             _settingsController.vendorType.value == "single"
                                 ? SizedBox.shrink()
                                 : Container(
                               padding:
                               EdgeInsets.symmetric(vertical: 15),
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
                                         (_productDetailsModel.data?.seller?.photo ?? ""),
                                     height: 40.w,
                                     width: 40.w,
                                     fit: BoxFit.contain,
                                     errorBuilder: (BuildContext
                                     context,
                                         Object? exception,
                                         StackTrace? stackTrace) {
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
                                     width: 10,
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
                                     width: 5,
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
                               height: 10,
                             ),

                             (_productDetailsModel.data?.product?.relatedProducts?.length??0) >
                                 0
                                 ? Container(
                               color: Colors.white,
                               child: Column(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(
                                         vertical: 10),
                                     child: Text(
                                       'Related Products'.tr,
                                       style: AppStyles.appFontBook
                                           .copyWith(
                                         color: AppStyles.greyColorBook,
                                           fontSize: 12.fontSize
                                       ),
                                     ),
                                   ),
                                   Divider(
                                     color: AppStyles.textFieldFillColor,
                                     thickness: 1,
                                     height: 1,
                                   ),
                                   Builder(builder: (context) {
                                     List<ProductModel> relatedProducts =
                                     [];
                                     _productDetailsModel
                                         .data!.product!.relatedProducts!
                                         .forEach((element) {
                                       if (element.relatedSellerProducts!
                                           .length >
                                           0) {
                                         relatedProducts.add(element
                                             .relatedSellerProducts!
                                             .first);
                                       }
                                     });
                                     return Container(
                                       height: 240.h,
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
                                           padding: EdgeInsets.zero,
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

                                             int totalRating = 0;
                                             double averageRating = 0.0;

                                             if ((prod.reviews??[]).isNotEmpty) {
                                               for (int i = 0; i < (prod.reviews??[]).length; i++) {
                                                 totalRating +=
                                                     prod.reviews?[i].rating ??
                                                         0;
                                               }
                                               averageRating = totalRating / (prod.reviews?.length??0);
                                             }

                                             return HorizontalProductWidget(
                                               productModel: prod,
                                               averageRating: averageRating,
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
                                 ? (_productDetailsModel.data?.product?.upSalesProducts?.length??0) >
                                 0
                                 ? Container(
                               child: Column(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(
                                         vertical: 10),
                                     child: Text(
                                       'Up Sales Products'.tr,
                                       style: AppStyles.appFontBook
                                           .copyWith(
                                         color:
                                         AppStyles.greyColorBook,
                                       ),
                                     ),
                                   ),
                                   Divider(
                                     color: AppStyles
                                         .textFieldFillColor,
                                     thickness: 1,
                                     height: 1,
                                   ),
                                   Builder(builder: (context) {
                                     List<ProductModel>
                                     upSalesProducts = [];
                                     _productDetailsModel.data?.product?.upSalesProducts?.forEach((element) {
                                       if (element.upSaleProducts!
                                           .length >
                                           0) {
                                         upSalesProducts.add(element
                                             .upSaleProducts!.first);
                                       }
                                     });
                                     return Container(
                                       height: 240.h,
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
                                           padding: EdgeInsets.zero,
                                           separatorBuilder:
                                               (context, index) {
                                             return SizedBox(
                                               width: 10,
                                             );
                                           },
                                           itemBuilder: (context,
                                               upSalesIndex) {
                                             ProductModel prod =
                                             upSalesProducts[
                                             upSalesIndex];

                                             int totalRating = 0;
                                             double averageRating = 0.0;

                                             if (prod.reviews!.isNotEmpty) {
                                               for (int i = 0; i <
                                                   prod.reviews!.length; i++) {
                                                 totalRating +=
                                                     prod.reviews?[i].rating ??
                                                         0;
                                               }
                                               averageRating = totalRating /
                                                   prod.reviews!.length;
                                             }

                                             return HorizontalProductWidget(
                                               productModel: prod,
                                               averageRating: averageRating,
                                             );
                                           }),
                                     );
                                   }),
                                 ],
                               ),
                             )
                                 : SizedBox.shrink()
                                 : (_productDetailsModel.data?.product?.crossSalesProducts?.length??0) >
                                 0
                                 ? Container(
                               color: Colors.white,
                               child: Column(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(
                                         vertical: 10),
                                     child: Text(
                                       'Cross Sales Products'.tr,
                                       style: AppStyles.appFontBook
                                           .copyWith(
                                         color:
                                         AppStyles.greyColorBook,
                                           fontSize: 12.fontSize
                                       ),
                                     ),
                                   ),
                                   Divider(
                                     color: AppStyles
                                         .textFieldFillColor,
                                     thickness: 1,
                                     height: 1,
                                   ),
                                   Builder(builder: (context) {
                                     List<ProductModel>
                                     crossSalesProducts = [];
                                     _productDetailsModel.data!
                                         .product!.crossSalesProducts!
                                         .forEach((element) {
                                       if (element.crossSaleProducts!
                                           .length >
                                           0) {
                                         crossSalesProducts.add(
                                             element
                                                 .crossSaleProducts!
                                                 .first);
                                       }
                                     });
                                     return Container(
                                       height: 240.h,
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
                                           padding: EdgeInsets.zero,
                                           separatorBuilder:
                                               (context, index) {
                                             return SizedBox(
                                               width: 10,
                                             );
                                           },
                                           itemBuilder: (context,
                                               crossSalesIndex) {
                                             ProductModel prod =
                                             crossSalesProducts[
                                             crossSalesIndex];

                                             int totalRating = 0;
                                             double averageRating = 0.0;

                                             if ((prod.reviews??[]).isNotEmpty) {
                                               for (int i = 0; i <
                                                   prod.reviews!.length; i++) {
                                                 totalRating +=
                                                     prod.reviews?[i].rating ??
                                                         0;
                                               }
                                               averageRating = totalRating /
                                                   prod.reviews!.length;
                                             }

                                             return HorizontalProductWidget(
                                               productModel: prod,
                                               averageRating: averageRating,
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
                     ),
                   ],
                 ),
               ),
               bottomNavigationBar: Container(
                 height: 75.h,
                 alignment: Alignment.topCenter,
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 20),
                     Obx(() {
                       return InkWell(
                         onTap: () {
                           Get.to(() => CartMain(true, true));
                         },
                         child: Container(
                           width: 50.w,
                           height: 46.w,
                           decoration: BoxDecoration(
                             gradient: AppStyles.gradient,
                             shape: BoxShape.rectangle,
                             borderRadius: BorderRadius.circular(5),
                           ),
                           child: badges.Badge(
                             // toAnimate: false,
                             showBadge: _loginController.loggedIn.value
                                 ? true
                                 : false,
                             position: badges.BadgePosition.topEnd(
                                 end: 4.w, top: 0.h),
                             badgeAnimation: badges.BadgeAnimation.size(
                                 toAnimate: false),
                             badgeStyle: badges.BadgeStyle(
                               badgeColor: Colors.white,
                               padding: EdgeInsets.all(2),
                             ),
                             badgeContent: Text(
                               '${cartController.cartListSelectedCount.value
                                   .toString()}',
                               style: AppStyles.appFontBook.copyWith(
                                 color: AppStyles.pinkColor,
                                   fontSize: 12.fontSize
                               ),
                             ),
                             child: Center(
                               child: Image.asset(
                                 'assets/images/cart_icon.png',
                                 width: 30.w,
                                 height: 30.w,
                                 color: Colors.white,
                               ),
                             ),
                           ),
                         ),
                       );
                     }),
                     SizedBox(width: 15),
                     _settingsController.vendorType.value == "single"
                         ? SizedBox.shrink()
                         : Padding(
                           padding: EdgeInsets.only(left: 15),
                           child: InkWell(
                                                  onTap: () {
                           Get.to(() =>
                               StoreHome(
                                   sellerId:
                                   _productDetailsModel.data!.seller!.id!));
                                                  },
                                                  child: Container(
                           width: 60.w,
                           height: 46.w,
                           margin: EdgeInsets.only(right: 15),
                           padding: EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             gradient: AppStyles.gradient,
                             shape: BoxShape.rectangle,
                             borderRadius: BorderRadius.circular(5.r),
                           ),
                           child: Image.asset(
                             'assets/images/store.png',
                             width: 5.w,
                             height: 5.w,
                             color: Colors.white,
                           ),
                                                  ),
                                                ),
                         ),

                     Expanded(
                       child: Obx(() {
                         return controller.stockManage.value == 1
                             ? InkWell(
                           child: Container(
                             alignment: Alignment.center,
                             width: Get.width,
                             height: 46.h,
                             decoration: BoxDecoration(
                               color: AppStyles.pinkColor,
                               borderRadius: BorderRadius.all(
                                 Radius.circular(5.r),
                               ),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(
                                 vertical: 8.0,
                                 horizontal: 10,
                               ),
                               child: !cartController.isCartLoading.value
                                   ? Text(
                                 Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0 ?  "Buy now".tr :"Add to Cart".tr,
                                 textAlign: TextAlign.center,
                                 style: AppStyles.appFontMedium
                                     .copyWith(
                                   color: Colors.white,
                                   fontSize: 14.fontSize,
                                 ),
                               )
                                   : Container(
                                 width: 20.w,
                                 height: 20.w,
                                 child: CircularProgressIndicator(
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                           ),
                           onTap: () async {
                             if (cartController.isCartLoading.value) {
                               return;
                             } else {
                               if (controller.stockCount.value > 0) {
                                 if (controller.minOrder.value >
                                     controller.stockCount.value) {
                                   SnackBars().snackBarWarning(
                                       'No more stock'.tr);
                                 } else {


                                   Map<String, dynamic> data = {
                                     'product_id':
                                     _productDetailsModel
                                         .data?.skus?.first.id,
                                     'qty':
                                     controller.itemQuantity.value,
                                     'price': getPriceForCart(),
                                     'seller_id': controller
                                         .products.value.data?.userId??1,
                                     'shipping_method_id':
                                     controller.shippingID.value,
                                     'product_type': 'product',
                                     'checked': true,
                                     "in_app_purchase_id" :  _productDetailsModel.data?.skus?.first.inAppPurchaseId,
                                   };

                                   if(Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0){

                                     inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);

                                   }else {
                                     final CartController cartController =
                                     Get.find();
                                     await cartController.addToCart(data);
                                   }
                                 }
                               } else {
                                 SnackBars().snackBarWarning(
                                     'No more stock'.tr);
                               }
                             }
                           },
                         )
                             : InkWell(
                           child: Container(
                             alignment: Alignment.center,
                             width: Get.width,
                             height: 46.h,
                             decoration: BoxDecoration(
                               color: Color(0xff5c7185),
                               borderRadius: BorderRadius.all(
                                 Radius.circular(5.r),
                               ),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(
                                 vertical: 10.0,
                                 horizontal: 10,
                               ),
                               child: !cartController.isCartLoading.value
                                   ? Text(
                                 Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0 ?  "Buy now".tr :"Add to Cart".tr,
                                 textAlign: TextAlign.center,
                                 style: AppStyles.appFontMedium
                                     .copyWith(
                                   color: Colors.white,
                                   fontSize: 14.fontSize,
                                 ),
                               )
                                   : Container(
                                 width: 20.w,
                                 height: 20.w,
                                 child: CircularProgressIndicator(
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                           ),
                           onTap: () async {
                             if (cartController.isCartLoading.value) {
                               return;
                             } else {

                                 Map<String, dynamic> data = {
                                   'product_id':
                                   _productDetailsModel
                                       .data?.skus?.first.id,
                                   'qty': controller.itemQuantity.value,
                                   'price': getPriceForCart(),
                                   'seller_id': controller
                                       .products.value.data?.userId??1,
                                   'shipping_method_id':
                                   controller.shippingID.value,
                                   'product_type': 'product',
                                   'checked': true,
                                   "in_app_purchase_id" :  _productDetailsModel
                                       .data?.skus?.first.inAppPurchaseId,

                                 };

                               if(Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0){
                               inAppPurchaseController.onInAppPurchaseProduct(productInfo: data);
                               }else {
                                 final CartController cartController =
                                 Get.find();
                                 await cartController.addToCart(data);
                               }
                             }
                           },
                         );
                       }),
                     ),
                     SizedBox(width: 20),
                   ],
                 ),
               ),
             );
           }
         }
         return Center(
           child: CustomLoadingWidget(),
         );
       });
  }

  ExpandableNotifier htmlExpandingWidget(String text) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expandable(
              controller: ExpandableController.of(context),
              collapsed: Container(
                height: 70.h,
                width: double.infinity,
                child: Text(text.replaceAll(RegExp(r'<[^>]+>'), ''),
                  style: AppStyles.appFontBook.copyWith(
                      color: AppStyles.greyColorBook,
                      fontSize: 11.fontSize
                  ),

                ),
              ),
              expanded: Container(
                child: Text(text.replaceAll(RegExp(r'<[^>]+>'), ''),
                    style: AppStyles.appFontBook.copyWith(
                        color: AppStyles.greyColorBook,
                        fontSize: 11.fontSize
                    )
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
                        style: AppStyles.appFontBook.copyWith(
                          color: AppStyles.greyColorBook,
                            fontSize: 12.fontSize
                        ),
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
  final ProductDetailsModel? productDetailsModel;
  final int initialIndex;

  PhotoViewerWidget({this.productDetailsModel, this.initialIndex = 0});

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
                   ( widget.productDetailsModel?.data?.product?.gallaryImages![index].imagesSource??'')),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.productDetailsModel?.data?.product?.gallaryImages![index].id??0),
              );
            },
            itemCount:
                widget.productDetailsModel?.data?.product?.gallaryImages?.length??0,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0.w,
                height: 20.0.w,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
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
                  "${widget.productDetailsModel?.data?.productName?.capitalizeFirst ?? ""}",
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
                itemCount: widget
                    .productDetailsModel?.data?.product?.gallaryImages?.length??0,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10);
                },
                itemBuilder: (context, imageIndex) {
                  return GestureDetector(
                    onTap: () {
                      pageController!.jumpToPage(imageIndex);
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
                            (widget.productDetailsModel?.data?.product?.gallaryImages?[imageIndex].imagesSource??''),
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
