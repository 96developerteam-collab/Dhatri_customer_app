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

      body: Column(
        children: [

          5.verticalSpace,
          Obx(() =>
          orderController.isOrderLoading.value ? Center(
            child: CustomLoadingWidget(),
          ) :
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(orderController.tabData.length, (index) {

                  log(orderController.tabData[index].name??'');
                  return GestureDetector(
                    onTap: () => orderController.onTabSelected(index),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            orderController.tabData[index].name?.tr ?? '',
                            style: orderController.selectedIndex == index
                                ? AppStyles.appFontBook.copyWith(fontSize: 12.fontSize)
                                : AppStyles.appFontBook.copyWith(
                              fontSize: 12.fontSize,
                              color: AppStyles.greyColorLight,
                            ),
                          ),
                        ),
                        if (orderController.selectedIndex == index)
                          Container(
                            width: 20.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                                color: AppStyles.pinkColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    topRight: Radius.circular(5.r))),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              Container(
                width: Get.width,
                height: 1,
                color: AppStyles.pinkColor.withOpacity(0.3),
              )
            ],
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
                        return Divider(
                          color: AppStyles.appBackgroundColor,
                          height: 5,
                          thickness: 5,
                        );
                      },
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
    );
  }
}
