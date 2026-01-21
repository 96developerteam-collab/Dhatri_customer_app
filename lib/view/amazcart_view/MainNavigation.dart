import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/account/Account.dart';
import 'package:amazcart/view/amazcart_view/account/SignInOrRegister.dart';
import 'package:amazcart/view/amazcart_view/cart/CartMain.dart';
import 'package:amazcart/view/amazcart_view/messages/MessageNotifications.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../AppConfig/language/languages/language_api_service.dart';
import 'Home.dart';

class MainNavigation extends StatefulWidget {
  final int? navIndex;
  final bool? hideNavBar;
  MainNavigation({this.navIndex, this.hideNavBar});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final LoginController loginController = Get.put(LoginController());

  final CartController cartController = Get.find();

  PersistentTabController? _controller;
  // bool _hideNavBar;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.navIndex ?? 0);
    // _hideNavBar = widget.hideNavBar == null ? false : true;
    LanguageAPIService().getLocalizationLanguage(langCode: AppLocalizations.getLanguageCode());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        if (currencyController.isLoading.value) {
          return Scaffold(
            body: Center(
              child: CustomLoadingWidget(),
            ),
          );
        } else {
          return Scaffold(
            body: PersistentTabView(

              context,
              controller: _controller,
              screens: [
                Home(),
                MessageNotifications(),

                CartMain(true),
                loginController.loggedIn.value ? Account() : SignInOrRegister(),
              ],
              confineInSafeArea: true,
              resizeToAvoidBottomInset: true,
              items: [
                PersistentBottomNavBarItem(
                  icon: Image.asset(
                    'assets/images/nav_icon_home.png',
                    color: AppStyles.pinkColor,
                  ),
                  inactiveIcon: Image.asset(
                    'assets/images/nav_icon_home.png',
                    color: AppStyles.greyColorLight,
                  ),
                  title: "Home".tr,
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                  textStyle: TextStyle(fontSize: 10.fontSize)
                ),
                PersistentBottomNavBarItem(
                  icon: Image.asset(
                    'assets/images/nav_icon_message.png',
                    color: AppStyles.pinkColor,
                  ),
                  inactiveIcon: Image.asset(
                    'assets/images/nav_icon_message.png',
                    color: AppStyles.greyColorLight,
                  ),
                  title: ("Notifications".tr),
                  textStyle: TextStyle(fontSize: 10.fontSize),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
                PersistentBottomNavBarItem(
                  icon: Obx(() => badges.Badge(
                            badgeAnimation:
                                badges.BadgeAnimation.fade(toAnimate: false),
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: AppStyles.pinkColor,
                            ),
                            badgeContent: Text(
                              '${cartController.cartListSelectedCount.value.toString()}',
                              style: AppStyles.appFont.copyWith(
                                color: Colors.white,
                                fontSize: 10.fontSize,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/nav_icon_cart.png',
                              color: AppStyles.pinkColor,
                            ),
                          )
                  ),
                  inactiveIcon: Obx(() =>badges.Badge(
                            badgeAnimation:
                                badges.BadgeAnimation.fade(toAnimate: false),
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: AppStyles.pinkColor,
                            ),
                            badgeContent: Text(
                              '${cartController.cartListSelectedCount.value.toString()}',
                              style: AppStyles.appFont.copyWith(
                                color: Colors.white,
                                fontSize: 10.fontSize,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/nav_icon_cart.png',
                              color: AppStyles.greyColorLight,
                            ),
                          )
                  ),
                  title: ("Cart".tr),
                  textStyle: TextStyle(fontSize: 10.fontSize),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),



                PersistentBottomNavBarItem(
                  icon: Image.asset(
                    'assets/images/nav_icon_account.png',
                    color: AppStyles.pinkColor,
                  ),
                  inactiveIcon: Image.asset(
                    'assets/images/nav_icon_account.png',
                    color: AppStyles.greyColorLight,
                  ),
                  title: ("Account".tr),
                  textStyle: TextStyle(fontSize: 10.fontSize),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
              ],
              navBarStyle: NavBarStyle.style8,
              navBarHeight: 70.h,
              bottomScreenMargin: 0,
              handleAndroidBackButtonPress: true,
              stateManagement: true,
              margin: EdgeInsets.zero,
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              onItemSelected: (index) async {
                if (index == 2) {
                  // final CartController cartController =
                  //     Get.put(CartController());
                  await cartController.getCartList();
                }
              },
            ),
          );
        }
      }),
    );
  }
}
