// import 'dart:convert';
//
// import 'package:amazcart/config/config.dart';
// import 'package:amazcart/model/NewModel/Order/OrderListModel.dart';
// import 'package:amazcart/model/NewModel/Order/OrderToShipModel.dart';
// import 'package:amazcart/utils/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/NewModel/Order/OrderData.dart';
// import '../view/account/orders/new_order_module/model/tab_response_model.dart';
//
// class OrderController extends GetxController with GetSingleTickerProviderStateMixin {
//   // final OrderRefundListController orderRefundListController = Get.put(OrderRefundListController());
//
//   var isLoading = false.obs;
//
//   var isAllOrderLoading = false.obs;
//
//   var isPendingOrderLoading = false.obs;
//
//   var isToShipOrderLoading = false.obs;
//
//   var isToReceiveOrderLoading = false.obs;
//
//   var tabIndex = 0.obs;
//
//   TabController? controller;
//
//   var tokenKey = "token";
//   GetStorage userToken = GetStorage();
//
//   List<Tab> tabs = <Tab>[
//     Tab(
//       child: Text(
//         'All'.tr,
//         style: AppStyles.kFontBlack14w5,
//       ),
//     ),
//     Tab(
//       child: Text(
//         'To Pay'.tr,
//         style: AppStyles.kFontBlack14w5,
//       ),
//     ),
//     Tab(
//       child: Text(
//         'To Ship'.tr,
//         style: AppStyles.kFontBlack14w5,
//       ),
//     ),
//     Tab(
//       child: Text(
//         'To Receive'.tr,
//         style: AppStyles.kFontBlack14w5,
//       ),
//     ),
//   ];
//
//   var allOrderListModel = OrderListModel().obs;
//
//   var pendingOrderListModel = OrderListModel().obs;
//
//   var toShippedOrderListModel = OrderToShipModel().obs;
//
//   var toReceiveOrderListModel = OrderToShipModel().obs;
//
//
//
//
//
//
//   /// ......................................New Order Module Start.......................................................
//
//   List<TabData> tabData = [];
//   RxBool isOrderLoading = true.obs;
//   RxInt selectedIndex = 0.obs;
//   RxList<OrderData> newOrderList = <OrderData>[].obs;
//   int newOrderStatusId = 0;
//
//   void onTabSelected(int index) {
//
//     selectedIndex.value = index;
//
//     newOrderStatusId = tabData[selectedIndex.value].id ?? 0;
//     print('Order Status ::: $newOrderStatusId');
//     getAllOrdersByStatus(id: newOrderStatusId);
//
//   }
//
//   Future<void> fetchTabData() async {
//
//     try{
//       isOrderLoading.value = true;
//       final response = await http.get(Uri.parse(
//           URLs.ALL_ORDER_DELIVERY_PROCESS));
//
//       if (response.statusCode == 200) {
//
//         isOrderLoading.value = false;
//         var jsonString = jsonDecode(response.body);
//
//         TabResponseModel tabResponseModel = TabResponseModel.fromJson(jsonString);
//
//         if(tabResponseModel.data!.isNotEmpty){
//
//           for(int i = 0; i < tabResponseModel.data!.length; i++){
//             tabData.add(tabResponseModel.data![i]);
//           }
//           newOrderStatusId = tabData.first.id ?? 0;
//           print("Order Status ::: $newOrderStatusId");
//         }
//
//         // tabData = json.decode(response.body)['data'];
//
//
//       } else {
//         throw Exception('Failed to load tab data');
//       }
//     } catch(e, t){
//       isOrderLoading.value = false;
//       debugPrint('$e');
//       debugPrint('$t');
//     }finally{
//       isOrderLoading.value = false;
//     }
//
//   }
//
//   Future<OrderListModel?> getAllNewModuleOrder({required int id}) async {
//     String token = await userToken.read(tokenKey);
//
//     Uri userData = Uri.parse(URLs.ALL_ORDER_LIST_BY_STATUS(id: id));
//
//     var response = await http.get(
//       userData,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var jsonString = jsonDecode(response.body);
//     if (jsonString['message'] == 'success') {
//       return OrderListModel.fromJson(jsonString);
//     } else {
//       //show error message
//       return OrderListModel();
//     }
//   }
//
//   Future<OrderListModel?> getAllOrdersByStatus({required int id}) async {
//     try {
//       isAllOrderLoading(true);
//       // await orderRefundListController.getRefundReasons();
//       var products = await getAllNewModuleOrder(id: id);
//       if (products != null) {
//         allOrderListModel.value = products;
//         // allOrderListModel.value.orders.forEach((order) {
//         //   order.packages.forEach((package) {
//         //     package.refundReasons.addAll(orderRefundListController.refundReasons);
//         //   });
//         // });
//       }
//       return products;
//     } finally {
//       isAllOrderLoading(false);
//     }
//   }
//
//
//   /// ......................................New Order Module end.........................................................
//
//
//
//   Future<OrderListModel?> getAll() async {
//     String token = await userToken.read(tokenKey);
//
//     Uri userData = Uri.parse(URLs.ALL_ORDER_LIST);
//
//     var response = await http.get(
//       userData,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var jsonString = jsonDecode(response.body);
//     if (jsonString['message'] == 'success') {
//       return OrderListModel.fromJson(jsonString);
//     } else {
//       //show error message
//       return null;
//     }
//   }
//
//   Future<OrderListModel?> getAllOrders() async {
//     try {
//       isAllOrderLoading(true);
//       // await orderRefundListController.getRefundReasons();
//       // print(orderRefundListController.refundReasons);
//       var products = await getAll();
//       if (products != null) {
//         allOrderListModel.value = products;
//         // allOrderListModel.value.orders.forEach((order) {
//         //   order.packages.forEach((package) {
//         //     package.refundReasons.addAll(orderRefundListController.refundReasons);
//         //   });
//         // });
//       }
//       return products;
//     } finally {
//       isAllOrderLoading(false);
//     }
//   }
//
//   Future<OrderListModel?> getPending() async {
//     String token = await userToken.read(tokenKey);
//
//     Uri userData = Uri.parse(URLs.ALL_ORDER_PENDING_LIST);
//
//     var response = await http.get(
//       userData,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var jsonString = jsonDecode(response.body);
//     if (jsonString['message'] == 'success') {
//       return OrderListModel.fromJson(jsonString);
//     } else {
//       //show error message
//       return null;
//     }
//   }
//
//   Future<OrderListModel?> getPendingOrders() async {
//     try {
//       isPendingOrderLoading(true);
//       var products = await getPending();
//       if (products != null) {
//         pendingOrderListModel.value = products;
//       }
//       return products;
//     } finally {
//       isPendingOrderLoading(false);
//     }
//   }
//
//   Future<OrderToShipModel?> getToShipped() async {
//     String token = await userToken.read(tokenKey);
//
//     Uri userData = Uri.parse(URLs.ORDER_TO_SHIP);
//
//     var response = await http.get(
//       userData,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var jsonString = jsonDecode(response.body);
//     if (jsonString['message'] == 'success') {
//       return OrderToShipModel.fromJson(jsonString);
//     } else {
//       //show error message
//       return null;
//     }
//   }
//
//   Future<OrderToShipModel?> getToShipOrders() async {
//     try {
//       isToShipOrderLoading(true);
//       var products = await getToShipped();
//       if (products != null) {
//         print(products);
//         toShippedOrderListModel.value = products;
//       }
//       return products;
//     } finally {
//       isToShipOrderLoading(false);
//     }
//   }
//
//   Future<OrderToShipModel?> getToReceive() async {
//     String token = await userToken.read(tokenKey);
//
//     Uri userData = Uri.parse(URLs.ORDER_TO_RECEIVE);
//
//     var response = await http.get(
//       userData,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var jsonString = jsonDecode(response.body);
//     if (jsonString['message'] == 'success') {
//       return OrderToShipModel.fromJson(jsonString);
//     } else {
//       //show error message
//       return null;
//     }
//   }
//
//   Future<OrderToShipModel?> getToReceiveOrders() async {
//     try {
//       isToReceiveOrderLoading(true);
//       var products = await getToReceive();
//       if (products != null) {
//         toReceiveOrderListModel.value = products;
//       }
//       return products;
//     } finally {
//       isToReceiveOrderLoading(false);
//     }
//   }
//
//   @override
//   void onInit() {
//     controller = TabController(vsync: this, length: tabs.length);
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     controller?.dispose();
//     super.onClose();
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../model/NewModel/Order/OrderData.dart';
import '../model/NewModel/Order/OrderListModel.dart';
import '../model/NewModel/Order/OrderToShipModel.dart';
import '../utils/styles.dart';
import '../view/amazcart_view/account/orders/new_order_module/model/tab_response_model.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // final OrderRefundListController orderRefundListController = Get.put(OrderRefundListController());

  var isLoading = false.obs;

  var isAllOrderLoading = false.obs;

  var isPendingOrderLoading = false.obs;

  var isToShipOrderLoading = false.obs;

  var isToReceiveOrderLoading = false.obs;

  var tabIndex = 0.obs;

  TabController? controller;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        'All'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
    Tab(
      child: Text(
        'To Pay'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
    Tab(
      child: Text(
        'To Ship'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
    Tab(
      child: Text(
        'To Receive'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
  ];

  var allOrderListModel = OrderListModel().obs;

  var pendingOrderListModel = OrderListModel().obs;

  var toShippedOrderListModel = OrderToShipModel().obs;

  var toReceiveOrderListModel = OrderToShipModel().obs;

  /// ......................................New Order Module Start.......................................................

  List<TabData> tabData = [];
  RxBool isOrderLoading = true.obs;
  RxInt selectedIndex = 0.obs;
  RxList<OrderData> newOrderList = <OrderData>[].obs;
  int newOrderStatusId = 0;

  void onTabSelected(int index) {
    selectedIndex.value = index;

    newOrderStatusId = tabData[selectedIndex.value].id ?? 0;
    print('Order Status ::: $newOrderStatusId');
    getAllOrdersByStatus(id: newOrderStatusId);
  }

  Future<void> fetchTabData() async {
    try {
      isOrderLoading.value = true;
      final response =
          await http.get(Uri.parse(URLs.ALL_ORDER_DELIVERY_PROCESS + "?lang=${AppLocalizations.getLanguageCode()}"));

      if (response.statusCode == 200) {
        isOrderLoading.value = false;
        var jsonString = jsonDecode(response.body);

        TabResponseModel tabResponseModel =
            TabResponseModel.fromJson(jsonString);

        if (tabResponseModel.data!.isNotEmpty) {
          for (int i = 0; i < tabResponseModel.data!.length; i++) {
            tabData.add(tabResponseModel.data![i]);
          }
          newOrderStatusId = tabData.first.id ?? 0;
          print("Order Status ::: $newOrderStatusId");
        }

        // tabData = json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load tab data');
      }
    } catch (e, t) {
      isOrderLoading.value = false;
      debugPrint('$e');
      debugPrint('$t');
    } finally {
      isOrderLoading.value = false;
    }
  }

  Future<OrderListModel?> getAllNewModuleOrder({required int id}) async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ALL_ORDER_LIST_BY_STATUS(id: id));

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);

    log("jsonString :::: ${response.body}");
    if (jsonString['message'] == 'success') {
      return OrderListModel.fromJson(jsonString);
    } else {
      //show error message
      return OrderListModel();
    }
  }

  Future<OrderListModel?> getAllOrdersByStatus({required int id}) async {
    try {
      isAllOrderLoading(true);
      // await orderRefundListController.getRefundReasons();
      var products = await getAllNewModuleOrder(id: id);
      if (products != null) {
        allOrderListModel.value = products;
        // allOrderListModel.value.orders.forEach((order) {
        //   order.packages.forEach((package) {
        //     package.refundReasons.addAll(orderRefundListController.refundReasons);
        //   });
        // });
      }
      return products;
    } finally {
      isAllOrderLoading(false);
    }
  }

  /// ......................................New Order Module end.........................................................

  Future<OrderListModel?> getAll() async {
    try {
      log("Url-> ${URLs.ALL_ORDER_LIST}");
      String token = await userToken.read(tokenKey);

      Uri userData = Uri.parse(URLs.ALL_ORDER_LIST + "?lang=${AppLocalizations.getLanguageCode()}");

      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'success') {
        return OrderListModel.fromJson(jsonString);
      } else {
        //show error message
        return null;
      }
    } catch (e, tr) {
      log("Error -> $e");
      log("Track -> $tr");
    }
  }

  Future<OrderListModel?> getAllOrders() async {
    try {
      isAllOrderLoading(true);
      // await orderRefundListController.getRefundReasons();
      var products = await getAll();
      if (products != null) {
        allOrderListModel.value = products;
        allOrderListModel.value.orders?.forEach((order) {
          newOrderList.add(order);
        });
      }
      return products;
    } finally {
      isAllOrderLoading(false);
    }
  }

  Future<OrderListModel?> getPending() async {
    String token = await userToken.read(tokenKey);

    try {
      log("Url-> ${URLs.ALL_ORDER_LIST}");
      Uri userData = Uri.parse(URLs.ALL_ORDER_PENDING_LIST);

      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'success') {
        return OrderListModel.fromJson(jsonString);
      } else {
        //show error message
        return null;
      }
    } catch (e, tr) {
      log("Error -> $e");
      log("Track -> $tr");
    }
  }

  Future<OrderListModel?> getPendingOrders() async {
    try {
      isPendingOrderLoading(true);
      var products = await getPending();
      if (products != null) {
        pendingOrderListModel.value = products;
      }
      return products;
    } finally {
      isPendingOrderLoading(false);
    }
  }

  Future<OrderToShipModel?> getToShipped() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ORDER_TO_SHIP);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return OrderToShipModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderToShipModel?> getToShipOrders() async {
    try {
      isToShipOrderLoading(true);
      var products = await getToShipped();
      if (products != null) {
        print(products);
        toShippedOrderListModel.value = products;
      }
      return products;
    } finally {
      isToShipOrderLoading(false);
    }
  }

  Future<OrderToShipModel?> getToReceive() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ORDER_TO_RECEIVE);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      try {
        return OrderToShipModel.fromJson(jsonString);
      } catch (e, tr) {
        log("Error -> $e");
        log("Track -> $tr");
        return OrderToShipModel();
      }
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderToShipModel?> getToReceiveOrders() async {
    try {
      isToReceiveOrderLoading(true);
      var products = await getToReceive();
      if (products != null) {
        toReceiveOrderListModel.value = products;
      }
      return products;
    } finally {
      isToReceiveOrderLoading(false);
      log("getToReceiveOrders ::: end");
    }
  }

  @override
  void onInit() {
    controller = TabController(vsync: this, length: tabs.length);
    // fetchTabData();
    fetchTabData().then((value) => getAllOrdersByStatus(id: newOrderStatusId));
    super.onInit();
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
