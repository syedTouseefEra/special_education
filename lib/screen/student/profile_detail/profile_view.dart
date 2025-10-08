import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomHeaderView(courseName: '', moduleName: "Profile Detail"),
                CustomText(
                  text: 'Add Weekly Goal And Possible Outcome !',
                  fontSize: 17.sp,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 15.sp),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 90.sp,
                              width: 90.sp,
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
                            SizedBox(width: 20.sp),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomContainer(
                                  borderRadius: 0,
                                  text: 'Syed Touseef',
                                  containerColor: AppColors.yellow,
                                  padding: 1,
                                  innerPadding: EdgeInsets.symmetric(
                                    vertical: 5.sp,
                                    horizontal: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 5.sp),
                                CustomText(text: 'Age- 5Years'),
                                CustomText(text: 'PID- 2636473'),
                                CustomText(text: 'Gender- Female'),
                                CustomText(text: 'D.O.B- 30-09-2022'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              borderRadius: 10.sp,
                              text: 'Diagnosis- GD',
                              containerColor: AppColors.themeColor,
                              padding: 1,
                              innerPadding: EdgeInsets.symmetric(
                                vertical: 8.sp,
                                horizontal: 35.sp,
                              ),
                            ),
                            CustomContainer(
                              borderRadius: 10.sp,
                              text: 'Update',
                              containerColor: AppColors.green,
                              padding: 1,
                              innerPadding: EdgeInsets.symmetric(
                                vertical: 8.sp,
                                horizontal: 25.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.sp),
                CustomContainer(
                  textAlign: TextAlign.center,
                  width: MediaQuery.sizeOf(context).width,
                  borderRadius: 0,
                  text: 'Delete Student',
                  containerColor: AppColors.themeColor,
                  padding: 5.sp,

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
