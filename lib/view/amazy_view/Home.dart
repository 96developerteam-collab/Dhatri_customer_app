import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazy_view/products/brand/AllBrandsPage.dart';
import 'package:amazcart/view/amazy_view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/view/amazy_view/products/marketing/AllTopPickProducts.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:loading_skeleton_niu/loading_skeleton.dart';
import 'package:supercharged/supercharged.dart';
import '../../controller/cart_controller.dart';
import '../../controller/product_details_controller.dart';
import '../../model/NewModel/HomePage/HomePageModel.dart';
import '../../model/NewModel/Product/ProductModel.dart';
import '../../widgets/amazy_widget/BuildIndicatorBuilder.dart';
import '../../widgets/amazy_widget/HomeTitlesWidget.dart';
import '../../widgets/amazy_widget/fa_icon_maker/fa_custom_icon.dart';
import '../../widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import '../../widgets/amazy_widget/single_product_widgets/HorizontalProductWidget.dart';
import 'products/category/ProductsByCategory.dart';
import 'products/marketing/FlashDeal/FlashDealView.dart';
import 'products/marketing/NewUserZone/NewUserZonePage.dart';
import 'products/product/product_details.dart';
import 'products/tags/ProductsByTags.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();

  final HomeController _homeController = Get.find<HomeController>();

  final GeneralSettingsController _settingsController =
      Get.find<GeneralSettingsController>();

  bool isScrolling = false;

  Future<void> refresh() async {
    await _homeController.getHomePage();
    _homeController.source?.refresh(true);
  }

  @override
  void initState() {
    Get.find<CartController>().getCartList();
    _homeController.source = RecommendedProductsLoadMore();
    super.initState();
  }

  @override
  void dispose() {
    _homeController.source?.dispose();
    super.dispose();
  }

