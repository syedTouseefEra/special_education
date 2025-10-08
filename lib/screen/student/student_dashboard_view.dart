import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/profile_detail/profile_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 15.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Student List",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DMSerif',
                      color: AppColors.themeColor,
                    ),
                    CustomContainer(
                      text: "Add Student",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      borderRadius: 15,
                      innerPadding: EdgeInsets.symmetric(
                        vertical: 4.sp,
                        horizontal: 10.sp,
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: searchController,
                  suffixIcon: Icon(
                    Icons.search,
                    size: 18.sp,
                    color: AppColors.themeBlue,
                  ),
                  borderColor: AppColors.grey,
                  label: 'Search',
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(bottom: 12.sp),
                  padding: EdgeInsets.fromLTRB(15.sp, 15.sp, 10.sp, 0.sp),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 70.sp,
                            width: 70.sp,
                            decoration: BoxDecoration(
                              color: AppColors.themeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              image:
                                  // student.studentImage != null && student.studentImage!.isNotEmpty
                                  //     ? DecorationImage(
                                  //   image: NetworkImage('${ApiServiceUrl.urlLauncher}uploads/${student.studentImage}',),
                                  //   // image: NetworkImage(student.studentImage!),
                                  //   fit: BoxFit.cover,
                                  // )
                                  //     :
                                  //
                                  const DecorationImage(
                                    image: AssetImage(ImgAssets.user),
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),

                          SizedBox(width: 10.sp),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "Unknown Student",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.themeColor,
                                ),
                                SizedBox(height: 2.sp),
                                CustomText(
                                  text: "PID - ${"N/A"}",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGrey,
                                ),
                                SizedBox(height: 2.sp),
                                CustomText(
                                  text: "Diagnosis - ${"N/A"}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            NavigationHelper.push(context, ProfileView());
                          },
                          child: CustomContainer(
                            text: 'View',
                            innerPadding: EdgeInsets.symmetric(
                              vertical: 4.sp,
                              horizontal: 22.sp,
                            ),
                            containerColor: Colors.white,
                            textColor: AppColors.yellow,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            borderColor: AppColors.yellow,
                            borderWidth: 1,
                            // onTap: onViewPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
