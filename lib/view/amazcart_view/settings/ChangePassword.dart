import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazcart_widget/AppBarWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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

  GetStorage userToken = GetStorage();

  Future<bool> updatePassword(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.CHANGE_PASSWORD);
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
    print(response.body);
    print(response.statusCode);

    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      SnackBars().snackBarError('${jsonString['message']}');
      return false;
    }
  }

  RxBool currentPasswordClean = false.obs;
  RxBool newPasswordClean = false.obs;
  RxBool confirmPasswordClean = false.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Change Password'.tr,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.r))),
              child: TextFormField(
                controller: currentPasswordCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (v){
                  if(v.isEmpty){
                    currentPasswordClean.value = false;
                  }else{
                    currentPasswordClean.value = true;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  suffixIcon: Obx(() {
                    return Visibility(
                      visible: currentPasswordClean.value,
                      child: IconButton(
                        icon: Icon(Icons.close,size : 16.w),
                        onPressed: () {
                          currentPasswordCtrl.clear();
                          currentPasswordClean.value = false;
                        },
                      ),
                    );
                  }),
                  hintText: 'Current Password'.tr,
                  hintMaxLines: 4,
                  hintStyle: AppStyles.appFont.copyWith(
                    color: Colors.grey,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value?.length == 0) {
                    return 'Type your current password'.tr;
                  } else if ((value?.length ?? 0) < 8) {
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.r))),
              child: TextFormField(
                controller: newPasswordCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (v){
                  if(v.isEmpty){
                    newPasswordClean.value = false;
                  }else{
                    newPasswordClean.value = true;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  suffixIcon: Obx(() {
                    return Visibility(
                      visible: newPasswordClean.value,
                      child: IconButton(
                        icon: Icon(Icons.close, size : 16.w),
                        onPressed: () {
                          newPasswordCtrl.clear();
                          newPasswordClean.value = false;
                        },
                      ),
                    );
                  }),
                  hintText: 'New Password'.tr,
                  hintMaxLines: 4,
                  hintStyle: AppStyles.appFont.copyWith(
                    color: Colors.grey,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value?.length == 0) {
                    return 'Type your new password'.tr;
                  } else if ((value?.length ?? 0) < 8) {
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: TextFormField(
                controller: reTypePasswordCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (v){
                  if(v.isEmpty){
                    confirmPasswordClean.value = false;
                  }else{
                    confirmPasswordClean.value = true;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppStyles.textFieldFillColor,
                    ),
                  ),
                  suffixIcon: Obx(() {
                    return Visibility(
                      visible: confirmPasswordClean.value,
                      child: IconButton(
                        icon: Icon(Icons.close,size : 16.w),
                        onPressed: () {
                          reTypePasswordCtrl.clear();
                          confirmPasswordClean.value = false;
                        },
                      ),
                    );
                  }),
                  hintText: 'Re-type Password'.tr,
                  hintMaxLines: 4,
                  hintStyle: AppStyles.appFont.copyWith(
                    color: Colors.grey,
                    fontSize: 15.fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value?.length == 0) {
                    return 'Type password again'.tr;
                  } else if ((value?.length ?? 0) < 8) {
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
          horizontal: 20.w,
          vertical: 20.h,
        ),
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            height: 50.h,
            decoration: BoxDecoration(
                color: AppStyles.pinkColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Text(
              'Update Password'.tr,
              style: AppStyles.kFontWhite14w5,
            ),
          ),
          onTap: () async {
            if (_formKey.currentState?.validate() == true) {
              Map data = {
                "old_password": currentPasswordCtrl.text,
                "password": newPasswordCtrl.text,
                "password_confirmation": reTypePasswordCtrl.text,
              };
              await updatePassword(data).then((value) async {
                if (value) {
                  SnackBars().snackBarSuccess(
                      'Password Updated successfully'.tr);
                  final LoginController loginController =
                  Get.put(LoginController());
                  await loginController.removeToken().then((value) {
                    Future.delayed(Duration(seconds: 4), () {
                      Get.offNamedUntil('/', (route) => true);
                      // Get.reloadAll(force: true);
                    });
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }
}
