import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../../controller/cart_controller.dart';
import '../../../../../../../../controller/login_controller.dart';
import '../../../../../../../../utils/styles.dart';
import '../../../../../cart/CartMain.dart';

class OrderListCartIconWidget extends StatelessWidget {
  final Color color;
  final bool isSliver;
  OrderListCartIconWidget({
    this.color = Colors.black,
    this.isSliver = true,
  });
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CartMain(true));
      },
      child: Container(
        width: 50.w,
        height: 50.w,
        padding: EdgeInsets.only(right: 2.w),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/icon_cart_grey.png',
                width: 30.w,
                height: 30.w,
                color: isSliver ? Colors.white : AppStyles.pinkColor,
              ),
            ),
            _loginController.loggedIn.value
                ? Positioned(
              right: 2.w,
              top: 2.h,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: isSliver ? Colors.white : AppStyles.pinkColor,
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
                      style: AppStyles.appFontLight.copyWith(
                        fontSize: 10.fontSize,
                        color: isSliver ? Colors.black : Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
