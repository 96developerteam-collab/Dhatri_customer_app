import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/category/ProductsByCategory.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazy_widget/fa_icon_maker/fa_custom_icon.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:loading_skeleton_niu/loading_skeleton.dart';

import '../../../../AppConfig/language/app_localizations.dart';
import '../../../../config/config.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../controller/home_controller.dart';
import '../../../../model/NewModel/Category/CategoryData.dart';
import '../../../../model/NewModel/Category/CategoryMain.dart';
import '../../../../model/NewModel/Category/ParentCategory.dart';
import '../../../../model/NewModel/Category/SingleCategory.dart';
import '../../../../widgets/amazy_widget/custom_loading_widget.dart';
import '../../settings/SettingsPage.dart';

class BrowseCategoryScreen extends StatefulWidget {
  @override
  State<BrowseCategoryScreen> createState() => _BrowseCategoryScreenState();
}

class _BrowseCategoryScreenState extends State<BrowseCategoryScreen> {

  final HomeController controller = Get.put(HomeController());

  final CartController cartController = Get.find();

  int _selectedIndex = 0;

  List<bool> isSelected = [];

  getAll() async {
    Future.delayed(Duration(seconds: 0), () async {
      await controller.getCategories();
    });
    controller.allCategoryList.forEach((element) {
      isSelected.add(false);
    });
  }

  @override
  void didChangeDependencies() async {
    await getAll();

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.w),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Browse Categories".tr,
          style: AppStyles.appFontMedium.copyWith(fontSize: 18.sp, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () => Get.toNamed('/search'),
          ),
          Obx(() => Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () => Get.toNamed('/cart'),
              ),
              if (cartController.cartListCount.value > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: AppStyles.pinkColor, shape: BoxShape.circle),
                    constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '${cartController.cartListCount.value}',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isAllCategoryLoading.value) {
          return Center(child: CustomLoadingWidget());
        }
        return Row(
          children: [
            // Left Sidebar
            Container(
              width: 90.w,
              color: Color(0xffF7F7F7),
              child: ListView.builder(
                itemCount: controller.allCategoryList.length,
                itemBuilder: (context, index) {
                  final category = controller.allCategoryList[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () async {
                      setState(() => _selectedIndex = index);
                      await controller.getSubCategories(categoryId: category.id ?? 0);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 3.w,
                            height: isSelected ? 30.h : 0,
                            decoration: BoxDecoration(
                              color: AppStyles.pinkColor,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                if (category.icon != null && category.icon!.isNotEmpty)
                                  FaCustomIcon.getIconWidget(
                                    category.icon!,
                                    size: 24.w,
                                    color: isSelected ? AppStyles.pinkColor : Colors.black54,
                                  )
                                else
                                  Icon(
                                    Icons.category_outlined,
                                    size: 24.w,
                                    color: isSelected ? AppStyles.pinkColor : Colors.black54,
                                  ),
                                SizedBox(height: 6.h),
                                Text(
                                  category.name ?? '',
                                  style: AppStyles.appFontMedium.copyWith(
                                    fontSize: 10.sp,
                                    color: isSelected ? AppStyles.pinkColor : Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Right Content Area
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Obx(() {
                  if (controller.isSubCategoryLoading.value) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  final subCategories = controller.singleCat.value.data?.subCategories ?? [];
                  final categoryData = controller.singleCat.value.data;

                  return ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 12.h),
                      // Banner
                      if (categoryData?.categoryImage?.image != null)
                        Container(
                          height: 100.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: FancyShimmerImage(
                              imageUrl: '${AppConfig.assetPath}/${categoryData!.categoryImage!.image}',
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                      
                      SizedBox(height: 16.h),

                      // Browse All Header
                      InkWell(
                        onTap: () => openCategory(categoryData),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppStyles.pinkColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppStyles.pinkColor.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Browse all products in ${categoryData?.name ?? ''}".tr,
                                style: AppStyles.appFontMedium.copyWith(fontSize: 13.sp, color: AppStyles.pinkColor),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppStyles.pinkColor),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20.h),

                      // Subcategories Grid
                      if (subCategories.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.h),
                            child: Column(
                              children: [
                                Icon(Icons.category_outlined, size: 50.w, color: Colors.grey[300]),
                                SizedBox(height: 12.h),
                                Text('No subcategories available'.tr, style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 15.h,
                          ),
                          itemCount: subCategories.length,
                          itemBuilder: (context, index) {
                            final subCat = subCategories[index];
                            return InkWell(
                              onTap: () => openCategory(subCat),
                              child: Column(
                                children: [
                                  Container(
                                    height: 70.w,
                                    width: 70.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF7F7F7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: subCat.icon != null && subCat.icon!.isNotEmpty
                                          ? FaCustomIcon.getIconWidget(
                                              subCat.icon!,
                                              size: 28.w,
                                              color: Colors.black87,
                                            )
                                          : Icon(Icons.category, size: 28.w, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    subCat.name ?? '',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.appFontMedium.copyWith(fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 20.h),
                    ],
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  void openCategory(dynamic category) {
    if (category == null) return;
    print('CAT $category');
    controller.categoryId.value = category.id;
    controller.categoryIdBeforeFilter.value = category.id;
    controller.allProds.clear();
    controller.subCats.clear();
    controller.lastPage.value = false;
    controller.pageNumber.value = 1;
    controller.category.value = CategoryData();
    controller.catAllData.value = SingleCategory();
    
    controller.getCategoryProducts();
    controller.getCategoryFilterData();
    
    if (controller.dataFilterCat.value.filterDataFromCat != null) {
      controller.dataFilterCat.value.filterDataFromCat?.filterType?.forEach((element) {
        if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
          element.filterTypeValue?.clear();
        }
      });
    }

    controller.filterRating.value = 0.0;

    Get.to(() => ProductsByCategory(categoryId: category.id));
  }
}
