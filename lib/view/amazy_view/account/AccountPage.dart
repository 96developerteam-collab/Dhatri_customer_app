import 'dart:io';
import 'dart:math';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/Settings/AddressBook.dart';
import 'package:amazcart/view/amazy_view/account/MyGiftCardsPage.dart';
import 'package:amazcart/view/amazy_view/account/ProfilePage.dart';
import 'package:amazcart/view/amazy_view/account/WishList.dart';
import 'package:amazcart/view/amazy_view/account/coupons/MyCoupons.dart';
import 'package:amazcart/view/amazy_view/account/orders/MyCancellations.dart';
import 'package:amazcart/view/amazy_view/account/orders/OrderList/MyOrders.dart';
import 'package:amazcart/view/amazy_view/account/orders/RefundAndDisputes/MyRefundsAndDisputes.dart';
import 'package:amazcart/view/amazy_view/authentication/LoginPage.dart';
import 'package:amazcart/view/amazy_view/products/giftCard/AllGiftCardsPage.dart';
import 'package:amazcart/view/amazy_view/support/SupportTicketsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/config.dart';
import '../../../controller/home_controller.dart';
import '../../../widgets/amazcart_widget/dio_exception.dart';
import '../../../widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import '../../../widgets/amazy_widget/snackbars.dart' show SnackBars;
import '../settings/SettingsPage.dart';
import 'orders/new_order_module/views/all_order_page.dart';
import 'reviews/MyReviews.dart';

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final LoginController loginController = Get.put(LoginController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();
  File? _file;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  final picker = ImagePicker();

  Future<bool> updatePhoto() async {
    String token = await userToken.read(tokenKey);

    final file =
        await DIO.MultipartFile.fromFile(_file!.path, filename: '${_file!.path}');

    final formData = DIO.FormData.fromMap({
      'avatar': file,
    });

    response = await dio.post(
      URLs.UPDATE_PROFILE_PHOTO,
      data: formData,
      options: DIO.Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          // print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
    });

    if (response?.statusCode == 202) {
      return true;
    } else {
      if (response?.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(response!.data);
        return false;
      }
    }
  }

  Future<bool> pickDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
      return true;
    } else {
      SnackBars().snackBarWarning('Cancelled'.tr);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (loginController.loggedIn.value) {
          return Scaffold(
            body: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                CustomSliverAppBarWidget(false, false),
                SliverFillRemaining(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ClipPath(
                        clipper: TsClip3(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.22,
                          color: AppStyles.pinkColor,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 30),
                              child: Row(
                                children: [
                                  Obx(() {
                                    if (loginController
                                            .profileData.value.avatar ==
                                        null) {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (AppConfig.isDemo) {
                                            SnackBars().snackBarWarning(
                                                "Disabled in demo".tr);
                                          } else {
                                            await pickDocument()
                                                .then((value) async {
                                              if (value) {
                                                await updatePhoto()
                                                    .then((up) async {
                                                  if (up) {
                                                    SnackBars().snackBarSuccess(
                                                        'Updated successfully'.tr);
                                                    await loginController
                                                        .getProfileData();
                                                  }
                                                });
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 40.w,
                                          width: 40.w,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.add,
                                            color: AppStyles.pinkColor,
                                            size: 20.w,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (AppConfig.isDemo) {
                                            SnackBars().snackBarWarning(
                                                "Disabled in demo".tr);
                                          } else {
                                            await pickDocument()
                                                .then((value) async {
                                              if (value) {
                                                await updatePhoto()
                                                    .then((up) async {
                                                  if (up) {
                                                    SnackBars().snackBarSuccess(
                                                        'Updated successfully'.tr);
                                                    await loginController
                                                        .getProfileData();
                                                  }
                                                });
                                              }
                                            });
                                          }
                                        },
                                        child: _file != null
                                            ? CircleAvatar(
                                                radius: 70.r,
                                                backgroundImage: FileImage(
                                                  _file!,
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    '${AppConfig.assetPath}/${loginController.profileData.value.avatar}',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 2.w,
                                                      )),
                                                  width: 70.w,
                                                  height: 70.w,
                                                  alignment: Alignment.center,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CachedNetworkImage(
                                                  imageUrl:
                                                      '${AppConfig.assetPath}/backend/img/default.png',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                    width: 70.w,
                                                    height: 70.w,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ),
                                      );
                                    }
                                  }),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Obx(
                                    () => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${loginController.profileData.value.name ?? ""}',
                                          textAlign: TextAlign.left,
                                          style: AppStyles.appFontMedium
                                              .copyWith(
                                                  fontSize: 18.fontSize,
                                                  color: Colors.white),
                                        ),
                                        Text(
                                          '${loginController.profileData.value.email ?? ""}',
                                          textAlign: TextAlign.left,
                                          style: AppStyles.appFontBook.copyWith(
                                              fontSize: 14.fontSize,
                                              color: Colors.white),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await loginController
                                                .accountController
                                                .getAccountDetails();
                                          },
                                          child: Container(
                                            height: 25.h,
                                            // color: Colors.blue,
                                            alignment: Alignment.center,
                                            child: loginController
                                                        .accountController
                                                        .customerData
                                                        .value
                                                        .walletRunningBalance !=
                                                    null
                                                ? Text(
                                                    'Wallet'.tr +
                                                        ': ${(loginController.accountController.customerData.value.walletRunningBalance! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                    textAlign: TextAlign.left,
                                                    style: AppStyles.appFontBook
                                                        .copyWith(
                                                      fontSize: 14.fontSize,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    children: [
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      AccountTiles(
                                        title: "Edit Profile".tr,
                                        image: 'assets/images/edit.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {
                                            Get.to(() => ProfilePage());
                                          }
                                        },
                                      ),
                                      AccountTiles(
                                        title: "Shipping Address".tr,
                                        image:
                                            'assets/images/shipping_address.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {
                                            Get.to(() => AddressBook());
                                          }
                                        },
                                      ),
                                      CustomExpansionTile(
                                        title: "My Services".tr,
                                        image: 'assets/images/track_order.png',
                                        children: [
                                          AccountTiles(
                                            title: "Wishlist".tr,
                                            image: 'assets/images/wishlist.png',
                                            onTap: () {
                                              if (!loginController
                                                  .loggedIn.value) {
                                                Get.dialog(LoginPage(),
                                                    useSafeArea: false);
                                              } else {
                                                Get.to(() => WishList());
                                              }
                                            },
                                          ),
                                          AccountTiles(
                                            title: "Coupons".tr,
                                            image:
                                                'assets/images/refund_and_disputes.png',
                                            onTap: () {
                                              if (!loginController
                                                  .loggedIn.value) {
                                                Get.dialog(LoginPage(),
                                                    useSafeArea: false);
                                              } else {
                                                Get.to(() => MyCoupons());
                                              }
                                            },
                                          ),
                                          CustomExpansionTile(
                                            title: "Gift Cards".tr,
                                            image:
                                                'assets/images/my_review.png',
                                            children: [
                                              AccountTiles(
                                                title: "My Gift Cards".tr,
                                                image:
                                                    'assets/images/my_review.png',
                                                onTap: () {
                                                  if (!loginController
                                                      .loggedIn.value) {
                                                    Get.dialog(LoginPage(),
                                                        useSafeArea: false);
                                                  } else {
                                                    Get.to(() =>
                                                        MyGiftCardsPage());
                                                  }
                                                },
                                              ),
                                              AccountTiles(
                                                title: "Purchase Gift Cards".tr,
                                                image:
                                                    'assets/images/my_review.png',
                                                onTap: () {
                                                  if (!loginController
                                                      .loggedIn.value) {
                                                    Get.dialog(LoginPage(),
                                                        useSafeArea: false);
                                                  } else {
                                                    Get.to(() =>
                                                        AllGiftCardPage());
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      AccountTiles(
                                        title: "Need Help?".tr,
                                        image: 'assets/images/need_help.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {
                                            Get.to(() => SupportTicketsPage());
                                          }
                                        },
                                      ),
                                      !loginController.loggedIn.value
                                          ? SizedBox.shrink()
                                          : ListTile(
                                              leading: Container(
                                                height: 40.w,
                                                width: 40.w,
                                                alignment: Alignment.center,
                                                padding:
                                                    EdgeInsets.only(right: 4),
                                                decoration: BoxDecoration(
                                                  color: AppStyles.pinkColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/logout.png',
                                                  height: 15.w,
                                                  width: 15.w,
                                                ),
                                              ),
                                              onTap: () async {
                                                await loginController
                                                    .removeToken();
                                              },
                                              title: Text(
                                                "Logout".tr,
                                                style: AppStyles.appFontBold
                                                    .copyWith(fontSize: 14.fontSize),
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                color: AppStyles.pinkColor,
                                                size: 18.w,
                                              ),
                                            ),

                                      30.h.verticalSpace,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                CustomSliverAppBarWidget(false, false),
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: TsClip3(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.22,
                          color: AppStyles.pinkColor,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 30),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hello".tr +
                                            ", " +
                                            "Welcome to".tr +
                                            " ${AppConfig.appName}",
                                        style: AppStyles.appFontBold.copyWith(
                                          fontSize: 14.fontSize,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.dialog(LoginPage(),
                                              useSafeArea: false);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.r)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 10),
                                          child: Text(
                                            'Sign in or Register'.tr,
                                            textAlign: TextAlign.center,
                                            style: AppStyles.appFontMedium
                                                .copyWith(
                                              color: AppStyles.pinkColor,
                                              fontSize: 14.fontSize,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      AccountTiles(
                                        title: "Edit Profile".tr,
                                        image: 'assets/images/edit.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {}
                                        },
                                      ),
                                      AccountTiles(
                                        title: "Shipping Address".tr,
                                        image:
                                            'assets/images/shipping_address.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {}
                                        },
                                      ),
                                      AccountTiles(
                                        title: "Wishlist".tr,
                                        image: 'assets/images/wishlist.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {}
                                        },
                                      ),
                                      AccountTiles(
                                        title: "Gift Cards".tr,
                                        image: 'assets/images/my_review.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {}
                                        },
                                      ),
                                      AccountTiles(
                                        title: "Coupons".tr,
                                        image:
                                            'assets/images/refund_and_disputes.png',
                                        onTap: () {
                                          if (!loginController.loggedIn.value) {
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          } else {}
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class AccountTiles extends StatelessWidget {
  final String? image;
  final String? title;
  final VoidCallback? onTap;

  AccountTiles({this.onTap, this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40.w,
        width: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 215, 215),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          '$image',
          height: 15.w,
          width: 15.w,
          color: AppStyles.pinkColor,
        ),
      ),
      onTap: onTap,
      title: Text(
        title!,
        style: AppStyles.appFontBold.copyWith(fontSize: 14.fontSize),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppStyles.pinkColor,
        size: 18.w,
      ),
    );
  }
}

class TsClip3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height - 30);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String? image;
  final String? title;
  final List<Widget>? children;
  CustomExpansionTile({this.image, this.title, this.children});
  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  // final GlobalKey expansionTileKey = GlobalKey();

  bool _customTileExpanded = false;

  // void _scrollToSelectedContent(GlobalKey gKey) {
  //   final keyContext = gKey.currentContext;

  //   if (keyContext != null) {
  //     Future.delayed(Duration(milliseconds: 200)).then((value) {
  //       Scrollable.ensureVisible(
  //         keyContext,
  //         duration: Duration(milliseconds: 200),
  //       );
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _customTileExpanded
                ? AppStyles.pinkColorAlt
                : Colors.transparent,
          ),
        ),
        child: ExpansionTile(
          leading: Container(
            height: 40.w,
            width: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 215, 215),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              '${widget.image}',
              height: 15.w,
              width: 15.w,
              color: AppStyles.pinkColor,
            ),
          ),
          title: Text(
            widget.title!,
            style: AppStyles.appFontBold.copyWith(fontSize: 14.fontSize),
          ),
          trailing: _customTileExpanded
              ? Transform.rotate(
                  angle: pi * 0.5,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppStyles.pinkColor,
                    size: 18.w,
                  ),
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  color: AppStyles.pinkColor,
                  size: 18.w,
                ),
          children: widget.children!,
          // children: [
          //   Row(
          //     children: [
          //       SizedBox(
          //         width: 20,
          //       ),
          //       Expanded(
          //         child: Column(
          //           children: widget.children,
          //         ),
          //       )
          //     ],
          //   ),
          // ],
          onExpansionChanged: (bool expanded) {
            // if (expanded) _scrollToSelectedContent(expansionTileKey);
            setState(() => _customTileExpanded = expanded);
          },
        ),
      ),
    );
  }
}
