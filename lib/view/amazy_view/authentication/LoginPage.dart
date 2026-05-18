import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'RegistrationPage.dart';

class LoginPage extends GetView<LoginController> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _loginController = Get.put(LoginController());
  final GeneralSettingsController _settingsController = Get.put(GeneralSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (_settingsController.isLoading.value) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  
                  // Big Logo
                  Image.asset(
                    AppConfig.appLogo,
                    width: 140.w,
                    height: 140.w,
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  Text(
                    _settingsController.loginWithOtpOnly.value ? 'Login with OTP'.tr : 'Login Your Account'.tr,
                    style: AppStyles.appFontBold.copyWith(
                      fontSize: 28.sp,
                      color: const Color(0xFF1A330F),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Phone Number Field
                        _buildTextField(
                          controller: _loginController.email,
                          hint: 'Phone Number'.tr,
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter phone number'.tr;
                            String digits = value.replaceAll(RegExp(r'\D'), '');
                            if (digits.length < 10) return 'Please enter a valid phone number'.tr;
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Password Field
                        if (!_settingsController.loginWithOtpOnly.value)
                          _buildTextField(
                            controller: _loginController.password,
                            hint: 'Password'.tr,
                            icon: Icons.lock_outline,
                            obscureText: _loginController.isPasswordHidden.value,
                            suffixIcon: GestureDetector(
                              onTap: () => _loginController.isPasswordHidden.value = !_loginController.isPasswordHidden.value,
                              child: Icon(
                                _loginController.isPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.grey,
                                size: 22.w,
                              ),
                            ),
                            validator: (value) => value!.isEmpty ? 'Please Type your password'.tr : null,
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Login Button
                  _loginController.isLoading.value
                      ? const Center(child: CupertinoActivityIndicator())
                      : InkWell(
                          onTap: () => _handleLogin(),
                          child: Container(
                            width: double.infinity,
                            height: 55.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF698F34), // Darker green from logo leaf
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Login'.tr,
                              style: AppStyles.appFontBold.copyWith(
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                  
                  SizedBox(height: 30.h),
                  
                  // Sign Up Link
                  GestureDetector(
                    onTap: () => Get.dialog(RegistrationPage(), useSafeArea: false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account yet? ".tr,
                          style: AppStyles.appFontMedium.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          'Sign Up'.tr,
                          style: AppStyles.appFontBold.copyWith(
                            color: const Color(0xFF1A330F),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.appFontMedium.copyWith(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22.w),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF1A330F), width: 1.5),
        ),
      ),
      style: AppStyles.appFontMedium.copyWith(fontSize: 16.sp),
      validator: validator,
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final String phoneInput = _loginController.getLoginIdentifier();
    final OtpController otpController = Get.put(OtpController());

    // ── Case 2a: login_with_otp_only == 1 ──────────────────────────────────
    if (_settingsController.loginWithOtpOnly.value) {
      final Map data = {
        "type": "login_with_otp_only",
        "phone": phoneInput,
      };

      _loginController.isLoading.value = true;
      var result = await otpController.generateOtp(data);
      _loginController.isLoading.value = false;

      if (result == true) {
        Get.to(() => OtpVerificationPage(
              data: data,
              onSuccess: (verified, [code]) async {
                if (verified == true) {
                  // No password for OTP-only login
                  bool loginSuccess = await _loginController.fetchUserLogin(
                    emailOrPhone: phoneInput,
                    code: code,
                  );
                  if (loginSuccess) Get.back();
                }
              },
            ));
      } else {
        SnackBars().snackBarError(result is String ? result : "OTP generation failed".tr);
      }
      return;
    }

    // ── Case 2b: otp_on_login == 1 ─────────────────────────────────────────
    if (_settingsController.otpOnLogin.value) {
      final Map data = {
        "type": "otp_on_login",
        "phone": phoneInput,
      };

      _loginController.isLoading.value = true;
      var result = await otpController.generateOtp(data);
      _loginController.isLoading.value = false;

      if (result == true) {
        Get.to(() => OtpVerificationPage(
              data: data,
              onSuccess: (verified, [code]) async {
                if (verified == true) {
                  bool loginSuccess = await _loginController.fetchUserLogin(
                    emailOrPhone: phoneInput,
                    password: _loginController.password.text,
                    code: code,
                  );
                  if (loginSuccess) Get.back();
                }
              },
            ));
      } else {
        SnackBars().snackBarError(result is String ? result : "OTP generation failed".tr);
      }
      return;
    }

    // ── Case 2c: both == 0 → direct password login (skip OTP entirely) ─────
    bool loginSuccess = await _loginController.fetchUserLogin(
      emailOrPhone: phoneInput,
      password: _loginController.password.text,
    );
    if (loginSuccess) Get.back();
  }
}
