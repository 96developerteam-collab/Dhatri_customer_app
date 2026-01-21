import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/cart/CartMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartIconWidget extends StatelessWidget {
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CartMain(false));
      },
      child: Container(
        width: 60.w,
        height: 80.h,
        // color: Colors.blue,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/icon_cart_grey.png',
                width: 30.w,
                height: 30.w,
                color: Colors.black,
              ),
            ),
            Positioned(
              right: 4.w,
              top: 4.h,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppStyles.pinkColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Obx(() {
                    if (cartController.isLoading.value) {
                      return Container();
                    }
                    return Text(
                      '${cartController.cartListSelectedCount.value}',
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontWhite12w5,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
