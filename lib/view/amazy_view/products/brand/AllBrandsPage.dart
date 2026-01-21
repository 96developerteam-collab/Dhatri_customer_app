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
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                    physics: BouncingScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 6,
                      height: 130.h,
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
                          width: Get.width * 0.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1a000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 6.r,
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: brand.logo != null
                                            ? Container(
                                                child: FancyShimmerImage(
                                                  imageUrl:
                                                      AppConfig.assetPath +
                                                              '/' +
                                                              brand.logo! ??
                                                          '',
                                                  boxFit: BoxFit.contain,
                                                  errorWidget:
                                                      FancyShimmerImage(
                                                    imageUrl:
                                                        "${AppConfig.assetPath}/backend/img/default.png",
                                                    boxFit: BoxFit.contain,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                child: Icon(
                                                  Icons.list_alt,
                                                  size: 50.w,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      brand.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFontMedium.copyWith(
                                        color: AppStyles.blackColor,
                                        fontSize: 15.fontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
