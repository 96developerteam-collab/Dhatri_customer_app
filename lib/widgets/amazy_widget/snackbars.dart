import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SnackBars {
  SnackbarController snackBarSuccess(message) {
    return Get.snackbar(
      'Success'.tr,
      "$message".tr.capitalizeFirst ?? '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      messageText: Text(
        "$message".tr.capitalizeFirst ?? '',
        style: AppStyles.kFontWhite12w5,
      ),
      titleText: Text(
        'Success'.tr,
        style: AppStyles.kFontWhite14w5,
      ),
      borderRadius: 5.r,
      duration: Duration(seconds: 2),
    );
  }

  SnackbarController snackBarSuccessBottom(message) {
    return Get.snackbar(
      'Success'.tr,
      "$message".tr.capitalizeFirst ?? '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      messageText: Text(
        "$message".tr.capitalizeFirst ?? '',
        style: AppStyles.kFontWhite12w5,
      ),
      titleText: Text(
        'Success'.tr,
        style: AppStyles.kFontWhite14w5,
      ),
      borderRadius: 5.r,
      duration: Duration(seconds: 2),
    );
  }

  SnackbarController snackBarError(message) {
    return Get.snackbar(
      'Error'.tr,
      "$message".tr.capitalizeFirst ?? '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      messageText: Text(
        "$message".tr.capitalizeFirst ?? '',
        style: AppStyles.kFontWhite12w5,
      ),
      titleText: Text(
        'Error'.tr,
        style: AppStyles.kFontWhite14w5,
      ),
      borderRadius: 5.r,
      duration: Duration(seconds: 2),
    );
  }

  SnackbarController snackBarWarning(message) {
    return Get.snackbar(
      'Warning'.tr,
      "$message".tr.capitalizeFirst ?? '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      messageText: Text(
        "$message".tr.capitalizeFirst ?? '',
        style: AppStyles.kFontWhite12w5,
      ),
      titleText: Text(
        'Warning'.tr,
        style: AppStyles.kFontWhite14w5,
      ),
      borderRadius: 5.r,
      duration: Duration(seconds: 2),
    );
  }
}
