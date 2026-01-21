import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../AppConfig/app_config.dart';
import '../../../../../../../../utils/styles.dart';
import '../../../../../MainNavigation.dart';
import 'order_list_cart_icon_widget.dart';

// class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {


//   @override
//   _AppBarWidgetState createState() => _AppBarWidgetState();


// }

class OrderListAppBarWidget extends StatelessWidget implements PreferredSizeWidget  {

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? 60 : 100);

  final String? title;
  final PreferredSizeWidget? bottom;
  final bool? showCart;
  OrderListAppBarWidget({
    this.title,
    this.bottom,
    this.showCart = true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title!,
        style: AppStyles.appFontMedium.copyWith(
          fontSize: 16.fontSize,
          color: Colors.black,
        ),
      ),
      actions: [
        showCart! ?  OrderListCartIconWidget(
          isSliver: false,
        ) : SizedBox.shrink(),
      ],
      leading: AppBarBackButton(
        onBack: (){
      {
            if(AppConfig.isPasswordChange){
              Get.to(MainNavigation());
              AppConfig.isPasswordChange = false;
            }
            else{
              Get.back();
            }

          }
        },
      ),
    );
  }
}
