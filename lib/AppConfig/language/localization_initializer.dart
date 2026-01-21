import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../database/auth_database.dart';
import 'language_controller.dart';

class LocalizationInitializer{

  static Future<void> init() async {

    await GetStorage.init();
    Get.put(GetStorage());

    // await GetStorage.init(AuthDBKeys.dbName);

    AuthDatabase.instance.init();

    final languageController = LanguageController();
    Get.put(languageController);


  }

}