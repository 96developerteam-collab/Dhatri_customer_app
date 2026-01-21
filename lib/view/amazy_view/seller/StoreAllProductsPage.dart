import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/amazy_view/seller/SellerProductsLoadMore.dart';
import 'package:amazcart/widgets/amazy_widget/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../model/NewModel/Product/ProductModel.dart';

class StoreAllProductsPage extends StatefulWidget {

  final int? sellerId;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  StoreAllProductsPage({this.sellerId, this.scaffoldKey});

  @override
  _StoreAllProductsPageState createState() => _StoreAllProductsPageState();
}

class _StoreAllProductsPageState extends State<StoreAllProductsPage> {

  final SellerProfileController controller = Get.put(SellerProfileController());


  final HomeController homeController = Get.put(HomeController());

  Sorting? _selectedSort;

  bool filterSelected = false;

  SellerProductsLoadMore? source;


  @override
  void initState() {
    source = SellerProductsLoadMore(widget.sellerId ?? 0);
    source?.isSorted = false;
    source?.isFilter = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingMoreCustomScrollView(
      key: Key('Tab2'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        LoadingMoreSliverList<ProductModel>(
          SliverListConfig<ProductModel>(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 50, top: 10),
            indicatorBuilder: BuildIndicatorBuilder(
              source: source,
              isSliver: true,
              name: 'Products'.tr,
            ).buildIndicator,
            extendedListDelegate:
            SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (BuildContext c, ProductModel prod, int index) {
              int totalRating = 0;
              double averageRating = 0.0;

              if ((prod.reviews??[]).isNotEmpty) {
                for (int i = 0; i < prod.reviews!.length; i++) {
                  totalRating += prod.reviews?[i].rating ?? 0;
                }
                averageRating = totalRating / prod.reviews!.length;
              }

              return GridViewProductWidget(
                productModel: prod,
                averageRating: averageRating,
              );
            },
            sourceList:source!,
          ),
        ),
      ],
    );

  }
}
