import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as DIO;
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/account_controller.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/database/auth_database.dart';
import 'package:amazcart/model/ErrorResponse.dart';
import 'package:amazcart/model/UserModel.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AccountController accountController = Get.put(AccountController());
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();
  final MyWishListController _myWishListController =
      Get.put(MyWishListController());

  var isLoading = false.obs;
  String token = '';
  var loginMsg = "".obs;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var loggedIn = false.obs;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // For phone number or email input
  var isPhoneLogin = false.obs;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();
  final TextEditingController referralCode = TextEditingController();
  final TextEditingController storeName = TextEditingController();

  Rx<File?> pickedDocument = Rx<File?>(null);
  Rx<File?> pickedShopImage = Rx<File?>(null);

  String? loadToken;

  final _googleSignIn = GoogleSignIn();

  Future<bool> checkToken() async {
    String token = userToken.read(tokenKey) ?? '';
    // await userToken.erase();
    // if (token.isNotEmpty) {
    //   print('Token OK ${checkToken()}');
    // } else {
    //   print('Token NOT ${checkToken()}');
    // }
    if (token.isNotEmpty) {
      print("Logged in");
      loggedIn.value = true;
      update();
      await getProfileData();
      return true;
    } else {
      print("Login Fail");
      loggedIn.value = false;
      update();
      return false;
    }
  }

  var profileData = UserClass().obs;

  Future<UserClass> getProfileData() async {
    String token = userToken.read(tokenKey) ?? '';
    try {
      // isLoading(true);
      var products = await getProfile(token);
      profileData.value = products;
      print(profileData.value);
      return products;
    } finally {
      // isLoading(false);
    }
  }

  static Future<UserClass> getProfile(String token) async {
    Uri userData = Uri.parse(URLs.GET_USER);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    // print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      var user = UserClass.fromJson(jsonString['user']);

      AuthDatabase.instance.saveUserId(userId: user.id!);
      return user;
    } else {
      //show error message
      return UserClass();
    }
  }

  Future<void> loadUserToken() async {
    // print("load user token");
    loadToken = await loadData();
    print(loadToken);
    if (loadToken != null) {
      var toke = await userToken.read(tokenKey);
      checkToken();
      isLoading(false);
      return toke;
    } else {
      await userToken.remove(tokenKey);
      print("Token remove");
    }
  }

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) ?? '';
  }

  Future<void> saveToken(String msg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (msg.length > 5) {
      await preferences.setString(tokenKey, msg);
      await userToken.write(tokenKey, msg);
    } else {
      print("Invalid token");
    }
  }

  Future registerUser(Map<String, dynamic> data) async {
    isLoading(true);
    try {
      DIO.Dio dio = DIO.Dio();

      // Handle email vs phone
      if (data.containsKey('login')) {
        String input = data['login'];
        String digits = input.replaceAll(RegExp(r'\D'), '');
        bool isPhone = digits.length >= 10; // Simple check, adjust as needed

        data.remove('login');
        if (isPhone) {
          data['phone'] = input;
        } else {
          data['email'] = input;
        }
      }

      DIO.FormData formData = DIO.FormData.fromMap(data);

      if (pickedDocument.value != null) {
        formData.files.add(MapEntry(
          "document",
          await DIO.MultipartFile.fromFile(
            pickedDocument.value!.path,
            filename: pickedDocument.value!.path.split('/').last,
          ),
        ));
      }

      if (pickedShopImage.value != null) {
        formData.files.add(MapEntry(
          "store_image", // Changed from shop_image to store_image
          await DIO.MultipartFile.fromFile(
            pickedShopImage.value!.path,
            filename: pickedShopImage.value!.path.split('/').last,
          ),
        ));
      }

      debugPrint('Register URL: ${URLs.REGISTER}');
      debugPrint('Register Fields: ${formData.fields}');

      var response = await dio.post(
        URLs.REGISTER,
        data: formData,
        options: DIO.Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Register Response: ${response.data}');

      if (response.statusCode == 201) {
        await fetchUserLogin(
          emailOrPhone: data['email'] ?? data['phone'] ?? registerEmail.text,
          password: registerPassword.text,
        ).then((value) {
          if (value) {
            firstName.clear();
            lastName.clear();
            registerEmail.clear();
            registerPassword.clear();
            registerConfirmPassword.clear();
            referralCode.clear();
            storeName.clear();
            pickedDocument.value = null;
            pickedShopImage.value = null;
          }
        });
        return true;
      } else {
        return false;
      }
    } on DIO.DioException catch (e) {
      debugPrint('Register Error: ${e.response?.data}');
      if (e.response?.data != null) {
        var responseData = e.response?.data;
        if (responseData['errors'] != null) {
          Map<String, dynamic> errors = responseData['errors'];
          String errorMessage = '';
          errors.forEach((key, value) {
            if (value is List) {
              errorMessage += value.join('\n') + '\n';
            } else {
              errorMessage += value.toString() + '\n';
            }
          });
          SnackBars().snackBarError(errorMessage.trim());
        } else if (responseData['message'] != null) {
          SnackBars().snackBarError(responseData['message']);
        } else {
          SnackBars().snackBarError("Registration failed");
        }
      } else {
        SnackBars().snackBarError("Registration failed");
      }
      return false;
    } catch (e) {
      debugPrint('Register Error: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  static Future register(data) async {
    Uri registerUrl = Uri.parse(URLs.REGISTER);
    debugPrint('Register Url: --------->>>>>>> $registerUrl');
    // Detect if email or phone is being used for signup
    String emailOrPhone = data['login'] ?? '';
    String digits = emailOrPhone.toString().replaceAll(RegExp(r'\D'), '');
    bool isPhone = digits.length == 10;

    // Update the data map with smart field detection
    Map registerData = {...data};

    // Remove the 'login' key and use 'email' or 'phone' based on input
    registerData.remove('login');

    if (isPhone) {
      registerData['phone'] = emailOrPhone;
    } else {
      registerData['email'] = emailOrPhone;
    }

    // Remove null values from map
    registerData.removeWhere((key, value) => value == null);

    var body = json.encode(registerData);

    debugPrint('Register Request Body: $body');
    debugPrint('Is Phone: $isPhone');

    //check
    var response = await http.post(
        registerUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);

    debugPrint('Register Response Status: ${response.statusCode}');
    debugPrint('Register Response Body: ${response.body}');

    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return jsonString;
    } else {
      log(response.body);
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    }
  }

  // Validate if input is phone or email
  bool isValidPhoneNumber(String input) {
    // Remove all non-digit characters
    String digits = input.replaceAll(RegExp(r'\D'), '');
    // Check if it's exactly 10 digits
    return digits.length == 10;
  }

  bool isValidEmail(String input) {
    // Basic email validation
    return input.contains('@') && input.contains('.');
  }

  String getLoginIdentifier() {
    String input = email.text.trim();
    // If it's a phone number, return it as is, otherwise it's email
    return input;
  }

  void toggleLoginMode(bool isPhone) {
    isPhoneLogin.value = isPhone;
    // Clear the email/phone field when toggling modes
    email.clear();
  }

  Future<bool> fetchUserLogin({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      isLoading(true);
      var loginData = await login(emailOrPhone, password);
      if (loginData != null) {
        token = loginData['token'];
        if (token.length > 5) {
          await saveToken(token);
          await loadUserToken();
          await accountController.getAccountDetails();
          await cartController.getCartList();
          await _myWishListController.getAllWishList();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  static Future login(emailOrPhone, password) async {

    // Uri loginUrl = Uri.parse(URLs.LOGIN);

    // Determine if it's phone or email
    String digits = emailOrPhone.toString().replaceAll(RegExp(r'\D'), '');
    bool isPhone = digits.length == 10;

    Uri loginUrl = Uri.parse(URLs.LOGIN);
    debugPrint('Login Url: --------->>>>>>> $loginUrl');

    // Create map with proper null handling
    Map data = {
      "login": emailOrPhone.toString(),
      "password": password.toString(),
      "device_token" : AuthDatabase.instance.getDeviceUniqueId()
    };

    // Remove null values from map
    data.removeWhere((key, value) => value == null);

    var body = json.encode(data);

    debugPrint('Login Request Body: $body');
    debugPrint('Is Phone: $isPhone');
    debugPrint('Input: $emailOrPhone');

    //check
    var response = await http.post(loginUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);

    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonString;
    } else {
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    }
  }

  Future<bool> socialLogin(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    Uri loginUrl = Uri.parse(URLs.SOCIAL_LOGIN);

    var body = json.encode(data);

    //check
    var response = await http.post(loginUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 200) {
      token = jsonString['token'];

      if (token.length > 5) {
        await userToken.write("method", "${data['provider']}");

        await saveToken(token);
        await loadUserToken();
        await accountController.getAccountDetails();
        await cartController.getCartList();
        await _myWishListController.getAllWishList();

        EasyLoading.dismiss();
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    } else {
      EasyLoading.dismiss();
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    }

    return false;
  }

  Future<void> removeToken() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    // final CartController cartController = Get.put(CartController());
    final CartController cartController = Get.find();

    try {
      isLoading(true);

      String token = userToken.read(tokenKey) ?? '';

      Uri logoutUrl = Uri.parse(URLs.LOGOUT);

      //check
      var response = await http.post(
        logoutUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == 'Logged out successfully') {
        EasyLoading.dismiss();

        var jsonString = jsonDecode(response.body);

        SnackBars().snackBarSuccess("${jsonString['message']}");

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove(tokenKey);
        await userToken.remove(tokenKey);
        AuthDatabase.instance.saveUserId(userId: null);

        await _googleSignIn.signOut();

        await FacebookAuth.instance.logOut();

        print("User logged Out");
        // cartController.getCartList();
        checkToken();
        loginMsg.value = 'Logged out';
        update();
        isLoading(false);
        cartController.getCartList();
        _myWishListController.getAllWishList();
        return jsonString;
      } else {
        EasyLoading.dismiss();
        var jsonString = jsonDecode(response.body);

        if (jsonString['message'] == "The given data was invalid.") {
          final errorResponse =
              ErrorResponse.fromJson(jsonDecode(response.body));

          SnackBars().snackBarError("${errorResponse.message}");
        } else {
          SnackBars().snackBarError("${jsonString['message']}");
        }

        isLoading(false);
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading(false);
      print(e.toString());
    } finally {
      EasyLoading.dismiss();
      isLoading(false);
    }
  }

  Future<dynamic> forgotPassword() async {
    var body = jsonEncode({
      'email': email.text,
    });

    EasyLoading.show(maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    //check
    var response = await http.post(
      Uri.parse(URLs.FORGOT_PASSWORD),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );

    print(response.statusCode.toString());
    print(response.body.toString());

    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      SnackBars().snackBarError(jsonString['message']);
      return false;
    }
  }

  RxBool isPasswordHidden = true.obs;

  @override
  void onInit() {
    checkToken();
    super.onInit();
  }
}
