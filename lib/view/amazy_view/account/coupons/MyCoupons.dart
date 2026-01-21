// import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazcart/controller/my_coupon_controller.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../AppConfig/app_config.dart';
import '../../../../controller/account_controller.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/amazy_widget/AppBarWidget.dart';
import '../../../../widgets/amazy_widget/ButtonWidget.dart';
import '../../../../widgets/amazy_widget/CustomDate.dart';
import '../../../../widgets/amazy_widget/PinkButtonWidget.dart';
import '../../../../widgets/amazy_widget/custom_loading_widget.dart';
import '../../../../widgets/amazy_widget/snackbars.dart';
import 'CouponDetails.dart';

class MyCoupons extends StatefulWidget {
  @override
  _MyCouponsState createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {
  final MyCouponController couponController = Get.put(MyCouponController());

  final AccountController accountController = Get.put(AccountController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController couponCodeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: "My Coupons".tr,
      ),
      body: Obx(() {
        if (couponController.isLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (couponController.myCoupons.value.coupons == null ||
              couponController.myCoupons.value.coupons?.length == 0) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    foregroundColor: AppStyles.pinkColor,
                    backgroundColor: AppStyles.pinkColor,
                    radius: 30.r,
                    child: Container(
                      color: AppStyles.pinkColor,
                      child: Image.asset(
                          AppConfig.appLogo,
                          width: 30.w,
                          height: 30.w
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'No Coupons found'.tr,
                    textAlign: TextAlign.center,
                    style: AppStyles.kFontPink15w5.copyWith(
                      fontSize: 16.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return Container(
          color: AppStyles.appBackgroundColor,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            itemCount: couponController.myCoupons.value.coupons?.length??0,
            separatorBuilder: (context, index) {
              return Divider(
                height: 20.h,
              );
            },
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slidable(
                    //actionPane: SlidableDrawerActionPane(),
                    //actionExtentRatio: 0.25,
                    startActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        Stack(
                          fit: StackFit.expand,
                          children: [
                            SlidableAction(
                              label: 'Delete'.tr,
                              backgroundColor: Colors.red,
                              icon: Icons.delete_forever,
                              onPressed: (context) async {
                                await couponController
                                    .deleteCoupon(couponController.myCoupons.value.coupons?[index].id)
                                    .then((value) {
                                  if (value.keys.first) {
                                    SnackBars().snackBarSuccess(
                                        value.values
                                            .toString()
                                            .capitalizeFirst);
                                    couponController.myCoupons.value.coupons?.remove(couponController.myCoupons.value.coupons?[index]);
                                  } else {
                                    SnackBars().snackBarError(
                                        value.values
                                            .toString()
                                            .capitalizeFirst);
                                  }
                                });
                                setState(() {});
                              },
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 4.0,
                                dashLength: 4.0,
                                dashColor: Colors.white,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 4.0,
                                dashLength: 4.0,
                                dashColor: Colors.white,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    endActionPane:
                    ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        Stack(
                          fit: StackFit.expand,
                          children: [
                            SlidableAction(
                              label: 'Delete'.tr,
                              backgroundColor: Colors.red,
                              icon: Icons.delete_forever,
                              onPressed: (context) async {
                                await couponController
                                    .deleteCoupon(couponController
                                    .myCoupons.value.coupons?[index].id)
                                    .then((value) {
                                  if (value.keys.first) {
                                    SnackBars().snackBarSuccess(
                                        value.values
                                            .toString()
                                            .capitalizeFirst);
                                    couponController.myCoupons.value.coupons?.remove(couponController.myCoupons.value.coupons?[index]);
                                  } else {
                                    SnackBars().snackBarError(
                                        value.values
                                            .toString()
                                            .capitalizeFirst);
                                  }
                                });
                                setState(() {});
                              },
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 4.0,
                                dashLength: 4.0,
                                dashColor: Colors.white,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 4.0,
                                dashLength: 4.0,
                                dashColor: Colors.white,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    child: Container(
                      height: 116.h,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/voucher_bg.png',
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 4.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.white,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 4.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.white,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 20.w,
                            top: 15.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  couponController.myCoupons.value.coupons?[index].coupon?.title?.capitalizeFirst??'',
                                  style: AppStyles.appFont.copyWith(
                                    color: AppStyles.blackColor,
                                    fontSize: 14.fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 6.0),
                                          child: couponController
                                              .myCoupons
                                              .value
                                              .coupons![index]
                                              .coupon!
                                              .discountType ==
                                              0
                                              ? Text(
                                            '%',
                                            style: AppStyles.appFont
                                                .copyWith(
                                              color: AppStyles.pinkColor,
                                              fontSize: 16.fontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                              : Text(
                                            '${currencyController.appCurrency
                                                .value}',
                                            style: AppStyles.appFont
                                                .copyWith(
                                              color: AppStyles.pinkColor,
                                              fontSize: 16.fontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        couponController
                                            .myCoupons
                                            .value
                                            .coupons![index]
                                            .coupon!
                                            .discountType ==
                                            0
                                            ? Text(
                                          '${couponController.myCoupons.value
                                              .coupons?[index].coupon!
                                              .discount??0}',
                                          style:
                                          AppStyles.appFont.copyWith(
                                            color: AppStyles.pinkColor,
                                            fontSize: 30.fontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                            : Text(
                                          double.parse((currencyController
                                              .conversionRate
                                              .value *
                                              couponController
                                                  .myCoupons
                                                  .value
                                                  .coupons![index]
                                                  .coupon!
                                                  .discount)
                                              .toString())
                                              .toStringAsFixed(2),
                                          style:
                                          AppStyles.appFont.copyWith(
                                            color: AppStyles.pinkColor,
                                            fontSize: 30.fontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(bottom: 4.0, left: 2),
                                      child: Text(
                                        'OFF'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          color: AppStyles.pinkColor,
                                          fontSize: 14.fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 20.w,
                            bottom: 15.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        PinkButtonWidget(
                                          width: 83.w,
                                          height: 38.h,
                                          btnOnTap: () {
                                            Get.to(
                                                  () =>
                                                  CouponDetails(
                                                    coupon: couponController.myCoupons.value.coupons?[index].coupon,
                                                  ),
                                            );
                                          },
                                          btnText: 'Details'.tr,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'Validity'.tr +
                                              ': ${CustomDate().formattedDate(
                                                  couponController.myCoupons
                                                      .value.coupons![index]
                                                      .coupon!
                                                      .startDate)} - ${CustomDate()
                                                  .formattedDate(
                                                  couponController.myCoupons
                                                      .value.coupons![index]
                                                      .coupon!.endDate)}',
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.blackColor,
                                            fontSize: 12.fontSize,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  couponController.myCoupons.value.coupons?[index].coupon!
                      .couponType ==
                      2
                      ? Column(
                    children: [
                      SizedBox(height: 5.fontSize),
                      couponController.myCoupons.value.coupons?[index]
                          .coupon?.minimumShopping !=
                          null
                          ? Text(
                        'Spend'.tr +
                            ' ${currencyController.setCurrentSymbolPosition(
                                amount: double.parse(
                                    (currencyController.conversionRate.value * (couponController.myCoupons.value.coupons?[index].coupon?.minimumShopping??0)).toString())
                                    .toStringAsFixed(2))} ' +
                            'get up-to'.tr +
                            ' ${currencyController.setCurrentSymbolPosition(
                                amount: double.parse(
                                    (currencyController.conversionRate.value *
                                        (couponController.myCoupons.value.coupons?[index].coupon?.maximumDiscount??0)).toString())
                                    .toStringAsFixed(2))} off',
                        style: AppStyles.appFont.copyWith(
                          color: AppStyles.pinkColor,
                          fontSize: 14.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                          : Container(),
                    ],
                  )
                      : couponController.myCoupons.value.coupons?[index].coupon!
                      .couponType ==
                      3
                      ? couponController.myCoupons.value.coupons![index]
                      .coupon!.maximumDiscount !=
                      null
                      ? Text(
                    'Free Shipping up-to'.tr +
                        ' ${double.parse(
                            (currencyController.conversionRate.value *
                                (couponController.myCoupons.value.coupons?[index]
                                    .coupon?.maximumDiscount??0)).toString())
                            .toStringAsFixed(2)}${currencyController.appCurrency
                            .value}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.pinkColor,
                      fontSize: 14.fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : Container()
                      : SizedBox(
                    height: 5.h,
                  ),
                ],
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Container(
        height: 70.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                RxBool cleanCouponsText = false.obs;
                Get.bottomSheet(
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            width: 40.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Color(0xffDADADA),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.r),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Add Coupon'.tr,
                            style: AppStyles.appFont.copyWith(
                              color: Colors.black,
                              fontSize: 16.fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Coupon Code'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 12.fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Color(0xffF6FAFC),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            child: TextFormField(
                              controller: couponCodeCtrl,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              onChanged: (v) {
                                if (v.isEmpty) {
                                  cleanCouponsText.value = false;
                                } else {
                                  cleanCouponsText.value = true;
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                suffixIcon: Obx(() {
                                  return Visibility(
                                    visible: cleanCouponsText.value,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        couponCodeCtrl.clear();
                                        cleanCouponsText.value = false;
                                      },
                                    ),
                                  );
                                }),
                                hintText: 'Enter Coupon Code'.tr,
                                hintMaxLines: 4,
                                hintStyle: AppStyles.appFont.copyWith(
                                  color: Colors.grey,
                                  fontSize: 15.fontSize,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 15.fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value?.length == 0) {
                                  return 'Type Coupon code'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.fontSize,
                          ),
                          ButtonWidget(
                            buttonText: 'Add'.tr,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await couponController
                                    .addCoupon(couponCodeCtrl.text);
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.w),
                          ),
                        ],
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  backgroundColor: Colors.white,
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: 140.w,
                height: 35.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(color: AppStyles.pinkColor)),
                child: Text(
                  'Add Coupon'.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.pinkColor,
                    fontSize: 14.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
