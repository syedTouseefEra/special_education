import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/widget/additional_detail_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/widget/general_information_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/widget/placement_details_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_profile/update_profile_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.sp),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                  ),
                  child: CustomHeaderView(courseName: "", moduleName: ""),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 40.sp,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        (UserData().getUserData.profileImage != null &&
                            UserData().getUserData.profileImage!.isNotEmpty)
                        ? NetworkImage(
                            '${ApiServiceUrl.urlLauncher}uploads/${UserData().getUserData.profileImage}',
                          )
                        : null,
                    child:
                        (UserData().getUserData.profileImage == null ||
                            UserData().getUserData.profileImage!.isEmpty)
                        ? Icon(Icons.person, size: 36.sp, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 5.sp),
                Center(
                  child: CustomText(
                    text: UserData().getUserData.name!.isEmpty
                        ? 'NA'
                        : UserData().getUserData.name.toString(),
                    color: AppColors.themeColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.sp),
                Center(
                  child: CustomText(
                    text: "Emp Id: ${UserData().getUserData.userId}",
                  ),
                ),
                SizedBox(height: 15.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: LabelValueText(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    isRow: true,
                    label: 'Profile Details',
                    labelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor,
                    ),
                    value: InkWell(
                      splashColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      onTap: (){
                        NavigationHelper.push(context, UpdateProfileView());
                      },
                      child: CustomContainer(
                        text: "Update Profile",
                        padding: 10.sp,
                        innerPadding: EdgeInsets.symmetric(
                          vertical: 5.sp,
                          horizontal: 15.sp,
                        ),
                        containerColor: AppColors.yellow,
                        textColor: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 0.7.sp),
                GeneralInformationView(),
                Divider(thickness: 0.7.sp),
                PlacementDetailsView(),
                Divider(thickness: 0.7.sp),
                AdditionalDetailView(),
                Divider(thickness: 0.7.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "Aadhar Card:",
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor,
                    ),
                    value: "38234824098982",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Divider(thickness: 0.7.sp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      '${ApiServiceUrl.urlLauncher}uploads/${UserData().getUserData.profileImage}',
                      width: 200.w,
                      height: 120.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Divider(thickness: 0.7.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: CustomText(
                    text: "Signature",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.themeColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Divider(thickness: 0.7.sp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      '${ApiServiceUrl.urlLauncher}uploads/${UserData().getUserData.profileImage}',
                      width: 200.w,
                      height: 120.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
