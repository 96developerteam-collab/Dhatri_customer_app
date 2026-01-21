import 'package:flutter/cupertino.dart';
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
      title:  Text('Confirmation'.tr),
      content: Text('Are you sure want to delete account?'.tr),
      actions: [
        TextButton(
            onPressed: ()=> Get.back(),
            child: Text('Cancel'.tr)
        ),
        TextButton(
            onPressed: () async {
              Get.back();
              await 500.milliseconds.delay();
              onYesTap.call();
            },
            child: Text('Delete'.tr)
        ),
      ],
    );
  }
}


