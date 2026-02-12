import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderRefundModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import '../../../../../model/NewModel/Order/Package.dart';
import '../../../../../model/NewModel/Product/ProductModel.dart';
import '../../../../../widgets/amazy_widget/AppBarWidget.dart';
import '../../../../../widgets/amazy_widget/BuildIndicatorBuilder.dart';
import '../../../../../widgets/amazy_widget/CustomDate.dart';
import '../../../../../widgets/amazy_widget/single_product_widgets/GridViewProductWidget.dart';
import '../../../products/RecommendedProductLoadMore.dart';
import '../../../products/product/product_details.dart';


class RefundDetails extends StatefulWidget {
  final RefundOrder? refundOrder;

  RefundDetails({this.refundOrder});

  @override
  _RefundDetailsState createState() => _RefundDetailsState();
}

class _RefundDetailsState extends State<RefundDetails> {
  final GeneralSettingsController currencyController =
  Get.put(GeneralSettingsController());

  String deliverStateName(Package package) {
    var deliveryStatus;
    package.processes?.forEach((element) {
      if (element.id == package.deliveryStatus) {
        deliveryStatus = element.name;
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  bool checkReview(Package package) {
    // print(package.deliveryStates);
    if (package.deliveryStates?.length != 0) {
      // print('${package.processes.last.id} == ${package.deliveryStatus}');
      if (package.processes?.last.id == package.deliveryStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  RecommendedProductsLoadMore? source;

  @override
  void initState() {
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var status = widget.refundOrder?.checkConfirmed ?? '';
    Color statusColor = status.toLowerCase().contains('approved')
        ? Colors.green
        : status.toLowerCase().contains('rejected')
            ? Colors.red
            : Colors.orange;

    return Scaffold(
      appBar: AppBarWidget(title: 'Refund Details'.tr),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Light green
              Color(0xFFF1F8F4), // Greenish-white
              Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: LoadingMoreCustomScrollView(
          reverse: false,
          showGlowLeading: false,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    // Order Info Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF0F9F4),
                            Color(0xFFFFFFFF),
                            Color(0xFFF5FFF9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFE8F5E9).withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Number'.tr,
                                      style: AppStyles.appFontBook.copyWith(
                                        fontSize: 11.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      widget.refundOrder?.order?.orderNumber
                                              ?.toUpperCase() ??
                                          '',
                                      style: AppStyles.appFontBold.copyWith(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  status.tr,
                                  style: AppStyles.appFontMedium.copyWith(
                                    fontSize: 12.sp,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Divider(height: 1, color: Color(0xFFE8F5E9)),
                          SizedBox(height: 16.h),
                          // Date Info
                          _buildInfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Request Sent Date'.tr,
                            value: CustomDate().formattedDateTime(
                                widget.refundOrder?.createdAt),
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow(
                            icon: Icons.event_outlined,
                            label: 'Order Date'.tr,
                            value: CustomDate().formattedDateTime(
                                widget.refundOrder?.order?.createdAt),
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Refund Method'.tr,
                            value: widget.refundOrder!.refundMethod!
                                .replaceAll("_", ' ')
                                .capitalizeFirst!,
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow(
                            icon: Icons.local_shipping_outlined,
                            label: 'Shipping Type'.tr,
                            value: widget.refundOrder!.shippingMethod!
                                .replaceAll("_", ' ')
                                .capitalizeFirst!,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Products Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF0F9F4),
                            Color(0xFFFFFFFF),
                            Color(0xFFF5FFF9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFE8F5E9).withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Refund Products'.tr,
                            style: AppStyles.appFontBold.copyWith(
                              fontSize: 15.sp,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                widget.refundOrder?.refundDetails?.length ?? 0,
                            itemBuilder: (context, packageIndex) {
                              var refundDetail =
                                  widget.refundOrder!.refundDetails![packageIndex];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (packageIndex > 0)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      child: Divider(
                                          height: 1, color: Color(0xFFE8F5E9)),
                                    ),
                                  // Package Info
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.inventory_2_outlined,
                                        size: 16.sp,
                                        color: Color(0xFF4CAF50),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        refundDetail.orderPackage?.packageCode ??
                                            '',
                                        style: AppStyles.appFontBold.copyWith(
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (currencyController.vendorType.value !=
                                      "single")
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 24.w,
                                        top: 4.h,
                                      ),
                                      child: Text(
                                        'Sold by'.tr +
                                            ': ' +
                                            '${refundDetail.seller?.firstName ?? ''}',
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 12.h),

                                  // Products
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 12.h),
                                    itemCount:
                                        refundDetail.refundProducts?.length ?? 0,
                                    itemBuilder: (context, productIndex) {
                                      var product = refundDetail
                                          .refundProducts![productIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => ProductDetails(
                                                productID: product
                                                        .sellerProductSku
                                                        ?.product
                                                        ?.id ??
                                                    0,
                                              ));
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Container(
                                                height: 70.w,
                                                width: 70.w,
                                                child: FancyShimmerImage(
                                                  imageUrl: AppConfig.assetPath +
                                                      '/' +
                                                      '${product.sellerProductSku?.product?.product?.thumbnailImageSource}',
                                                  boxFit: BoxFit.cover,
                                                  errorWidget: Image.asset(
                                                    "assets/images/placeholder.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.sellerProductSku?.product
                                                            ?.productName ??
                                                        '',
                                                    style: AppStyles.appFontMedium
                                                        .copyWith(
                                                      fontSize: 13.sp,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  // Variations
                                                  ...(product.sellerProductSku
                                                              ?.productVariations ??
                                                          [])
                                                      .map((v) => Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 2.h),
                                                            child: Text(
                                                              '${v.attribute?.name ?? ''}: ${v.attributeValue?.name ?? v.attributeValue?.value ?? ''}',
                                                              style: AppStyles
                                                                  .appFontBook
                                                                  .copyWith(
                                                                fontSize: 11.sp,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  SizedBox(height: 6.h),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        currencyController
                                                            .setCurrentSymbolPosition(
                                                          amount: ((product
                                                                      .returnAmount ??
                                                                  0) *
                                                              currencyController
                                                                  .conversionRate
                                                                  .value)
                                                              .toStringAsFixed(2),
                                                        ),
                                                        style: AppStyles.appFontBold
                                                            .copyWith(
                                                          fontSize: 14.sp,
                                                          color: Color(0xFF4CAF50),
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Text(
                                                        '(${product.returnQty}x)',
                                                        style: AppStyles.appFontBook
                                                            .copyWith(
                                                          fontSize: 12.sp,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Pickup/Drop-off Info Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF0F9F4),
                            Color(0xFFFFFFFF),
                            Color(0xFFF5FFF9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFE8F5E9).withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                widget.refundOrder?.pickUpAddressCustomer != null
                                    ? Icons.local_shipping_outlined
                                    : Icons.location_on_outlined,
                                size: 20.sp,
                                color: Color(0xFF4CAF50),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                widget.refundOrder?.pickUpAddressCustomer != null
                                    ? 'Courier Pickup Info'.tr
                                    : 'Drop off Info'.tr,
                                style: AppStyles.appFontBold.copyWith(
                                  fontSize: 15.sp,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          _buildPickupInfoRow(
                            'Shipping Method'.tr,
                            '${widget.refundOrder?.shippingGateway?.methodName}',
                          ),
                          if (widget.refundOrder?.pickUpAddressCustomer != null)
                            ...[
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'Name'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.name}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'Email'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.email}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'Phone Number'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.phone}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'Address'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.address}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'City'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.city}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'State'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.state}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'Country'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.country}',
                              ),
                              SizedBox(height: 10.h),
                              _buildPickupInfoRow(
                                'Postcode'.tr,
                                '${widget.refundOrder?.pickUpAddressCustomer?.postalCode}',
                              ),
                            ]
                          else ...[
                            SizedBox(height: 10.h),
                            _buildPickupInfoRow(
                              'Drop off Address'.tr,
                              '${widget.refundOrder?.dropOffAddress ?? ""}',
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'You might like'.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFont.copyWith(
                    color: Color(0xFF4CAF50),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                indicatorBuilder: BuildIndicatorBuilder(
                  source: source,
                  isSliver: true,
                  name: 'Recommended Products'.tr,
                ).buildIndicator,
                extendedListDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (BuildContext c, ProductModel prod, int index) {
                  return GridViewProductWidget(
                    productModel: prod,
                    averageRating: 0,
                  );
                },
                sourceList: source!,
              ),
              key: const Key('refundDetailsPageLoadMoreKey'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: Color(0xFF4CAF50),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.appFontBook.copyWith(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppStyles.appFontMedium.copyWith(
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickupInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppStyles.appFontBook.copyWith(
              fontSize: 12.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppStyles.appFontMedium.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

}
