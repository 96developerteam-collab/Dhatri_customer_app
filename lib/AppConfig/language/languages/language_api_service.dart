import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:amazcart/AppConfig/language/language_controller.dart';
import 'package:amazcart/model/language/localization_language_response.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../config/config.dart';
import '../../../database/auth_database.dart';

class LanguageAPIService {
  Dio _dio = Dio();
  Future<void> getLocalizationLanguage({String langCode = "en"}) async {
    try {
      log("URL -> ${URLs.getLang}");
      await _dio.get(URLs.getLang, queryParameters: {"lang": langCode}).then(
          (v) async {
        // log("language keys ::: ${v.data}");
        LocalizationLanguageResponseModel response =
            LocalizationLanguageResponseModel.fromJson(v.data);
        if (response.success == true) {
          ///Stored app localization language key and value data
          AuthDatabase.instance.saveAppLocalizationLang(
              localizationUIModel:
                  response.localizationUIModel ?? LocalizationUIModel());
          await 300.milliseconds.delay();
          AppLocalizations.setDefaultLocalization();
        }
      });
    } on DioException catch (e, tr) {
      log("Error -> $e");
      log("Track -> $tr");
    }
  }

  Future<void> setLocalizationLanguage({String langCode = "en"}) async {
    try {
      log("URL -> ${URLs.setLang}");
      GetStorage userToken = GetStorage();
      String token = await userToken.read("token");

      var response = await _dio.post(URLs.setLang,
          data: {'lang': AppLocalizations.getLanguageCode()},
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      log("Lang response -> ${response.data}");
    } on DioException catch (e, tr) {
      log("Error -> $e");
      log("Track -> $tr");
    }
  }
}
