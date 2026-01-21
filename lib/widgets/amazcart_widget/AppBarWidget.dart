import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  AppBarWidget({this.title});

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: false,
      toolbarHeight: 60.h,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text(
        widget.title ?? '',
        style: AppStyles.appFont.copyWith(
          fontWeight: FontWeight.bold,
          color: AppStyles.blackColor,
          fontSize: 17.fontSize,
        ),
      ),
      leading: AppBarBackButton(),
    );
  }
}
