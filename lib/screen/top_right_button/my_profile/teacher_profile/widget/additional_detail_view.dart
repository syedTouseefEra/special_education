import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/my_profile_data_model.dart';

class AdditionalDetailView extends StatelessWidget {
  final MyProfileDataModel profile;
  const AdditionalDetailView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    String address = [
      profile.addressLine1,
      profile.addressLine2
    ].where((line) => line != null && line.isNotEmpty).join(' ');
    if (address.isEmpty) address = 'NA';

    String city = profile.cityName?.isNotEmpty == true ? profile.cityName! : 'NA';
    String country = profile.countryName?.isNotEmpty == true ? profile.countryName! : 'NA';
    String pinCode = profile.pinCode != null ? profile.pinCode.toString() : 'NA';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Additional Details",
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),

          SizedBox(height: 4.sp),
          Divider(thickness: 0.7.sp),
          SizedBox(height: 12.sp),

          _info("Address", address),
          _info("City/Town", city),
          _info("Pincode", pinCode),
          _info("Country", country),
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
