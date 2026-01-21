import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({this.buttonText, this.onTap, this.padding});
  final String? buttonText;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding,
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 50.h,
          decoration: BoxDecoration(
              gradient: AppStyles.gradient,
              borderRadius: BorderRadius.all(Radius.circular(5.0.r))),
          child: Text(
            buttonText!,
            style: AppStyles.appFontBook.copyWith(
              color: Colors.white,
              fontSize: 14.fontSize
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
