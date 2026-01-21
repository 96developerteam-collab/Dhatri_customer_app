import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/gift_card_controller.dart';
import 'package:amazcart/model/AllGiftCardsModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/AppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/grid_view_gift_card_widget.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../../AppConfig/language/app_localizations.dart';
import '../../../../config/config.dart';
import '../../../../controller/product_controller.dart';

// ignore: must_be_immutable
class AllGiftCardPage extends StatefulWidget {
  @override
  _AllGiftCardPageState createState() => _AllGiftCardPageState();
}

class _AllGiftCardPageState extends State<AllGiftCardPage> {
  final ProductController controller = Get.put(ProductController());
  // final CartController cartController = Get.put(CartController());
  final CartController cartController = Get.find();

  final GiftCardController giftCardController = Get.put(GiftCardController());

  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());

  // Sorting _selectedSort;

  bool freeSelected = false;

  Future<void> onRefresh() async {
    print('onref');
    controller.allProducts.clear();
    controller.productPageNumber.value = 1;
    controller.productLastPage.value = false;
    await controller.getAllProducts();
  }

  AllGiftCardsLoadMore? source;

  @override
  void initState() {
    source = AllGiftCardsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();

    super.dispose();
  }

  String calculatePrice(GiftCardsUIModel prod) {
    String priceText;
    if ((prod.giftCardEndDate?.millisecondsSinceEpoch ?? 0) <
        DateTime.now().millisecondsSinceEpoch) {
      priceText =
          ((prod.sellingPrice ?? 0) * currencyController.conversionRate.value)
              .toString();
    } else {
      if (prod.discountType == 0) {
        priceText = (((prod.sellingPrice ?? 0) - (((prod.discount ?? 0) / 100) * (prod.sellingPrice ?? 0))) *
            currencyController.conversionRate.value)
            .toString();
      } else {
        priceText = (((prod.sellingPrice ?? 0) - (prod.discount ?? 0)) *
            currencyController.conversionRate.value)
            .toString();
      }
    }
    return priceText;
  }

  String calculateMainPrice(GiftCardsUIModel productModel) {
    String amountText;

    if ((productModel.discount ?? 0) > 0) {
      amountText = ((productModel.sellingPrice ?? 0) *
          currencyController.conversionRate.value)
          .toString();
    } else {
      amountText = '';
    }

    return amountText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar:AppBarWidget(
          title: "Browse Gift Cards".tr,
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            children: [

              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: LoadingMoreList<GiftCardsUIModel>(
                  ListConfig<GiftCardsUIModel>(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    indicatorBuilder: BuildIndicatorBuilder(
                      source: source,
                      isSliver: false,
                      name: 'Gift Card'.tr,
                    ).buildIndicator,
                    extendedListDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder:
                        (BuildContext c, GiftCardsUIModel prod, int index) {
                      return GridViewGiftCardWidget(
                        giftCardsUIModel: prod,
                      );
                    },
                    sourceList: source!,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class AllGiftCardsLoadMore extends LoadingMoreBase<GiftCardsUIModel> {
  bool isSorted = false;
  String sortKey = 'new';

  final ProductController controller = Get.put(ProductController());

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
    DIO.Dio _dio = DIO.Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      DIO.Response result;
      AllGiftCardsModel? source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await _dio
              .get(
              URLs.ALL_GIFT_CARDS,
              queryParameters: {
                "lang" : AppLocalizations.getLanguageCode()
              }
          )
              .catchError((onError) {
            print('ERROR');
            this.length = 0;
          });
        } else {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'page': pageIndex,
            "lang" : AppLocalizations.getLanguageCode()
          }).catchError((onError) {
            print('ERROR');
          });
        }
        if (result != null) {
          print(result.statusCode);
          final data = new Map<String, dynamic>.from(result.data);
          source = AllGiftCardsModel.fromJson(data);
          productsLength = source.giftCards?.length??0;
        }
      } else {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'sort_by': sortKey,
            "lang" : AppLocalizations.getLanguageCode()
          });
        } else {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'sort_by': sortKey,
            'page': pageIndex,
            "lang" : AppLocalizations.getLanguageCode()
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllGiftCardsModel.fromJson(data);
        productsLength = source.giftCards?.length??0;
      }

      if (source != null) {
        if (pageIndex == 1) {
          this.clear();
        }
        for (var item in source.giftCards ?? []) {
          this.add(item);
        }

        _hasMore = source.giftCards?.length != 0;
        pageIndex++;
        isSuccess = true;
      }
    } catch (exception, stack) {
      isSuccess = false;
      print('Exception => $exception');
      print('Stack => $stack');
    }
    return isSuccess;
  }
}
