import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../database/auth_database.dart';

class RegistrationPage extends GetView<LoginController> {
  final LoginController _accountController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: Get.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                        padding: EdgeInsets.only(left: 10.w,top: 20.h),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
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
                      'Create an Account'.tr,
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
                      'Signup with your own active email and new password or login your account'
                          .tr,
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      controller: _accountController.firstName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'First Name'.tr + " *",
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14.fontSize,
                        ),
                        prefixIcon: Container(
                          height: 10.w,
                          width: 10.w,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/person.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      style: AppStyles.appFontMedium,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Type First name'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.lastName,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Last Name'.tr + " *",
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14.fontSize,
                        ),
                        prefixIcon: Container(
                          height: 10.w,
                          width: 10.w,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/person.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Type Last name'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerEmail,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Email or Phone Number'.tr + " *",
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14.fontSize,
                        ),
                        prefixIcon: Container(
                          height: 10.w,
                          width: 10.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/email.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email or phone number'.tr;
                        }

                        // Check if it's a phone number
                        String digits = value.replaceAll(RegExp(r'\D'), '');
                        bool isPhone = digits.length == 10;

                        // Check if it's an email
                        bool isEmail = value.contains('@');

                        // If it's neither phone nor email, show error
                        if (!isPhone && !isEmail) {
                          return 'Please enter a valid email or 10 digit phone number'.tr;
                        }

                        // If it looks like an email but doesn't have dot
                        if (isEmail && !value.contains('.')) {
                          return 'Please enter a valid email'.tr;
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerPassword,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Password'.tr + " *",
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14.fontSize,
                        ),
                        prefixIcon: Container(
                          height: 10.w,
                          width: 10.w,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/lock.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Please Type your password'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerConfirmPassword,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Confirm Password'.tr + " *",
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14.fontSize,
                        ),
                        prefixIcon: Container(
                          height: 10.w,
                          width: 10.w,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/lock.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Type password again'.tr;
                        } else if (controller.registerPassword.text != value) {
                          return 'Password must be the same'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.referralCode,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Referral code (optional)'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14.fontSize,
                        ),
                        prefixIcon: Container(
                          height: 10.w,
                          width: 10.w,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/my_review.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _accountController.isLoading.value
                        ? Center(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: CupertinoActivityIndicator()))
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map registrationData = {
                                    "first_name": controller.firstName.text,
                                    // "last_name": controller.lastName.text,
                                    "login": controller.registerEmail.text,
                                    "referral_code":
                                        controller.referralCode.text,
                                    "password":
                                        controller.registerPassword.text,
                                    "password_confirmation":
                                        controller.registerConfirmPassword.text,
                                    "user_type": "customer",
                                    "device_token" : AuthDatabase.instance.getDeviceUniqueId()
                                  };

                                  if (_settingsController
                                      .otpOnCustomerRegistration.value) {
                                    Map data = {
                                      "type": "otp_on_customer_registration",
                                      "login": controller.registerEmail.text,
                                      "first_name": controller.firstName.text,
                                    };

                                    final OtpController otpController =
                                        Get.put(OtpController());

                                    _accountController.isLoading.value = true;

                                    await otpController
                                        .generateOtp(data)
                                        .then((value) {
                                      if (value == true) {
                                        _accountController.isLoading.value =
                                            false;
                                        Get.to(() => OtpVerificationPage(
                                              data: data,
                                              onSuccess: (result) async {
                                                if (result == true) {
                                                  await _accountController
                                                      .registerUser(
                                                          registrationData);
                                                }
                                              },
                                            ));
                                      } else {
                                        _accountController.isLoading.value =
                                            false;
                                        SnackBars()
                                            .snackBarWarning(value.toString());
                                      }
                                    });
                                  } else {
                                    await _accountController.registerUser(registrationData);
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: Get.width,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    gradient: AppStyles.gradient,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.r))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sign Up'.tr,
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
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8.h
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account?'.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                color: AppStyles.greyColorLight,
                                fontSize: 16.fontSize,
                              ),
                            ),
                            TextSpan(
                              text: '  ' + 'Login'.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                color: AppStyles.pinkColor,
                                fontSize: 16.fontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: Get.height * 0.07,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
