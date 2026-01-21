import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/amazy_widget/animate_widget/elasticIn.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                height: 50.w,
                width: 50.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('${AppConfig.loginBackgroundImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElasticIn(
                    manualTrigger: false,
                    animate: true,
                    infinite: true,
                    child: Image.asset(
                      "${AppConfig.appLogo}",
                      height: 60.w,
                      width: 60.w,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "${AppConfig.appName}",
                    style: AppStyles.appFontBold.copyWith(
                      color: Colors.white,
                      fontSize: 20.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              bottom: 50.h,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "${AppConfig.appName} ${"Online Ecommerce".tr}",
                  style: AppStyles.appFontBook.copyWith(
                    color: Colors.white,
                    fontSize: 14.fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
