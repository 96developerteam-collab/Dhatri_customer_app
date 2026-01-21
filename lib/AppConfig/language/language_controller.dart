import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import 'app_localizations.dart';
import 'languages/translate_language.dart';
import 'languages/en_US.dart';

RxBool isRtl = false.obs;

class LanguageController extends GetxController implements Translations {

  Map<String, Map<String, String>> translationsData = {
    "en": en_US,
    "active": translatedLanguage,
  };

  @override
  Map<String, Map<String, String>> get keys => translationsData;

  @override
  void onInit() async {
    super.onInit();
    Get.updateLocale(Locale(AppLocalizations.activeLocalizationLangCode()));
    update();
  }
}
