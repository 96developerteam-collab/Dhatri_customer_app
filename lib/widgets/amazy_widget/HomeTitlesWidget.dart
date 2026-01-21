import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:get/get.dart';

class HomeTitlesWidget extends StatelessWidget {
  final VoidCallback? btnOnTap;
  final String? title;
  final bool? showDeal;
  final Duration? dealDuration;
  final int? endTime;

  HomeTitlesWidget({
    this.btnOnTap,
    this.title,
    this.showDeal,
    this.dealDuration,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 20.h),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: btnOnTap,
            child: Row(
              children: [
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFontBold.copyWith(
                    fontSize: 18.fontSize,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                showDeal!
                    ? Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                      gradient: AppStyles.gradient,
                      borderRadius: BorderRadius.circular(5.r)),
                  child: SlideCountdownClock(
                    duration: dealDuration??Duration(seconds: 1),
                    slideDirection: SlideDirection.up,
                    padding: EdgeInsets.all(0),
                    textStyle:AppStyles.appFontLight.copyWith(
                          color: Colors.white,
                          fontSize: 12.fontSize
                        ),

                    shouldShowDays: true,
                    tightLabel: true,

                    // widgetBuilder: (_, CurrentRemainingTime? time) {
                    //   return Text(
                    //     '${time?.days}d-${time?.hours}h-${time?.min}m-${time?.sec}s',
                    //     style: AppStyles.appFontLight.copyWith(
                    //       color: Colors.white,
                    //     ),
                    //   );
                    // },
                  ),
                )
                    : SizedBox.shrink(),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Show All'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.appFontLight
                          .copyWith(color: AppStyles.pinkColor, fontSize: 12.fontSize),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.w,
                      color: AppStyles.pinkColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
