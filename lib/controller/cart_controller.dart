import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Cart/MyCartModel.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../database/auth_database.dart';
import 'login_controller.dart';

class CartController extends GetxController {
  var isLoading = false.obs;

  var isCartLoading = false.obs;

  var tokenKey = 'token';
  RxBool deleteSelected = false.obs;
  RxList<MyCart> cartItemDelete = <MyCart>[].obs;

  GetStorage userToken = GetStorage();

  var cartListModel = MyCartModel().obs;

  var cartListCount = 0.obs;

  var cartListSelectedCount = 0.obs;

  Future<MyCartModel> getCart() async {
    String token = userToken.read(tokenKey) ?? '';

    Uri userData = Uri.parse(URLs.CART + '?lang=${AppLocalizations.getLanguageCode()}&device_token=${AuthDatabase.instance.getDeviceUniqueId()}${ AuthDatabase.instance.getUserId() != null ? "&user_id=${AuthDatabase.instance.getUserId()}":""}');
    print('cart url:: ${URLs.CART}');

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return MyCartModel.fromJson(jsonString);
    } else {
      cartListSelectedCount.value = 0;
      //show error message
      return MyCartModel();
    }
  }

  Future<MyCartModel> getCartList() async {
    print('cart get');
    try {
      isCartLoading(true);

      String token = userToken.read(tokenKey) ?? '';

      // if(token.isEmpty){
      //   print('model is calling');
      //   isCartLoading(false);
      //   return MyCartModel();
      // }

      log("call get cart API :::::: ");

      var cartList = await getCart();
      if (cartList != null) {
        cartListModel.value = cartList;
        var count = 0;
        var selectedCount = 0;
        cartListModel.value.carts?.values.forEach((element) {
          element.forEach((element) {
            if (element.isSelect == 1) {
              selectedCount += element.qty!;
            }
            count += element.qty!;
          });
        });
        cartListCount.value = 0;
        cartListCount.value = count;
        cartListSelectedCount.value = 0;
        cartListSelectedCount.value = selectedCount;
      }
      else {
        cartListModel.value = MyCartModel();
      }
      return cartList;
    } catch(e, t){
      print('Cart Controller e: $e');
      print('Cart Controller t: $t');
      return MyCartModel();
    } finally {
      isCartLoading(false);
    }
  }

  Future<bool> addToCart(Map<String,dynamic> data) async {

    EasyLoading.show(maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey)??"";
    Uri userData = Uri.parse(URLs.CART + '?lang=${AppLocalizations.getLanguageCode()}');

     var withoutLoginData = {
      "device_token" : AuthDatabase.instance.getDeviceUniqueId(),
       if(AuthDatabase.instance.getUserId() != null)
         "user_id" : AuthDatabase.instance.getUserId()
    };

     data.addAll(withoutLoginData);

     log("Merged map :::: $data");

    var body = json.encode(data);


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode);
    print(response.body);

    var jsonString = jsonDecode(response.body);


    log("response.body :::: ${response.body}");

    if (response.statusCode == 201) {
      EasyLoading.dismiss();
      SnackBars().snackBarSuccess(
          jsonString['message'].toString().capitalizeFirst);
      await getCartList();
      return true;
    } else {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarError(jsonString['message'].toString().capitalizeFirst);
      return false;
    }
  }

  Future updateCartQuantity(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey)??'';

    Uri userData = Uri.parse(URLs.CART_QUANTITY_UPDATE + '?lang=${AppLocalizations.getLanguageCode()}');

    var body = jsonEncode(data);


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future selectUnselectCartItem(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_SELECT_UNSELECT_SINGLE);

    var body = jsonEncode(data);


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 200) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future selectUnselectSeller(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_SELECT_UNSELECT_SELLER_WISE + '?lang=${AppLocalizations.getLanguageCode()}');

    var body = jsonEncode(data);


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 200) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future selectUnselectAllItem(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_SELECT_UNSELECT_ALL + '?lang=${AppLocalizations.getLanguageCode()}');

    var body = jsonEncode(data);


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 200) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future removeFromCart(data) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey)??'';

    Uri userData = Uri.parse(URLs.CART_REMOVE_CART_ITEM + '?lang=${AppLocalizations.getLanguageCode()}');

    var body = jsonEncode(data);


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 203) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future removeAllFromCart() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_REMOVE_ALL + "?device_token=${AuthDatabase.instance.getDeviceUniqueId()}&user_id=${AuthDatabase.instance.getUserId()}");


    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 203) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future updateShipping(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_UPDATE_SHIPPING + '?lang=${AppLocalizations.getLanguageCode()}');

    var body = jsonEncode(data);

    //check
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  // @override
  // void onInit() {
  //   getCartList();
  //   super.onInit();
  // }
}
