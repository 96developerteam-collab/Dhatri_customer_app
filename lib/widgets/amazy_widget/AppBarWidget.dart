import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget//appbar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view/amazy_view/MainNavigation.dart';
import 'package:amazcart/widgets/amazy_widget/cart_icon_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget  {

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? 60 : 100);

  final String? title;
  final PreferredSizeWidget? bottom;
  final bool? showCart;
  AppBarWidget({
    this.title,
    this.bottom,
    this.showCart = true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: false,
      toolbarHeight: 60.h,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: bottom,
      title: Text(
        title??'',
        style: AppStyles.appFontMedium.copyWith(
          fontSize: 16.fontSize,
          color: Colors.black,
        ),
      ),
      actions: [
      showCart! ?  CartIconWidget(
          isSliver: false,
        ) : SizedBox.shrink(),
      ],
      leading: AppBarBackButton(
        color: AppStyles.pinkColor,
        onBack: (){
          if(AppConfig.isPasswordChange){
            Get.to(MainNavigation());
            AppConfig.isPasswordChange = false;
          }
          else{
            Get.back();
          }
        },
      ),
    );
  }
}
