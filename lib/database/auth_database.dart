import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:get_storage/get_storage.dart';

import '../model/language/localization_language_response.dart';
class AuthDatabase {
  static AuthDatabase? _instance;

  AuthDatabase._() {
    _instance = this;
  }

  static AuthDatabase get instance => _instance ?? AuthDatabase._();

  void init() async {
    await GetStorage.init(AuthDBKeys.dbName);
    generateDeviceUniqueId();
  }

  void generateDeviceUniqueId()async{
    final storage = GetStorage(AuthDBKeys.dbName);
    String deviceId = getDeviceUniqueId();

    if(deviceId.isEmpty){
      const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      final random = Random.secure();
      var randomDeviceId = String.fromCharCodes(Iterable.generate(40, (_) => chars.codeUnitAt(random.nextInt(chars.length)))) + DateTime.now().toIso8601String();
      await storage.write(AuthDBKeys.deviceID,randomDeviceId);
      await storage.save();
    }
  }



  String getDeviceUniqueId(){
    try {
      final storage = GetStorage(AuthDBKeys.dbName);
      var data = storage.read(AuthDBKeys.deviceID);
      if (data != null) {
        return data;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  void saveAppLocalizationLang({
    required LocalizationUIModel localizationUIModel
  }) async {
    try{
      final storage = GetStorage(AuthDBKeys.dbName);
      await storage.write(AuthDBKeys.appLocalization, localizationUIModel.toString());
      await storage.save();
    }catch(e){
    }
  }

  LocalizationUIModel? getAppLocalization() {
    try {
      final storage = GetStorage(AuthDBKeys.dbName);
      var data = storage.read(AuthDBKeys.appLocalization);
      if (data != null) {
        return LocalizationUIModel.fromJson(jsonDecode(data));
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }


  void saveUserId({
    required int? userId
  }) async {
    try{

      print("Save user id ::: $userId");
      final storage = GetStorage(AuthDBKeys.dbName);
      await storage.write(AuthDBKeys.userID, userId);
      await storage.save();
    }catch(e){
    }
  }

  int? getUserId() {
    try {
      final storage = GetStorage(AuthDBKeys.dbName);
      var data = storage.read(AuthDBKeys.userID);
      return data;
    } catch (e) {
      return null;
    }
  }
}

class AuthDBKeys {
  static const dbName = 'localizationDb';
  static const appLocalization = 'app_localization';
  static const deviceID = "device_id";
  static const userID = "user_id";
}
