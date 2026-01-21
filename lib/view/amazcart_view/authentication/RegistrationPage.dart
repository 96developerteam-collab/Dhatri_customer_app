import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/database/auth_database.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegistrationPage extends GetView<LoginController> {
  final LoginController _accountController = Get.put(LoginController());

  // final GeneralSettingsController _settingsController =
  //     Get.put(GeneralSettingsController());

  final GeneralSettingsController _settingsController = Get.find();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: Get.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConfig.loginScreenBackgroundGradient1,
                AppConfig.loginScreenBackgroundGradient2,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10.w),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16.w,
                          ),
                        ),
                      ),
                    ],
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
                    AppConfig.appName.toUpperCase(),
                    style: AppStyles.kFontWhite14w5.copyWith(
                      fontSize: 25.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Register'.tr,
                      style: AppStyles.kFontWhite14w5.copyWith(
                        fontSize: 20.fontSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              controller: _accountController.firstName,
                              decoration: InputDecoration(
                                hintText: 'First Name'.tr,
                                hintStyle: AppStyles.kFontWhite14w5,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                errorStyle: AppStyles.kFontWhite12w5.copyWith(
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.kFontWhite14w5
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              validator: (value) {
                                if (value?.length == 0) {
                                  return 'Please Type first name'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              controller: _accountController.lastName,
                              decoration: InputDecoration(
                                hintText: 'Last Name'.tr,
                                hintStyle: AppStyles.kFontWhite14w5,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                errorStyle: AppStyles.kFontWhite12w5.copyWith(
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.kFontWhite14w5
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              validator: (value) {
                                if (value?.length == 0) {
                                  return 'Please Type last name'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: TextFormField(
                      controller: _accountController.registerEmail,
                      decoration: InputDecoration(
                        hintText: 'Email or Phone Number'.tr,
                        hintStyle: AppStyles.kFontWhite14w5,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter email or phone number'.tr;
                        }

                        // Check if it's a phone number
                        String digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                        bool isPhone = digits.length == 10;

                        // Check if it's an email
                        bool isEmail = (value ?? '').contains('@');

                        // If it's neither phone nor email, show error
                        if (!isPhone && !isEmail) {
                          return 'Please enter a valid email or 10 digit phone number'.tr;
                        }

                        // If it looks like an email but doesn't have dot
                        if (isEmail && !(value ?? '').contains('.')) {
                          return 'Please enter a valid email'.tr;
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: TextFormField(
                      controller: _accountController.registerPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password'.tr,
                        hintStyle: AppStyles.kFontWhite14w5,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        if (value?.length == 0) {
                          return 'Please Type password'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: TextFormField(
                      controller: _accountController.registerConfirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password'.tr,
                        hintStyle: AppStyles.kFontWhite14w5,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        if (value?.length == 0) {
                          return 'Please Type confirm password'.tr;
                        } else if (controller.registerPassword.text != value) {
                          return 'Password must be the same'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: TextFormField(
                      controller: _accountController.referralCode,
                      decoration: InputDecoration(
                        hintText: "${'Referral code'.tr} (${"Optional".tr})",
                        hintStyle: AppStyles.kFontWhite14w5,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _accountController.isLoading.value
                        ? Center(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                child: CupertinoActivityIndicator()))
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map registrationData = {
                                    "first_name": controller.firstName.text,
                                    "last_name": controller.lastName.text,
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

                                  log("_settingsController.otpOnCustomerRegistration.value ::: ${_settingsController.otpOnCustomerRegistration.value}");
                                  if (_settingsController.otpOnCustomerRegistration.value) {

                                    Map data = {
                                      "type": "otp_on_customer_registration",
                                      "login": controller.registerEmail.text,
                                      "first_name": controller.firstName.text,
                                    };

                                    final OtpController otpController = Get.put(OtpController());

                                    _accountController.isLoading.value = true;

                                    await otpController.generateOtp(data).then((value) {
                                      if (value == true) {
                                        _accountController.isLoading.value = false;
                                        Get.to(() => OtpVerificationPage(
                                              data: data,
                                              onSuccess: (result) async {
                                                if (result == true) {
                                                  log("After OTP completed :::::: ");
                                                  await _accountController.registerUser(registrationData);
                                                }
                                              },
                                            ));
                                      } else {
                                        _accountController.isLoading.value = false;
                                        SnackBars().snackBarWarning(value.toString());
                                      }
                                    });
                                  }
                                  else {
                                    await _accountController.registerUser(registrationData);
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: Get.width,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Sign Up'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppStyles.kFontPink15w5),
                                ),
                              ),
                            ),
                          ),
                  ),
                  // GestureDetector(
                  //   onTap: () => Get.to(() => ForgotPasswordPage()),
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 10),
                  //     child: Text(
                  //       'Forgot password'.tr + '?',
                  //       style: AppStyles.kFontWhite14w5,
                  //     ),
                  //   ),
                  // ),
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
