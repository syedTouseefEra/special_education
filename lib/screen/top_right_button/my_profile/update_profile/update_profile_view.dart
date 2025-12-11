import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_profile/widget/update_additional_details_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_profile/widget/update_address_details_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_profile/widget/update_employment_details_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_profile/widget/update_general_information_view.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
                children: [
                  SizedBox(height: 5.sp),
                  CustomHeaderView(
                    backIconColor: AppColors.themeColor,
                    courseName: 'Profile',
                    primaryColor: AppColors.darkGrey,
                    moduleName: "Update Profile Details",
                  ),
                  Divider(thickness: 0.7.sp,color: AppColors.themeColor,),
                ]
            ),
          ),
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpdateGeneralInformationView(),
                UpdateAddressDetailsView(),
                UpdateEmploymentDetailsView(),
                UpdateAdditionalDetailsView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
