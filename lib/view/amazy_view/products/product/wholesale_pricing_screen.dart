import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductDetailsModel.dart';
import 'package:amazcart/model/NewModel/Product/Skus.dart';
import 'package:amazcart/model/NewModel/Product/WholeSalePrice.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:amazcart/widgets/amazcart_widget/snackbars.dart';

class WholesalePricingScreen extends StatefulWidget {
  final ProductDetailsController controller;
  final bool inWishList;
  final Function(bool) onWishlistToggle;

  const WholesalePricingScreen({
    Key? key,
    required this.controller,
    required this.inWishList,
    required this.onWishlistToggle,
  }) : super(key: key);

  @override
  State<WholesalePricingScreen> createState() => _WholesalePricingScreenState();
}

class _WholesalePricingScreenState extends State<WholesalePricingScreen> {
  final GeneralSettingsController _settingsController = Get.find();
  final CartController _cartController = Get.find();
  late bool _inWishList;

  @override
  void initState() {
    super.initState();
    _inWishList = widget.inWishList;
    
    // Ensure controller quantities and calculations are aligned
    if ((widget.controller.products.value.data?.variantDetails?.length ?? 0) > 0) {
      widget.controller.calculatePriceAfterSku();
    } else {
      widget.controller.calculatePrice();
    }
  }

  // Construct SKU option map to fetch sku wise details
  Map<String, dynamic> _getSkuMap(Skus sku) {
    Map<String, dynamic> map = {};
    if (sku.productVariations != null) {
      for (int i = 0; i < sku.productVariations!.length; i++) {
        var v = sku.productVariations![i];
        map['id[$i]'] = '${v.attributeValueId}-${v.attributeId}';
      }
    }
    return map;
  }

  // Handle switching variant/SKU tabs
  Future<void> _selectSku(Skus sku) async {
    Map<String, dynamic> data = {
      'product_id': widget.controller.products.value.data!.id,
      'user_id': widget.controller.products.value.data!.userId,
    };
    data.addAll(_getSkuMap(sku));
    await widget.controller.getSkuWisePrice(data);
  }

  // Get current active SKU id
  int _getSelectedSkuId() {
    if ((widget.controller.products.value.data?.variantDetails?.length ?? 0) > 0) {
      return widget.controller.productSkuID.value;
    } else {
      return widget.controller.products.value.data?.skus?.first.id ?? 0;
    }
  }

  // Clean, premium display name construction for SKUs/variants
  String _getSkuName(Skus sku) {
    if (sku.productVariations == null || sku.productVariations!.isEmpty) {
      return "STANDARD SACK".tr;
    }
    return sku.productVariations!.map((v) {
      String attrName = v.attribute?.name ?? '';
      String val = '';
      if (attrName == 'Color') {
        val = v.attributeValue?.color?.name ?? v.attributeValue?.value ?? '';
      } else {
        val = v.attributeValue?.value ?? '';
      }
      val = val.toUpperCase();
      if (attrName.toLowerCase() == 'size' && !val.contains('SACK')) {
        val = '$val SACK';
      }
      return val;
    }).join(' / ');
  }

