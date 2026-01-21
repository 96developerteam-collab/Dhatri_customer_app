import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/Settings/SettingsPage.dart';
import 'package:amazcart/view/amazcart_view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class SignInOrRegister extends StatefulWidget {
  const SignInOrRegister({super.key, this.enableBackButton = false});


  final bool enableBackButton;

  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.h),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/account_appbar_bg.svg',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      if(widget.enableBackButton)
                        AppBarBackButton(
                          color: Colors.white,
                        ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Container(
                        height: 30.w,
                        width: 30.w,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          color: AppStyles.pinkColor,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Hello".tr +
                            ", " +
                            "Welcome to".tr +
                            " ${AppConfig.appName}",
                        style: AppStyles.kFontWhite14w5,
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        onPressed: () {
                          Get.to(() => SettingsPage());
                        },
                        icon: Icon(
                          Icons.settings_outlined,
                          color: Colors.white.withOpacity(0.9),
                          size: 20.w,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(LoginPage(), useSafeArea: false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Sign in or Register'.tr,
                        textAlign: TextAlign.center,
                        style: AppStyles.appFont.copyWith(
                          color: AppStyles.pinkColor,
                          fontSize: 14.fontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.w, right: 20.w),
                child: Text(
                  ''.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.greyColorLight,
                    fontSize: 12.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  'assets/images/icon_all_orders.svg',
                  width: 16.w,
                ),
                title: Text(
                  'All Orders'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70.h,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  width: 16.w,
                  'assets/images/icon_cancellations.svg',
                ),
                title: Text(
                  'My Cancellations'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70.h,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  width: 16.w,

                  'assets/images/icon_returns.svg',
                ),
                title: Text(
                  'My Returns'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70.h,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.w, right: 20.w, top: 20.h),
                child: Text(
                  'My Services'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.greyColorLight,
                    fontSize: 12.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  width: 16.w,
                  'assets/images/icon_my_reviews.svg',
                ),
                title: Text(
                  'My Review'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70.h,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  width: 16.w,
                  'assets/images/icon_need_help.svg',
                ),
                title: Text(
                  'Need Help?'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70.h,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
