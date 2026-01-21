import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/Settings/SettingsPage.dart';
import 'package:amazcart/view/amazcart_view/account/MyGiftCardsPage.dart';
import 'package:amazcart/view/amazcart_view/account/WishList.dart';
import 'package:amazcart/view/amazcart_view/account/coupons/MyCoupons.dart';
import 'package:amazcart/view/amazcart_view/account/orders/MyCancellations.dart';
import 'package:amazcart/view/amazcart_view/account/orders/RefundAndDisputes/MyRefundsAndDisputes.dart';
import 'package:amazcart/view/amazcart_view/account/reviews/MyReviews.dart';
import 'package:amazcart/view/amazcart_view/support/SupportTicketsPage.dart';
import 'package:amazcart/widgets/amazcart_widget/appbar_back_button.dart';
import 'package:amazcart/widgets/amazcart_widget/dio_exception.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'orders/new_order_module/views/all_order_page.dart';

class Account extends StatefulWidget {
  const Account({super.key, this.enableBackButton = false});

  final bool enableBackButton;
  // @override
  // _AccountState createState() => _AccountState();

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
    });

    print(response);
    if (response!.statusCode == 202) {
      return true;
    } else {
      if (response!.statusCode == 401) {
        SnackBars().snackBarWarning("${"Invalid Access token".tr}. ${"Please re-login".tr}");
        return false;
      } else {
        SnackBars().snackBarError(response!.data);
        return false;
      }
    }
  }

  Future<bool> pickDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
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
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.h,
            backgroundColor: AppStyles.pinkColor,
            titleSpacing: 0,
            leading: widget.enableBackButton? AppBarBackButton(color: Colors.white) : null,
            centerTitle: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 100.h,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                'assets/images/account_appbar_bg.svg',
                fit: BoxFit.cover,
              ),
            ),
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Obx(() {
                    if (loginController.loggedIn.value) {
                      if (loginController.profileData.value.avatar == null) {
                        return GestureDetector(
                          onTap: () async {
                            if (AppConfig.isDemo) {
                              SnackBars().snackBarWarning("Disabled in demo".tr);
                            } else {
                              await pickDocument().then((value) async {
                                if (value) {
                                  await updatePhoto().then((up) async {
                                    if (up) {
                                      SnackBars().snackBarSuccess(
                                          'Updated successfully'.tr);
                                      await loginController.getProfileData();
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
                                color: Colors.white, shape: BoxShape.circle),
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
                              SnackBars().snackBarWarning("Disabled in demo".tr);
                            } else {
                              await pickDocument().then((value) async {
                                if (value) {
                                  await updatePhoto().then((up) async {
                                    if (up) {
                                      SnackBars().snackBarSuccess(
                                          'Updated successfully'.tr);
                                      await loginController.getProfileData();
                                    }
                                  });
                                }
                              });
                            }
                          },
                          child: _file != null
                              ? CircleAvatar(
                                  radius: 30.r,
                                  backgroundImage: FileImage(
                                    _file!,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      '${AppConfig.assetPath}/${loginController.profileData.value.avatar}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    width: 60.w,
                                    height: 60.w,
                                    alignment: Alignment.center,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CachedNetworkImage(
                                    imageUrl:
                                        '${AppConfig.assetPath}/backend/img/default.png',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      width: 60.w,
                                      height: 60.w,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
                  SizedBox(
                    width: 10.w,
                  ),
                  Obx(
                    () => loginController.loggedIn.value
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${loginController.profileData.value.name}',
                                textAlign: TextAlign.left,
                                style: AppStyles.kFontWhite14w5.copyWith(
                                  fontSize: 17.fontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await loginController.accountController
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
                                          'Wallet'.tr + ': ${currencyController.setCurrentSymbolPosition(amount: (loginController.accountController.customerData.value.walletRunningBalance! * currencyController.conversionRate.value).toStringAsFixed(2))}',
                                          textAlign: TextAlign.left,
                                          style: AppStyles.kFontWhite14w5,
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 30.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Text(
                              'Sign in or Register'.tr,
                              textAlign: TextAlign.center,
                              style: AppStyles.appFont.copyWith(
                                color: AppStyles.pinkColor,
                                fontSize: 16.fontSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () {
                      Get.to(() => SettingsPage());
                      // Get.to(() => NotificationSettings());
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Colors.white.withOpacity(0.9),
                      size: 20.w,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    height: 80.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => WishList());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   '3',
                                  //   style: AppStyles.appFont.copyWith(
                                  //     color: AppStyles.pinkColor,
                                  //     fontSize: ScreenUtil().setSp(19),
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Icon(
                                    Icons.widgets_sharp,
                                    color: AppStyles.pinkColor,
                                    size: 20.w,

                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'My Wishlist'.tr,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 12.fontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            InkWell(
                              onTap: () {
                                Get.to(() => MyGiftCardsPage());
                                // Get.to(() => StoreFollowed());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   '12',
                                  //   style: AppStyles.appFont.copyWith(
                                  //     color: AppStyles.pinkColor,
                                  //     fontSize: ScreenUtil().setSp(19),
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Icon(
                                    Icons.card_giftcard,
                                    color: AppStyles.pinkColor,
                                    size: 20.w,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Gift Cards'.tr,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 12.fontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                Get.to(() => MyCoupons());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   '2',
                                  //   style: AppStyles.appFont.copyWith(
                                  //     color: AppStyles.pinkColor,
                                  //     fontSize: ScreenUtil().setSp(19),
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Icon(
                                    Icons.credit_card,
                                    color: AppStyles.pinkColor,
                                    size: 20.w,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Coupons'.tr,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 12.fontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Text(
                      ''.tr,
                      style: AppStyles.appFont.copyWith(
                        color: AppStyles.greyColorLight,
                        fontSize: 12.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTile(
                    onTap: () {
                      // Get.to(
                      //   () => MyOrders(0),
                      // );
                      Get.to(() => DynamicOrderListTabs());
                    },
                    tileColor: Colors.white,
                    leading: SvgPicture.asset(
                      width: 16.w,
                      'assets/images/icon_all_orders.svg',
                    ),
                    title: Text(
                      'All Orders'.tr,
                      style: AppStyles.appFont.copyWith(
                        color: Colors.black,
                        fontSize: 15.fontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: SizedBox(
                      height: 70.h,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => MyCancellations());
                    },
                    tileColor: Colors.white,
                    leading: SvgPicture.asset(
                      width: 16.w,
                      'assets/images/icon_cancellations.svg',
                    ),
                    title: Text(
                      'My Cancellations'.tr,
                      style: AppStyles.appFont.copyWith(
                        color: Colors.black,
                        fontSize: 15.fontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: SizedBox(
                      height: 70.h,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => MyRefundsAndDisputes());
                    },
                    tileColor: Colors.white,
                    leading: SvgPicture.asset(
                      'assets/images/icon_returns.svg',
                      width: 16.w,
                    ),
                    title: Text(
                      'Refunds and Disputes'.tr,
                      style: AppStyles.appFont.copyWith(
                        color: Colors.black,
                        fontSize: 15.fontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: SizedBox(
                      height: 70.h,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.w, right: 20.w, top: 20.h),
                    child: Text(
                      'My Services'.tr,
                      style: AppStyles.appFont.copyWith(
                        color: AppStyles.greyColorLight,
                        fontSize: 12.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => MyReviews(
                            tabIndex: 0,
                          ));
                    },
                    tileColor: Colors.white,
                    leading: SvgPicture.asset(
                      'assets/images/icon_my_reviews.svg',
                      width: 16.w,
                    ),
                    title: Text(
                      'My Review'.tr,
                      style: AppStyles.appFont.copyWith(
                        color: Colors.black,
                        fontSize: 15.fontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => SupportTicketsPage());
                    },
                    tileColor: Colors.white,
                    leading: SvgPicture.asset(
                      'assets/images/icon_need_help.svg',
                      width: 16.w,
                    ),
                    title: Text(
                      'Need Help?'.tr,
                      style: AppStyles.appFont.copyWith(
                        color: Colors.black,
                        fontSize: 15.fontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: SizedBox(
                      height: 70.h,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
