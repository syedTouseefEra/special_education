import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/my_profile_provider.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/widget/additional_detail_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/widget/general_information_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/widget/placement_details_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_profile/update_profile_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyProfileProvider>(
        context,
        listen: false,
      ).getTeacherProfileData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          body: Consumer<MyProfileProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(child: Text(provider.error!));
              }

              if (provider.myProfileData == null || provider.myProfileData!.isEmpty) {
                return const Center(child: Text("No profile data available"));
              }

              final profile = provider.myProfileData!.first;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: CustomHeaderView(courseName: "", moduleName: ""),
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 40.sp,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: (profile.image != null && profile.image!.isNotEmpty)
                            ? NetworkImage('${ApiServiceUrl.urlLauncher}uploads/${profile.image}')
                            : null,
                        child: (profile.image == null || profile.image!.isEmpty)
                            ? Icon(Icons.person, size: 36.sp, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Center(
                      child: CustomText(
                        text: profile.teacherName?.isEmpty ?? true ? 'NA' : profile.teacherName!,
                        color: AppColors.themeColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Center(
                      child: CustomText(
                        text: "Emp Id: ${profile.employeeId ?? 'NA'}",
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
                    GeneralInformationView(profile: profile),
                    Divider(thickness: 0.7.sp),
                    PlacementDetailsView(profile: profile),
                    Divider(thickness: 0.7.sp),
                    AdditionalDetailView(profile: profile),
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
                        value: profile.adharCardNumber ?? 'NA',
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
                        child: profile.adharCardImage != null && profile.adharCardImage!.isNotEmpty
                            ? Image.network(
                          '${ApiServiceUrl.urlLauncher}uploads/${profile.adharCardImage}',
                          width: 200.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 200.w,
                          height: 120.h,
                          color: Colors.grey.shade300,
                          child: Icon(Icons.image, size: 50.sp),
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
                        child: profile.signature != null && profile.signature!.isNotEmpty
                            ? Image.network(
                          '${ApiServiceUrl.urlLauncher}uploads/${profile.signature}',
                          width: 200.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 200.w,
                          height: 120.h,
                          color: Colors.grey.shade300,
                          child: Icon(Icons.edit, size: 50.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.sp),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
