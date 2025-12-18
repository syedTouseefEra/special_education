import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';
import 'package:special_education/screen/student/profile_detail/student_profile_view.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';


class CustomViewCard extends StatelessWidget {
  final StudentListDataModal student;
  final VoidCallback? onViewPressed;

  const CustomViewCard({
    super.key,
    required this.student,
    this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.fromLTRB(
        15.sp,
        15.sp,
        10.sp,
        10.sp,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.borderColor,
          width: 1.sp,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 70.sp,
                width: 70.sp,
                decoration: BoxDecoration(
                  color: AppColors.themeColor
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                  image:
                  student.studentImage != null &&
                      student
                          .studentImage!
                          .isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(
                      '${ApiServiceUrl.urlLauncher}uploads/${student.studentImage}',
                    ),
                    fit: BoxFit.cover,
                  )
                      : const DecorationImage(
                    image: AssetImage(
                      ImgAssets.user,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:
                      student.studentName ??
                          "Unknown Student",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor,
                    ),
                    SizedBox(height: 2.sp),
                    CustomText(
                      text:
                      "PID - ${student.pidNumber ?? "N/A"}",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(height: 2.sp),
                    CustomText(
                      text:
                      "Diagnosis - ${student.diagnosis ?? "N/A"}",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: () async {
                final provider = Provider.of<StudentDashboardProvider>(
                  context,
                  listen: false,
                );
                final success = await provider
                    .fetchProfileDetail(
                  context,
                  student.id.toString(),
                );
                if (success &&
                    provider.studentProfileData !=
                        null &&
                    provider
                        .studentProfileData!
                        .isNotEmpty) {
                  final profile =
                  provider.studentProfileData![0];
                  NavigationHelper.push( context,
                    ProfileView(id: profile.studentId.toString()),
                  );
                } else {
                  showSnackBar(provider.error ??
                      "Failed to load top_right_button", context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: CustomContainer(
                  padding: 0.sp,
                  text: 'View',
                  innerPadding: EdgeInsets.symmetric(
                    vertical: 3.sp,
                    horizontal: 20.sp,
                  ),
                  containerColor: Colors.white,
                  textColor: AppColors.yellow,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  borderColor: AppColors.yellow,
                  borderWidth: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
