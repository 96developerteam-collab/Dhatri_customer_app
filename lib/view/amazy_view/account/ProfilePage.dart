import 'dart:convert';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazcart_widget/dio_exception.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../../widgets/amazy_widget/AppBarWidget.dart';
import '../../../widgets/amazy_widget/CustomInputDecoration.dart';
import '../../../widgets/amazy_widget/PinkButtonWidget.dart';
import '../../../widgets/amazy_widget/custom_loading_widget.dart';
import '../../../widgets/amazy_widget/snackbars.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LoginController loginController = Get.put(LoginController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();
  File? _file;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  String maxDateTime = '2099-12-31';
  String initDateTime = '1900-01-01';
  String _format = 'yyyy-MMMM-dd';
  DateTime? _dateTime;
  String? toDate;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  final _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  Future<bool> updatePhoto() async {
    String token = await userToken.read(tokenKey);

    final file =
        await DIO.MultipartFile.fromFile(_file!.path, filename: '${_file!.path}');

    final formData = DIO.FormData.fromMap({
      'avatar': file,
    });

    response = await dio.post(
      URLs.UPDATE_PROFILE_PHOTO,
      data: formData,
      options: DIO.Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e){
      print(e);
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
    });

    print(response);
    if (response?.statusCode == 202) {
      return true;
    } else {
      if (response?.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(response!.data);
        return false;
      }
    }
  }

  Future<bool> pickDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
      return true;
    } else {
      SnackBars().snackBarWarning('Cancelled');
      return false;
    }
  }

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController phoneNumberCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  @override
  void initState() {
    firstNameCtrl.text = loginController.profileData.value.firstName ?? "";
    lastNameCtrl.text = loginController.profileData.value.lastName ?? "";
    dobCtrl.text = loginController.profileData.value.dateOfBirth ?? "";
    descriptionCtrl.text = loginController.profileData.value.description ?? "";
    phoneNumberCtrl.text = loginController.profileData.value.phone ?? "";
    emailCtrl.text = loginController.profileData.value.email ?? "";
    super.initState();
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future updateProfile(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.UPDATE_USER_PROFILE);
    var body = json.encode(data);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      if (response.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title : "Account Information".tr , showCart: false,),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        if (loginController.profileData.value.avatar == null) {
                          return GestureDetector(
                            onTap: () async {
                              if (AppConfig.isDemo) {
                                SnackBars().snackBarWarning("Disabled in demo".tr);
                              } else {
                                await pickDocument().then((value) async {
                                  if (value) {
                                    await updatePhoto().then((up) async {
                                      if (up) {
                                        SnackBars().snackBarSuccess(
                                            'Updated successfully'.tr);
                                        await loginController.getProfileData();
                                      }
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                  color: AppStyles.pinkColorAlt,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.add,
                                color: AppStyles.pinkColor,
                                size: 40.w,
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              if (AppConfig.isDemo) {
                                SnackBars().snackBarWarning("Disabled in demo".tr);
                              } else {
                                await pickDocument().then((value) async {
                                  if (value) {
                                    await updatePhoto().then((up) async {
                                      if (up) {
                                        SnackBars().snackBarSuccess(
                                            'Updated successfully'.tr);
                                        await loginController.getProfileData();
                                      }
                                    });
                                  }
                                });
                              }
                            },
                            child: _file != null
                                ? CircleAvatar(
                                    radius: 100.w,
                                    backgroundImage: FileImage(
                                      _file!,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        '${AppConfig.assetPath}/${loginController.profileData.value.avatar}',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.w,
                                          )),
                                      width: 100.w,
                                      height: 100.w,
                                      alignment: Alignment.center,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        CachedNetworkImage(
                                      imageUrl:
                                          '${AppConfig.assetPath}/backend/img/default.png',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                        width: 100.w,
                                        height: 100.w,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                          );
                        }
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              TextFormField(
                                controller: firstNameCtrl,
                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(label: "First Name".tr),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16.fontSize,
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return 'Please Type first name'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: lastNameCtrl,
                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(label: "Last Name".tr),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16.fontSize,
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return 'Please Type last name'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: phoneNumberCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(
                                        label: "Mobile Number".tr),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16.fontSize,
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return 'Please Enter your Mobile Number'.tr;
                                  }else if(!value.isPhoneNumber){
                                    return 'Invalid mobile number'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: emailCtrl,
                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(
                                        label: "Email Address".tr),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16.fontSize,
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return 'Please Type Email address'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(loginController
                                      .profileData.value.dateOfBirth);
                                  var splitted;
                                  if (loginController
                                              .profileData.value.dateOfBirth !=
                                          "" &&
                                      loginController
                                              .profileData.value.dateOfBirth !=
                                          null) {
                                    splitted = loginController
                                        .profileData.value.dateOfBirth
                                        .toString()
                                        .split('-');
                                  } else {
                                    splitted =
                                        '2000/12/31'.toString().split('/');
                                  }

                                  print(splitted);
                                  final dob =
                                      '${splitted[0]}-${splitted[1]}-${splitted[2]}';
                                  DatePicker.showDatePicker(
                                    context,
                                    pickerTheme: DateTimePickerTheme(
                                      confirm: Text(
                                        'Update'.tr,
                                        style: AppStyles.kFontPink15w5,
                                      ),
                                      cancel: Text(
                                        'Cancel'.tr,
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ),
                                    minDateTime: DateTime.parse(initDateTime),
                                    maxDateTime: DateTime.parse(maxDateTime),
                                    initialDateTime: DateTime.parse(dob),
                                    dateFormat: _format,
                                    locale: _locale,
                                    onClose: () => print("----- onClose -----"),
                                    onCancel: () => print('onCancel'),
                                    onChange: (dateTime, List<int> index) {
                                      setState(() {
                                        _dateTime = dateTime;
                                      });
                                    },
                                    onConfirm:
                                        (dateTime, List<int> index) async {
                                      setState(() {
                                        _dateTime = dateTime;
                                        toDate =
                                            '${_dateTime!.year}-${getAbsoluteDate(_dateTime!.month)}-${getAbsoluteDate(_dateTime!.day)}';
                                        print(toDate);

                                        dobCtrl.text = toDate!;
                                      });
                                    },
                                  );
                                },
                                child: TextFormField(
                                  controller: dobCtrl,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  decoration: CustomInputDecoration()
                                      .underlineDecoration(
                                          label: "Date of Birth".tr)
                                      .copyWith(
                                          disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppStyles.pinkColor,
                                        ),
                                      )),
                                  style: AppStyles.appFontBook.copyWith(
                                    fontSize: 16.fontSize,
                                  ),
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return 'Please type date of birth'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: descriptionCtrl,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(label: "Description".tr),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16.fontSize,
                                ),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return 'Please Enter description'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              PinkButtonWidget(
                                width: Get.width,
                                height: 40.fontSize,
                                btnText: "Submit".tr,
                                btnOnTap: () async {
                                  if (AppConfig.isDemo) {
                                    SnackBars()
                                        .snackBarWarning("Disabled in demo".tr);
                                  } else {
                                    if (_formKey.currentState!.validate()) {
                                      Map data = {
                                        "first_name": firstNameCtrl.text,
                                        "last_name": lastNameCtrl.text,
                                        "email": emailCtrl.text,
                                        "phone": phoneNumberCtrl.text,
                                        "date_of_birth": dobCtrl.text,
                                        "description": descriptionCtrl.text,
                                      };
                                      await updateProfile(data)
                                          .then((value) async {
                                        if (value) {
                                          SnackBars().snackBarSuccess(
                                              'Profile updated successfully');
                                          await loginController.getProfileData();
                                        }
                                      });
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
