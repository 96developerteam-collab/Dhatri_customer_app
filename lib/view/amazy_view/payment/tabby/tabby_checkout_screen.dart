import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:http/http.dart' as http;

import '../../../../config/config.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../controller/checkout_controller.dart';
import '../../../../widgets/amazy_widget/snackbars.dart';
import '../../account/orders/OrderList/MyOrders.dart';

final CheckoutController _checkoutController = Get.put(CheckoutController());
// final CartController cartController = Get.put(CartController());
final CartController cartController = Get.find();

class TabbyCheckoutNavParams {
  TabbyCheckoutNavParams({
    required this.selectedProduct,
  });

  final TabbyProduct selectedProduct;
}

class TabbyCheckoutPage extends StatefulWidget {
  const TabbyCheckoutPage({Key? key}) : super(key: key);

  @override
  State<TabbyCheckoutPage> createState() => _TabbyCheckoutPageState();
}

class _TabbyCheckoutPageState extends State<TabbyCheckoutPage> {
  late TabbyProduct selectedProduct;

  Future<void> onResult(WebViewResult resultCode) async {
    print('Tabby Response :::::: ${resultCode.name}');

    // "email": _checkoutController.orderData['customer_email'],
    // "phone": _checkoutController.orderData['customer_phone'],
    // controller.selectedGateway.value.id

    final String apiUrl = 'https://spn21.spondan.com/amazcart/api/tabby-checkout';

    final Map<dynamic, dynamic> requestData = _checkoutController.orderData;

    //check
    final response = await http.post(
      Uri.parse(URLs.TABBYURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {

      SnackBars().snackBarSuccess("Order created successfully".tr);
      Get.delete<CheckoutController>();
      await cartController.getCartList();

      await 2500.milliseconds.delay();
      Get.back();
      Get.back();

      Get.to(() => MyOrders(0));

      // Successful response, handle the data as needed

      final responseData = jsonDecode(response.body);
      print('Response Tabby: ${responseData}');
    } else {
      SnackBars().snackBarSuccess("Order create unsuccessfully".tr);
      // Handle error response
      print('Error: ${response.statusCode}');
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultCode.name),
      ),
    );
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)!.settings;
    selectedProduct =
        (settings.arguments as TabbyCheckoutNavParams).selectedProduct;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tabby Checkout'.tr),
      ),
      body: TabbyWebView(
        webUrl: selectedProduct.webUrl,
        onResult: onResult,
      ),
    );
  }
}
