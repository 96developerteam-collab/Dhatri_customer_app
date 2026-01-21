import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:get/get.dart';

class HomeTitlesWidget extends StatelessWidget {
  final VoidCallback? btnOnTap;
  final String? title;
  final bool showDeal;
  final Duration? dealDuration;

  HomeTitlesWidget(
      {this.btnOnTap, this.title, this.showDeal = false, this.dealDuration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 20.h),
      child: Column(
        children: [
         2.verticalSpace,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: btnOnTap,
            child: Row(
              children: [
                Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: AppStyles.appFont.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                5.verticalSpace,
                showDeal != false
                    ? SlideCountdownClock(
                        duration: dealDuration ?? Duration(seconds: 1),
                        slideDirection: SlideDirection.up,
                        textStyle: AppStyles.appFont.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Color(0xff64086C),
                          shape: BoxShape.rectangle,
                        ),
                        onDone: () {},
                        tightLabel: true,
                        shouldShowDays: true,
                      )
                    : SizedBox.shrink(),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Shop more'.tr.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppStyles.appFont.copyWith(color: AppStyles.pinkColor, fontSize: 12.sp),
                    ),
                    2.horizontalSpace,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.w,
                      color: AppStyles.pinkColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          2.verticalSpace
        ],
      ),
    );
  }
}
