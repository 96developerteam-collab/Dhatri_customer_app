import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/amazcart_widget/ButtonWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsModalWidget extends StatelessWidget {
  SettingsModalWidget(
      {this.buttonOnTap,
      this.modalTitle,
      this.textFieldHint,
      this.textFieldTitle,
      this.errorMsg,
      this.textEditingController,
        this.enableCloseIcon = true,
        this.onChanged,
        this.onClose
      });

  final VoidCallback? buttonOnTap;
  final String? modalTitle;
  final String? textFieldTitle;
  final String? textFieldHint;
  final String? errorMsg;
  final TextEditingController? textEditingController;
  final bool enableCloseIcon;
  final Function(String)? onChanged;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: 40.w,
            height: 5,
            decoration: BoxDecoration(
              color: Color(0xffDADADA),
              borderRadius: BorderRadius.all(
                Radius.circular(30.r),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            modalTitle ?? '',
            style: AppStyles.appFont.copyWith(
              color: Colors.black,
              fontSize: 16.fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              textFieldTitle ?? '',
              style: AppStyles.appFont.copyWith(
                color: Colors.black,
                fontSize: 12.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: Color(0xffF6FAFC),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              maxLines: 3,
              controller: textEditingController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
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
                suffixIcon: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: enableCloseIcon,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          textEditingController?.clear();
                          if(onClose != null){
                            onClose!();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                hintText: textFieldHint,
                hintMaxLines: 4,
                hintStyle: AppStyles.appFont.copyWith(
                  color: Colors.grey,
                  fontSize: 15.fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              keyboardType: TextInputType.text,
              style: AppStyles.appFont.copyWith(
                color: Colors.black,
                fontSize: 15.fontSize,
                fontWeight: FontWeight.w500,
              ),
              validator: (value) {
                if (value?.length == 0) {
                  return errorMsg;
                } else {
                  return null;
                }
              },
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          ButtonWidget(
            buttonText: 'Save'.tr,
            onTap: buttonOnTap,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          ),
        ],
      ),
    );
  }
}
