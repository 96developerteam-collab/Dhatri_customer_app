import 'dart:developer';
import 'package:amazcart/model/NewModel/GeneralSettingsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../database/auth_database.dart';
import '../../model/language/localization_language_response.dart';
import 'language_controller.dart' as lg;
import 'languages/en_US.dart';
import 'languages/translate_language.dart';

LanguageModel selectedLanguageDrop = LanguageModel();
RxList<LanguageModel> languages = <LanguageModel>[].obs;

class AppLocalizations {

  static String getLanguageCode() {
    return appLocalizationsData()?.code??"en";
  }

  static String activeLocalizationLangCode(){
    return getLanguageCode() == "en" ? "en" : "active";
  }

  static Map<String, String> getTranslationKeys() {
    Map<String, dynamic>? oldTranslationKeys =
    appLocalizationsData()?.localizationLangValue?.toJson();

    if (oldTranslationKeys == null || oldTranslationKeys.isEmpty) {
      return en_US;
    }

    Map<String, String> translation = {};

    oldTranslationKeys.forEach((k, v) {
      String value = v ?? "";
      translation[k] = value.toString();
    });

    return translation;
  }

  static bool isRtl() {
    return appLocalizationsData()?.rtl == true;
  }

  static LocalizationUIModel? appLocalizationsData() {
    return AuthDatabase.instance.getAppLocalization();
  }

  static String getLanguageNativeName(){

    return appLocalizationsData()?.native??"English";
  }

  static String getSelectedLanguage(){
    return "${getLanguageNativeName()}(${getLanguageCode().toUpperCase()})";
  }


  static void setDefaultLocalization(){
    lg.LanguageController langController = Get.find();
    translatedLanguage.assignAll(AppLocalizations.getTranslationKeys());
    langController.keys.update(AppLocalizations.activeLocalizationLangCode(), (value) => AppLocalizations.getTranslationKeys());
    Get.updateLocale(Locale(AppLocalizations.activeLocalizationLangCode()));
    lg.isRtl.value = AppLocalizations.isRtl();
  }
}