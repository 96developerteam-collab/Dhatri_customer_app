import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/category/ProductsByCategory.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazy_widget/fa_icon_maker/fa_custom_icon.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
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
      body: Padding(
        padding: EdgeInsets.only(bottom:60.w),
        child: Column(
          children: [
            CustomScrollView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                CustomSliverAppBarWidget(false, false),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                      ),
                    ),
                    child: Text(
                      "Browse Categories".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 18.fontSize,
                        color: Color(0xff5C7185),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
                child: Obx(() {
              if (controller.isAllCategoryLoading.value) {
                return Center(child: CustomLoadingWidget());
              } else {
                return Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.allCategoryList.length,
                          itemBuilder: (context, index) {
                            CategoryData category = controller.allCategoryList[index];
                            return Container(
                              color: _selectedIndex == index
                                  ? AppStyles.appBackgroundColor
                                  : Colors.white,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  await controller.getSubCategories(
                                      categoryId: category.id ?? 0);
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        category.categoryImage?.image != null && (category.categoryImage?.image ?? '').isNotEmpty
                                            ? Container(
                                          height: 50.h,
                                          width: 50.w,
                                          child: FancyShimmerImage(
                                            imageUrl: AppConfig.assetPath + '/' + category.categoryImage!.image!,
                                            boxFit: BoxFit.contain,
                                            errorWidget: category.icon != null && (category.icon ?? '').isNotEmpty
                                                ? FaCustomIcon.getIconWidget(
                                              category.icon ?? '',
                                              size: 30.w,
                                              color: _selectedIndex == index
                                                  ? AppStyles.pinkColor
                                                  : Colors.black,
                                            )
                                                : Icon(
                                              Icons.list_alt_outlined,
                                              size: 30.w,
                                              color: _selectedIndex == index
                                                  ? AppStyles.pinkColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        )
                                            : category.icon != null && (category.icon ?? '').isNotEmpty
                                            ? Container(
                                          height: 50.h,
                                          child: FaCustomIcon.getIconWidget(
                                            category.icon ?? '',
                                            size: 30.w,
                                            color: _selectedIndex == index
                                                ? AppStyles.pinkColor
                                                : Colors.black,
                                          ),
                                        )
                                            : Container(
                                          height: 50.h,
                                          child: Icon(
                                            Icons.list_alt_outlined,
                                            size: 30.w,
                                            color: _selectedIndex == index
                                                ? AppStyles.pinkColor
                                                : Colors.black,
                                          ),
                                        ),
                                        Container(
                                          width: 75.w,
                                          child: Text(
                                            category.name ?? '',
                                            style: AppStyles.kFontBlack14w5
                                                .copyWith(
                                                color: _selectedIndex == index
                                                    ? Colors.pink
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
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
                    Flexible(
                      flex: 3,
                      child: Obx(
                            () {
                          if (controller.isSubCategoryLoading.value) {
                            return Center(
                                child: Container(
                                  // child: CupertinoActivityIndicator(),
                                ));
                          } else {
                            if (controller.singleCat.value.data == null) {
                              return Center(child: Text('No data available'.tr));
                            } else {
                              return ListView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  controller.singleCat.value.data?.categoryImage?.image != null
                                      ? Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppStyles
                                                    .lightBlueColorAlt)),
                                        child: FancyShimmerImage(
                                          imageUrl: AppConfig.assetPath +
                                              '/' + '${controller.singleCat.value.data?.categoryImage?.image}',
                                          height: 80.h,
                                          boxFit: BoxFit.cover,
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
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      print(controller.singleCat.value.data);
                                      openCategory(controller.singleCat.value.data);
                                    },
                                    leading: controller.singleCat.value.data?.categoryImage?.image != null &&
                                        (controller.singleCat.value.data?.categoryImage?.image ?? '').isNotEmpty
                                        ? Container(
                                      height: 50.h,
                                      width: 50.w,
                                      child: FancyShimmerImage(
                                        imageUrl: AppConfig.assetPath + '/' + controller.singleCat.value.data!.categoryImage!.image!,
                                        boxFit: BoxFit.contain,
                                        errorWidget: controller.singleCat.value.data?.icon != null &&
                                            (controller.singleCat.value.data?.icon ?? '').isNotEmpty
                                            ? FaCustomIcon.getIconWidget(
                                          controller.singleCat.value.data?.icon ?? '',
                                          size: 30.w,
                                          color: AppStyles.blackColor,
                                        )
                                            : Icon(
                                          Icons.list_alt_outlined,
                                          size: 30.w,
                                          color: AppStyles.blackColor,
                                        ),
                                      ),
                                    )
                                        : controller.singleCat.value.data?.icon != null &&
                                        (controller.singleCat.value.data?.icon ?? '').isNotEmpty
                                        ? Container(
                                      height: 50.h,
                                      child: Icon(
                                        FaCustomIcon.getFontAwesomeIcon(
                                            controller.singleCat.value.data?.icon ?? ''),
                                        size: 30.w,
                                        color: AppStyles.blackColor,
                                      ),
                                    )
                                        : Container(
                                      height: 50.h,
                                      child: Icon(
                                        Icons.list_alt_outlined,
                                        size: 30.w,
                                        color: AppStyles.blackColor,
                                      ),
                                    ),
                                    title: Text(
                                      controller.singleCat.value.data?.name ?? '',
                                      style: AppStyles.kFontBlack14w5,
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller.singleCat.value.data
                                          ?.subCategories?.length ?? 0,
                                      itemBuilder: (context, subCatIndex) {
                                        if ((controller.singleCat.value.data?.subCategories?[subCatIndex].subCategories?.length ?? 0) > 0) {
                                          return ExpansionTile(
                                              title: ListTile(
                                                onTap: () async {
                                                  openCategory(controller.singleCat.value.data?.subCategories?[subCatIndex]);
                                                },
                                                contentPadding: EdgeInsets.zero,
                                                leading: controller.singleCat.value.data?.subCategories?[subCatIndex].icon !=
                                                    null
                                                    ? Container(
                                                  height: 50.h,
                                                  child: Icon(
                                                    FaCustomIcon
                                                        .getFontAwesomeIcon(
                                                        controller.singleCat.value.data?.subCategories?[subCatIndex].icon ?? ''),
                                                    size: 30.w,
                                                    color:
                                                    AppStyles.blackColor,
                                                  ),
                                                )
                                                    : Container(
                                                  height: 50.h,
                                                  child: Icon(
                                                    Icons.list_alt_outlined,
                                                    size: 30.w,
                                                    color:
                                                    AppStyles.blackColor,
                                                  ),
                                                ),
                                                title: Text(
                                                    controller
                                                        .singleCat
                                                        .value
                                                        .data
                                                        ?.subCategories?[subCatIndex]
                                                        .name ?? '',
                                                    style:
                                                    AppStyles.kFontBlack14w5),
                                              ),
                                              children: List.generate(
                                                  controller
                                                      .singleCat
                                                      .value
                                                      .data
                                                      ?.subCategories?[subCatIndex]
                                                      .subCategories
                                                      ?.length ?? 0, (expansionIndex) {
                                                return ListTile(
                                                  onTap: () {
                                                    openCategory(
                                                        controller
                                                            .singleCat
                                                            .value
                                                            .data
                                                            ?.subCategories?[
                                                        subCatIndex]
                                                            .subCategories?[
                                                        expansionIndex]);
                                                  },
                                                  leading: controller
                                                      .singleCat
                                                      .value
                                                      .data
                                                      ?.subCategories?[
                                                  subCatIndex]
                                                      .subCategories?[
                                                  expansionIndex]
                                                      .icon !=
                                                      null
                                                      ? Container(
                                                    height: 50.w,
                                                    width: 50.w,
                                                    child: Icon(
                                                      FaCustomIcon.getFontAwesomeIcon(
                                                          controller
                                                              .singleCat
                                                              .value
                                                              .data
                                                              ?.subCategories?[
                                                          subCatIndex]
                                                              .subCategories?[
                                                          expansionIndex]
                                                              .icon ?? ''),
                                                      color: AppStyles
                                                          .blackColor,
                                                    ),
                                                  )
                                                      : Container(
                                                    height: 50.w,
                                                    width: 50.w,
                                                    child: Icon(
                                                      Icons.list_alt_outlined,
                                                      color: AppStyles
                                                          .blackColor,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    controller
                                                        .singleCat
                                                        .value
                                                        .data
                                                        ?.subCategories?[subCatIndex]
                                                        .subCategories?[
                                                    expansionIndex]
                                                        .name ?? '',
                                                    style: AppStyles.kFontBlack14w5,
                                                  ),
                                                );
                                              }));
                                        }
                                        return ListTile(
                                          onTap: () {
                                            openCategory(controller.singleCat.value
                                                .data?.subCategories?[subCatIndex]);
                                          },
                                          leading: controller
                                              .singleCat
                                              .value
                                              .data
                                              ?.subCategories?[subCatIndex]
                                              .icon !=
                                              null
                                              ? Container(
                                            height: 50.w,
                                            width: 50.w,
                                            child: Icon(
                                              FaCustomIcon.getFontAwesomeIcon(
                                                  controller
                                                      .singleCat
                                                      .value
                                                      .data
                                                      ?.subCategories?[
                                                  subCatIndex]
                                                      .icon ?? ''),
                                              color: AppStyles.blackColor,
                                            ),
                                          )
                                              : Container(
                                            height: 50.w,
                                            width: 50.w,
                                            child: Icon(
                                              Icons.list_alt_outlined,
                                              color: AppStyles.blackColor,
                                            ),
                                          ),
                                          title: Text(
                                            controller.singleCat.value.data
                                                ?.subCategories?[subCatIndex].name ?? '',
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                        );
                                      }),
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            })
            )
          ],
        ),
      ),
    );
  }

  void openCategory(dynamic category) {
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

    // Get.toNamed('/productsByCategory');
    Get.to(() => ProductsByCategory(
      categoryId: category.id,
    ));
  }

}