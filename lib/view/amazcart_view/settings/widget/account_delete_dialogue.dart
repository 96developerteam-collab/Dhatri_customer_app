import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDeleteDialogue extends StatelessWidget {
  final Function() onYesTap;

  const AccountDeleteDialogue({
    required this.onYesTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('Confirmation'.tr,style: AppStyles.kFontBlack13w4),
      content: Text('Are you sure want to delete account?'.tr,style: AppStyles.kFontBlack12w4),
      actions: [
        TextButton(
            onPressed: ()=> Get.back(),
            child: Text('Cancel'.tr,style: AppStyles.kFontBlack13w4)
        ),
        TextButton(
            onPressed: onYesTap,
            child: Text('Delete'.tr,style: AppStyles.kFontBlack13w4)
        ),
      ],
    );
  }
}


