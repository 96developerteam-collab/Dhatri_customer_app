import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../controller/order_controller.dart';
import '../../../../../model/NewModel/Order/OrderData.dart';
import '../../../../../utils/styles.dart';
import '../../../../../widgets/amazy_widget/custom_loading_widget.dart';
import 'widgets/NoOrderPlacedWidget.dart';
import 'widgets/OrderListDataWidget.dart';

class AllOrdersListScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    orderController.getAllOrders();

    return Obx(
          () {
        if (orderController.isAllOrderLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (orderController.allOrderListModel.value.orders == null ||
              orderController.allOrderListModel.value.orders?.length == 0) {
            return NoOrderPlacedWidget();
          }
          return Container(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 5.h,
                  thickness: 5,
                );
              },
              itemCount: orderController.allOrderListModel.value.orders?.length ?? 0,
              itemBuilder: (context, index) {
                OrderData order = orderController.allOrderListModel.value.orders![index];
                return OrderAllToPayListDataWidget(
                  order: order,
                );
              },
            ),
          );
        }
      },
    );
  }
}
