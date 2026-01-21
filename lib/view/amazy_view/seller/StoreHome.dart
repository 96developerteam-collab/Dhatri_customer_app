import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/seller/SellerProductsLoadMore.dart';
import 'package:amazcart/view/amazy_view/seller/StoreAllProductsPage.dart';
import 'package:amazcart/view/amazy_view/seller/SellerProfileFilterDrawer.dart';
import 'package:amazcart/view/amazy_view/seller/StoreHomePage.dart';
import 'package:amazcart/widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'package:amazcart/widgets/amazy_widget/bottom_sheet_tile.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class StoreHome extends StatefulWidget {
  final int? sellerId;

  StoreHome({this.sellerId});

  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  SellerProfileController controller = Get.put(Get.put(SellerProfileController()));

  String popUpItem1 = "Home";
  String popUpItem2 = "Share";
  String popUpItem3 = "Search";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SellerProductsLoadMore? source;

  bool filterSelected = false;

  @override
  void initState() {
    if (mounted) {
      getSellerDetails();
    }
    source = SellerProductsLoadMore(widget.sellerId!);
    source!.isSorted = false;
    source!.isFilter = false;
    super.initState();
  }

  getSellerDetails() async {
    try {
      await controller.getSellerProfile(widget.sellerId).then((value) {
        controller.sellerId.value = widget.sellerId!;
      });
    }catch(e){
    }
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    // var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SellerProfileFilterDrawer(
          sellerId: widget.sellerId,
          scaffoldKey: _scaffoldKey,
          source: source,
        ),
        backgroundColor: AppStyles.appBackgroundColor,
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CustomLoadingWidget());
          } else {
            return Scaffold(
              backgroundColor: AppStyles.appBackgroundColor,
              body: NestedScrollView(
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    CustomSliverAppBarWidget(true, true),
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: 200.h,
                      floating: false,
                      pinned: false,
                      automaticallyImplyLeading: false,
                      actions: [Container()],
                      titleSpacing: 0,
                      centerTitle: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 170.h,
                              alignment: Alignment.topCenter,
                              child: controller
                                          .seller.value.seller?.sellerAccount !=
                                      null
                                  ? FancyShimmerImage(
                                      imageUrl:
                                          "${AppConfig.assetPath}/${controller.seller.value.seller!.sellerAccount!.banner}",
                                      boxFit: BoxFit.cover,
                                      errorWidget: FancyShimmerImage(
                                        imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                        boxFit: BoxFit.cover,
                                        width: Get.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                      ),
                                    )
                                  : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.22,
                                    color: AppStyles.pinkColor,
                                  ),
                            ),
                            Positioned(
                              bottom: 0.h,
                              left: 20.w,
                              right: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  controller.seller.value.seller?.avatar == null || (controller.seller.value.seller?.avatar??'').isEmpty ?
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF1F1F1),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/images/person.png',
                                      color: Colors.white,
                                      width: 80.w,
                                      height: 80.w,
                                    ),
                                  ) : InkWell(
                                    onTap: (){
                                      print('${AppConfig.assetPath}/${controller.seller.value.seller!.avatar}');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color(0xffF1F1F1),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.network(
                                        '${AppConfig.assetPath}/${controller.seller.value.seller!.avatar}',
                                        width: 80.w,
                                        height: 80.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.seller.value.seller?.sellerAccount !=
                                                      null
                                                  ? controller
                                                          .seller
                                                          .value
                                                          .seller?.sellerAccount?.sellerShopDisplayName ??
                                                      "${controller.seller.value.seller?.firstName ?? ""} ${controller.seller.value.seller?.lastName ?? ""}"
                                                  : "${controller.seller.value.seller?.firstName ?? ""} ${controller.seller.value.seller?.lastName ?? ""}",
                                              style: AppStyles.appFontBold
                                                  .copyWith(fontSize: 18.fontSize),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                // pinnedHeaderSliverHeightBuilder: () {
                //   return pinnedHeaderHeight;
                // },
                floatHeaderSlivers: false,
                body: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppStyles.appBackgroundColor,
                          width: 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TabBar(
                        controller: controller.tabController,
                        indicatorColor: AppStyles.pinkColor,
                        isScrollable: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 12.fontSize
                        ),
                        unselectedLabelStyle: AppStyles.appFontBook,
                        tabs: controller.myTabs,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller.tabController,
                        children: <Widget>[
                          StoreHomePage(),
                          StoreAllProductsPage(
                            scaffoldKey: _scaffoldKey,
                            sellerId: widget.sellerId,
                          ),
                          Container(
                            child: Column(
                              children: [
                                BottomSheetTile(
                                  title: "Seller Name".tr,
                                  value: controller.seller.value.seller?.firstName??'',
                                  color: Color(0xFFF2F0F6),
                                ),
                                BottomSheetTile(
                                  title: "Phone".tr,
                                  value: controller.seller.value.seller?.phone ?? '_',
                                  color: Colors.white,
                                ),
                                BottomSheetTile(
                                  title: "Shop Name".tr,
                                  value: controller.seller.value.seller?.sellerBusinessInformation?.businessOwnerName ?? '_',
                                  color: Color(0xFFF2F0F6),
                                ),
                                BottomSheetTile(
                                  title: "Address".tr,
                                  value: controller.seller.value.seller?.sellerBusinessInformation?.businessAddress1 ?? '_',
                                  color: Colors.white,
                                ),
                                BottomSheetTile(
                                  title: "Address".tr,
                                  value: controller.seller.value.seller?.sellerBusinessInformation?.businessCountry ?? '_',
                                  color: Color(0xFFF2F0F6),
                                ),
                                BottomSheetTile(
                                  title: "Reviews".tr,
                                  value: controller.seller.value.seller?.sellerReviews?.first.rating ?? '0',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }));
  }
}

class SkewBgWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    // paint.color = Color(0xffffffff);
    paint.color = AppStyles.pinkColor;
    path = Path();
    path.lineTo(size.width * 0.06, size.height * 0.06);
    path.cubicTo(size.width * 0.06, size.height * 0.06, size.width,
        size.height * 0.06, size.width, size.height * 0.06);
    path.cubicTo(size.width, size.height * 0.06, size.width * 0.96,
        size.height * 1.06, size.width * 0.96, size.height * 1.06);
    path.cubicTo(size.width * 0.96, size.height * 1.06, size.width * 0.01,
        size.height * 1.06, size.width * 0.01, size.height * 1.06);
    path.cubicTo(size.width * 0.01, size.height * 1.06, size.width * 0.06,
        size.height * 0.06, size.width * 0.06, size.height * 0.06);
    path.cubicTo(size.width * 0.06, size.height * 0.06, size.width * 0.06,
        size.height * 0.06, size.width * 0.06, size.height * 0.06);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


