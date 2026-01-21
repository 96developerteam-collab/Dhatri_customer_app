import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/new_user_zone_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/marketing/NewUserZone/NewUserZoneCouponMain.dart';
import 'package:amazcart/widgets/amazcart_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:amazcart/widgets/amazcart_widget/cart_icon_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'NewUserZoneCategoryMain.dart';
import 'NewUserZoneProducts.dart';

class NewUserZonePage extends StatefulWidget {
  @override
  _NewUserZonePageState createState() => _NewUserZonePageState();
}

class _NewUserZonePageState extends State<NewUserZonePage>
    with SingleTickerProviderStateMixin {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    newUserZoneController.newUserProducts.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (newUserZoneController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CustomLoadingWidget(),
          ),
        );
      } else {
        if (newUserZoneController.newZone.value.newUserZone == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30.h,
              ),
              Image.asset(
                AppConfig.appLogo,
                width: 50.w,
                height: 50.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                '- ' + 'No Products found'.tr + ' - ',
                style: AppStyles.kFontBlack17w5,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0.w),
                child: PinkButtonWidget(
                  height: 32.h,
                  btnOnTap: () {
                    Get.back();
                  },
                  btnText: 'Continue Shopping'.tr,
                ),
              ),
            ],
          );
        }

        return Scaffold(
          backgroundColor: Color(
            newUserZoneController.bgColor.value,
          ),
          body: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 80.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: Color(
                    newUserZoneController.bgColor.value,
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    CartIconWidget(),
                  ],
                  titleSpacing: 0,
                  centerTitle: false,
                  elevation: 1,
                  title: SliverAppBarTitleWidget(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                       AppBarBackButton(),
                        SizedBox(
                          width: 10
                        ),
                        Expanded(
                          child: Text(
                            newUserZoneController
                                .newZone.value.newUserZone?.title ?? '',
                            style: AppStyles.kFontBlack14w5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            child: FancyShimmerImage(
                              imageUrl:
                                  '${AppConfig.assetPath}/${newUserZoneController.newZone.value.newUserZone?.bannerImage}',
                              boxFit: BoxFit.cover,
                              errorWidget: FancyShimmerImage(
                                imageUrl:
                                    "${AppConfig.assetPath}/backend/img/default.png",
                                boxFit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                             AppBarBackButton(
                               color: Colors.white,
                             ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  newUserZoneController
                                      .newZone.value.newUserZone?.title ?? '',
                                  style: AppStyles.kFontWhite14w5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            floatHeaderSlivers: true,

            body: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppStyles.pinkColor,
                  isScrollable: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  automaticIndicatorColorAdjustment: true,

                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Text(
                          newUserZoneController
                              .newZone.value.newUserZone?.productNavigationLabel ?? '',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack14w5),

                      ///todo tab item
                    ),
                    Tab(
                      child: Text(
                          newUserZoneController.newZone.value.newUserZone
                              ?.categoryNavigationLabel ?? '',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack14w5
                      ),
                    ),
                    Tab(
                      child: Text(
                        newUserZoneController
                            .newZone.value.newUserZone?.couponNavigationLabel ?? '',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: AppStyles.kFontBlack14w5,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      NewUserZoneProducts(),
                      NewUserZoneCategoryMain(),
                      NewUserZoneCouponMain(),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}
