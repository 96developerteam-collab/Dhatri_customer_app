import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../config/config.dart';
import '../../../database/auth_database.dart';
import 'ForgotPassword.dart';
import 'RegistrationPage.dart';
// ignore: must_be_immutable
class LoginPage extends GetView<LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _googleSignIn = GoogleSignIn();

  final LoginController _loginController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  // ignore: unused_field
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;

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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
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
                            padding: EdgeInsets.only(left: 10.h),
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 25.w,
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
                          'Sign In'.tr,
                          style: AppStyles.kFontWhite14w5.copyWith(
                            fontSize: 20.fontSize,
                          ),
                        ),
                      ),

                      // Toggle between Email and Phone Login
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _loginController.toggleLoginMode(false),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: !_loginController.isPhoneLogin.value
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Email'.tr,
                                  style: TextStyle(
                                    color: !_loginController.isPhoneLogin.value
                                        ? AppStyles.darkBlueColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.fontSize,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () => _loginController.toggleLoginMode(true),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: _loginController.isPhoneLogin.value
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Phone'.tr,
                                  style: TextStyle(
                                    color: _loginController.isPhoneLogin.value
                                        ? AppStyles.darkBlueColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.fontSize,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),

                      5.verticalSpace,

                      if (AppConfig.isDemo)
                        InkWell(
                          onTap: () {
                            controller.email.text = "customer@gmail.com";
                            controller.password.text = "12345678";
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5.r))),
                            child: Text('Customer Login'.tr,
                                textAlign: TextAlign.center,
                                style: AppStyles.kFontPink15w5),
                          ),
                        ),

                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                        child: Obx(() => TextFormField(
                          controller: _loginController.email,
                          decoration: InputDecoration(
                            hintText: _loginController.isPhoneLogin.value
                                ? 'Enter Your Phone Number'.tr
                                : 'Enter Your Email'.tr,
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
                                color: AppStyles.darkBlueColor,
                              ),
                            ),
                            errorStyle: AppStyles.kFontDarkBlue12w5,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            suffixIcon: Icon(
                              _loginController.isPhoneLogin.value
                                  ? Icons.phone_outlined
                                  : Icons.mail_outline_rounded,
                              size: 16.w,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          keyboardType: _loginController.isPhoneLogin.value
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                          style: AppStyles.kFontWhite14w5,
                          maxLines: 1,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return _loginController.isPhoneLogin.value
                                  ? 'Please enter your phone number'.tr
                                  : 'Please enter your email'.tr;
                            }
                            if (_loginController.isPhoneLogin.value) {
                              String digits = value.replaceAll(RegExp(r'\D'), '');
                              if (digits.length != 10) {
                                return 'Phone number must be 10 digits'.tr;
                              }
                            } else {
                              if (!value.contains('@')) {
                                return 'Please enter a valid email'.tr;
                              }
                            }
                            return null;
                          },
                        )),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                        child: TextFormField(
                          controller: _loginController.password,
                          obscureText: _loginController.isPasswordHidden.value,
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
                                color: AppStyles.darkBlueColor,
                              ),
                            ),
                            errorStyle: AppStyles.kFontDarkBlue12w5,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _loginController.isPasswordHidden.value =
                                    !_loginController.isPasswordHidden.value;
                              },
                              child: Icon(
                                _loginController.isPasswordHidden.value
                                    ? Icons.lock
                                    : Icons.lock_open,
                                size: 16.w,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          style: AppStyles.kFontWhite14w5,
                          maxLines: 1,
                          validator: (value) {
                            if (value?.length == 0) {
                              return 'Please Type your password'.tr + '...';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: _loginController.isLoading.value
                            ? Center(
                                child: Container(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 20.h),
                                    child: CupertinoActivityIndicator()))
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 5.h),
                                child: InkWell(
                                  onTap: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    } else {
                                      if (_settingsController.otpOnLogin.value) {
                                        Map data = {
                                          "type": "otp_on_login",
                                          "email":
                                              _loginController.email.value.text,
                                        };

                                        final OtpController otpController =
                                            Get.put(OtpController());

                                        _loginController.isLoading.value = true;

                                        await otpController
                                            .generateOtp(data)
                                            .then((value) {
                                          if (value == true) {
                                            _loginController.isLoading.value =
                                                false;
                                            Get.to(() => OtpVerificationPage(
                                                  data: data,
                                                  onSuccess: (result) async {
                                                    if (result == true) {
                                                      var jsonString =
                                                          await _loginController
                                                              .fetchUserLogin(
                                                                  emailOrPhone:
                                                                      _loginController
                                                                          .email
                                                                          .text,
                                                                  password:
                                                                      _loginController
                                                                          .password
                                                                          .text)
                                                              .then((value) {
                                                        if (value == true) {
                                                          Get.back();
                                                        }
                                                      });
                                                      print(jsonString);
                                                    }
                                                  },
                                                ));
                                          } else {
                                            _loginController.isLoading.value =
                                                false;
                                            SnackBars()
                                                .snackBarWarning(value.toString());
                                          }
                                        });
                                      } else {
                                        var jsonString = await _loginController
                                            .fetchUserLogin(
                                                emailOrPhone: _loginController.email.text,
                                                password:
                                                    _loginController.password.text)
                                            .then((value) {
                                          if (value == true) {
                                            Get.back();
                                          }
                                        });
                                        print(jsonString);
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
                                            BorderRadius.all(Radius.circular(5.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Sign In'.tr,
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontPink15w5),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Forget url: ${URLs.FORGOT_PASSWORD}');
                          Get.to(() => ForgotPasswordPage());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          child: Text(
                            'Forgot password?'.tr,
                            style: AppStyles.kFontWhite14w5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(RegistrationPage(), useSafeArea: false);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Don't have an account Yet?".tr,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.appFont.copyWith(
                                      color: Colors.white,
                                      fontSize: 14.fontSize,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Up'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.appFont.copyWith(
                                      color: Colors.white,
                                      fontSize: 14.fontSize,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      AppConfig.facebookLogin || AppConfig.googleLogin
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: Get.width * 0.25,
                                  child: Divider(
                                    height: 0.5,
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Or continue with".tr,
                                  style: AppStyles.kFontWhite12w5,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Container(
                                  width: Get.width * 0.25,
                                  child: Divider(
                                    height: 0.5,
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppConfig.facebookLogin
                              ? InkWell(
                                  onTap: () async {
                                    final LoginResult result = await FacebookAuth
                                        .instance
                                        .login(); // by default we request the email and the public profile
                                    if (result.status == LoginStatus.success) {
                                      _accessToken = result.accessToken!;

                                      final userData =
                                          await FacebookAuth.instance.getUserData();
                                      _userData = userData;

                                      final _getToken = FacebookResponse.fromJson(
                                        _accessToken!.toJson(),
                                      );

                                      final _getUser =
                                          FacebookUser.fromJson(userData);

                                      Map data = {
                                        "provider_id": _getUser.id,
                                        "provider_name": "facebook",
                                        "name": _getUser.name,
                                        "email": _getUser.email,
                                        "token": _getToken.token.toString(),
                                        "device_token" : AuthDatabase.instance.getDeviceUniqueId()
                                      };

                                      print(data);

                                      await _loginController
                                          .socialLogin(data)
                                          .then((value) async {
                                        if (value == true) {
                                          Get.back();
                                        } else {
                                          await FacebookAuth.instance.logOut();
                                        }
                                      });
                                    } else {
                                      print(result.status);
                                      print(result.message);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          width: 50.w,
                                          height: 50.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50.w,
                                        height: 50.w,
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/images/facebook_logo.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(
                            width: 20.w,
                          ),
                          AppConfig.googleLogin
                              ? InkWell(
                                  onTap: () async {
                                    try {
                                      GoogleSignInAccount? googleSignInAccount =
                                          await _googleSignIn.signIn();

                                      log("googleSignInAccount :: ${googleSignInAccount}");

                                      await googleSignInAccount!.authentication
                                          .then((value) async {
                                        log("value :: ${value.accessToken}");

                                        Map data = {
                                          "provider_id": googleSignInAccount.id,
                                          "provider_name": "google",
                                          "name": googleSignInAccount.displayName,
                                          "email": googleSignInAccount.email,
                                          "token": value.accessToken.toString(),
                                          "device_token" : AuthDatabase.instance.getDeviceUniqueId()
                                        };

                                        await _loginController
                                            .socialLogin(data)
                                            .then((value) {
                                          if (value == true) {
                                            Get.back();
                                          } else {
                                            _googleSignIn.signOut();
                                          }
                                        });
                                      });
                                    } catch (e, t) {
                                      debugPrint(e.toString());
                                      debugPrint(t.toString());
                                    }

                                    // await _googleSignIn.signOut().then((value) {
                                    //   log(value.authHeaders.toString());
                                    // });
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          width: 50.w,
                                          height: 50.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50.w,
                                        height: 50.w,
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/images/google_logo.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ],
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

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

FacebookResponse facebookResponseFromJson(String str) =>
    FacebookResponse.fromJson(json.decode(str));

String facebookResponseToJson(FacebookResponse data) =>
    json.encode(data.toJson());

class FacebookResponse {
  FacebookResponse({
    required this.userId,
    required this.token,
  });

  String userId;
  String token;

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      FacebookResponse(
        userId: json["userId"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}

FacebookUser facebookUserFromJson(String str) =>
    FacebookUser.fromJson(json.decode(str));

String facebookUserToJson(FacebookUser data) => json.encode(data.toJson());

class FacebookUser {
  FacebookUser({
    required this.email,
    required this.id,
    required this.name,
  });

  String email;
  String id;
  String name;

  factory FacebookUser.fromJson(Map<String, dynamic> json) => FacebookUser(
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
      };
}
