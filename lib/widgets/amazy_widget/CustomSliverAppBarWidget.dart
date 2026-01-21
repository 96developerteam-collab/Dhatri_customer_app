import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/products/SearchPageMain.dart';
import 'package:amazcart/view/amazy_view/notifications/MessageNotifications.dart';
import 'package:amazcart/view/amazy_view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/amazy_widget/cart_icon_widget.dart';
import 'package:amazcart/widgets/amazy_widget/custom_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'appbar_back_button.dart';

class CustomSliverAppBarWidget extends StatelessWidget {
  final bool showBack;
  final bool showCart;
  CustomSliverAppBarWidget(this.showBack, this.showCart);
  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find<HomeController>();
    return SliverAppBar(
      backgroundColor: AppStyles.pinkColor,
      titleSpacing: 0,
      expandedHeight: 120.h,
      automaticallyImplyLeading: false,
      stretch: false,
      pinned: true,
      floating: false,
      toolbarHeight: 120.h,
      forceElevated: false,
      scrolledUnderElevation: 0,
      elevation: 0,
      actions: [
        Container(),
      ],
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              showCart
                  ? CartIconWidget()
                  : Container(
                      height: 40.w,
                      width: 40.w,
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            print('open drawer');
                           scaffoldkey.value.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.menu_rounded,
                            size: 30.w,
                            color: Colors.white,
                          )),
                    ),
              SizedBox(width: 8),
              showBack
                  ? AppBarBackButton()
                  : Container(
                      height: 35.w,
                      width: 35.w,
                      child: Image.asset(
                        "${AppConfig.appBarIcon}",
                        height: 35.w,
                        width: 35.w,
                        fit: BoxFit.contain,
                      ),
                    ),
              SizedBox(width: 12),
              Text(
                'Dhatri',
                style: TextStyle(
                  fontFamily: 'ArchivoBlack',
                  fontSize: 30.fontSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  final LoginController loginController = Get.find<LoginController>();
                  if (loginController.loggedIn.value) {
                    Get.to(() => MessageNotifications());
                  } else {
                    Get.to(() => LoginPage());
                  }
                },
                child: Icon(
                  Icons.notifications,
                  size: 24.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15.w),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: GestureDetector(
              onTap: () {
                Get.to(() => SearchPageMain());
              },
              child: Container(
                height: 40.h,
                child: TextField(
                  autofocus: true,
                  enabled: false,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  style:  AppStyles.appFont.copyWith(fontSize: 12.fontSize, color: AppStyles.greyColorDark,),
                  expands: false,

                  decoration: CustomInputBorder()
                      .inputDecorationAppBar(
                        'Dhatri',
                      )
                      .copyWith(
                    hintStyle: AppStyles.appFont.copyWith(fontSize: 12.fontSize, color: AppStyles.blackColor,),
                    prefixIcon: CustomGradientOnChild(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.search,
                              color: AppStyles.pinkColor,
                              size: 16.w,
                            ),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
