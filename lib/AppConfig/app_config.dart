import 'package:flutter/material.dart';

class AppConfig {

 static const String hostUrl = "https://dev.dhatri.store";
 static String appName = 'Dhatri';

 static bool isAmazCartTheme = false;

 // Updated Theme Colors
 static String appColorScheme = "#4f7942";

 static String appColorSchemeGradient1 = '#4f7942';
 static String appColorSchemeGradient2 = '#4f7942';

 static Color loginScreenBackgroundGradient1 = Color(0xff39B021);
 static Color loginScreenBackgroundGradient2 = Color(0xff2E8A1A);

 static String loginBackgroundImage = 'assets/config/login_bg.png';

 static String appLogo = 'assets/config/splash_screen_logo.png';
 static String appBanner = 'assets/config/app_banner.png';
 static String appBarIcon = 'assets/config/appbar_icon.png';

 static const String assetPath = hostUrl + '/public';

 static const String privacyPolicyUrl =
     'https://dhatri.store/terms-&-conditions%201';

 static bool googleLogin = false;
 static bool facebookLogin = false;
 static bool appleLogin = false;

 static bool isDemo = false;

 static String tabbyMerchantCode = 'FONCY';
 static bool isPasswordChange = false;
}
