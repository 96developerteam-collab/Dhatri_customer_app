import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetTile extends StatelessWidget {
  final String? title;
  final String? value;
  final Color? color;
  final bool hasMultipleData;
  final Widget? listview;
  final double? width;
  final double? height;
  final TextStyle? titleTextStyle;
  final TextStyle? valueTextStyle;

  const BottomSheetTile({
    super.key,
    this.title,
    this.value,
    this.color,
    this.hasMultipleData = false,
    this.listview,
    this.width,
    this.height,
    this.titleTextStyle,
    this.valueTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.04,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFF2F0F6),
        ),
        color: color,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: width ?? Get.width * 0.31,
            child: Text(
              title ?? "",
              style: titleTextStyle ?? TextStyle(
                color: Color(0xFF412C56),
                fontSize: 10.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          VerticalDivider(
            color: const Color(0xFF635976).withOpacity(0.1),
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(
              value ?? "",
              style: valueTextStyle ?? TextStyle(
                  color: Color(0xFF635976),
                  fontSize: 10.fontSize,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}