import 'dart:convert';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/Home.dart';
import 'package:amazcart/view/amazy_view/MainNavigation.dart';
import 'package:amazcart/widgets/amazy_widget/AppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/CustomInputDecoration.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazy_widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController reTypePasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var tokenKey = 'token';
  final LoginController loginController = Get.put(LoginController());

  RxBool isLoading = false.obs;

  GetStorage userToken = GetStorage();

  Future<bool> updatePassword(Map data) async {

    try{

      isLoading.value = true;

      EasyLoading.show(
          maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.CHANGE_PASSWORD);
      var body = json.encode(data);
      var response = await http.post(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      print(response.body);
      print(response.statusCode);

      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isLoading.value = false;
        EasyLoading.dismiss();
        return true;
      } else {
        isLoading.value = false;
        EasyLoading.dismiss();
        SnackBars().snackBarError('${jsonString['message']}');
        return false;
      }

    }catch(e, t){
      isLoading.value = false;
      debugPrint('$e');
      debugPrint('$t');
    } finally{
      isLoading.value = false;
    }


    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Change Password'.tr,
        showCart: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: currentPasswordCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: CustomInputDecoration()
                    .underlineDecoration(label: "Current Password".tr),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: AppStyles.appFontMedium.copyWith(
                  color: Colors.black,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Type your current password'.tr;
                  } else if (value.length < 8) {
                    return 'The password must be at least 8 characters.'.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: newPasswordCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: CustomInputDecoration()
                    .underlineDecoration(label: "New Password".tr),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: AppStyles.appFontMedium.copyWith(
                  color: Colors.black,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Type your new password'.tr;
                  } else if (value.length < 8) {
                    return 'The password must be at least 8 characters.'.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: reTypePasswordCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: CustomInputDecoration()
                    .underlineDecoration(label: "Re-type Password".tr),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: AppStyles.appFontMedium.copyWith(
                  color: Colors.black,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Type password again'.tr;
                  } else if (value.length < 8) {
                    return 'The password must be at least 8 characters.'.tr;
                  } else if (value != newPasswordCtrl.text) {
                    return 'The password confirmation does not match.'.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        child: Obx(() => isLoading.value ? Center(child: CircularProgressIndicator()) : GestureDetector(
          child: Container(
            alignment: Alignment.center,
            height: 40.h,
            decoration: BoxDecoration(
                gradient: AppStyles.gradient,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Text(
              'Update Password'.tr,
              style: AppStyles.kFontWhite14w5,
            ),
          ),
          onTap: () async {



            if (_formKey.currentState!.validate() && loginController.loggedIn.value) {
              Map data = {
                "old_password": currentPasswordCtrl.text,
                "password": newPasswordCtrl.text,
                "password_confirmation": reTypePasswordCtrl.text,
              };
              await updatePassword(data).then((value) async {
                if (value) {
                  Get.back();
                  SnackBars().snackBarSuccess('Password Updated successfully'.tr);
                  final LoginController loginController =
                  Get.put(LoginController());
                  await loginController.removeToken().then((value) {
                    Future.delayed(Duration(seconds: 4), () {

                      // Get.to(MainNavigation());
                      //AppConfig.isPasswordChange = true;
                      // Get.offNamedUntil('/', (route) => true);
                      Get.reloadAll(force: false);
                    });
                  });

                }
              });
            }
          },
        )),
      ),
    );
  }
}
