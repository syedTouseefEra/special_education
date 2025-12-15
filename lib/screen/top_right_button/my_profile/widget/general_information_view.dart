import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/top_right_button/my_profile/my_profile_data_model.dart';

class GeneralInformationView extends StatelessWidget {
  final MyProfileDataModel profile;
  const GeneralInformationView({super.key, required this.profile});

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

          _info("Mobile", profile.mobileNumber ?? 'NA'),
          _info("Email Id", profile.emailId ?? 'NA'),
          _info("Gender", profile.gender ?? 'NA'),
          _info("DOB", profile.dateOfBirth ?? 'NA'),
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
