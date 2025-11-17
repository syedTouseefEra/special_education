import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/screen/teacher/update_teacher/update_teacher_detail_view.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class ProfileViewWidget extends StatelessWidget {
  const ProfileViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherDashboardProvider>(context);
    final selectedTeacher = teacherProvider.selectedTeacherData;

    final isLoading = selectedTeacher == null || selectedTeacher.isEmpty;
    final teacher = !isLoading ? selectedTeacher.first : null;

    if (isLoading) {
      return _buildShimmerProfile(context);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 330.sp,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              gradient: LinearGradient(
                colors: [AppColors.gradientColorOne, AppColors.gradientColorTwo],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 100.sp,
                      width: 100.sp,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        image: (teacher?.image != null && teacher!.image!.isNotEmpty)
                            ? DecorationImage(
                          image: NetworkImage(
                            '${ApiServiceUrl.urlLauncher}uploads/${teacher.image}',
                          ),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: AssetImage(ImgAssets.user),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.sp),
                  CustomText(
                    text: teacher?.teacherName ?? "No Name Available",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.themeColor,
                  ),
                  SizedBox(height: 3.sp),
                  LabelValueText(
                    isRow: true,
                    label: "Mobile Number:",
                    value: teacher?.mobileNumber?.toString() ?? "N/A",
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                  SizedBox(height: 3.sp),
                  LabelValueText(
                    isRow: true,
                    label: "Email ID:",
                    value: teacher?.emailId?.toString() ?? "N/A",
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                  SizedBox(height: 3.sp),
                  LabelValueText(
                    isRow: true,
                    label: "Registration Number:",
                    value: teacher?.employeeId?.toString() ?? "N/A",
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                  SizedBox(height: 10.sp),
                  CustomText(
                    text: "Employment Details",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.themeColor,
                  ),
                  SizedBox(height: 5.sp),
                  LabelValueText(
                    isRow: true,
                    label: "Designation:",
                    value: teacher?.designation?.toString() ?? "N/A",
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                  SizedBox(height: 3.sp),
                  LabelValueText(
                    isRow: true,
                    label: "Joining Date:",
                    value: teacher?.joiningDate?.toString() ?? "N/A",
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.sp,),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5.sp,
                    color: AppColors.black
                )
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp,vertical: 3.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Profile Details',
                        fontSize: 18.sp,
                        color: AppColors.themeColor,
                        fontFamily: 'Dm Serif',
                        fontWeight: FontWeight.w600,
                      ),
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () {
                          final teacherProvider = Provider.of<TeacherDashboardProvider>(context, listen: false);
                          final teacher = teacherProvider.selectedTeacherData?.first;
                          if (teacher != null) {
                            NavigationHelper.push(
                              context,
                              UpdateTeacherDetailView(teacher: teacher),
                            );
                          }
                        },

                        child: CustomContainer(
                          fontSize: 12.sp,
                          text: 'Update',
                          containerColor: AppColors.green,
                          borderRadius: 20.r,
                          padding: 12.sp,
                          innerPadding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  child: Container(
                    height:680.h,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.sp,
                            color: AppColors.grey
                        )
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 10.sp,vertical: 5.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'General Information',
                            fontSize: 16.sp,
                            color: AppColors.themeColor,
                            fontFamily: 'Dm Serif',
                            fontWeight: FontWeight.w600,
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "Employee Id: ",
                            value: teacher?.employeeId?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "DOB: ",
                            value: teacher?.dateOfBirth?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "Gender: ",
                            value: teacher?.gender?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 3.sp),
                          CustomText(
                            text: 'Additional Details',
                            fontSize: 16.sp,
                            color: AppColors.themeColor,
                            fontFamily: 'Dm Serif',
                            fontWeight: FontWeight.w600,
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "Address: ",
                            value: "${teacher?.addressLine1?.toString() ?? 'N/A'}, ${teacher?.addressLine2 ?? ''}",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "City/Town: ",
                            value: teacher?.cityName?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "State: ",
                            value: teacher?.stateName?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "Pincode: ",
                            value: teacher?.pinCode?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "Country: ",
                            value: teacher?.countryName?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          SizedBox(height: 3.sp),
                          LabelValueText(
                            isRow: true,
                            label: "Nationality: ",
                            value: teacher?.nationality?.toString() ?? "N/A",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.black,
                            ),
                            valueCase: TextCase.title,
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),


                          Row(
                            children: [
                              CustomText(
                                text: 'Aadhar Card : ',
                                fontSize: 16.sp,
                                color: AppColors.themeColor,
                                fontFamily: 'Dm Serif',
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(text:  teacher?.aadharCardNumber?.toString() ?? "N/A",color: AppColors.black,fontSize: 16.sp,)
                            ],
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 3.sp),
                          Container(
                            height: 120.sp,
                            width: 220.sp,
                            decoration: BoxDecoration(
                              color: AppColors.themeColor.withOpacity(0.1),

                              image: DecorationImage(
                                image: (teacher?.aadharCardImage != null &&
                                    teacher!.aadharCardImage!.isNotEmpty)
                                    ? NetworkImage(
                                  '${ApiServiceUrl.urlLauncher}uploads/${teacher.aadharCardImage}',
                                )
                                    : const AssetImage(ImgAssets.user) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),


                          CustomText(
                            text: 'Signature',
                            fontSize: 16.sp,
                            color: AppColors.themeColor,
                            fontFamily: 'Dm Serif',
                            fontWeight: FontWeight.w600,
                          ),
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 3.sp),
                          Container(
                            height: 120.sp,
                            width: 220.sp,
                            decoration: BoxDecoration(
                              color: AppColors.themeColor.withOpacity(0.1),

                              image: DecorationImage(
                                image: (teacher?.signature != null &&
                                    teacher!.signature!.isNotEmpty)
                                    ? NetworkImage(
                                  '${ApiServiceUrl.urlLauncher}uploads/${teacher.signature}',
                                )
                                    : const AssetImage(ImgAssets.user) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.sp,)
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _buildShimmerProfile(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 400.sp,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientColorOne, AppColors.gradientColorTwo],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.sp),
            Container(
              height: 70.sp,
              width: 70.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 15.sp),
            Container(
              height: 16.sp,
              width: 120.sp,
              color: Colors.white,
            ),
            SizedBox(height: 10.sp),
            Container(
              height: 14.sp,
              width: 300.sp,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