  // Trigger inquiry bottom sheet/dialog
  void _openInquiryDialog(int qty) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Bulk Order Inquiry".tr,
              style: AppStyles.appFontBold.copyWith(
                fontSize: 18.fontSize,
                color: Color(0xFF042E1E),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Interested in ordering ${qty}+ units? Contact our dedicated B2B team to get the best wholesale quotation tailored to your requirements."
                  .tr,
              style: AppStyles.appFontBook.copyWith(
                fontSize: 13.fontSize,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: Color(0xFF042E1E)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    icon: Icon(Icons.phone_in_talk, color: Color(0xFF042E1E)),
                    label: Text(
                      "CALL SUPPORT".tr,
                      style: AppStyles.appFontBold.copyWith(
                        color: Color(0xFF042E1E),
                        fontSize: 14.fontSize,
                      ),
                    ),
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '+919999999999', // Placeholder or customized support number
                      );
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF25D366), // WhatsApp Green
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.message, color: Colors.white),
                    label: Text(
                      "WHATSAPP US".tr,
                      style: AppStyles.appFontBold.copyWith(
                        color: Colors.white,
                        fontSize: 14.fontSize,
                      ),
                    ),
                    onPressed: () async {
                      String productName = widget.controller.products.value.data?.product?.productName ?? '';
                      String message = "Hello, I am interested in inquiring about a bulk order of ${qty}+ units of $productName.";
                      final Uri whatsappUri = Uri.parse(
                        "https://wa.me/919999999999?text=${Uri.encodeComponent(message)}",
                      );
                      if (await canLaunchUrl(whatsappUri)) {
                        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                      } else {
                        SnackBars().snackBarWarning("WhatsApp is not installed.");
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var product = widget.controller.products.value.data;
    var skus = product?.skus ?? [];

    return Scaffold(
      backgroundColor: Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.w),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Product Details".tr,
          style: AppStyles.appFontBold.copyWith(
            fontSize: 18.fontSize,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _inWishList ? Icons.favorite : Icons.favorite_border,
              color: _inWishList ? Colors.red : Colors.grey,
              size: 24.w,
            ),
            onPressed: () async {
              setState(() {
                _inWishList = !_inWishList;
              });
              widget.onWishlistToggle(_inWishList);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Header Info Block
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Thumbnail image container
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            width: 68.w,
                            height: 68.w,
                            color: Colors.grey.shade100,
                            child: Image.network(
                              "${AppConfig.assetPath}/${product?.product?.thumbnailImageSource}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported_outlined, color: Colors.grey);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.product?.productName ?? '',
                                style: AppStyles.appFontBold.copyWith(
                                  fontSize: 16.fontSize,
                                  color: Colors.black,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFEF6E4),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      "Wholesale Tier Pricing".tr,
                                      style: AppStyles.appFontMedium.copyWith(
                                        fontSize: 11.fontSize,
                                        color: Color(0xFFB07A10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Variant Tab Selector
                  if (skus.length > 1) ...[
                    Text(
                      "Select Product Variant".tr,
                      style: AppStyles.appFontBold.copyWith(
                        fontSize: 14.fontSize,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(() {
                      int selectedSkuId = _getSelectedSkuId();
                      return SizedBox(
                        height: 40.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: skus.length,
                          separatorBuilder: (context, index) => SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            var sku = skus[index];
                            String label = _getSkuName(sku);
                            bool isSelected = sku.id.toString() == selectedSkuId.toString();

                            return GestureDetector(
                              onTap: () => _selectSku(sku),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: isSelected ? Color(0xFF042E1E) : Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isSelected ? Colors.transparent : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  label,
                                  style: AppStyles.appFontBold.copyWith(
                                    fontSize: 12.fontSize,
                                    color: isSelected ? Colors.white : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],

                  // Tiers Header List
                  Text(
                    "Wholesale Pricing Tiers".tr,
                    style: AppStyles.appFontBold.copyWith(
                      fontSize: 14.fontSize,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Dynamic Price Tiers list
                  Obx(() {
                    if (widget.controller.isSkuLoading.value) {
                      return SizedBox(
                        height: 200.h,
                        child: Center(child: CustomLoadingWidget()),
                      );
                    }

                    var currentSku = widget.controller.productSKU.value.sku;
                    var tiers = currentSku?.wholeSalePrices ?? [];

                    if (tiers.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.layers_clear_outlined, color: Colors.grey, size: 48.w),
                            SizedBox(height: 12.h),
                            Text(
                              "No tiers available for this variant.".tr,
                              style: AppStyles.appFontBook.copyWith(
                                fontSize: 13.fontSize,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    double regularPrice = (widget.controller.productSKU.value.sellingPrice as num?)?.toDouble() ?? 0.0;
                    if (regularPrice == 0.0 && skus.isNotEmpty) {
                      regularPrice = (skus.firstWhereOrNull((s) => s.id.toString() == _getSelectedSkuId().toString())?.sellingPrice ?? 0.0).toDouble();
                    }

                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tiers.length,
                          separatorBuilder: (context, index) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            var tier = tiers[index];
                            int minQty = tier.minQty ?? 1;
                            int? maxQty = tier.maxQty;
                            double tierPrice = (tier.sellingPrice ?? 0.0).toDouble();

                            // Active calculation check
                            int currentQty = widget.controller.itemQuantity.value;
                            bool isActive = currentQty >= minQty && (maxQty == null || currentQty <= maxQty);

                            // Saving calculation
                            double savingPercent = regularPrice > 0 ? ((regularPrice - tierPrice) / regularPrice) * 100 : 0.0;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isActive ? Color(0xFF042E1E) : Colors.grey.shade200,
                                  width: isActive ? 1.5.w : 1.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.01),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Left side highlight indicator
                                  if (isActive)
                                    Container(
                                      width: 4.w,
                                      height: 72.h,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF042E1E),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.r),
                                          bottomLeft: Radius.circular(12.r),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Details column
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "TIER ${index + 1}".tr,
                                                    style: AppStyles.appFontBold.copyWith(
                                                      fontSize: 11.fontSize,
                                                      color: Colors.grey.shade500,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  if (isActive) ...[
                                                    SizedBox(width: 6.w),
                                                    Icon(
                                                      Icons.check_circle_rounded,
                                                      color: Color(0xFF042E1E),
                                                      size: 14.w,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                maxQty == null ? "$minQty+ Units" : "$minQty - $maxQty Units",
                                                style: AppStyles.appFontBold.copyWith(
                                                  fontSize: 16.fontSize,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Price column
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${_settingsController.appCurrency.value}${tier.sellingPrice} / unit",
                                                style: AppStyles.appFontBold.copyWith(
                                                  fontSize: 15.fontSize,
                                                  color: Color(0xFF042E1E),
                                                ),
                                              ),
                                              if (savingPercent > 0.5) ...[
                                                SizedBox(height: 4.h),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFE6F4EA),
                                                    borderRadius: BorderRadius.circular(4.r),
                                                  ),
                                                  child: Text(
                                                    "Saves ${savingPercent.toStringAsFixed(0)}%",
                                                    style: AppStyles.appFontBold.copyWith(
                                                      fontSize: 10.fontSize,
                                                      color: Color(0xFF137333),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        // Support Call Option
                        if (tiers.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48.h),
                              side: BorderSide(color: Color(0xFF042E1E), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            icon: Icon(Icons.support_agent_outlined, color: Color(0xFF042E1E), size: 20.w),
                            label: Text(
                              "INQUIRE FOR ${(tiers.last.maxQty ?? tiers.last.minQty ?? 15)}+ UNITS".tr,
                              style: AppStyles.appFontBold.copyWith(
                                fontSize: 13.fontSize,
                                color: Color(0xFF042E1E),
                                letterSpacing: 0.5,
                              ),
                            ),
                            onPressed: () {
                              int lastQty = tiers.last.maxQty ?? tiers.last.minQty ?? 15;
                              _openInquiryDialog(lastQty);
                            },
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Bottom Cart Actions Block
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Obx(() {
                int quantity = widget.controller.itemQuantity.value;
                double currentPrice = widget.controller.productPrice.value;
                double totalPrice = widget.controller.finalPrice.value;

                return Row(
                  children: [
                    // Quantity Adjustment
                    Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.black54, size: 18.w),
                            onPressed: widget.controller.cartDecrease,
                          ),
                          Container(
                            constraints: BoxConstraints(minWidth: 28.w),
                            alignment: Alignment.center,
                            child: Text(
                              "$quantity",
                              style: AppStyles.appFontBold.copyWith(
                                fontSize: 16.fontSize,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.black54, size: 18.w),
                            onPressed: widget.controller.cartIncrease,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // Add to Cart Action
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (_cartController.isCartLoading.value) return;

                          int activeSkuId = _getSelectedSkuId();
                          if (widget.controller.stockManage.value == 1 && widget.controller.stockCount.value <= 0) {
                            SnackBars().snackBarWarning("No more stock".tr);
                            return;
                          }

                          Map<String, dynamic> cartData = {
                            'product_id': activeSkuId,
                            'qty': quantity,
                            'price': currentPrice,
                            'seller_id': product?.userId ?? 1,
                            'shipping_method_id': widget.controller.shippingID.value,
                            'product_type': 'product',
                            'checked': true,
                            "in_app_purchase_id": widget.controller.inAppPurchaseId,
                          };

                          await _cartController.addToCart(cartData);
                        },
                        child: Container(
                          height: 48.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF042E1E), // Premium deep green
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: _cartController.isCartLoading.value
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  "ADD TO CART | ${_settingsController.appCurrency.value}${totalPrice.toStringAsFixed(2)}",
                                  style: AppStyles.appFontBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.fontSize,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
