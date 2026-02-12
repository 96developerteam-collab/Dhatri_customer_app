import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../../controller/order_controller.dart';
import '../../../../../../model/NewModel/Order/OrderData.dart';
import '../../../../../../utils/styles.dart';
import '../../../../../../widgets/amazy_widget/AppBarWidget.dart' show AppBarWidget;
import '../../../../../../widgets/amazy_widget/custom_loading_widget.dart';
import '../../OrderList/widgets/NoOrderPlacedWidget.dart';
import '../../OrderList/widgets/OrderListDataWidget.dart';



class DynamicOrderListTabs extends StatefulWidget {
  @override
  _DynamicOrderListTabsState createState() => _DynamicOrderListTabsState();
}

class _DynamicOrderListTabsState extends State<DynamicOrderListTabs> {
  // List<dynamic> _tabData = [];
  // bool _isLoading = true;
  // int _selectedIndex = 0;

  final OrderController orderController = Get.put(OrderController());

  // @override
  // void initState() {
  //   super.initState();
  //   fetchTabData();
  //   orderController.getAllOrders();
  // }

  // Future<void> fetchTabData() async {
  //   final response = await http.get(Uri.parse(
  //       'https://spn4.pixelcoder.net/amazcart/v4.1/api/delivery-processes'));
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _tabData = json.decode(response.body)['data'];
  //       _isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load tab data');
  //   }
  // }

  // void _onTabSelected(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (orderController.isOrderLoading.value) {
    //   return Center(
    //     child: CustomLoadingWidget(),
    //   );
    // }

    return Scaffold(
      appBar: AppBarWidget(
        title: "My Orders".tr,
      ),
      // body: Center(
      //   child: Text('Selected Tab ID: ${_tabData[_selectedIndex]['id']}'),
      // ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Light green
              Color(0xFFF1F8F4), // Greenish-white
              Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: Column(
          children: [
            5.verticalSpace,
            Obx(() =>
            orderController.isOrderLoading.value ? Center(
              child: CustomLoadingWidget(),
            ) :
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4CAF50).withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(orderController.tabData.length, (index) {

                        log(orderController.tabData[index].name??'');
                        return GestureDetector(
                          onTap: () => orderController.onTabSelected(index),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: orderController.selectedIndex == index
                                  ? Color(0xFF4CAF50).withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  orderController.tabData[index].name?.tr ?? '',
                                  style: orderController.selectedIndex == index
                                      ? AppStyles.appFontBold.copyWith(
                                          fontSize: 13.fontSize,
                                          color: Color(0xFF4CAF50),
                                        )
                                      : AppStyles.appFontBook.copyWith(
                                    fontSize: 12.fontSize,
                                    color: AppStyles.greyColorDark,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                if (orderController.selectedIndex == index)
                                  Container(
                                    width: 24.w,
                                    height: 3.h,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                        ),
                                        borderRadius: BorderRadius.circular(2.r)),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF4CAF50).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )

            ),


            5.verticalSpace,
            Expanded(
              child: Obx(
                    () {
                  if (orderController.isAllOrderLoading.value) {
                    return Center(
                      child: CustomLoadingWidget(),
                    );
                  } else {
                    if (orderController.allOrderListModel.value.orders == null ||
                        orderController.allOrderListModel.value.orders!.length == 0) {
                      return Center(child: NoOrderPlacedWidget());
                    }
                    return Container(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8.h);
                        },
                        padding: EdgeInsets.only(bottom: 16.h),
                        itemCount: orderController.allOrderListModel.value.orders!.length,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
