import 'dart:convert';

import 'package:amazcart/AppConfig/language/app_localizations.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/MyPurchasedGiftCards.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'package:scratcher/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../../widgets/amazy_widget/AppBarWidget.dart';
import '../../../widgets/amazy_widget/BuildIndicatorBuilder.dart';
import '../../../widgets/amazy_widget/CustomDate.dart';
import '../../../widgets/amazy_widget/snackbars.dart';

// ignore: must_be_immutable
class MyGiftCardsPage extends StatefulWidget {
  @override
  _MyGiftCardsPageState createState() => _MyGiftCardsPageState();
}

class _MyGiftCardsPageState extends State<MyGiftCardsPage> {
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();

  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());


  bool freeSelected = false;

  MyGiftCardsLoadMore? source;

  @override
  void initState() {
    source = MyGiftCardsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar:AppBarWidget(
        title: "My Gift Cards".tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),

            Expanded(
              child: LoadingMoreList<GiftCardDatum>(
                ListConfig<GiftCardDatum>(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  indicatorBuilder: BuildIndicatorBuilder(
                    source: source,
                    isSliver: false,
                    name: 'Gift Cards',
                  ).buildIndicator,
                  showGlowLeading: true,
                  itemBuilder: (BuildContext c, GiftCardDatum prod, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          height: 215.5.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                              Align(
                                alignment: Alignment.center,
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            prod.giftCard!.name!,
                                            style: AppStyles.kFontBlack17w5,
                                          ),
                                          Text(
                                            'Validity'.tr +
                                                ': ${CustomDate().formattedDate(prod.giftCard!.startDate)} - ${CustomDate().formattedDate(prod.giftCard!.endDate)}',
                                            style: AppStyles.appFont.copyWith(
                                              color: AppStyles.blackColor,
                                              fontSize: 12.fontSize,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                currencyController.setCurrentSymbolPosition(amount: double.parse(((prod.giftCard?.sellingPrice??0) * currencyController.conversionRate.value).toString()).toPrecision(2).toString()),
                                                style:
                                                AppStyles.appFont.copyWith(
                                                  color: AppStyles.pinkColor,
                                                  fontSize: 20.fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            'Scratch to reveal'.tr,
                                            style: AppStyles.appFont.copyWith(
                                              color: AppStyles.blackColor,
                                              fontSize: 14.fontSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Scratcher(
                                            brushSize: 30,
                                            threshold: 100,
                                            color: AppStyles.pinkColor,
                                            onScratchEnd: () {
                                              FlutterClipboard.copy(
                                                  '${prod.secretCode}')
                                                  .then((value) {
                                                print(
                                                    'copied: ${prod.secretCode}');
                                                SnackBars().snackBarSuccess(
                                                    'Secret Code copied to Clipboard'.tr);
                                              });
                                            },
                                            onChange: (value) => print(
                                                "Scratch progress: $value%"),
                                            onThreshold: () {
                                              FlutterClipboard.copy(
                                                  '${prod.secretCode}')
                                                  .then((value) {
                                                print(
                                                    'copied: ${prod.secretCode}');
                                                SnackBars().snackBarSuccess(
                                                    'Secret Code copied to Clipboard'.tr);
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0.h),
                                              child: Text(
                                                prod.secretCode!,
                                                style:
                                                AppStyles.appFont.copyWith(
                                                  color: AppStyles.blackColor,
                                                  fontSize: 14.fontSize,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                        ],
                                      ),
                                      // PinkButtonWidget(
                                      //   height: 32.h,
                                      //   width: 100.w,
                                      //   btnOnTap: () {},
                                      //   btnText: 'Redeem'.tr,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  sourceList: source!,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyGiftCardsLoadMore extends LoadingMoreBase<GiftCardDatum> {
  bool isSorted = false;
  String sortKey = 'new';

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && length < productsLength) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    GetStorage userToken = GetStorage();
    var tokenKey = 'token';

    String token = await userToken.read(tokenKey);

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      http.Response result;
      MyPurchasedGiftCards? source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + "?lang=${AppLocalizations.getLanguageCode()}"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        } else {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + '?page=$pageIndex&lang=${AppLocalizations.getLanguageCode()}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        }
        if (result.statusCode != 404) {
          final data = jsonDecode(result.body);
          source = MyPurchasedGiftCards.fromJson(data);
          productsLength = source.giftcards!.total;
        } else {
          isSuccess = false;
        }
      } else {
        if (this.length == 0) {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + '?sort_by=$sortKey'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        } else {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS +
                '?sort_by=$sortKey&page=$pageIndex'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        }
        if (result.statusCode != 404) {
          final data = jsonDecode(result.body);
          source = MyPurchasedGiftCards.fromJson(data);
          productsLength = source.giftcards!.total;
        } else {
          isSuccess = false;
        }
      }

      if (pageIndex == 1) {
        this.clear();
      }
      if (result.statusCode != 404) {
        for (var item in source!.giftcards!.data!) {
          this.add(item);
        }

        _hasMore = source.giftcards!.data?.length != 0;
        pageIndex++;
        isSuccess = true;
      } else {}
    } catch (exception, stack) {
      isSuccess = false;
      print("exc $exception");
      print("stk $stack");
    }
    return isSuccess;
  }
}
