import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomInputBorder {
  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.textFieldFillColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.textFieldFillColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.textFieldFillColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      hintText: 'Search in'.tr + " " + '$hintText' + '...',
      hintMaxLines: 1,
      hintStyle: AppStyles.appFont.copyWith(
        fontSize: 12.0.fontSize,
        color: AppStyles.greyColorDark,
      ),
    );
  }
}
