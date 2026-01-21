import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/styles.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key, this.onBack, this.shapeBorder, this.color});
  final Function()? onBack;
  final ShapeBorder? shapeBorder;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        customBorder: shapeBorder??CircleBorder(),
        onTap: () {
          if(onBack == null) {
            Get.back();
          }else{
            onBack!();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: Platform.isIOS ? 5.w : 0),
          child: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back_outlined,
            color: color??Colors.black,
            size: 18.w,
          ),
        ),
      ),
    );
  }
}
