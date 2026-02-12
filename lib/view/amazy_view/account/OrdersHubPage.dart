import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/styles.dart';
import '../../../widgets/amazy_widget/CustomSliverAppBarWidget.dart';
import 'orders/new_order_module/views/all_order_page.dart';
import 'orders/MyCancellations.dart';
import 'orders/RefundAndDisputes/MyRefundsAndDisputes.dart';
import 'reviews/MyReviews.dart';

class OrdersHubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, false),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Management'.tr,
                    style: AppStyles.appFontBold.copyWith(
                      fontSize: 24.fontSize,
                      color: AppStyles.pinkColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Manage all your orders and reviews'.tr,
                    style: AppStyles.appFontBook.copyWith(
                      fontSize: 14.fontSize,
                      color: AppStyles.greyColorDark,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  
                  // All Orders Button
                  OrderHubTile(
                    title: "All Orders".tr,
                    subtitle: "View all your orders".tr,
                    icon: Icons.shopping_bag_outlined,
                    onTap: () {
                      Get.to(() => DynamicOrderListTabs());
                    },
                  ),
                  
                  SizedBox(height: 15.h),
                  
                  // My Cancellations Button
                  OrderHubTile(
                    title: "My Cancellations".tr,
                    subtitle: "View cancelled orders".tr,
                    icon: Icons.cancel_outlined,
                    onTap: () {
                      Get.to(() => MyCancellations());
                    },
                  ),
                  
                  SizedBox(height: 15.h),
                  
                  // Refunds and Disputes Button
                  OrderHubTile(
                    title: "Refunds and Disputes".tr,
                    subtitle: "Track your refunds and disputes".tr,
                    icon: Icons.money_off_outlined,
                    onTap: () {
                      Get.to(() => MyRefundsAndDisputes());
                    },
                  ),
                  
                  SizedBox(height: 15.h),
                  
                  // My Reviews Button
                  OrderHubTile(
                    title: "My Reviews".tr,
                    subtitle: "View and manage your reviews".tr,
                    icon: Icons.rate_review_outlined,
                    onTap: () {
                      Get.to(() => MyReviews(tabIndex: 0));
                    },
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

class OrderHubTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const OrderHubTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppStyles.greyColorLight.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50.w,
              width: 50.w,
              decoration: BoxDecoration(
                color: AppStyles.pinkColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: AppStyles.pinkColor,
                size: 26.w,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.appFontBold.copyWith(
                      fontSize: 16.fontSize,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppStyles.appFontBook.copyWith(
                      fontSize: 13.fontSize,
                      color: AppStyles.greyColorDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppStyles.pinkColor,
              size: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}
