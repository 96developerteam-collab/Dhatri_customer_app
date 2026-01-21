import 'dart:developer';

import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Filter/FilterAttributeValue.dart';
import 'package:amazcart/model/NewModel/Filter/FilterColor.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazcart_view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/widgets/amazcart_widget/PinkButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:amazcart/widgets/amazcart_widget/BlueButtonWidget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class BrandFilterDrawer extends StatefulWidget {
  final int? brandId;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final BrandProductsLoadMore? source;

  BrandFilterDrawer({this.brandId, this.scaffoldKey, this.source});

  @override
  _BrandFilterDrawerState createState() => _BrandFilterDrawerState();
}

class _BrandFilterDrawerState extends State<BrandFilterDrawer> {
  final HomeController controller = Get.put(HomeController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  RangeValues? _currentRangeValues;
  bool showRange = false;

  double _lowerValue = 0.0;
  double _upperValue = 0.0;

  @override
  void initState() {
    if (controller.brandAllData.value.lowestPrice != null &&
        ((controller.brandAllData.value.lowestPrice??0) <
            (controller.brandAllData.value.heightPrice??0))) {
      showRange = true;

      _lowerValue = (controller.brandAllData.value.lowestPrice??0).toDouble();
      _upperValue = (controller.brandAllData.value.heightPrice??0).toDouble();

      print('LOW PRICE $_lowerValue');
      print('HIGH PRICE $_upperValue');

      _currentRangeValues = RangeValues(_lowerValue, _upperValue);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width * 0.7,
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Filter Products'.tr,
                style: AppStyles.kFontBlack14w5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            //Category
            controller.subCatsInBrands.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppStyles.textFieldFillColor,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Child Category'.tr,
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  )
                : Container(),

            (controller.subCatsInBrands.length??0) > 0
                ? Builder(
                    builder: (context) {

                      final _items = (controller.subCatsInBrands??[])
                          .map((category) => MultiSelectItem<CategoryData?>(
                              category, category.name ?? ''))
                          .toList();

                      return MultiSelectChipField<CategoryData?>(
                        items: _items,
                        scroll: false,
                        searchable: false,
                        showHeader: false,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        itemBuilder: (item, state) {
                          return Card(
                            color:
                            controller.selectedBrandCat.contains(item.value)
                                ? AppStyles.darkBlueColor
                                : Colors.white,
                            elevation:
                            controller.selectedBrandCat.contains(item.value)
                                ? 5
                                : 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Container(
                              height: 30.h,
                              child: MaterialButton(
                                onPressed: () async {
                                  state.didChange(controller.selectedBrandCat);

                                  // if (controller.selectedBrandCat.contains(item.value)) {
                                  //   controller.selectedBrandCat.remove(item.value);
                                  //
                                  //   controller.subCatFilter.value.filterTypeValue?.remove(item.value?.id.toString());
                                  //
                                  //   controller.dataFilterCat.value.filterDataFromCat?.filterType?.where((element) =>
                                  //   element.filterTypeId == 'cat').toList().remove(controller.subCatFilter.value);
                                  //
                                  //   await doFilter();
                                  // }

                                  if (controller.selectedBrandCat.contains(item.value)) {
                                    controller.selectedBrandCat.remove(item.value);

                                    // controller.subCatFilter.value.filterTypeValue?.remove(item.value?.id.toString());

                                    // controller.dataFilterCat.value.filterDataFromCat?.filterType?.where((element) => element.filterTypeId == 'cat').toList().remove(controller.subCatFilter.value);

                                    var catIndex = controller.dataFilterCat.value.filterDataFromCat?.filterType?.indexWhere((element) => element.filterTypeId == 'cat');

                                    if(catIndex != -1){

                                      var tempCat = controller.dataFilterCat.value.filterDataFromCat?.filterType?[catIndex!].filterTypeValue;
                                      tempCat?.remove(item.value?.id);

                                    }

                                    if(controller.selectedBrandCat.isEmpty && catIndex != -1){
                                      controller.dataFilterCat.value.filterDataFromCat?.filterType?[catIndex!].filterTypeValue?.clear();
                                    }

                                    await doFilter();
                                  }
                                  else {


                                    // controller.selectedBrandCat.add(item.value??CategoryData());
                                    // controller.subCatFilter.value.filterTypeValue?.add(item.value?.id.toString());
                                    //
                                    // controller.dataFilterCat.value.filterDataFromCat?.filterType?.add(controller.subCatFilter.value);


                                    controller.dataFilterCat.value.filterDataFromCat?.filterType?.forEach((element) {
                                      if (element.filterTypeId == 'cat') {
                                        controller.selectedBrandCat.add(item.value??CategoryData());

                                        var index =  element.filterTypeValue?.indexWhere((v)=> v == item.value?.id);
                                        if(index == -1){
                                          element.filterTypeValue?.add(item.value?.id);
                                        }
                                      }
                                    });


                                    await doFilter();
                                  }
                                },
                                child: Text(item.value?.name ?? '',
                                    style: controller.selectedBrandCat
                                        .contains(item.value)
                                        ? AppStyles.kFontWhite14w5
                                        : AppStyles.kFontBlack14w5),
                              ),
                            ),
                          );
                        },
                      );



                    },
                  )
                : Container(),

            (controller.brandAllData.value.attributes?.length ?? 0) > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.brandAllData.value.attributes?.length,
                    itemBuilder: (context, attIndex) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: AppStyles.textFieldFillColor,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  '${controller.brandAllData.value.attributes?[attIndex].name}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
                          ),
                          (controller.brandAllData.value.attributes?[attIndex].values?.length ?? 0) > 0
                              ? Builder(
                                  builder: (context) {
                                    final _items = controller.brandAllData.value
                                        .attributes?[attIndex].values
                                        ?.map((attribute) => MultiSelectItem<
                                                FilterAttributeValue>(
                                            attribute, attribute.value ?? ''))
                                        .toList();
                                    return MultiSelectChipField<FilterAttributeValue>(
                                      items: _items ?? [],
                                      scroll: false,
                                      searchable: false,
                                      showHeader: false,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: Colors.white),
                                      ),
                                      itemBuilder: (MultiSelectItem<FilterAttributeValue?>? item, FormFieldState<List<FilterAttributeValue?>> state) {
                                        final itemValue = item?.value;
                                        return Card(
                                          color: controller.selectedBrandAttribute.contains(itemValue)
                                              ? AppStyles.darkBlueColor
                                              : Colors.white,
                                          elevation: controller.selectedBrandAttribute.contains(itemValue)
                                              ? 5
                                              : 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: Container(
                                            height: 30.h,
                                            constraints: BoxConstraints(maxWidth: 200),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                state.didChange(controller.selectedBrandAttribute);

                                                if (controller.selectedBrandAttribute.contains(itemValue)) {
                                                  controller.selectedBrandAttribute.remove(itemValue);

                                                  await controller.removeBrandFilterAttribute(
                                                    isColor: false,
                                                    typeId: controller.brandAllData.value.attributes?[attIndex].id.toString() ?? '',
                                                    value: itemValue,
                                                  );

                                                  await doFilter();
                                                } else {
                                                  controller.selectedBrandAttribute.add(itemValue ?? FilterAttributeValue());
                                                  await controller.addBrandFilterAttribute(
                                                    isColor: false,
                                                    typeId: controller.brandAllData.value.attributes?[attIndex].id.toString() ?? '',
                                                    value: itemValue,
                                                  );

                                                  await doFilter();
                                                }
                                              },
                                              child: Text(
                                                itemValue?.value ?? '',
                                                style: controller.selectedBrandAttribute.contains(itemValue)
                                                    ? AppStyles.kFontWhite14w5
                                                    : AppStyles.kFontBlack14w5,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );


                                  },
                                )
                              : Container(),
                        ],
                      );
                    })
                : Container(),

            //Color
            controller.brandAllData.value.color != null
                ? (controller.brandAllData.value.color?.values?.length ?? 0) > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppStyles.textFieldFillColor,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Color'.tr,
                              style: AppStyles.kFontBlack12w4,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    : Container()
                : Container(),

            controller.brandAllData.value.color != null
                ? (controller.brandAllData.value.color?.values?.length ?? 0) > 0
                    ? Builder(
                        builder: (context) {
                          final _items = controller
                              .brandAllData.value.color?.values
                              ?.map((attribute) =>
                                  MultiSelectItem<FilterColorValue>(
                                      attribute, attribute.value ?? ''))
                              .toList();
                          return MultiSelectChipField<FilterColorValue>(
                            items: _items ?? [],
                            scroll: false,
                            searchable: false,
                            showHeader: false,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            itemBuilder: (MultiSelectItem<FilterColorValue?>? item, FormFieldState<List<FilterColorValue?>> state) {
                              var bgColor = 0;
                              if (item?.value?.value?.contains('#') == true) {
                                bgColor = controller.getBGColor(item?.value?.value ?? '');
                              } else {
                                bgColor = controller.colourNameToHex(item?.value?.value ?? '');
                              }
                              return Container(
                                height: 30.h,
                                constraints: BoxConstraints(maxWidth: 200),
                                child: GestureDetector(
                                  onTap: () async {
                                    state.didChange(controller.selectedBrandColorValue);
                                    if (controller.selectedBrandColorValue.contains(item?.value)) {
                                      controller.selectedBrandColorValue.remove(item?.value);
                                      await controller.removeBrandFilterAttribute(
                                        isColor: true,
                                        typeId: controller.brandAllData.value.color?.id.toString() ?? '',
                                        colorValue: item?.value,
                                      );
                                      await doFilter();
                                    } else {
                                      controller.selectedBrandColorValue.add(item?.value ?? FilterColorValue());
                                      await controller.addBrandFilterAttribute(
                                        isColor: true,
                                        typeId: controller.brandAllData.value.color?.id.toString() ?? '',
                                        colorValue: item?.value,
                                      );
                                      await doFilter();
                                    }
                                  },
                                  child: Container(
                                    width: 50.w,
                                    height: 50.w,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                                            margin: EdgeInsets.symmetric(vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: Color(bgColor),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: controller.selectedBrandColorValue.contains(item?.value) ? 3 : 0.1,
                                                color: controller.selectedBrandColorValue.contains(item?.value) ? Colors.pink : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        controller.selectedBrandColorValue.contains(item?.value)
                                            ? Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 1
                                              )
                                            ],
                                            size: 18.w,
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        },
                      )
                    : Container()
                : Container(),

            //Price Range
            showRange
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppStyles.textFieldFillColor,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          'Price Range'.tr +
                              ' (${currencyController.appCurrency.value})',
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                    ],
                  )
                : Container(),

            showRange
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: FlutterSlider(
                      values: [_lowerValue + 1, _upperValue - 1],
                      min: (controller.brandAllData.value.lowestPrice??0).toDouble(),
                      max: (controller.brandAllData.value.heightPrice??0).toDouble(),
                      onDragCompleted:
                          (handlerIndex, lowerValue, upperValue) async {
                        print('UPPER $lowerValue LOWER $upperValue');

                        controller.lowRangeBrandCtrl.text =
                            lowerValue.toString();
                        controller.highRangeBrandCtrl.text =
                            upperValue.toString();

                        _lowerValue = lowerValue;
                        _upperValue = upperValue;

                        setState(() {});

                        controller
                            .dataFilterCat.value.filterDataFromCat?.filterType
                            ?.forEach((element) {
                          if (element.filterTypeId == 'price_range') {
                            element.filterTypeValue?.clear();
                            element.filterTypeValue?.add([
                              controller.lowRangeBrandCtrl.text,
                              controller.highRangeBrandCtrl.text,
                            ]);
                          }
                        });

                        await doFilter();
                      },
                      rangeSlider: true,
                      handler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Material(
                          type: MaterialType.circle,
                          color: AppStyles.pinkColor,
                          elevation: 3,
                          child: Container(
                              child: Icon(
                            Icons.circle,
                            size: 25,
                            color: AppStyles.pinkColor,
                          )),
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Material(
                          type: MaterialType.circle,
                          color: AppStyles.pinkColor,
                          elevation: 3,
                          child: Container(
                              child: Icon(
                            Icons.circle,
                            size: 25,
                            color: AppStyles.pinkColor,
                          )),
                        ),
                      ),
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBar: BoxDecoration(
                          color: AppStyles.mediumPinkColor,
                          // border: Border.all(width: 3, color: Colors.blue),
                        ),
                        activeTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          color: AppStyles.pinkColor,
                        ),
                      ),
                      hatchMark: FlutterSliderHatchMark(
                        disabled: true,
                      ),
                    ),
                  )
                : Container(),

            showRange
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: controller.lowRangeBrandCtrl,
                          scrollPhysics: AlwaysScrollableScrollPhysics(),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText:
                                '${_currentRangeValues?.start.round().toString()}',
                            fillColor: AppStyles.appBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10.w),
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
                            hintStyle:
                                AppStyles.kFontGrey12w5.copyWith(fontSize: 13.fontSize),
                          ),
                          style: AppStyles.kFontBlack13w5,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        ' - ',
                        style: AppStyles.kFontBlack12w4,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: controller.highRangeBrandCtrl,
                          scrollPhysics: AlwaysScrollableScrollPhysics(),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText:
                                '${_currentRangeValues?.end.round().toString()}',
                            fillColor: AppStyles.appBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10.w),
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
                            hintStyle:
                                AppStyles.kFontGrey12w5.copyWith(fontSize: 13),
                          ),
                          style: AppStyles.kFontBlack13w5,
                        ),
                      ),
                    ]),
                  )
                : Container(),

            SizedBox(
              height: 10.h,
            ),
            //Rating

            SizedBox(
              height: 5.h,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                'Rating'.tr,
                style: AppStyles.kFontBlack12w4,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: controller.filterRating.value,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    glow: false,
                    itemSize: 20.w,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppStyles.goldenYellowColor,
                      size: 10.w,
                    ),
                    onRatingUpdate: (rating) async {
                      print(rating);
                      controller.filterRating.value = rating;

                      controller
                          .dataFilterCat.value.filterDataFromCat?.filterType
                          ?.forEach((element) {
                        if (element.filterTypeId == 'rating') {
                          element.filterTypeValue?.clear();
                          element.filterTypeValue?.add(rating.toInt());
                        }
                      });

                      await doFilter();
                    },
                  ),
                  Obx(() {
                    return Text(
                      '${controller.filterRating.value.toString()} ' +
                          'and Up'.tr,
                      style: AppStyles.kFontBlack12w4,
                    );
                  })
                ],
              ),
            ),

            //Button
            SizedBox(
              height: 10.h,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              Expanded(
                child: BlueButtonWidget(
                  height: 40.h,
                  btnText: 'Reset'.tr,
                  btnOnTap: () async {
                    controller.categoryId.value = controller.categoryIdBeforeFilter.value;
                    controller.allBrandProducts.clear();
                    controller.subCatsInBrands.clear();
                    controller.lastBrandPage.value = false;
                    controller.filterPageNumber.value = 1;
                    if (controller.dataFilterCat.value.filterDataFromCat !=
                        null) {
                      controller
                          .dataFilterCat.value.filterDataFromCat?.filterType
                          ?.forEach((element) {
                        if (element.filterTypeId == 'brand' ||
                            element.filterTypeId == 'cat') {
                          print(element.filterTypeId);
                          element.filterTypeValue?.clear();
                        }
                      });
                    }
                    controller.getBrandFilterData();
                    controller.getBrandProducts();
                    //
                    // Get.toNamed('/productsByBrands');

                    controller.filterSortKey.value = 'new';

                    widget.source?.isFilter = false;
                    widget.source?.isSorted = false;
                    widget.source?.refresh(true);
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: PinkButtonWidget(
                  height: 40.h,
                  btnText: 'Apply Filter'.tr,
                  btnOnTap:()=>doFilter(isApply : true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future doFilter({bool isApply = false}) async {
    controller.dataFilterCat.value.filterDataFromCat?.filterType
        ?.forEach((element) {
      if (element.filterTypeId == 'price_range') {
        element.filterTypeValue?.clear();
        element.filterTypeValue?.add([
          controller.lowRangeBrandCtrl.text,
          controller.highRangeBrandCtrl.text,
        ]);
      }
    });

    controller.dataFilterCat.value.filterDataFromCat?.filterType
        ?.forEach((element) {
      if (element.filterTypeId == 'rating') {
        element.filterTypeValue?.clear();
        element.filterTypeValue
            ?.add(controller.filterRating.value.toInt().toString());
      }
    });
    controller.filterPageNumber.value = 1;
    controller.lastBrandPage.value = false;

    controller.filterSortKey.value = 'new';

    widget.source?.isFilter = true;
    widget.source?.isSorted = true;
    widget.source?.refresh(true);

    if(isApply){
      Get.back();
    }

  }
}
