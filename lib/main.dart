import 'dart:developer';
import 'dart:io';
import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/bindings/home_bindings.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/in-app-purchase_controller.dart';
import 'package:amazcart/view/amazcart_view/MainNavigation.dart' as amazcart;
import 'package:amazcart/view/amazy_view/MainNavigation.dart' as amazy;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:amazcart/utils/styles.dart';

import 'AppConfig/language/app_localizations.dart';
import 'AppConfig/language/language_controller.dart';
import 'AppConfig/language/localization_initializer.dart';
import 'controller/cart_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  //await Firebase.initializeApp();

  final CartController controller = Get.put(CartController());
  TabbySDK().setup(
    withApiKey:
        'pk_test_ec208bef-3e27-45aa-a6b5-1807d238e950', // Put here your Api key
    // environment: Environment.stage, // Or use Environment.production
  );

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  if(Platform.isIOS){
    var inAppPurchaseController = Get.put(InAppPurchaseController());
    inAppPurchaseController.initialize();
  }

  await LocalizationInitializer.init();
  await Hive.initFlutter();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppStyles.lightBlueColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
  configLoading();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (_, child) => Obx(() => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              locale: Locale(AppLocalizations.getLanguageCode()),
              builder: EasyLoading.init(),
              textDirection:
                  isRtl.value ? TextDirection.rtl : TextDirection.ltr,
              translations: LanguageController(),
              fallbackLocale: Locale(AppLocalizations.getLanguageCode()),
              title: AppConfig.appName,
              initialBinding: HomeBindings(),
              // getPages: routes,
              defaultTransition: Transition.fadeIn,
              theme: ThemeData().copyWith(
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                  ),
                  popupMenuTheme: PopupMenuThemeData().copyWith(
                    color: Colors.white,
                    menuPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h)
                  ),
                  dropdownMenuTheme: DropdownMenuThemeData().copyWith(
                    menuStyle: MenuStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        return Colors.white; //your desired selected background color
                      }),
                    ),
                  )),
              home: child,
            )),
        child: AppConfig.isAmazCartTheme ?  amazcart.MainNavigation(
          navIndex: 0,
        ) : amazy.MainNavigation(),
      );
    } catch (e, tr) {
      log(e.toString());
      log(tr.toString());

      return Text(e.toString());
    }
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.transparent
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = Colors.transparent
    ..userInteractions = true
    ..progressColor = Colors.transparent
    ..boxShadow = <BoxShadow>[]
    ..dismissOnTap = false;
}
