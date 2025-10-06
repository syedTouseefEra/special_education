
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';



class DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const DetailItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.themeColor,
          ),
          CustomText(
            text: value,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.darkGrey,
          ),
        ],
      ),
    );
  }
}
