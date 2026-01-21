import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/support/CreateTicketPage.dart';
import 'package:amazcart/widgets/amazcart_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class TicketIndicator {
  final dynamic source;
  final bool? isSliver;
  final String? name;

  TicketIndicator({this.source, this.isSliver, this.name});

  Widget buildIndicator(BuildContext context, IndicatorStatus status) {
    Widget widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget =
            Center(child: SizedBox(width: 50, child: CustomLoadingWidget()));
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Container(
          margin: EdgeInsets.only(right: 0.0),
          child: Center(child: CustomLoadingWidget()),
        );
        if (isSliver!) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.error:
        widget = Text('Error'.tr, style: AppStyles.kFontBlack14w5);

        widget = GestureDetector(
          onTap: () {
            source.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:
        widget = ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              foregroundColor: AppStyles.pinkColor,
              backgroundColor: AppStyles.pinkColor,
              radius: 30.r,
              child: Container(
                color: AppStyles.pinkColor,
                child: Image.asset(
                  AppConfig.appLogo,
                  width: 30.w,
                  height: 30.w,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '- ${"Error getting data".tr} - ',
              style: AppStyles.kFontBlack17w5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: PinkButtonWidget(
                height: 32.h,
                btnOnTap: () {
                  source.errorRefresh();
                },
                btnText: 'Reload'.tr,
              ),
            ),
          ],
        );
        if (isSliver!) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('- ${"End of Results".tr} - ', style: AppStyles.kFontBlack14w5),
            ],
          ),
        );
        break;
      case IndicatorStatus.empty:
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              foregroundColor: AppStyles.pinkColor,
              backgroundColor: AppStyles.pinkColor,
              radius: 30.r,
              child: Container(
                color: AppStyles.pinkColor,
                child: Image.asset(
                  AppConfig.appLogo,
                  width: 30.w,
                  height: 30.w,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '- ${"No item found 1".tr} - ',
              style: AppStyles.kFontBlack17w5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: PinkButtonWidget(
                  height: 40.h,
                  btnOnTap: () {
                    Get.to(() => CreateTicketPage(source));
                  },
                  btnText: 'Create Ticket'.tr),
            ),
          ],
        );
        if (isSliver!) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }
}
