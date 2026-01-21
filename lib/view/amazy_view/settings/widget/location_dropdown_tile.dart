import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../AppConfig/app_config.dart';

class LocationDropDownTile extends StatelessWidget {
  final String title;
  final String? image;
  final Function() onTap;

  const LocationDropDownTile({
    required this.title,
    this.image,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.black12.withOpacity(0.05),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(image!=null)
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Image.network(
                      '${AppConfig.assetPath}/$image',
                      width: 20.w,
                      errorBuilder:
                          (context, object, stackTrace) {
                        return Icon(Icons.flag,size: 16.w,);
                      },
                    ),
                  ),
                Text(title,style: AppStyles.kFontBlack12w4),
              ],
            ),
            Icon(Icons.arrow_drop_down,size: 18.w,),
          ],
        ),
      ),
    );
  }
}
