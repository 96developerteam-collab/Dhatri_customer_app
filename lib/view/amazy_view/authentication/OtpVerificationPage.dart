import 'dart:async';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationPage extends StatefulWidget {
  final Function(bool)? onSuccess;
  final Map? data;

  OtpVerificationPage({this.data, this.onSuccess});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final OtpController _otpController = Get.put(OtpController());
  final GeneralSettingsController _settingsController = Get.put(GeneralSettingsController());

  String? enteredOtp;
  bool timedOut = false;
  late int _validationTime;
  late Timer _timer;
  int _currentSeconds = 0;

  @override
  void initState() {
    super.initState();
    _validationTime = _settingsController.otpCodeValidationTime.value * 60;
    _currentSeconds = _validationTime;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds == 0) {
        setState(() {
          timedOut = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _currentSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: SafeArea(
        child: Stack(
          children: [
            // Bottom Leaf Graphic
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  AppConfig.appLogo,
                  width: 100.w,
                  height: 100.w,
                  color: const Color(0xFF1A330F),
                ),
              ),
            ),
            
            Column(
              children: [
                // Custom Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back, color: const Color(0xFF1A330F), size: 26.w),
                      ),
                      const Spacer(),
                      Text(
                        AppConfig.appName,
                        style: AppStyles.appFontBold.copyWith(
                          fontSize: 24.sp,
                          color: const Color(0xFF1A330F),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 40.w), // To balance the back button
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Circular Logo Placeholder
                            Container(
                              padding: EdgeInsets.all(15.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF9F9F5),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                AppConfig.appLogo,
                                width: 80.w,
                                height: 80.w,
                              ),
                            ),
                            
                            SizedBox(height: 30.h),
                            
                            Text(
                              'Verification Code'.tr,
                              style: AppStyles.appFontBold.copyWith(
                                fontSize: 24.sp,
                                color: const Color(0xFF1A330F),
                              ),
                            ),
                            
                            SizedBox(height: 15.h),
                            
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'We sent a 6-digit code to your phone number. Please check and enter your code.'.tr,
                                textAlign: TextAlign.center,
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 40.h),
                            
                            // Pin Code Fields
                            PinCodeTextField(
                              appContext: context,
                              length: 6,
                              animationType: AnimationType.fade,
                              keyboardType: TextInputType.number,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10.r),
                                fieldHeight: 55.w,
                                fieldWidth: 45.w,
                                activeFillColor: Colors.white,
                                inactiveFillColor: const Color(0xFFF9F9F5),
                                selectedFillColor: Colors.white,
                                activeColor: const Color(0xFF698F34),
                                inactiveColor: Colors.grey[300],
                                selectedColor: const Color(0xFF698F34),
                                borderWidth: 1,
                              ),
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              onChanged: (value) => enteredOtp = value,
                            ),
                            
                            SizedBox(height: 40.h),
                            
                            // Verify Button
                            InkWell(
                              onTap: () => _handleVerify(),
                              child: Container(
                                width: double.infinity,
                                height: 55.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D5019),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Text(
                                  "Verify & Proceed".tr,
                                  style: AppStyles.appFontBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 30.h),
                            
                            // Resend Section
                            GestureDetector(
                              onTap: timedOut ? () => _handleResend() : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't receive code? ".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    'Resend OTP'.tr,
                                    style: AppStyles.appFontBold.copyWith(
                                      color: timedOut ? const Color(0xFF2D5019) : Colors.grey[400],
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 20.h),
                            
                            // Timer Badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer_outlined, size: 16.w, color: const Color(0xFF2D5019)),
                                  SizedBox(width: 8.w),
                                  Text(
                                    timedOut ? "Code Expired".tr : "Resend in ".tr + _formatTime(_currentSeconds),
                                    style: AppStyles.appFontBold.copyWith(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF2D5019),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleVerify() {
    if (enteredOtp == null || enteredOtp!.length < 6) {
      SnackBars().snackBarWarning("Please enter 6-digit OTP".tr);
      return;
    }
    
    if (timedOut) {
      SnackBars().snackBarWarning("OTP Timed out. Please resend OTP".tr);
      return;
    }

    bool isCorrectOTP = _otpController.resultChecker(int.parse(enteredOtp!));
    if (isCorrectOTP) {
      Get.back(result: widget.onSuccess!(true));
    } else {
      SnackBars().snackBarWarning("OTP does not match".tr);
    }
  }

  void _handleResend() async {
    setState(() {
      timedOut = false;
      _currentSeconds = _validationTime;
    });
    startTimer();
    
    var value = await _otpController.generateOtp(widget.data!);
    if (value == true) {
      SnackBars().snackBarSuccess("OTP Resent successfully".tr);
    } else {
      SnackBars().snackBarError(value is String ? value : "Failed to resend OTP".tr);
    }
  }
}
