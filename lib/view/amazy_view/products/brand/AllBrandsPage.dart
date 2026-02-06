import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/view/amazy_view/products/brand/all_brand_controller.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/custom_grid_delegate.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../model/NewModel/Brand/BrandData.dart';

class AllBrandsPage extends StatefulWidget {
  @override
  _AllBrandsPageState createState() => _AllBrandsPageState();
}

class _AllBrandsPageState extends State<AllBrandsPage> {
  final AllBrandController _brandController = Get.put(AllBrandController());
  final CartController cartController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Brands".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 18.fontSize,
                        color: Color(0xff5C7185),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Obx(() {
              if (_brandController.isBrandsLoading.value) {
                return Center(child: CustomLoadingWidget());
              } else {
                return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h), // Reduced outer padding
                    physics: BouncingScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.w, // Added spacing between cards
                      mainAxisSpacing: 8.h, // Added spacing between cards
                      height: 140.h, // Reduced height slightly
                    ),
                    itemCount: _brandController.allBrands.length,
                    itemBuilder: (context, index) {
                      BrandData brand = _brandController.allBrands[index];
                      return GestureDetector(
                        onTap: () async {
                          Get.to(() => ProductsByBrands(
                                brandId: brand.id!,
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0D000000),
                                offset: Offset(0, 2),
                                blurRadius: 4.r,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Brand logo/image - with less padding
                              Container(
                                height: 65.h, // Slightly reduced
                                width: 65.w,  // Slightly reduced
                                margin: EdgeInsets.only(top: 12.h, bottom: 6.h), // Reduced bottom margin
                                padding: EdgeInsets.all(4.w), // Reduced padding
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: brand.logo != null
                                    ? FancyShimmerImage(
                                        imageUrl: AppConfig.assetPath + '/' + brand.logo!,
                                        boxFit: BoxFit.contain,
                                        errorWidget: FancyShimmerImage(
                                          imageUrl:
                                              "${AppConfig.assetPath}/backend/img/default.png",
                                          boxFit: BoxFit.contain,
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.business,
                                          size: 28.w, // Slightly reduced
                                          color: AppStyles.greyColorDark,
                                        ),
                                      ),
                              ),
                              
                              // Brand name text - increased font size slightly
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w), // Reduced horizontal padding
                                child: Text(
                                  brand.name!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFontMedium.copyWith(
                                    color: AppStyles.blackColor,
                                    fontSize: 12.fontSize, // Increased from 11
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 8.h), // Reduced bottom spacing
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
          ),
        ],
      ),
    );
  }
}