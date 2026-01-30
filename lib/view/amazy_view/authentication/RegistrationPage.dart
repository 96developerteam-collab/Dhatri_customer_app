import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
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
  final GeneralSettingsController _settingsController = Get.put(GeneralSettingsController());

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
                  SizedBox(height: 30.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10.w, top: 20.h),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppConfig.appLogo,
                        width: 33.w,
                        height: 33.w,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        AppConfig.appName,
                        style: AppStyles.appFontBold.copyWith(fontSize: 20.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Create an Account'.tr,
                    style: AppStyles.appFontBold.copyWith(fontSize: 22.sp),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Signup with your own active email and new password or login your account'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.appFontBook.copyWith(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // First Name
                  _buildTextField(
                    controller: _accountController.firstName,
                    hint: 'First Name'.tr + " *",
                    icon: Icons.person,
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Type First name'.tr : null,
                  ),

                  // Last Name
                  _buildTextField(
                    controller: _accountController.lastName,
                    hint: 'Last Name'.tr + " *",
                    icon: Icons.person,
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Type Last name'.tr : null,
                  ),

                  // Email / Phone
                  _buildTextField(
                    controller: _accountController.registerEmail,
                    hint: 'Email or Phone Number'.tr + " *",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter email or phone number'.tr;

                      String digits = value!.replaceAll(RegExp(r'\D'), '');
                      bool isPhone = digits.length == 10;
                      bool isEmail = value.contains('@') && value.contains('.');

                      if (!isPhone && !isEmail) {
                        return 'Please enter a valid email or 10 digit phone number'.tr;
                      }
                      return null;
                    },
                  ),

                  // Password
                  _buildTextField(
                    controller: _accountController.registerPassword,
                    hint: 'Password'.tr + " *",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => value?.isEmpty ?? true ? 'Please Type your password'.tr : null,
                  ),

                  // Confirm Password
                  _buildTextField(
                    controller: _accountController.registerConfirmPassword,
                    hint: 'Confirm Password'.tr + " *",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Type password again'.tr;
                      if (value != _accountController.registerPassword.text) {
                        return 'Password must be the same'.tr;
                      }
                      return null;
                    },
                  ),

                  // Referral Code (optional)
                  _buildTextField(
                    controller: _accountController.referralCode,
                    hint: 'Referral code (optional)'.tr,
                    icon: Icons.card_giftcard,
                    validator: (_) => null,
                  ),

                  // Store Name
                  _buildTextField(
                    controller: _accountController.storeName,
                    hint: 'Store Name'.tr + " *",
                    icon: Icons.store,
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Please enter store name'.tr : null,
                  ),

                  // Store Documents (PDF Picker)
                  _buildFilePickerField(
                    label: 'Store Documents (GST, MSME, STORE DOCS, COMPANY PAN)'.tr + " *",
                    file: _accountController.pickedDocument.value,
                    icon: Icons.description,
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                      );
                      if (result != null && result.files.single.path != null) {
                        File file = File(result.files.single.path!);
                        int sizeInBytes = await file.length();
                        double sizeInMb = sizeInBytes / (1024 * 1024);
                        if (sizeInMb > 5) {
                          SnackBars().snackBarWarning("File size should be less than 5MB".tr);
                        } else {
                          _accountController.pickedDocument.value = file;
                        }
                      }
                    },
                  ),

                  // Shop Image Picker
                  _buildFilePickerField(
                    label: 'SHOP Image'.tr + " *",
                    file: _accountController.pickedShopImage.value,
                    icon: Icons.image,
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        _accountController.pickedShopImage.value = File(image.path);
                      }
                    },
                  ),

                  SizedBox(height: 30.h),

                  // Sign Up Button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _accountController.isLoading.value
                        ? const Center(child: CupertinoActivityIndicator())
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            child: InkWell(
                              onTap: () async {
                                if (!_formKey.currentState!.validate()) return;

                                if (_accountController.pickedDocument.value == null) {
                                  SnackBars().snackBarWarning("Please upload Store Documents".tr);
                                  return;
                                }
                                if (_accountController.pickedShopImage.value == null) {
                                  SnackBars().snackBarWarning("Please upload Shop Image".tr);
                                  return;
                                }

                                Map<String, dynamic> data = {
                                  "first_name": _accountController.firstName.text.trim(),
                                  "last_name": _accountController.lastName.text.trim(),
                                  "login": _accountController.registerEmail.text.trim(),
                                  "referral_code": _accountController.referralCode.text.trim(),
                                  "store_name": _accountController.storeName.text.trim(),
                                  "password": _accountController.registerPassword.text,
                                  "password_confirmation": _accountController.registerConfirmPassword.text,
                                  "user_type": "customer",
                                  "device_token": AuthDatabase.instance.getDeviceUniqueId(),
                                };

                                if (_settingsController.otpOnCustomerRegistration.value) {
                                  // OTP flow...
                                  Map otpData = {
                                    "type": "otp_on_customer_registration",
                                    "login": _accountController.registerEmail.text.trim(),
                                    "first_name": _accountController.firstName.text.trim(),
                                  };

                                  final OtpController otpController = Get.put(OtpController());
                                  _accountController.isLoading.value = true;

                                  bool success = await otpController.generateOtp(otpData);
                                  _accountController.isLoading.value = false;

                                  if (success) {
                                    Get.to(() => OtpVerificationPage(
                                          data: otpData,
                                          onSuccess: (verified) async {
                                            if (verified == true) {
                                              await _accountController.registerUser(data);
                                            }
                                          },
                                        ));
                                  } else {
                                    SnackBars().snackBarWarning("OTP generation failed".tr);
                                  }
                                } else {
                                  await _accountController.registerUser(data);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 40.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: AppStyles.gradient,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Text(
                                  'Sign Up'.tr,
                                  style: AppStyles.appFontBook.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),

                  SizedBox(height: 16.h),

                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? '.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                color: AppStyles.greyColorLight,
                                fontSize: 16.sp,
                              ),
                            ),
                            TextSpan(
                              text: 'Login'.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                color: AppStyles.pinkColor,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Get.height * 0.07),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppStyles.appFontBook.copyWith(fontSize: 14.sp),
          prefixIcon: Container(
            height: 10.w,
            width: 10.w,
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: AppStyles.pinkColor, size: 22.w),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppStyles.pinkColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
          ),
          errorStyle: AppStyles.appFontMedium.copyWith(
            color: AppStyles.pinkColor,
            fontSize: 12.sp,
          ),
        ),
        style: AppStyles.appFontMedium.copyWith(fontSize: 15.sp),
        validator: validator,
      ),
    );
  }

  Widget _buildFilePickerField({
    required String label,
    required File? file,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: file == null ? label : null,
            labelStyle: AppStyles.appFontBook.copyWith(
              fontSize: 14.sp,
              color: file == null ? Colors.grey[600] : AppStyles.pinkColor,
            ),
            hintText: file != null ? file.path.split('/').last : null,
            hintStyle: AppStyles.appFontBook.copyWith(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
            prefixIcon: Container(
              height: 10.w,
              width: 10.w,
              padding: EdgeInsets.all(12),
              child: Icon(icon, color: AppStyles.pinkColor, size: 22.w),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppStyles.pinkColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
            errorStyle: AppStyles.appFontMedium.copyWith(
              color: AppStyles.pinkColor,
              fontSize: 12.sp,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          child: file != null
              ? Text(
                  file.path.split('/').last,
                  style: AppStyles.appFontBook.copyWith(fontSize: 14.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}