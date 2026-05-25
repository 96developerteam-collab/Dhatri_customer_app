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
import 'package:flutter/services.dart';
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
  final TextEditingController _quantityTextController = TextEditingController();
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
  
Widget wholesalePriceWidget() {
  return Obx(() {
    var prices = ((controller.products.value.data?.variantDetails?.length ?? 0) > 0)
        ? controller.productSKU.value.sku?.wholeSalePrices ?? []
        : controller.products.value.data?.skus?.first.wholeSalePrices ?? [];

    if (prices.isEmpty) return SizedBox.shrink();

    double rowHeight = 40.h; // estimated row height
    double tableHeight = prices.length > 3 ? rowHeight * 3 : rowHeight * prices.length;

    return Container(
      width: double.infinity, // full width
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h), // almost zero margin
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppStyles.greyColorLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wholesale Prices".tr,
            style: AppStyles.appFontBold.copyWith(
              fontSize: 16.fontSize,
              color: AppStyles.blackColor,
            ),
          ),
          SizedBox(height: 8.h),

          /// Scrollable Table
          Container(
            height: tableHeight,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder(
                  top: BorderSide(color: AppStyles.greyColorLight.withOpacity(0.3), width: 1),
                  bottom: BorderSide(color: AppStyles.greyColorLight.withOpacity(0.3), width: 1),
                  horizontalInside: BorderSide(color: AppStyles.greyColorLight.withOpacity(0.2), width: 1),
                ),
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.5),
                },
                children: [
                  // Table Header
                  TableRow(
                    decoration: BoxDecoration(
                      color: AppStyles.greyColorLight.withOpacity(0.1),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                        child: Text(
                          "Min QTY".tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.appFontMedium.copyWith(
                            color: AppStyles.blackColor,
                            fontSize: 12.fontSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                        child: Text(
                          "Max QTY".tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.appFontMedium.copyWith(
                            color: AppStyles.blackColor,
                            fontSize: 12.fontSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                        child: Text(
                          "${(controller.products.value.data?.product?.unitTypeId?.toString() ?? "Unit").tr} Price",
                          textAlign: TextAlign.center,
                          style: AppStyles.appFontMedium.copyWith(
                            color: AppStyles.blackColor,
                            fontSize: 12.fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Table rows
                  ...List.generate(prices.length, (index) {
                    var tier = prices[index];
                    bool isSelected = controller.itemQuantity.value >= tier.minQty! &&
                        (tier.maxQty == null || controller.itemQuantity.value <= tier.maxQty!);

                    return TableRow(
                      decoration: BoxDecoration(
                        color: isSelected ? AppStyles.pinkColor.withOpacity(0.08) : Colors.transparent,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                          child: Text(
                            "${tier.minQty}",
                            textAlign: TextAlign.center,
                            style: AppStyles.appFontBold.copyWith(
                              fontSize: 12.fontSize,
                              color: isSelected ? AppStyles.pinkColor : AppStyles.blackColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                          child: Text(
                            tier.maxQty != null ? "${tier.maxQty}" : "∞",
                            textAlign: TextAlign.center,
                            style: AppStyles.appFontBold.copyWith(
                              fontSize: 12.fontSize,
                              color: isSelected ? AppStyles.pinkColor : AppStyles.blackColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                          child: Text(
                            "${_settingsController.appCurrency.value} ${tier.sellingPrice!.toStringAsFixed(2)}",
                            textAlign: TextAlign.center,
                            style: AppStyles.appFontBold.copyWith(
                              fontSize: 12.fontSize,
                              color: isSelected ? AppStyles.pinkColor : AppStyles.blackColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}




  @override
  void initState() {
    if (Platform.isIOS) {
      inAppPurchaseController = Get.find();
    }
    getProductFuture = getProductDetails();
    
    // Initialize controller with current quantity
    _quantityTextController.text = controller.itemQuantity.value.toString();
    
    // Listen to quantity changes from +/- buttons
    ever(controller.itemQuantity, (val) {
      if (int.tryParse(_quantityTextController.text) != val && 
          _quantityTextController.text != val.toString()) {
         _quantityTextController.text = val.toString();
         _quantityTextController.selection = TextSelection.fromPosition(
            TextPosition(offset: _quantityTextController.text.length));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSpecRow(String title, String value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.appFontMedium.copyWith(
                color: Colors.grey.shade700,
                fontSize: 13.fontSize,
              ),
            ),
            Text(
              value,
              style: AppStyles.appFontBold.copyWith(
                color: const Color(0xFF042E1E),
                fontSize: 13.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    Widget alwaysVisibleWholesalePricingCard() {
      return Obx(() {
        var currentSku = controller.productSKU.value.sku;
        var tiers = currentSku?.wholeSalePrices ?? [];

        if (tiers.isEmpty) {
          tiers = controller.products.value.data?.skus?.first.wholeSalePrices ?? [];
        }

        if (tiers.isEmpty) return const SizedBox.shrink();

        double regularPrice = (controller.productSKU.value.sellingPrice as num?)?.toDouble() ?? 0.0;
        if (regularPrice == 0.0) {
          var skus = controller.products.value.data?.skus ?? [];
          if (skus.isNotEmpty) {
            regularPrice = (skus.first.sellingPrice ?? 0.0).toDouble();
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.discount_outlined, color: const Color(0xFF042E1E), size: 20.w),
                      SizedBox(width: 8.w),
                      Text(
                        "Wholesale Pricing Tiers".tr,
                        style: AppStyles.appFontBold.copyWith(
                          fontSize: 16.fontSize,
                          color: const Color(0xFF042E1E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tiers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 6.h),
                    itemBuilder: (context, index) {
                      var tier = tiers[index];
                      int minQty = tier.minQty ?? 1;
                      int? maxQty = tier.maxQty;
                      double tierPrice = (tier.sellingPrice ?? 0.0).toDouble();

                      int currentQty = controller.itemQuantity.value;
                      bool isActive = currentQty >= minQty && (maxQty == null || currentQty <= maxQty);

                      double savingPercent = regularPrice > 0 ? ((regularPrice - tierPrice) / regularPrice) * 100 : 0.0;

                      String unitType = (controller.products.value.data?.product?.unitTypeId?.toString() ?? "Unit").tr;
                      String pluralUnitType = (unitType.toLowerCase().endsWith('s') || unitType.toLowerCase().endsWith('x') || unitType.toLowerCase() == 'kg') ? unitType : '${unitType}s';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isActive ? const Color(0xFF042E1E) : Colors.grey.shade200,
                            width: isActive ? 1.5.w : 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (isActive)
                              Container(
                                width: 4.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF042E1E),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    bottomLeft: Radius.circular(12.r),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "TIER ${index + 1}".tr,
                                              style: AppStyles.appFontBold.copyWith(
                                                fontSize: 10.fontSize,
                                                color: Colors.grey.shade700,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            if (isActive) ...[
                                              SizedBox(width: 4.w),
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: const Color(0xFF042E1E),
                                                size: 12.w,
                                              ),
                                            ],
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          maxQty == null ? "$minQty+ $pluralUnitType" : "$minQty - $maxQty $pluralUnitType",
                                          style: AppStyles.appFontBold.copyWith(
                                            fontSize: 14.fontSize,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${_settingsController.appCurrency.value}${tier.sellingPrice} / ${unitType.toLowerCase()}",
                                          style: AppStyles.appFontBold.copyWith(
                                            fontSize: 14.fontSize,
                                            color: const Color(0xFF042E1E),
                                          ),
                                        ),
                                        if (savingPercent > 0.5) ...[
                                          SizedBox(height: 2.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE6F4EA),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              "Saves ${savingPercent.toStringAsFixed(0)}%",
                                              style: AppStyles.appFontBold.copyWith(
                                                fontSize: 9.fontSize,
                                                color: const Color(0xFF137333),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      });
    }

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
               backgroundColor: const Color(0xFFFBF9F1),
               body: NestedScrollView(
                // physics: NeverScrollableScrollPhysics(),
                 headerSliverBuilder:
                     (BuildContext context, bool innerBoxIsScrolled) {
                   return <Widget>[
                     SliverAppBar(
                       expandedHeight: 320.0.h,
                       pinned: true,
                       collapsedHeight: 70.h,
                       stretch: false,
                       forceElevated: false,
                       titleSpacing: 0,
                       scrolledUnderElevation: 0,
                       backgroundColor: const Color(0xFFFBF9F1),
                       automaticallyImplyLeading: false,
                       actions: [Container()],
                       flexibleSpace: FlexibleSpaceBar(
                         centerTitle: true,
                         background: Container(
                           child: Stack(
                             clipBehavior: Clip.none,
                             children: [
                               Positioned.fill(
                                 child: Container(
                                   margin: EdgeInsets.only(top: 80.h, left: 20.w, right: 20.w, bottom: 20.h),
                                   decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(16.r),
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.black.withOpacity(0.04),
                                         blurRadius: 10,
                                         offset: const Offset(0, 4),
                                       ),
                                     ],
                                   ),
                                   child: (_productDetailsModel.data?.product?.gallaryImages?.length??0) >
                                       1
                                       ? Container(
                                     child: Swiper(
                                       itemBuilder: (BuildContext context,
                                           int index) {
                                         return Container(
                                           padding: EdgeInsets.all(16.w),
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
                                     EdgeInsets.all(16.w),
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

                              SizedBox(height: 8.h),
                              // Stock Badge, Stars, Reviews
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_productDetailsModel.data?.stockManage == 1)
                                    Container(
                                      margin: EdgeInsets.only(right: 8.w),
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: (_productDetailsModel.data?.skus?.first.productStock ?? 0) > 0
                                            ? const Color(0xFFE6F4EA)
                                            : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        (_productDetailsModel.data?.skus?.first.productStock ?? 0) > 0
                                            ? "In Stock".tr
                                            : "Not in Stock".tr,
                                        style: AppStyles.appFontBold.copyWith(
                                          fontSize: 11.fontSize,
                                          color: (_productDetailsModel.data?.skus?.first.productStock ?? 0) > 0
                                              ? const Color(0xFF137333)
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  StarCounterWidget(
                                    value: (_productDetailsModel.data?.avgRating ?? 0) > 0
                                        ? _productDetailsModel.data!.avgRating!
                                        : averageRating,
                                    color: const Color(0xFF048E38),
                                    size: 16.fontSize,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '(${_productDetailsModel.data?.reviews?.length ?? 0} ${"reviews".tr})',
                                    style: AppStyles.appFontBook.copyWith(
                                      fontSize: 13.fontSize,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              // Sold by
                              if (_productDetailsModel.data?.seller?.name != null)
                                Text(
                                  "Sold by ".tr + "${_productDetailsModel.data?.seller?.name ?? ""}",
                                  style: AppStyles.appFontBook.copyWith(
                                    fontSize: 13.fontSize,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              SizedBox(height: 14.h),                             // Price + Quantity & Variants card (reference image style)
                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(16.r),
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.black.withOpacity(0.04),
                                     blurRadius: 10,
                                     offset: const Offset(0, 2),
                                   ),
                                 ],
                               ),
                               child: Column(
                                 children: [
                                   Obx(() {
                                     return Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         // Left: price
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             if (_productDetailsModel.data?.mrp != null &&
                                                 _productDetailsModel.data!.mrp! > 0)
                                               Text(
                                                 _settingsController.setCurrentSymbolPosition(
                                                     amount: (_productDetailsModel.data!.mrp! *
                                                         _settingsController.conversionRate.value)
                                                         .toStringAsFixed(2)),
                                                 style: AppStyles.appFontBook.copyWith(
                                                   fontSize: 13.fontSize,
                                                   color: AppStyles.greyColorDark,
                                                   decoration: TextDecoration.lineThrough,
                                                 ),
                                               ),
                                             Text(
                                               _settingsController.setCurrentSymbolPosition(
                                                   amount: (controller.productPrice.value *
                                                       _settingsController.conversionRate.value)
                                                       .toStringAsFixed(2)),
                                               style: AppStyles.appFontBold.copyWith(
                                                 fontSize: 26.fontSize,
                                                 color: Colors.black,
                                                 height: 1.1,
                                               ),
                                             ),
                                             Text(
                                               "${(controller.products.value.data?.product?.unitTypeId?.toString() ?? "Unit").tr} Price",
                                               style: AppStyles.appFontBook.copyWith(
                                                 fontSize: 12.fontSize,
                                                 color: AppStyles.greyColorBook,
                                               ),
                                             ),
                                           ],
                                         ),
                                         // Right: dark-green quantity stepper
                                         if (!(Platform.isIOS && controller.products.value.data?.product?.isPhysical == 0))
                                           Container(
                                             decoration: BoxDecoration(
                                                color: const Color(0xFF2B6B22),
                                                borderRadius: BorderRadius.circular(10.r),
                                             ),
                                             child: Row(
                                               mainAxisSize: MainAxisSize.min,
                                               children: [
                                                 InkWell(
                                                   onTap: () {
                                                     if (controller.itemQuantity.value <= controller.minOrder.value) {
                                                       SnackBars().snackBarWarning(
                                                           "Can't add less than".tr +
                                                               ' ${controller.minOrder.value} ' +
                                                               'Products'.tr);
                                                     } else {
                                                       controller.cartDecrease();
                                                     }
                                                   },
                                                   child: Container(
                                                     width: 38.w,
                                                     height: 38.w,
                                                     alignment: Alignment.center,
                                                     child: Icon(Icons.remove, color: Colors.white, size: 18.w),
                                                   ),
                                                 ),
                                                 Container(
                                                   width: 44.w,
                                                   height: 38.w,
                                                   color: Colors.white,
                                                   alignment: Alignment.center,
                                                   child: TextField(
                                                     controller: _quantityTextController,
                                                     textAlign: TextAlign.center,
                                                     keyboardType: TextInputType.number,
                                                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                     onChanged: (val) { controller.updateQuantity(val); },
                                                     decoration: const InputDecoration(
                                                       border: InputBorder.none,
                                                       isDense: true,
                                                       contentPadding: EdgeInsets.zero,
                                                     ),
                                                     style: AppStyles.appFontBold.copyWith(
                                                       fontSize: 16.fontSize,
                                                       color: Colors.black,
                                                     ),
                                                   ),
                                                 ),
                                                 InkWell(
                                                   onTap: () {
                                                     if (controller.stockManage.value == 1) {
                                                       if (controller.itemQuantity.value >= controller.stockCount.value) {
                                                         SnackBars().snackBarWarning('Stock not available.'.tr);
                                                       } else {
                                                         controller.cartIncrease();
                                                       }
                                                     } else {
                                                       if (controller.itemQuantity.value >= controller.maxOrder.value) {
                                                         SnackBars().snackBarWarning(
                                                             "Can't add more than".tr +
                                                                 ' ${controller.maxOrder.value} ' +
                                                                 'Products'.tr);
                                                       } else {
                                                         controller.cartIncrease();
                                                       }
                                                     }
                                                   },
                                                   child: Container(
                                                     width: 38.w,
                                                     height: 38.w,
                                                     alignment: Alignment.center,
                                                     child: Icon(Icons.add, color: Colors.white, size: 18.w),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                       ],
                                     );
                                   }),
                                   
                                   if (((controller.products.value.data?.variantDetails ?? []).length) > 0) ...[
                                     Padding(
                                       padding: EdgeInsets.symmetric(vertical: 12.h),
                                       child: Divider(color: Colors.grey.shade200, thickness: 1),
                                     ),
                                     ListView.separated(
                                       shrinkWrap: true,
                                       padding: EdgeInsets.zero,
                                       physics: NeverScrollableScrollPhysics(),
                                       itemCount: (controller.products.value.data?.variantDetails ?? []).length,
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
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text(
                                                 'Select ${variant.name}'.tr,
                                                 style: AppStyles.appFontBook.copyWith(
                                                   color: Colors.black,
                                                   fontSize: 16.fontSize,
                                                 ),
                                               ),
                                               Flexible(
                                                 child: Wrap(
                                                   alignment: WrapAlignment.end,
                                                   crossAxisAlignment: WrapCrossAlignment.center,
                                                   spacing: 5,
                                                   runSpacing: 5,
                                                   children: List.generate(
                                                     variant.code!.length,
                                                     (colorIndex) {
                                                       var bgColor = 0;
                                                       if (!variant.code![colorIndex].contains('#')) {
                                                         bgColor = CustomColorConvert()
                                                             .colourNameToHex(variant.code![colorIndex]);
                                                       } else {
                                                         bgColor = CustomColorConvert()
                                                             .getBGColor(variant.code![colorIndex]);
                                                       }
                                                       return GestureDetector(
                                                         onTap: () async {
                                                           setState(() {
                                                             selected.clear();
                                                             controller.products.value.data!.variantDetails!
                                                                 .forEach((element) {
                                                               if (element.name == 'Color') {
                                                                 element.code!.forEach((element2) {
                                                                   selected.add(false);
                                                                 });
                                                               }
                                                             });
                                                             selected[colorIndex] = !selected[colorIndex];
                                                           });
                                                           addValueToMap(
                                                               getSKU,
                                                               'id[$variantIndex]',
                                                               '${variant.attrValId![colorIndex]}-${variant.attrId}');
                                                           Map data = {
                                                             'product_id': controller.products.value.data!.id,
                                                             'user_id': controller.products.value.data!.userId,
                                                           };
                                                           data.addAll(getSKU);
                                                           await controller.getSkuWisePrice(data).then((value) {
                                                             if (value == false) {
                                                               setState(() {});
                                                             }
                                                           });
                                                         },
                                                         child: Container(
                                                           width: 30.w,
                                                           height: 30.w,
                                                           alignment: Alignment.center,
                                                           padding: const EdgeInsets.all(2.0),
                                                           decoration: BoxDecoration(
                                                             border: Border.all(
                                                               color: selected[colorIndex]
                                                                   ? const Color(0xFF042E1E)
                                                                   : Colors.transparent,
                                                             ),
                                                             shape: BoxShape.circle,
                                                           ),
                                                           child: Container(
                                                             width: 30.w,
                                                             height: 30.w,
                                                             decoration: BoxDecoration(
                                                               shape: BoxShape.circle,
                                                               color: Color(bgColor),
                                                             ),
                                                           ),
                                                         ),
                                                       );
                                                     },
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           );
                                         } else {
                                           return Row(
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text(
                                                 'Select ${variant.name?.tr}',
                                                 style: AppStyles.appFontBook.copyWith(
                                                   color: Colors.black,
                                                   fontSize: 16.fontSize,
                                                 ),
                                               ),
                                               Flexible(
                                                 child: Align(
                                                   alignment: Alignment.centerRight,
                                                   child: CustomRadioButton(
                                                     buttonLables: variant.value!,
                                                     buttonValues: variant.attrValId!,
                                                     radioButtonValue: (value, index) async {
                                                       addValueToMap(
                                                           getSKU,
                                                           'id[$variantIndex]',
                                                           '$value-${variant.attrId}');
                                                       Map data = {
                                                         'product_id': controller.products.value.data!.id,
                                                         'user_id': controller.products.value.data!.userId,
                                                       };
                                                       data.addAll(getSKU);
                                                       await controller.getSkuWisePrice(data).then((value) {
                                                         if (value == false) {
                                                           setState(() {});
                                                         }
                                                       });
                                                     },
                                                     horizontal: true,
                                                     enableShape: true,
                                                     textColor: Colors.black,
                                                     selectedTextColor: Colors.white,
                                                     buttonColor: Colors.grey.shade200,
                                                     selectedColor: const Color(0xFF042E1E),
                                                     elevation: 0,
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           );
                                         }
                                       },
                                     ),
                                   ],
                                 ],
                               ),
                             ),

                             // ** Always-Visible Wholesale Pricing Tiers and Modernized Product Specifications Cards
                              SizedBox(height: 16.h),
                              alwaysVisibleWholesalePricingCard(),
                              SizedBox(height: 16.h),

                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Specifications'.tr,
                                      style: AppStyles.appFontBold.copyWith(
                                        color: const Color(0xFF042E1E),
                                        fontSize: 16.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    if (_productDetailsModel.data?.product?.brand != null)
                                      buildSpecRow("Brand".tr, "${_productDetailsModel.data?.product?.brand?.name ?? ''}"),
                                    if (_productDetailsModel.data?.product?.modelNumber != null)
                                      buildSpecRow("Model Number".tr, "${_productDetailsModel.data?.product?.modelNumber ?? ''}"),
                                    buildSpecRow("Availability".tr, (_productDetailsModel.data!.skus?.isNotEmpty ?? false) && _productDetailsModel.data!.skus!.first.productStock! > 0 ? "In Stock".tr : "Not in stock".tr),
                                    if (_productDetailsModel.data?.product?.skus?.first.sku != null)
                                      Obx(() => buildSpecRow("Product SKU".tr, "${controller.productSKU.value.sku?.sku ?? ''}")),
                                    if (_productDetailsModel.data?.product?.specification != null) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        child: Divider(color: Colors.grey.shade100, thickness: 1),
                                      ),
                                      htmlExpandingWidget("${_productDetailsModel.data!.product!.specification ?? ''}"),
                                    ]
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
                             color: const Color(0xFF2B6B22),
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
                     SizedBox(width: 15.w),
                     Expanded(
                       child: Obx(() {
                         return controller.stockManage.value == 1
                             ? InkWell(
                           child: Container(
                             alignment: Alignment.center,
                             width: Get.width,
                             height: 46.h,
                             decoration: BoxDecoration(
                               color: const Color(0xFF2B6B11),
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
                                  Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0
                                      ? "Buy now".tr
                                      : "${"Add to Cart".tr} • ${_settingsController.setCurrentSymbolPosition(amount: (controller.finalPrice.value * _settingsController.conversionRate.value).toStringAsFixed(2))}",
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFontMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.fontSize,
                                  ),
                                )
                                   : Container(
                                 width: 20.w,
                                 height: 20.w,
                                 child: CircularProgressIndicator(
                                   color:  Colors.white,
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
                                color: const Color(0xFF2B6B22),
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
                                  Platform.isIOS && _productDetailsModel.data?.product?.isPhysical == 0
                                      ? "Buy now".tr
                                      : "${"Add to Cart".tr} • ${_settingsController.setCurrentSymbolPosition(amount: (controller.finalPrice.value * _settingsController.conversionRate.value).toStringAsFixed(2))}",
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFontMedium.copyWith(
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
                                     _productDetailsModel.data?.skus?.first.id,
                                 'qty': controller.itemQuantity.value,
                                 'price': getPriceForCart(),
                                 'seller_id': controller
                                         .products.value.data?.userId ??
                                     1,
                                 'shipping_method_id':
                                     controller.shippingID.value,
                                 'product_type': 'product',
                                 'checked': true,
                                 "in_app_purchase_id": _productDetailsModel
                                     .data?.skus?.first.inAppPurchaseId,
                               };

                               if (Platform.isIOS &&
                                   _productDetailsModel.data?.product?.isPhysical ==
                                       0) {
                                 inAppPurchaseController.onInAppPurchaseProduct(
                                     productInfo: data);
                               } else {
                                 final CartController cartController = Get.find();
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

