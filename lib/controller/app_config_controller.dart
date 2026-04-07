import 'package:get/get.dart';
import '../AppConfig/app_config.dart';

class AppConfigController extends GetxController {
  var isAmazCartTheme = AppConfig.isAmazCartTheme.obs;
  var appName = AppConfig.appName.obs;
  var appLogo = AppConfig.appLogo.obs;
  var appColorScheme = AppConfig.appColorScheme.obs;

  void updateTheme(bool isAmazCart) {
    isAmazCartTheme.value = isAmazCart;
    update();
  }

  void updateAppName(String name) {
    appName.value = name;
    update();
  }
}
