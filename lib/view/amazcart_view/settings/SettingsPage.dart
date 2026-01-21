import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:amazcart/AppConfig/language/language_controller.dart';
import 'package:amazcart/AppConfig/language/languages/language_api_service.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/model/NewModel/Currency.dart';
import 'package:amazcart/model/NewModel/GeneralSettingsModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/Settings/AccountInformation.dart';
import 'package:amazcart/view/amazcart_view/Settings/AddressBook.dart';
import 'package:amazcart/view/amazcart_view/Settings/MessagesSettings.dart';
import 'package:amazcart/view/amazcart_view/settings/ChangePassword.dart';
import 'package:amazcart/view/amazcart_view/settings/widget/account_delete_dialogue.dart';
import 'package:amazcart/widgets/amazcart_widget/AppBarWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/BlueButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // bool _isRadioSelected = false;
  final LoginController loginController = Get.put(LoginController());
  final GeneralSettingsController settingsController =
      Get.put(GeneralSettingsController());

  final LanguageController languageController = Get.put(LanguageController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  bool active = true;
  bool isSwitchingLang = false;

  @override
  void initState() {
    int index = languages.indexWhere(
        (v) => v.native == AppLocalizations.getLanguageNativeName());
    LanguageModel languageModel = languages[index];
    selectedLanguageDrop = languageModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: AppStyles.appBackgroundColor,
            appBar: AppBarWidget(
              title: 'Settings'.tr,
            ),
            body: Obx(() {
              return Container(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    loginController.loggedIn.value
                        ? ListTile(
                            tileColor: Colors.white,
                            onTap: () {
                              Get.to(() => AccountInformation());
                            },
                            title: Text(
                              'Account Information'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 15.fontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? Divider(
                            color: AppStyles.appBackgroundColor,
                            height: 1,
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? ListTile(
                            onTap: () {
                              Get.to(() => AddressBook());
                            },
                            tileColor: Colors.white,
                            title: Text(
                              'Address Book'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 15.fontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? Divider(
                            color: AppStyles.appBackgroundColor,
                            height: 1,
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? ListTile(
                            onTap: () {
                              Get.to(() => NotificationSettings());
                            },
                            tileColor: Colors.white,
                            title: Text(
                              'Notifications'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 15.fontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              'Receive exclusive offers & personal updates'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 13.fontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? Divider(
                            color: AppStyles.appBackgroundColor,
                            height: 1,
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? ListTile(
                            onTap: () {
                              Get.to(() => ChangePassword());
                            },
                            tileColor: Colors.white,
                            title: Text(
                              'Change Password'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 15.fontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(),
                    loginController.loggedIn.value
                        ? Divider(
                            color: AppStyles.appBackgroundColor,
                            height: 1,
                          )
                        : Container(),
                    if (loginController.loggedIn.value)
                      ListTile(
                          onTap: () {
                            Get.bottomSheet(
                              GetBuilder<LanguageController>(
                                  init: LanguageController(),
                                  builder: (controller) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Container(
                                            width: 40.w,
                                            height: 5.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xffDADADA),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            'Change Language'.tr,
                                            style: AppStyles.appFont.copyWith(
                                              color: Colors.black,
                                              fontSize: 16.fontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                            title:
                                                DropdownButton<LanguageModel>(
                                                  dropdownColor: Colors.white,
                                              iconSize: 18.w,
                                              hint: Text("Select Language".tr,style: AppStyles.kFontBlack12w4),
                                              isExpanded: true,
                                              items: List.generate(
                                                languages.length,
                                                (index) {
                                                  var languageName = Get.find<
                                                          GeneralSettingsController>()
                                                      .settingsModel
                                                      .value
                                                      .languages?[index];

                                                  return DropdownMenuItem<
                                                      LanguageModel>(
                                                    child: Text(
                                                      languageName?.native ??
                                                          'English',
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    ),
                                                    value: languageName,
                                                  );
                                                },
                                              ),
                                              onChanged: (value) async {
                                                print(
                                                    "Change language ::::: ${value?.code}");

                                                setState(() {
                                                  isSwitchingLang = true;
                                                });
                                                try {
                                                  await LanguageAPIService()
                                                      .setLocalizationLanguage(
                                                          langCode:
                                                              value?.code ??
                                                                  'en');

                                                  await LanguageAPIService()
                                                      .getLocalizationLanguage(
                                                          langCode:
                                                              value?.code ??
                                                                  'en');

                                                  setState(() {
                                                    selectedLanguageDrop =
                                                        value!;
                                                    isSwitchingLang = false;
                                                  });

                                                  loginController
                                                      .loggedIn.value = false;

                                                  await 100
                                                      .milliseconds
                                                      .delay();
                                                  loginController
                                                      .loggedIn.value = true;
                                                  //refresh home page data
                                                  HomeController
                                                      _homeController =
                                                      Get.find();
                                                  _homeController.getHomePage();
                                                  _homeController.source
                                                      ?.refresh(true);

                                                  Get.back();
                                                } catch (e, tr) {
                                                  print("-------$e , $tr");
                                                  SnackBars().snackBarWarning(
                                                      'Something went wrong'
                                                          .tr);
                                                }
                                              },
                                              value: selectedLanguageDrop,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.2,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r),
                                ),
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                          tileColor: Colors.white,
                          title: Text(
                            'Language'.tr,
                            style: AppStyles.appFont.copyWith(
                              color: Colors.black,
                              fontSize: 15.fontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            AppLocalizations.getLanguageNativeName(),
                            style: AppStyles.appFont.copyWith(
                              color: Colors.black,
                              fontSize: 13.fontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    if (loginController.loggedIn.value)
                      Divider(
                        color: AppStyles.appBackgroundColor,
                        height: 1,
                      ),

                    ListTile(
                      onTap: () {
                        Get.bottomSheet(
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              child: Container(
                                color: Color.fromRGBO(0, 0, 0, 0.001),
                                child: DraggableScrollableSheet(
                                  initialChildSize: 0.4,
                                  minChildSize: 0.3,
                                  maxChildSize: 1,
                                  builder: (_, scrollController2) {
                                    return Obx(() {
                                      if (currencyController.isLoading.value) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.w, vertical: 10.h),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                     Radius.circular(25.0.r),
                                                topRight:
                                                     Radius.circular(25.0.r),
                                              ),
                                            ),
                                            child: Center(
                                              child: CustomLoadingWidget(),
                                            ),
                                          ),
                                        );
                                      }
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(25.0),
                                              topRight:
                                                  const Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Scaffold(
                                            backgroundColor: Colors.white,
                                            body: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      width: 40.w,
                                                      height: 5.h,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffDADADA),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(30.r),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Center(
                                                  child: Text(
                                                    'Change Currency'.tr,
                                                    style: AppStyles
                                                        .kFontBlack15w4
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Text(
                                                  'Select Currency'.tr + ' :',
                                                  textAlign: TextAlign.left,
                                                  style:
                                                      AppStyles.kFontBlack15w4,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Obx(() {
                                                  return DropdownButton<
                                                      Currency>(
                                                    elevation: 1,
                                                    isExpanded: true,
                                                    dropdownColor: Colors.white,
                                                      iconSize: 18.w,
                                                    underline: Container(),
                                                    value: currencyController
                                                        .currency.value,
                                                    items: currencyController
                                                        .currenciesList
                                                        .map((e) {
                                                      return DropdownMenuItem<
                                                          Currency>(
                                                        child: Text(
                                                            '${e.name} (${e.symbol.toString()})',style: AppStyles.kFontBlack12w4,),
                                                        value: e,
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (Currency? value) {
                                                      setState(() {
                                                        currencyController
                                                                .currency
                                                                .value =
                                                            value ?? Currency();
                                                      });
                                                    },
                                                  );
                                                }),
                                                Divider(),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    BlueButtonWidget(
                                                      height: 40.h,
                                                      width: (Get.width - 130.w)/2 - 8,
                                                      btnText: 'Back'.tr,
                                                      btnOnTap: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    PinkButtonWidget(
                                                      height: 40.h,
                                                      width: (Get.width - 130.w)/2 - 8,
                                                      btnOnTap: () async {
                                                        currencyController
                                                                .appCurrency
                                                                .value =
                                                            currencyController
                                                                    .currency
                                                                    .value
                                                                    .symbol ??
                                                                '';
                                                        currencyController
                                                                .conversionRate
                                                                .value =
                                                            currencyController
                                                                    .currency
                                                                    .value
                                                                    .convertRate ??
                                                                0.0;
                                                        currencyController
                                                                .currencyName
                                                                .value =
                                                            currencyController
                                                                    .currency
                                                                    .value
                                                                    .name ??
                                                                '';

                                                        await 500
                                                            .milliseconds
                                                            .delay();
                                                        Get.back();
                                                        SnackBars().snackBarSuccess(
                                                            "Currency changed to"
                                                                    .tr +
                                                                ' ${currencyController.currency.value.name?.capitalizeFirst}');
                                                      },
                                                      btnText: 'Confirm'.tr,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          persistent: true,
                        );
                      },
                      tileColor: Colors.white,
                      title: Text(
                        'Currency'.tr,
                        style: AppStyles.appFont.copyWith(
                          color: Colors.black,
                          fontSize: 15.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        '${currencyController.currencyName.value} (${currencyController.appCurrency.value})',
                        style: AppStyles.appFont.copyWith(
                          color: Colors.black,
                          fontSize: 13.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Divider(
                      color: AppStyles.appBackgroundColor,
                      height: 1,
                    ),
                    ListTile(
                      onTap: () async {
                        // ignore: deprecated_member_use
                        if (!await launch(AppConfig.privacyPolicyUrl))
                          throw 'Could not launch ${AppConfig.privacyPolicyUrl}';
                      },
                      tileColor: Colors.white,
                      title: Text(
                        'Policies'.tr,
                        style: AppStyles.appFont.copyWith(
                          color: Colors.black,
                          fontSize: 15.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Divider(
                      color: AppStyles.appBackgroundColor,
                      height: 1,
                    ),

                    ///Account Delete
                    Obx(
                      () => loginController.loggedIn.value
                          ? Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Get.dialog(
                                      AccountDeleteDialogue(
                                        onYesTap: () {
                                          settingsController
                                              .deleteAccount()
                                              .then((value) =>
                                                  Navigator.pop(context));
                                        },
                                      ),
                                      // backgroundColor: Colors.white,
                                    );
                                  },
                                  tileColor: Colors.white,
                                  trailing: Icon(Icons.warning_amber_rounded,size: 18.w,),
                                  title: Text(
                                    'Delete Account'.tr,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.pinkColor,
                                      fontSize: 15.fontSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: AppStyles.appBackgroundColor,
                                  height: 1,
                                ),
                                ListTile(
                                  onTap: () {
                                    loginController.removeToken();
                                  },
                                  tileColor: Colors.white,
                                  title: Text(
                                    'Logout'.tr,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.pinkColor,
                                      fontSize: 15.fontSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              );
            })),
        Visibility(
          visible: isSwitchingLang,
          child: Center(
            child: Platform.isIOS
                ?  CupertinoActivityIndicator(
                    radius: 24.r,
                  )
                : const CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    @required this.label,
    @required this.padding,
    @required this.groupValue,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final String? label;
  final EdgeInsets? padding;
  final bool? groupValue;
  final bool? value;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged!(value);
        }
      },
      child: Padding(
        padding: padding ?? EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label ?? ''),
            Radio<bool>(
              groupValue: groupValue,
              value: value ?? true,
              onChanged: (bool? newValue) {
                onChanged!(newValue);
              },
              activeColor: AppStyles.pinkColor,
            ),
          ],
        ),
      ),
    );
  }
}
