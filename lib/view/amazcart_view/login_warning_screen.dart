import 'package:amazcart/view/amazcart_view/authentication/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../AppConfig/app_config.dart';
import '../../utils/styles.dart';

class LoginWarningScreen extends StatelessWidget {
  const LoginWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: Get.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    AppConfig.loginScreenBackgroundGradient1,
                    AppConfig.loginScreenBackgroundGradient2,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
          ),

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text("Welcome to".tr +
                    " ${AppConfig.appName}",
                style: AppStyles.kFontWhite14w5,
              ),
              10.verticalSpace,
              Image.asset(
                AppConfig.appLogo,
                width: 50.w,
                height: 50.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                AppConfig.appName.toUpperCase(),
                style: AppStyles.kFontWhite14w5.copyWith(
                  fontSize: 25.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
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
              ),
              50.verticalSpace,

            ]
          ),
        ),
      ),
    );
  }
}
