import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as DIO;
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/account_controller.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/database/auth_database.dart';
import 'package:amazcart/model/ErrorResponse.dart';
import 'package:amazcart/model/UserModel.dart';
import 'package:amazcart/model/NewModel/Merchant/MerchantModel.dart';
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
  final TextEditingController gstNumber = TextEditingController();

  Rx<File?> pickedDocument = Rx<File?>(null);
  Rx<File?> pickedShopImage = Rx<File?>(null);

  var merchants = <Merchant>[].obs;
  var filteredMerchants = <Merchant>[].obs;
  var isMerchantLoading = false.obs;
  var selectedMerchant = Rx<Merchant?>(null);

  String? loadToken;

  final _googleSignIn = GoogleSignIn();

  Future<bool> checkToken() async {
    String token = userToken.read(tokenKey) ?? '';

    // Fallback: if GetStorage lost the token, try recovering from SharedPreferences
    if (token.isEmpty) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String spToken = preferences.getString(tokenKey) ?? '';
      if (spToken.isNotEmpty) {
        // Re-sync token back to GetStorage
        await userToken.write(tokenKey, spToken);
        token = spToken;
        print("Token recovered from SharedPreferences");
      }
    }

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
    print("this the things - getProfile called");
    Uri userData = Uri.parse(URLs.GET_USER);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("this the things - response body: ${response.body}");
    print("this the things - status code: ${response.statusCode}");
    
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      var user = UserClass.fromJson(jsonString['user']);

      AuthDatabase.instance.saveUserId(userId: user.id!);
      
      if (user.warehouseId != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt('warehouse_id', user.warehouseId!);
        GetStorage().write('warehouse_id', user.warehouseId!);
      }
      
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
        String input = data['login'].toString().trim();
        String digits = input.replaceAll(RegExp(r'\D'), '');
        bool isPhone = digits.length >= 10; 

        data.remove('login');
        if (isPhone) {
          // Prepend +91 if missing
          String phone = input;
          if (!phone.startsWith('+')) {
            // Remove any leading 0s or existing 91 if it was typed without +
            if (phone.length == 10) {
              phone = '+91$phone';
            } else if (phone.length == 12 && phone.startsWith('91')) {
              phone = '+$phone';
            } else if (!phone.startsWith('+91')) {
              phone = '+91$phone';
            }
          }
          data['phone'] = phone;
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
        var responseData = response.data;
        // Clear form fields after successful registration
        firstName.clear();
        lastName.clear();
        registerEmail.clear();
        registerPassword.clear();
        registerConfirmPassword.clear();
        referralCode.clear();
        storeName.clear();
        gstNumber.clear();
        pickedDocument.value = null;
        pickedShopImage.value = null;
        selectedMerchant.value = null;

        String successMsg = responseData['message'] ?? 'Registration successful! Please login to continue.'.tr;
        SnackBars().snackBarSuccess(successMsg);
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
    // Check if it's between 10 and 15 digits
    return digits.length >= 10 && digits.length <= 15;
  }

  bool isValidEmail(String input) {
    // Basic email validation
    return input.contains('@') && input.contains('.');
  }

  String getLoginIdentifier() {
    String input = email.text.trim();
    String digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10 && !input.contains('@') && !input.startsWith('+')) {
      return "+91" + digits;
    }
    return input;
  }

  void toggleLoginMode(bool isPhone) {
    isPhoneLogin.value = isPhone;
    // Clear the email/phone field when toggling modes
    email.clear();
  }

  Future<bool> fetchUserLogin({
    required String emailOrPhone,
    String? password,
  }) async {
    try {
      isLoading(true);
      var loginData = await login(emailOrPhone, password);
      if (loginData != null) {
        token = loginData['token'];
        if (token.length > 5) {
          await saveToken(token);
          if (loginData['user'] != null) {
            if (loginData['user']['warehouse_id'] != null) {
              int warehouseId = loginData['user']['warehouse_id'];
              SharedPreferences preferences = await SharedPreferences.getInstance();
              await preferences.setInt('warehouse_id', warehouseId);
              await userToken.write('warehouse_id', warehouseId);
            }
            if (loginData['user']['id'] != null) {
              AuthDatabase.instance.saveUserId(userId: loginData['user']['id']);
            }
          }
          await loadUserToken();
          
          // Non-blocking calls to refresh background data
          accountController.getAccountDetails();
          cartController.getCartList();
          _myWishListController.getAllWishList();
          try {
            final HomeController homeController = Get.put(HomeController());
            homeController.getHomePage();
            homeController.source?.refresh(true);
          } catch (e) {
            print(e);
          }
          
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

    // Determine if it's phone or email
    String finalInput = emailOrPhone.toString().trim();
    String digits = finalInput.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10 && !finalInput.contains('@') && !finalInput.startsWith('+')) {
      finalInput = "+91" + digits;
    }
    bool isPhone = !finalInput.contains('@');

    Uri loginUrl = Uri.parse(URLs.LOGIN);
    debugPrint('Login Url: --------->>>>>>> $loginUrl');

    // Create map with proper null handling
    Map data = {
      "login": finalInput,
      "device_token" : AuthDatabase.instance.getDeviceUniqueId()
    };

    if (password != null) {
      data["password"] = password.toString();
    }

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
        if (jsonString['user'] != null) {
          if (jsonString['user']['warehouse_id'] != null) {
            int warehouseId = jsonString['user']['warehouse_id'];
            SharedPreferences preferences = await SharedPreferences.getInstance();
            await preferences.setInt('warehouse_id', warehouseId);
            await userToken.write('warehouse_id', warehouseId);
          }
          if (jsonString['user']['id'] != null) {
            AuthDatabase.instance.saveUserId(userId: jsonString['user']['id']);
          }
        }
        await loadUserToken();
        
        // Non-blocking calls
        accountController.getAccountDetails();
        cartController.getCartList();
        _myWishListController.getAllWishList();
        try {
          final HomeController homeController = Get.put(HomeController());
          homeController.getHomePage();
          homeController.source?.refresh(true);
        } catch (e) {
          print(e);
        }

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
        await preferences.remove('warehouse_id');
        await userToken.remove(tokenKey);
        await userToken.remove('warehouse_id');
        AuthDatabase.instance.saveUserId(userId: null);

        await _googleSignIn.signOut();

        await FacebookAuth.instance.logOut();

        print("User logged Out");
        // cartController.getCartList();
        checkToken();
        loginMsg.value = 'Logged out';
        update();
        isLoading(false);
        // Non-blocking calls after logout
        cartController.getCartList();
        _myWishListController.getAllWishList();
        try {
          final HomeController homeController = Get.put(HomeController());
          homeController.getHomePage();
          homeController.source?.refresh(true);
        } catch (e) {
          print(e);
        }
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

  Future<void> getMerchants() async {
    isMerchantLoading(true);
    try {
      debugPrint("Fetching merchants from: ${URLs.MERCHANT_LIST}");
      var response = await http.get(
        Uri.parse(URLs.MERCHANT_LIST),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      debugPrint("Merchants Response Status: ${response.statusCode}");
      debugPrint("Merchants Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var merchantModel = MerchantModel.fromJson(data);
        merchants.value = merchantModel.merchants ?? [];
        filteredMerchants.value = merchants;
        debugPrint("Successfully loaded ${merchants.length} merchants");
      } else {
        debugPrint("Failed to load merchants. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching merchants: $e");
    } finally {
      isMerchantLoading(false);
    }
  }

  void searchMerchants(String query) {
    if (query.isEmpty) {
      filteredMerchants.value = merchants;
    } else {
      filteredMerchants.value = merchants.where((merchant) {
        final name = merchant.sellerWarehouseAddress?.warehouseName?.toLowerCase() ?? "";
        final address = merchant.sellerWarehouseAddress?.warehouseAddress?.toLowerCase() ?? "";
        return name.contains(query.toLowerCase()) || address.contains(query.toLowerCase());
      }).toList();
    }
  }

  @override
  void onInit() {
    checkToken();
    getMerchants();
    super.onInit();
  }
}
