import 'package:amazcart/controller/order_cancel_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/OrderCancelReasonModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/amazcart_widget/BlueButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/PinkButtonWidget.dart';
import 'package:amazcart/widgets/amazcart_widget/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderCancelWidget extends StatefulWidget {
  final int? packageId;
  final OrderData? order;

  OrderCancelWidget({this.packageId, this.order});

  @override
  _OrderCancelWidgetState createState() => _OrderCancelWidgetState();
}

class _OrderCancelWidgetState extends State<OrderCancelWidget> {
  final OrderCancelController controller = Get.put(OrderCancelController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 1,
            builder: (ctx, scrollController2) {
              return Obx(() {
                if (controller.isLoading.value) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(25.0.r),
                          topRight:  Radius.circular(25.0.r),
                        ),
                      ),
                      child: Center(
                        child: CustomLoadingWidget(),
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(25.0.r),
                        topRight:  Radius.circular(25.0.r),
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 40.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: Color(0xffDADADA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: Text(
                              'Cancel Order'.tr,
                              style: AppStyles.kFontBlack15w4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            'Select Cancel Reason'.tr + ' :',
                            textAlign: TextAlign.left,
                            style: AppStyles.kFontBlack15w4,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Obx(() {
                            return DropdownButton<CancelReason>(
                              elevation: 1,
                              isExpanded: true,
                              underline: Container(),
                              dropdownColor: Colors.white,
                              value: controller.reasonValue.value,
                              items: controller.cancelReasons.map((e) {
                                return DropdownMenuItem<CancelReason>(
                                  child: Text('${e.name}',style: AppStyles.kFontBlack12w4,),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (CancelReason? value) {
                                setState(() {
                                  controller.reasonValue.value = value!;
                                });
                              },
                            );
                          }),
                          Divider(),
                          SizedBox(
                            height: 20.h,
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: BlueButtonWidget(
                                  height: 40.h,
                                  btnText: 'Back'.tr,
                                  btnOnTap: () {
                                    Get.back();
                                  },
                                ),
                              ),

                              SizedBox(
                                width: 15.w,
                              ),

                              Expanded(
                                child: PinkButtonWidget(
                                  height: 40.h,
                                  btnOnTap: () async {
                                    Map data = {
                                      'order_id': widget.order!.orderNumber,
                                      'reason': controller.reasonValue.value.id,
                                    };
                                    // print(data);
                                
                                    await controller.cancelOrder(data);
                                  },
                                  btnText: 'Cancel Order'.tr,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
