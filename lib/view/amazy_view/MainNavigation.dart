import 'dart:ui';
import 'dart:math';
import 'package:amazcart/view/amazy_view/settings/SettingsPage.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:amazcart/widgets/amazy_widget/fa_icon_maker/fa_custom_icon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../AppConfig/app_config.dart';
import '../../AppConfig/language/app_localizations.dart';
import '../../AppConfig/language/languages/language_api_service.dart';
import '../../controller/cart_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/login_controller.dart';
import '../../controller/settings_controller.dart';
import '../../utils/styles.dart';
import 'Home.dart';
import 'SplashScreen.dart';
import 'account/AccountPage.dart';
import 'authentication/LoginPage.dart';
import 'cart/CartMain.dart';
import 'package:amazcart/view/amazy_view/account/orders/OrderList/AllOrdersList.dart';
import 'products/category/browse_category_screen.dart';

// Hexagon clipper for cart icon
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;
    final radius = width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(HexagonClipper oldClipper) => false;
}

// Hexagon border painter for cart icon
class HexagonBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;

  HexagonBorderPainter({
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = _createHexagonPath(size);
    canvas.drawPath(path, borderPaint);
  }

  Path _createHexagonPath(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;
    final radius = width / 2 - borderWidth / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(HexagonBorderPainter oldDelegate) => false;
}

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  PersistentTabController? _controller;
  final GeneralSettingsController _settingsController = Get.put(GeneralSettingsController());

  final LoginController loginController = Get.find<LoginController>();
  final CartController _cartController = Get.find<CartController>();
  @override
  void initState() {
    LanguageAPIService().getLocalizationLanguage(langCode: AppLocalizations.getLanguageCode());
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        if (_settingsController.isLoading.value && !Get.isRegistered<HomeController>()) {
          return SplashScreen();
        } else {

          return Scaffold(
            key: scaffoldkey.value,
            drawer: SettingsPage(),
            body: PersistentTabView(
              context,
              controller: _controller!,
              screens: [
                Home(),
                BrowseCategoryScreen(),
                CartMain(true, false),
                !loginController.loggedIn.value
                    ? LoginPage()
                    : AllOrdersListScreen(),
                AccountPage(),
              ],
              confineInSafeArea: true,
              resizeToAvoidBottomInset: true,
              navBarStyle: NavBarStyle.style15,
              padding:  NavBarPadding.only(left: 5.w, right: 5.w, bottom: 5.h),
              navBarHeight: 55.w,
              bottomScreenMargin: 0,
              handleAndroidBackButtonPress: true,
              stateManagement: true,
              margin: EdgeInsets.zero,
              hideNavigationBarWhenKeyboardShows: true,
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              onItemSelected: (index) async {
                if (index == 2) {
                  await Get.find<CartController>().getCartList();
                }
              },
              decoration: NavBarDecoration(borderRadius: BorderRadius.circular(20.r)),
              items: [
                PersistentBottomNavBarItem(
                  icon: CustomGradientOnChild(
                    child: CustomGradientOnChild(
                      child: Icon(
                        FontAwesomeIcons.home,
                        size: 20.w,
                      ),
                    ),
                  ),
                  inactiveIcon: Icon(
                    FontAwesomeIcons.home,
                    color: AppStyles.greyColorDark,
                    size: 20.w,
                  ),
                  title: "Home".tr,
                  textStyle: AppStyles.appFontBook.copyWith(
                    fontSize: 12.fontSize,
                  ),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
                PersistentBottomNavBarItem(
                  icon: CustomGradientOnChild(
                    child: CustomGradientOnChild(
                      child: Icon(
                        FontAwesomeIcons.bars,
                        size: 20.w,
                      ),
                    ),
                  ),
                  inactiveIcon: Icon(
                    FontAwesomeIcons.bars,
                    color: AppStyles.greyColorDark,
                    size: 20.w,
                  ),
                  title: "Category".tr,
                  textStyle: AppStyles.appFontBook.copyWith(
                    fontSize: 12.fontSize,
                  ),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),

                PersistentBottomNavBarItem(
                  icon: Container(
                    height: 46.w,
                    child: badges.Badge(
                      showBadge: true,
                      position: badges.BadgePosition.topEnd(end: 5.w, top: -8.w),
                      // toAnimate: false,
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.white,
                        padding: EdgeInsets.all(4.w),
                      ),
                      badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
                      badgeContent: Text(
                        '${_cartController.cartListSelectedCount.value}',
                        style: AppStyles.appFontBook.copyWith(
                          color: AppStyles.pinkColor,
                          fontSize: 12.fontSize
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 65.w,
                          width: 65.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              child: SizedBox(
                                child: Image.asset(
                                  'assets/images/cart_icon.png',
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                  height: 25.w,
                                  width: 25.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  inactiveIcon: Container(
                    height: 46.w,
                    child: badges.Badge(
                      // toAnimate: false,
                      showBadge: true,
                      position: badges.BadgePosition.topEnd(end: 5.w, top: -8.w),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.white,
                        padding: EdgeInsets.all(4.w),
                      ),
                      badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
                      badgeContent: Text(
                        '${_cartController.cartListSelectedCount.value.toString()}',
                        style: AppStyles.appFontBook.copyWith(
                          color: AppStyles.pinkColor,
                          fontSize: 12.fontSize
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 65.w,
                          width: 65.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              child: SizedBox(
                                child: Image.asset(
                                  'assets/images/cart_icon.png',
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                  height: 25.w,
                                  width: 25.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: "Cart".tr,
                  textStyle: AppStyles.appFontBook.copyWith(
                    fontSize: 12.fontSize,
                  ),
                  inactiveColorPrimary: AppStyles.greyColorDark,
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorSecondary: AppStyles.greyColorDark,
                  activeColorSecondary: AppStyles.greyColorDark,
                ),

                PersistentBottomNavBarItem(
                  icon: CustomGradientOnChild(
                    child: CustomGradientOnChild(
                      child: Icon(
                        FontAwesomeIcons.history,
                        size: 20.w,
                      ),
                    ),
                  ),
                  inactiveIcon: Icon(
                    FontAwesomeIcons.history,
                    color: AppStyles.greyColorDark,
                    size: 20.w,
                  ),
                  title: "Orders".tr,
                  textStyle: AppStyles.appFontBook.copyWith(
                    fontSize: 12.fontSize,
                  ),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),

                PersistentBottomNavBarItem(
                  icon: CustomGradientOnChild(
                    child: CustomGradientOnChild(
                      child: Icon(
                        FontAwesomeIcons.user,
                        size: 20.w,
                      ),
                    ),
                  ),
                  inactiveIcon: Icon(
                    FontAwesomeIcons.user,
                    color: AppStyles.greyColorDark,
                    size: 20.w,
                  ),
                  title: "Profile".tr,
                  textStyle: AppStyles.appFontBook.copyWith(
                    fontSize: 12.fontSize,
                  ),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class CustomNavigationWidget extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int>? onItemSelected;

  final NavBarDecoration navBarDecoration;
  final NavBarEssentials? navBarEssentials;

  CustomNavigationWidget({
    this.navBarEssentials,
    this.navBarDecoration =   const NavBarDecoration(),
    this.selectedIndex,
    this.onItemSelected,
  });

  Widget _buildItem(BuildContext context, PersistentBottomNavBarItem item,
      bool isSelected, double height) {
    return Container(
      width: 150.0,
      height: height,
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 1, bottom: 1),
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(
                          color: isSelected
                              ? (item.activeColorSecondary == null
                                  ? item.activeColorPrimary
                                  : item.activeColorSecondary)
                              : item.inactiveColorPrimary == null
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary),
                      child:
                       isSelected ? item.icon : item.inactiveIcon ?? item.icon ,
                    ),
                  ),
                ),
                item.title == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Material(
                          type: MaterialType.transparency,
                          child: FittedBox(
                              child: Text(
                            item.title!,
                            style: item.textStyle != null
                                ? (item.textStyle!.apply(
                                    color: isSelected
                                        ? (item.activeColorSecondary == null
                                            ? item.activeColorPrimary
                                            : item.activeColorSecondary)
                                        : item.inactiveColorPrimary))
                                : TextStyle(
                                    color: isSelected
                                        ? (item.activeColorSecondary == null
                                            ? item.activeColorPrimary
                                            : item.activeColorSecondary)
                                        : item.inactiveColorPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0),
                          )),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleItem(
      PersistentBottomNavBarItem item, bool isSelected, double height) {
    return Padding(
      padding: EdgeInsets.only(
          top: kTabLabelPadding.top ?? 0.0,
          bottom: kTabLabelPadding.bottom ?? 0.0),
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0, 6),
            child: Center(
              child: Container(
                width: 150.0,
                height: height,
                margin: EdgeInsets.only(top: 0.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.activeColorPrimary,
                  border: Border.all(color: Colors.transparent, width: 5.0),
                  boxShadow: this.navBarDecoration.boxShadow,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  child: IconTheme(
                    data: IconThemeData(
                        size: item.iconSize,
                        color: item.activeColorSecondary == null
                            ? item.activeColorPrimary
                            : item.activeColorSecondary),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: item.inactiveIcon,
                    ),
                  ),
                ),
              ),
            ),
          ),
          item.title == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      type: MaterialType.transparency,
                      child: FittedBox(
                          child: Text(
                        item.title!,
                        style: item.textStyle != null
                            ? (item.textStyle!.apply(
                                color: isSelected
                                    ? (item.activeColorSecondary == null
                                        ? item.activeColorPrimary
                                        : item.activeColorSecondary)
                                    : item.inactiveColorPrimary))
                            : TextStyle(
                                color: isSelected
                                    ? (item.activeColorPrimary)
                                    : item.inactiveColorPrimary,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                      )),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarEssentials!.items!.length / 2).floor();
    return Container(
      color: Colors.yellow,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius:
                this.navBarDecoration.borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: this.navBarEssentials!.items![selectedIndex!].filter ??
                  ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: this.navBarEssentials!.items!.map((item) {
                  int index = this.navBarEssentials!.items!.indexOf(item);
                  return Flexible(
                    child: GestureDetector(
                      onTap: () {
                        onItemSelected!(index);
                      },
                      child: index == midIndex
                          ? Container(width: 150, color: Colors.transparent)
                          : _buildItem(
                              context, item, selectedIndex == index, 150),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
                onTap: () {
                  onItemSelected!(midIndex);
                },
                child: _buildMiddleItem(this.navBarEssentials!.items![midIndex],
                    selectedIndex == midIndex, kBottomNavigationBarHeight)),
          )
        ],
      ),
    );
  }
}
