import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/amazy_view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/view/amazy_view/products/category/ProductsByCategory.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/amazy_widget/HomeTitlesWidget.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/HorizontalProductWidget.dart';
import 'package:amazcart/widgets/amazy_widget/fa_icon_maker/fa_custom_icon.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:loading_more_list/loading_more_list.dart';

import '../../../model/NewModel/Brand/BrandData.dart';
import '../../../model/NewModel/Category/CategoryData.dart';
import '../../../model/NewModel/Category/SingleCategory.dart';
import '../../../model/NewModel/Product/ProductModel.dart';
import '../../../model/NewModel/Seller/SellerProfileModel.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage();
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  final SellerProfileController controller = Get.find<SellerProfileController>();

  final HomeController homeController = Get.put(HomeController());

  RecommendedProductsLoadMore? source;

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
    return ExtendedVisibilityDetector(
      // const Key('Tab1'),
      uniqueKey: Key('Tab1'),
      child: LoadingMoreCustomScrollView(
        reverse: false,
        showGlowLeading: false,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                SizedBox(
                  height: 15,
                ),
                HomeTitlesWidget(
                  title: 'New Arrival'.tr,
                  btnOnTap: () {
                    controller.tabController?.animateTo(1);
                  },
                  showDeal: false,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 220.h,
                  child: ListView.separated(
                      itemCount: controller.recentProductsList.take(5).length??0,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (context, topPickIndex) {
                        ProductModel prod =
                        controller.recentProductsList[topPickIndex]??ProductModel();
                        return HorizontalProductWidget(
                          productModel: prod,
                          averageRating: 0,
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                (controller.seller.value.categoryList?.length ?? 0) > 0
                    ? HomeTitlesWidget(
                  title: 'Categories'.tr,
                  btnOnTap: () {
                    controller.tabController?.animateTo(1);
                  },
                  showDeal: false,
                )
                    : SizedBox.shrink(),
                (controller.seller.value.categoryList?.length ?? 0) > 0
                    ? SizedBox(
                  height: 10,
                )
                    : SizedBox.shrink(),
                (controller.seller.value.categoryList?.length ?? 0) > 0
                    ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    color: AppStyles.lightBlueColorAlt,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 100.h,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: controller.seller.value.categoryList?.length ?? 0,
                          itemBuilder: (context, index) {
                            CategoryList category = controller.seller.value.categoryList?[index] ?? CategoryList();
                            return InkWell(
                              onTap: () {
                                homeController.categoryId.value =
                                    category.id;
                                homeController.categoryIdBeforeFilter
                                    .value = category.id;
                                homeController.allProds.clear();
                                homeController.subCats.clear();
                                homeController.lastPage.value = false;
                                homeController.pageNumber.value = 1;
                                homeController.category.value =
                                    CategoryData();
                                homeController.catAllData.value =
                                    SingleCategory();
                                homeController.getCategoryProducts();
                                homeController.getCategoryFilterData();
                                if (homeController.dataFilterCat.value
                                    .filterDataFromCat !=
                                    null) {
                                  homeController.dataFilterCat.value
                                      .filterDataFromCat?.filterType
                                      ?.forEach((element) {
                                    if (element.filterTypeId == 'brand' ||
                                        element.filterTypeId == 'cat') {
                                      print(element.filterTypeId);
                                      element.filterTypeValue?.clear();
                                    }
                                  });
                                }

                                homeController.filterRating.value = 0.0;

                                // Get.toNamed('/productsByCategory');
                                Get.to(() => ProductsByCategory(
                                  categoryId: category.id,
                                ));
                              },
                              child: Container(
                                color: Colors.white,
                                width: 80.w,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      category.icon != null
                                          ? Container(
                                        height: 50.h,
                                        child: FaCustomIcon.getIconWidget(category.icon ?? '', size: 30.w),
                                      )
                                          : Container(
                                        height: 50.h,
                                        child: Icon(
                                          Icons.list_alt_outlined,
                                          size: 30.w,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 5.0,
                                        ),
                                        child: Text(
                                          category.name ?? '',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack13w5,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10,
                ),
                HomeTitlesWidget(
                  title: 'Brands'.tr,
                  btnOnTap: () {
                    controller.tabController?.animateTo(1);
                  },
                  showDeal: false,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    color: AppStyles.lightBlueColorAlt,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 100.h,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: controller.seller.value.brandList?.length ?? 0,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            BrandData brand =
                                controller.seller.value.brandList?[index] ?? BrandData();
                            return InkWell(
                              onTap: () {
                                homeController.brandId.value = brand.id ?? 0;
                                homeController.allBrandProducts.clear();
                                homeController.subCatsInBrands.clear();
                                homeController.lastBrandPage.value = false;
                                homeController.brandPageNumber.value = 1;
                                homeController.getBrandProducts();
                                homeController.getBrandFilterData();

                                if (homeController.dataFilterCat.value
                                    .filterDataFromCat !=
                                    null) {
                                  homeController.dataFilterCat.value
                                      .filterDataFromCat?.filterType
                                      ?.forEach((element) {
                                    if (element.filterTypeId == 'brand' ||
                                        element.filterTypeId == 'cat') {
                                      print(element.filterTypeId);
                                      element.filterTypeValue?.clear();
                                    }
                                  });
                                }
                                Get.to(() => ProductsByBrands(
                                  brandId: brand.id ?? 0,
                                ));
                              },
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  color: Colors.white,
                                  width: 80.h,
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: brand.logo != null
                                                ? Container(
                                              child: FancyShimmerImage(
                                                imageUrl:
                                                AppConfig.assetPath +
                                                    '/' + '${brand.logo}',
                                                boxFit: BoxFit.contain,
                                                errorWidget:
                                                FancyShimmerImage(
                                                  imageUrl:
                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                  errorWidget:
                                                  FancyShimmerImage(
                                                    imageUrl:
                                                    "${AppConfig.assetPath}/backend/img/default.png",
                                                    boxFit:
                                                    BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            )
                                                : Container(
                                                child:
                                                Icon(Icons.list_alt,size: 16.w,)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: (brand.name?.length ?? 0) < 10
                                                  ? 1.0
                                                  : 0.0,
                                              horizontal: 4),
                                          child: Text(
                                            brand.name ?? '',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.kFontBlack12w4,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
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
              padding: EdgeInsets.all(5.0),
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
              itemBuilder: (BuildContext c, ProductModel prod, int index) {
                return GridViewProductWidget(
                  productModel: prod,
                  averageRating: 0,
                );
              },
              sourceList: source ?? RecommendedProductsLoadMore(),
            ),
            key: const Key('homePageLoadMoreKey'),
          ),
        ],
      ),
    );
  }
}