LinearGradient? selectColor(int position) {
  LinearGradient? c;

 c = LinearGradient(
      colors: [Color(0xff3cd47f), AppStyles.pinkColor], // Mint green
      stops: [0, 1],
      begin: Alignment(0.71, 0.71),
      end: Alignment(-0.71, -0.71),
    );
  // if (position % 8 == 0)
  //   c = LinearGradient(
  //     colors: [Color(0xff43a047), AppStyles.pinkColor], // Fresh green
  //     stops: [0, 1],
  //     begin: Alignment(-0.71, -0.71),
  //     end: Alignment(0.71, 0.71),
  //   );

  // if (position % 8 == 1)
  //   c = LinearGradient(
  //     colors: [Color(0xff3cd47f), AppStyles.pinkColor], // Mint green
  //     stops: [0, 1],
  //     begin: Alignment(0.71, 0.71),
  //     end: Alignment(-0.71, -0.71),
  //   );

  // if (position % 8 == 2)
  //   c = LinearGradient(
  //     colors: [Color(0xff43a047), AppStyles.pinkColor], // Nature green
  //     stops: [0, 1],
  //     begin: Alignment(0.72, 0.69),
  //     end: Alignment(-0.72, -0.69),
  //   );

  // if (position % 8 == 3)
  //   c = LinearGradient(
  //     colors: [Color(0xff00c853), AppStyles.pinkColor], // Neon green
  //     stops: [0, 1],
  //     begin: Alignment(0.71, 0.71),
  //     end: Alignment(-0.71, -0.71),
  //   );

  // if (position % 8 == 4)
  //   c = LinearGradient(
  //     colors: [Color(0xff66bb6a), AppStyles.pinkColor], // Soft green
  //     stops: [0, 1],
  //     begin: Alignment(-0.71, -0.71),
  //     end: Alignment(0.71, 0.71),
  //   );

  // if (position % 8 == 5)
  //   c = LinearGradient(
  //     colors: [Color(0xff4caf50), AppStyles.pinkColor], // Medium green
  //     stops: [0, 1],
  //     begin: Alignment(0.71, 0.71),
  //     end: Alignment(-0.71, -0.71),
  //   );

  // if (position % 8 == 6)
  //   c = LinearGradient(
  //     colors: [Color(0xff1b5e20), AppStyles.pinkColor], // Dark to light green
  //     stops: [0, 1],
  //     begin: Alignment(0.72, 0.69),
  //     end: Alignment(-0.72, -0.69),
  //   );

  // if (position % 8 == 7)
  //   c = LinearGradient(
  //     colors: [Color(0xff76ff03), AppStyles.pinkColor], // Lime green
  //     stops: [0, 1],
  //     begin: Alignment(0.71, 0.71),
  //     end: Alignment(-0.71, -0.71),
  //   );

  return c;
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isScrolling
              ? Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: FloatingActionButton.small(
                    backgroundColor: AppStyles.pinkColor,
                    onPressed: () {
                      scrollController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Icon(
                      Icons.arrow_upward,
                      size: 20.w,
                    ),
                  ),
                )
              : Container(),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: refresh,
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
              child: LoadingMoreCustomScrollView(
                controller: scrollController,
                slivers: [
                  CustomSliverAppBarWidget(false, false),
                  SliverToBoxAdapter(
                    child: ListView(
                      padding: EdgeInsets.only(top: 4.h),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ///** SLIDER */
                        Obx(() =>
                          _homeController.isHomePageLoading.value
                            ? Container(
                              padding: EdgeInsets.all(1),
                              child: LoadingSkeleton(
                                height: 200.h,
                                width: Get.width,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.2),
                                ],
                              ),
                            ) :
                          _homeController.homePageModel.value.sliders == null || (_homeController.homePageModel.value.sliders??[]).isEmpty ? SizedBox.shrink() : Container(
                                height: 200.h,
                               // padding: EdgeInsets.only(top: 0),
                                child: Swiper(
                                  itemCount: _homeController
                                      .homePageModel.value.sliders!.length,
                                  autoplay: true,
                                  autoplayDelay: 5000,
                                  itemBuilder:
                                      (BuildContext context, int sliderIndex) {
                                    HomePageSlider slider = _homeController
                                        .homePageModel
                                        .value
                                        .sliders![sliderIndex];
                                    return FancyShimmerImage(
                                      imageUrl: AppConfig.assetPath +
                                          '/' +
                                          slider.sliderImage!,
                                      boxFit: BoxFit.fill,
                                      width: Get.width,
                                      height: 200.h,
                                      errorWidget: FancyShimmerImage(

                                        imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                        boxFit: BoxFit.contain,
                                        errorWidget: FancyShimmerImage(
                                          imageUrl:
                                              "${AppConfig.assetPath}/backend/img/default.png",
                                          boxFit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: (sliderIndex) {
                                    HomePageSlider slider = _homeController
                                        .homePageModel
                                        .value
                                        .sliders![sliderIndex];
                                    if (slider.dataType ==
                                        SliderDataType.PRODUCT) {
                                      Get.to(() => ProductDetails(
                                            productID: slider.dataId,
                                          ));
                                    } else if (slider.dataType ==
                                        SliderDataType.CATEGORY) {
                                      Get.to(() => ProductsByCategory(
                                            categoryId: slider.dataId,
                                          ));
                                    } else if (slider.dataType ==
                                        SliderDataType.BRAND) {
                                      Get.to(() => ProductsByBrands(
                                            brandId: slider.dataId,
                                          ));
                                    } else if (slider.dataType ==
                                        SliderDataType.TAG) {
                                      Get.to(() => ProductsByTags(
                                            tagName: slider.tag!.name,
                                            tagId: slider.tag!.id,
                                          ));
                                    }
                                  },
                                  pagination: SwiperPagination(
                                      margin: EdgeInsets.all(5.0.w),
                                      builder: SwiperCustomPagination(builder:
                                          (BuildContext context,
                                              SwiperPluginConfig config) {
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RectSwiperPaginationBuilder(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            activeColor: Colors.white,
                                            size: Size(5.0, 5.0),
                                            activeSize: Size(20.0.w, 5.0.h),
                                          ).build(context, config),
                                        );
                                      })),
                                ),
                              )

                        ),



                        /// ** FEATURES*/

                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 15.0.h, left: 15.w, right: 15.w),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Expanded(
                        //         child: Row(
                        //           children: [
                        //             Image.asset(
                        //               'assets/images/Shipping.png',
                        //               width: 30.w,
                        //               height: 30.w,
                        //             ),
                        //             SizedBox(width: 4.w),
                        //             Expanded(
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     "Free Shipping".tr,
                        //                     style: AppStyles.appFontBold.copyWith(
                        //                       fontSize: 11.fontSize,
                        //                     ),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                   Text(
                        //                     "Free All Shipping".tr,
                        //                     style: AppStyles.appFontBook.copyWith(
                        //                       fontSize: 9.fontSize,
                        //                       color: Color(0xff5C7185),
                        //                     ),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                            
                        //       Expanded(
                        //         child: Row(
                        //           children: [
                        //             Image.asset(
                        //               'assets/images/help.png',
                        //               width: 30.w,
                        //               height: 30.w,
                        //             ),
                        //             SizedBox(width: 4.w),
                        //             Expanded(
                        //               child: Column( 
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     "Help Center".tr,
                        //                     style: AppStyles.appFontBold.copyWith(
                        //                       fontSize: 11.fontSize,
                        //                     ),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                   Text(
                        //                     "24/7 Support".tr,
                        //                     style: AppStyles.appFontBook.copyWith(
                        //                       fontSize: 9.fontSize,
                        //                       color: Color(0xff5C7185),
                        //                     ),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ), 
                             
                        //       Expanded(
                        //         child: Row(
                        //           children: [
                        //             Image.asset(
                        //               'assets/images/money.png',
                        //               width: 30.w,
                        //               height: 30.w,
                        //             ),
                        //             SizedBox(
                        //               width: 4.w,
                        //             ),
                        //             Expanded(
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     "Money Back".tr,
                        //                     style: AppStyles.appFontBold.copyWith(
                        //                       fontSize: 11.fontSize,
                        //                     ),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                   Text(
                        //                     "Back in 30 days".tr,
                        //                     style: AppStyles.appFontBook.copyWith(
                        //                       fontSize: 9.fontSize,
                        //                       color: Color(0xff5C7185),
                        //                     ),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ), 
                        //     ],
                        //   ),
                        // ),

                        ///** CATEGORY */

               Container(
  padding: EdgeInsets.only(
    left: 10.0.w, 
    right: 10.0.w, 
    top: 30.0.h
  ),
  child: Obx(() =>
    !_homeController.isHomePageLoading.value && _homeController.homePageModel.value.topCategories != null &&
        _homeController.homePageModel.value.topCategories!.length > 0 ? Container(
        height: 100.w,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 15.w,
            );
          },
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: _homeController.homePageModel.value
              .topCategories!.length,
          itemBuilder: (context, index) {
            CategoryBrand category = _homeController
                .homePageModel
                .value
                .topCategories![index];

            return Container(
              alignment: Alignment.center,
              height: 50.w,
              width: 50.w,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 50.w,
                    width: 50.w,
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () async {
                        Get.to(() => ProductsByCategory(
                              categoryId: category.id,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          // Removed gradient for better image visibility
                          color: Colors.grey[100], // Fallback color
                        ),
                        child: category.image != null 
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: FancyShimmerImage(
                                  imageUrl: AppConfig.assetPath + '/' + category.image!,
                                  boxFit: BoxFit.cover,
                                  width: 50.w,
                                  height: 50.w,
                                  errorWidget: Container(
                                    decoration: BoxDecoration(
                                      gradient: selectColor(index),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      category.icon != null
                                          ? FaCustomIcon.getFontAwesomeIcon(category.icon!)
                                          : Icons.list_alt_outlined,
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                  ),
                                ),
                              )
                            : category.icon != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      gradient: selectColor(index),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      FaCustomIcon.getFontAwesomeIcon(category.icon!),
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      gradient: selectColor(index),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.list_alt_outlined,
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    category.name!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppStyles.appFontMedium
                        .copyWith(
                      fontSize: 14.fontSize,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
      : Container(
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              mainAxisExtent: 80.w,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(12.r)),
                    child: LoadingSkeleton(
                      width: 50.w,
                      height: 50.w,
                      child: SizedBox(),
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        )
  ),
),
                        /// ** FLASH SALE
                        Container(
                          padding:  EdgeInsets.only(
                              left: 10.0.w, right: 10.0.w, top: 0.0),
                          child: Obx(() {
                            if (_homeController.isHomePageLoading.value) {
                              return ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                    height: 240.h,
                                    child: ListView.separated(
                                        itemCount: 4,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5.w,
                                          );
                                        },
                                        itemBuilder: (context, flashIndex) {
                                          return Container(
                                            width: 150.w,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 10.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x1a000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6.r,
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              child: LoadingSkeleton(
                                                height: 210.h,
                                                width: 150.w,
                                                child: SizedBox(),
                                                colors: [
                                                  Colors.white.withOpacity(0.1),
                                                  Colors.black.withOpacity(0.1),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              );
                            } else {
                              if (_homeController.hasDeal.value) {
                                return ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    HomeTitlesWidget(
                                      title: 'Flash Sale'.tr,
                                      btnOnTap: () {
                                        Get.to(() => FlashDealView());
                                      },
                                      dealDuration: _homeController.dealDuration.value,
                                      showDeal: true,
                                    ),
                                    Container(
                                      height: 240.h,
                                      child: ListView.separated(
                                          itemCount: _homeController
                                              .homePageModel
                                              .value
                                              .flashDeal!
                                              .allProducts!
                                              .length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              width: 5.w,
                                            );
                                          },
                                          itemBuilder: (context, flashIndex) {
                                            FlashDealAllProduct flashDeal =
                                                _homeController
                                                    .homePageModel
                                                    .value
                                                    .flashDeal!
                                                    .allProducts![flashIndex];

                                            int totalRating = 0;
                                            double averageRating = 0.0;

                                            if((flashDeal.product?.reviews??[]).isNotEmpty){
                                              for(int i = 0; i < flashDeal.product!.reviews!.length; i++){
                                                totalRating += flashDeal.product!.reviews?[i].rating ?? 0;
                                              }
                                              averageRating = totalRating/flashDeal.product!.reviews!.length;
                                            }

                                            return HorizontalProductWidget(
                                              productModel: flashDeal.product!,
                                              averageRating: averageRating,
                                            );
                                          }),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }
                          }),
                        ),

                        /// ** NEW USER ZONE
                        Container(
                          padding: EdgeInsets.only(
                              left: 10.0.w, right: 10.0.w, top: 10.0.h),
                          child: Obx(() {

                            if (_homeController.homePageModel.value.newUserZone != null) {

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => NewUserZonePage());
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          height: 85.h,
                                          padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                          alignment: Alignment.center,
                                          color: AppStyles.pinkColor,
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              15.horizontalSpace,
                                              Container(
                                                width: 50.w,
                                                height: 50.w,
                                                child: Image.asset(
                                                  'assets/images/icon_gift_alt.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              15.horizontalSpace,
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'New Users Zone!'.tr,
                                                      maxLines: 1,
                                                      style: AppStyles
                                                          .kFontWhite14w5
                                                          .copyWith(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize:
                                                          17.fontSize,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    Text(
                                                      '${_homeController.homePageModel.value.newUserZone?.title ?? ""}',
                                                      maxLines: 1,
                                                      style: AppStyles
                                                          .kFontWhite14w5
                                                          .copyWith(
                                                        fontSize: 12.fontSize,
                                                      ),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              Container(
                                                height: 35.w,
                                                width: 35.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14.w,
                                                  color: AppStyles.pinkColor,
                                                ),
                                              ),
                                              15.horizontalSpace,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                      child: Container(
                                        height: 150.h,
                                        padding: EdgeInsets.all(4.w),
                                        color: AppStyles.lightBlueColorAlt,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: List.generate(
                                                    _homeController
                                                        .homePageModel
                                                        .value
                                                        .newUserZone!
                                                        .allProducts!
                                                        .length, (index) {
                                                  return Expanded(
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () async {
                                                        final ProductDetailsController
                                                        productDetailsController =
                                                        Get.put(
                                                            ProductDetailsController());
                                                        await productDetailsController
                                                            .getProductDetails2(
                                                            _homeController
                                                                .homePageModel
                                                                .value
                                                                .newUserZone!
                                                                .allProducts![
                                                            index]
                                                                .product!
                                                                .id);
                                                        Get.to(() => ProductDetails(
                                                            productID: _homeController
                                                                .homePageModel
                                                                .value
                                                                .newUserZone!
                                                                .allProducts![
                                                            index]
                                                                .product!
                                                                .id ??
                                                                0));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 4.w,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                          child: Container(
                                                            decoration:
                                                            BoxDecoration(
                                                              color: Colors.white,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                10.verticalSpace,
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                  FancyShimmerImage(
                                                                    imageUrl:
                                                                    '${AppConfig.assetPath}/${_homeController.homePageModel.value.newUserZone!.allProducts![index].product!.product!.thumbnailImageSource}',
                                                                    boxFit: BoxFit
                                                                        .contain,
                                                                    errorWidget:
                                                                    FancyShimmerImage(
                                                                      imageUrl:
                                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                                      boxFit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                                10.verticalSpace,
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Wrap(
                                                                    crossAxisAlignment:
                                                                    WrapCrossAlignment
                                                                        .center,
                                                                    children: [
                                                                      if (_homeController
                                                                              .homePageModel
                                                                              .value
                                                                              .newUserZone
                                                                              ?.allProducts?[index]
                                                                              .product
                                                                              ?.mrp !=
                                                                          null &&
                                                                          _homeController
                                                                                  .homePageModel
                                                                                  .value
                                                                                  .newUserZone!
                                                                                  .allProducts![index]
                                                                                  .product!
                                                                                  .mrp! >
                                                                              0)
                                                                        Text(
                                                                          '${_settingsController.setCurrentSymbolPosition(amount:  (_homeController.homePageModel.value.newUserZone!.allProducts![index].product!.mrp! * _settingsController.conversionRate.value).toStringAsFixed(2))}',
                                                                          style: AppStyles.kFontGrey12w5.copyWith(
                                                                            decoration: TextDecoration.lineThrough,
                                                                            fontSize: 10.fontSize,
                                                                          ),
                                                                        ),
                                                                      if (_homeController
                                                                              .homePageModel
                                                                              .value
                                                                              .newUserZone
                                                                              ?.allProducts?[index]
                                                                              .product
                                                                              ?.mrp !=
                                                                          null &&
                                                                          _homeController
                                                                                  .homePageModel
                                                                                  .value
                                                                                  .newUserZone!
                                                                                  .allProducts![index]
                                                                                  .product!
                                                                                  .mrp! >
                                                                              0)
                                                                        SizedBox(width: 5.w),
                                                                      Text(
                                                                        _settingsController.calculatePrice(_homeController
                                                                            .homePageModel
                                                                            .value
                                                                            .newUserZone
                                                                            ?.allProducts?[index]
                                                                            .product ??
                                                                            ProductModel()),
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style: AppStyles
                                                                            .kFontPink15w5
                                                                            .copyWith(
                                                                            fontSize: 12.fontSize),
                                                                      ),
                                                                      3.horizontalSpace,
                                                                      if (!(_homeController
                                                                          .homePageModel
                                                                          .value
                                                                          .newUserZone!
                                                                          .allProducts![index]
                                                                          .product!
                                                                          .hasDiscount ==
                                                                          'no'))
                                                                        Text(
                                                                          _settingsController.calculateMainPrice(_homeController
                                                                              .homePageModel
                                                                              .value
                                                                              .newUserZone!
                                                                              .allProducts![index]
                                                                              .product!),
                                                                          style: AppStyles
                                                                              .kFontGrey12w5
                                                                              .copyWith(
                                                                            decoration:
                                                                            TextDecoration.lineThrough,
                                                                            fontSize:
                                                                            12.fontSize,
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                5.verticalSpace,
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            2.horizontalSpace,
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.r)),
                                              child: GestureDetector(
                                                behavior:
                                                HitTestBehavior.translucent,
                                                onTap: () {
                                                  Get.to(() => NewUserZonePage());
                                                },
                                                child: Container(
                                                  width: Get.width * 0.35,
                                                  decoration: BoxDecoration(
                                                    color: AppStyles.pinkColor,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${_homeController.homePageModel.value.newUserZone!.coupon!.discount}% ' +
                                                            'OFF'.tr,
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: AppStyles
                                                            .kFontWhite14w5
                                                            .copyWith(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14.fontSize,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${_homeController.homePageModel.value.newUserZone!.coupon!.title}',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: AppStyles.appFont
                                                            .copyWith(
                                                          fontSize: 12.fontSize,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      5.verticalSpace,
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              NewUserZonePage());
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              2.w),
                                                          alignment:
                                                          Alignment.center,
                                                          height: 30.h,
                                                          width: 85.w,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffFFD600),
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      25.r))),
                                                          child: Text(
                                                            'Shop Now'.tr,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: AppStyles
                                                                .appFont
                                                                .copyWith(
                                                              fontSize:
                                                              12.fontSize,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    5.verticalSpace,
                                  ],
                                );

                              }
                              else {
                                return SizedBox.shrink();
                              }

                          }),
                        ),

                        ///** BRANDS

            Container(
  padding: EdgeInsets.only(
    left: 10.0.w, 
    right: 10.0.w, 
    top: 10.0.h
  ),
  child: Obx(() {
    if (_homeController.isHomePageLoading.value) {
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeTitlesWidget(
            title: 'Brands'.tr,
            btnOnTap: () {
              // Get.to(() => AllBrandsPage());
            },
            showDeal: false,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            child: Container(
              color: AppStyles.lightBlueColorAlt,
              child: Container(
                padding: EdgeInsets.all(10.w),
                child: Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      mainAxisExtent: 110.h, // Increased for larger image
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                        child: LoadingSkeleton(
                          width: 70.w, // Increased from 50.w
                          height: 60.w, // Increased from 40.w
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeTitlesWidget(
            title: 'Brands'.tr,
            btnOnTap: () {
              Get.to(() => AllBrandsPage());
            },
            showDeal: false,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            child: Container(
              color: AppStyles.lightBlueColorAlt,
              child: Container(
                height: _homeController.chunkedBrands.length > 4
                    ? 250.h // Increased for larger image
                    : 150.h, // Increased for larger image
                padding: EdgeInsets.all(10.w),
                child: Container(
                  child: Swiper.children(
                    children: _homeController
                        .chunkedBrands
                        .chunked(8)
                        .map((e) {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          mainAxisExtent: 110.h, // Increased from 90.h
                        ),
                        itemBuilder: (context, index) {
                          CategoryBrand brand = e[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => ProductsByBrands(
                                brandId: brand.id!,
                              ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r)
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    // Image container - increased size
                                    Expanded(
                                      flex: 4, // Increased flex for image
                                      child: Container(
                                        padding: EdgeInsets.all(12.w), // More padding
                                        child: brand.logo != null
                                            ? Container(
                                                child: FancyShimmerImage(
                                                  imageUrl: AppConfig.assetPath + '/' + brand.logo! ?? '',
                                                  boxFit: BoxFit.contain,
                                                  errorWidget: FancyShimmerImage(
                                                    imageUrl: "${AppConfig.assetPath}/backend/img/default.png",
                                                    boxFit: BoxFit.contain,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                child: Icon(
                                                  Icons.list_alt,
                                                  size: 50.w, // Increased icon size
                                                ),
                                              ),
                                      ),
                                    ),
                                    // Text container - smaller
                                    Expanded(
                                      flex: 1, // Reduced flex for text
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                        ),
                                        child: Text(
                                          brand.name!,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.appFontLight.copyWith(
                                            fontSize: 9.fontSize, // Further reduced from 10.fontSize
                                            color: AppStyles.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6), // Reduced spacing
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: e.length,
                      );
                    }).toList(),
                    loop: false,
                    pagination: SwiperPagination(
                      margin: EdgeInsets.zero,
                      builder: SwiperCustomPagination(
                        builder: (BuildContext context, SwiperPluginConfig config) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: RectSwiperPaginationBuilder(
                              color: Colors.white.withOpacity(0.5),
                              activeColor: Colors.pink,
                              size: Size(5.0, 5.0),
                              activeSize: Size(20.0.w, 5.0.h),
                            ).build(context, config),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }),
),

                        ///** TOP PICKS
                        Container(
                          padding: EdgeInsets.only(
                              left: 10.0.w, right: 10.0.w, top: 10.0.h),
                          child: Obx(() {
                            if (_homeController.isHomePageLoading.value ||
                                _homeController.homePageModel.value == null) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.r)),
                                    child: Container(
                                      child: LoadingSkeleton(
                                        height: 150.h,
                                        width: Get.width,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  HomeTitlesWidget(
                                    title: 'Top Picks'.tr,
                                    btnOnTap: () {
                                      Get.to(() => AllTopPickProducts());
                                    },
                                    showDeal: false,
                                  ),
                                  Container(
                                    height: 220.h,
                                    child: _homeController.homePageModel.value.topPicks == null || _homeController.homePageModel.value.topPicks!.isEmpty ? SizedBox() : ListView.separated(
                                        itemCount: _homeController
                                            .homePageModel.value.topPicks!
                                            .take(8)
                                            .length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5.w,
                                          );
                                        },
                                        itemBuilder: (context, topPickIndex) {
                                          ProductModel prod = _homeController
                                              .homePageModel
                                              .value
                                              .topPicks![topPickIndex];

                                          double totalRating = 0;
                                          double averageRating = 0.0;

                                          if((prod.reviews??[]).isNotEmpty){
                                            for(int i = 0; i < prod.reviews!.length; i++){
                                              totalRating += prod.reviews?[i].rating ?? 0;
                                          }
                                            averageRating = totalRating/prod.reviews!.length;
                                          }

                                          return HorizontalProductWidget(
                                            productModel: prod,
                                            averageRating: averageRating,
                                          );
                                        }),
                                  ),
                                ],
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),

                  ///** RECOMMENDED

                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                      child: Center(
                        child: Text(
                          'You might like'.tr,
                          textAlign: TextAlign.left,
                          style: AppStyles.appFontBold.copyWith(
                            fontSize: 20.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),

                  LoadingMoreSliverList<ProductModel>(
                    SliverListConfig<ProductModel>(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        bottom: 50,
                      ),
                      indicatorBuilder: BuildIndicatorBuilder(
                        source: _homeController.source,
                        isSliver: true,
                        name: 'Recommended Products'.tr,
                      ).buildIndicator,
                      extendedListDelegate:
                          SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 0,
                      ),
                      itemBuilder:
                          (BuildContext c, ProductModel prod, int index) {

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
                      sourceList: _homeController.source!,
                    ),
                    key: const Key('homePageLoadMoreKey'),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
