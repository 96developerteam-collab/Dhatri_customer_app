import 'package:amazcart/controller/support_ticket_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazy_widget/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/amazy_widget/AppBarWidget.dart';
import 'AllSupportTicketsPage.dart';
import 'SupportTicketByStatusPage.dart';

class SupportTicketsPage extends StatefulWidget {
  @override
  _SupportTicketsPageState createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  final SupportTicketController controller = Get.put(SupportTicketController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CustomLoadingWidget(),
          ),
        );
      } else {
        return DefaultTabController(
          length: (controller.supportTickets.value.statuses?.length ?? 0) + 1,
          child: Scaffold(
            backgroundColor: context.theme.cardColor,
            appBar: AppBarWidget(title: 'Support Ticket'.tr,showCart: false),
            body: Column(
              children: [

                TabBar(
                  labelColor: AppStyles.pinkColor,
                  indicator: BoxDecoration(
                    color: Color(0xffFFF0F4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  unselectedLabelColor: AppStyles.greyColorDark,
                  indicatorColor: AppStyles.pinkColor,
                  labelStyle: AppStyles.kFontBlack14w5,
                  isScrollable: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  // automaticIndicatorColorAdjustment: true,
                  tabs: List.generate(
                      (controller.supportTickets.value.statuses?.length ?? 0) + 1,
                          (index) {
                        if (index == 0) {
                          return Tab(
                            child: Text(
                              'All'.tr,
                            ),
                          );
                        }
                        return Tab(
                          child: Text(
                            controller.supportTickets.value.statuses?[index - 1].name ?? '',
                          ),
                        );
                      }),
                ),

                Expanded(
                  child: TabBarView(
                    children: List.generate(
                        (controller.supportTickets.value.statuses?.length ?? 0) + 1, (index) {
                      if (index == 0) {
                        return AllSupportTicketsPage();
                      }
                      return SupportTicketByStatusPage(
                          statusId:
                          controller.supportTickets.value.statuses?[index - 1].id,
                          statusName: controller
                              .supportTickets.value.statuses?[index - 1].name);
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
