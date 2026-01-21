import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsListTileWidget extends StatelessWidget {
  SettingsListTileWidget({this.titleText, this.subtitleText, this.changeOnTap});

  final String? titleText;
  final String? subtitleText;
  final VoidCallback? changeOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      isThreeLine: subtitleText != null,
      title: Text(
        titleText ?? '',
        style: AppStyles.appFont.copyWith(
          color: Colors.black,
          fontSize: 15.fontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: subtitleText != null ? Text(
        subtitleText!,
        style: AppStyles.appFont.copyWith(
          color: Colors.black,
          fontSize: 13.fontSize,
          fontWeight: FontWeight.w400,
        ),
      ) : null,
      trailing: SizedBox(
        height: 70.h,
        child: InkWell(
          onTap: changeOnTap,
          child: Padding(
            padding:  EdgeInsets.only(top: 15.0.h),
            child: Text(
              'Change'.tr,
              textAlign: TextAlign.center,
              style: AppStyles.appFont.copyWith(
                color: AppStyles.lightBlueColor,
                fontSize: 13.fontSize,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
