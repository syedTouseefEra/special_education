import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';

class GeneralInformationView extends StatelessWidget {
  const GeneralInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "General Information",
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),

          SizedBox(height: 4.sp),
          Divider(thickness: 0.7.sp),
          SizedBox(height: 12.sp),

          _info("Mobile", "9884994948"),
          _info("Email Id", "clairejane@327gmail.com"),
          _info("Gender", "Female"),
          _info("DOB", "09-12-2025"),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: LabelValueText(
        label: label,
        value: value,
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textGrey,
        ),
        valueStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      ),
    );
  }
}
