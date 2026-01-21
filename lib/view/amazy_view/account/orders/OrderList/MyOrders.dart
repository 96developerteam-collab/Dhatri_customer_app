import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/order_controller.dart';
import '../../../../../utils/styles.dart';
import '../../../../../widgets/amazy_widget/AppBarWidget.dart';
import 'AllOrdersList.dart';
import 'OrderToPayList.dart';
import 'OrderToReceiveList.dart';
import 'OrderToShipList.dart';

class MyOrders extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  final int tabIndex;

  MyOrders(this.tabIndex);

  @override
  Widget build(BuildContext context) {
    orderController.controller?.index = tabIndex;

    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        showCart: false,
        title: 'My Orders'.tr,
        bottom: TabBar(
          controller: orderController.controller,
          labelColor: AppStyles.blackColor,
          labelPadding: EdgeInsets.zero,
          tabs: orderController.tabs,
          indicatorColor: AppStyles.pinkColor,
          labelStyle: AppStyles.kFontWhite12w5,
          unselectedLabelColor: AppStyles.greyColorDark,

        ),
      ),
      body: TabBarView(
        controller: orderController.controller,
        children: [
          AllOrdersListScreen(),
          OrderToPayListScreen(),
          OrderToShipListScreen(),
          OrderToReceiveListScreen(),
        ],
      ),
    );
  }
}
