import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../AppConfig/app_config.dart';
import '../../../controller/login_controller.dart';
import '../../../controller/otp_controller.dart';
import '../../../controller/settings_controller.dart';
import '../../../utils/styles.dart';
import '../../../widgets/amazy_widget/snackbars.dart';
import 'OtpVerificationPage.dart';

class ForgotPasswordPage extends GetView<LoginController> {
  final LoginController _loginController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10.w),
                      child: IconButton(
                        onPressed: () {
                          Get.close(1);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 25.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppConfig.appLogo,
                      width: 33.w,
                      height: 33.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      AppConfig.appName,
                      style: AppStyles.appFontBold.copyWith(
                        fontSize: 20.fontSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Reset Password'.tr,
                    style: AppStyles.appFontBold.copyWith(
                      fontSize: 22.fontSize,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Enter your email to get password reset mail'.tr,
                    textAlign: TextAlign.center,
                    style: AppStyles.appFontBook.copyWith(
                      fontSize: 16.fontSize,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: TextFormField(
                    controller: _loginController.email,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email'.tr,
                      hintStyle: AppStyles.appFontMedium,
                      prefixIcon: Container(
                        height: 10.w,
                        width: 10.w,
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/email.png',
                        ),
                      ),
                      errorStyle: AppStyles.appFontMedium
                          .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppStyles.appFontMedium
                        .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),

                    maxLines: 1,
                    validator: (value) {
                      if (value!.length == 0) {
                        return 'Please Type Email address'.tr + '...';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _loginController.isLoading.value
                      ? Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: CupertinoActivityIndicator()))
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: InkWell(
                            onTap: () async {
                              if (_settingsController
                                  .otpOnPasswordReset.value) {
                                Map data = {
                                  "type": "otp_on_password_reset",
                                  "email": _loginController.email.value.text,
                                };

                                final OtpController otpController =
                                    Get.put(OtpController());

                                _loginController.isLoading.value = true;

                                await otpController
                                    .generateOtp(data)
                                    .then((value) {
                                  if (value == true) {
                                    _loginController.isLoading.value = false;
                                    Get.to(() => OtpVerificationPage(
                                          data: data,
                                          onSuccess: (result) async {
                                            if (result == true) {
                                              var jsonString =
                                                  await _loginController
                                                      .forgotPassword()
                                                      .then((value) {
                                                if (value == true) {
                                                  SnackBars().snackBarSuccess(
                                                      "Reset password link sent"
                                                          .tr);
                                                } else {
                                                  SnackBars().snackBarError(
                                                      value.toString());
                                                }
                                              });
                                              print(jsonString);
                                            }
                                          },
                                        ));
                                  } else {
                                    _loginController.isLoading.value = false;
                                    SnackBars()
                                        .snackBarWarning(value.toString());
                                  }
                                });
                              } else {
                                var jsonString = await _loginController
                                    .forgotPassword()
                                    .then((value) {
                                  if (value == true) {
                                    SnackBars().snackBarSuccess(
                                        "Reset password link sent".tr);
                                  }
                                });
                                print(jsonString);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: Get.width,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  gradient: AppStyles.gradient,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Send'.tr,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFontBook.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.fontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
