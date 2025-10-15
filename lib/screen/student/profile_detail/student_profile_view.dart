import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/student/profile_detail/widget/all_videos_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/long_term_goal_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/profile_details_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/student_profile_data_model.dart';
import 'package:special_education/screen/student/profile_detail/widget/weekly_goal_view.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';

class ProfileView extends StatefulWidget {
  final StudentProfileDataModel student;
  const ProfileView({super.key, required this.student});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String selectedTab = 'Profile Details';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeaderView(
                    courseName: '',
                    moduleName: "Profile Detail",
                  ),
                  CustomText(
                    text: 'Add Weekly Goal And Possible Outcome!',
                    fontSize: 18.sp,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 15.sp),
                  Container(
                    height: 220.sp,
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
                                      widget.student.image != null &&
                                          widget.student.image!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            '${ApiServiceUrl.urlLauncher}uploads/${widget.student.image}',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
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
                                    text:
                                        '${widget.student.firstName} ${widget.student.middleName} ${widget.student.lastName}'
                                            .trim(),

                                    containerColor: AppColors.yellow,
                                    padding: 1,
                                    innerPadding: EdgeInsets.symmetric(
                                      vertical: 5.sp,
                                      horizontal: 15.sp,
                                    ),
                                  ),
                                  SizedBox(height: 5.sp),
                                  CustomText(
                                    text: 'Age- ${widget.student.age}',
                                  ),
                                  CustomText(
                                    text: 'PID- ${widget.student.pidNumber}',
                                  ),
                                  CustomText(
                                    text: 'Gender- ${widget.student.gender}',
                                  ),
                                  CustomText(
                                    text: 'D.O.B- ${widget.student.dob}',
                                  ),
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

                  Visibility(
                    visible: selectedTab != 'Learning Objective',
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        print('delete Student');
                      },
                      child: CustomContainer(
                        textAlign: TextAlign.center,
                        width: MediaQuery.sizeOf(context).width,
                        borderRadius: 0,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        text: 'Delete Student',
                        containerColor: AppColors.themeColor,
                        padding: 5.sp,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              selectedTab = 'Profile Details';
                            });
                          },
                          child: CustomContainer(
                            textAlign: TextAlign.center,
                            borderRadius: 0,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            text: 'Profile Details',
                            containerColor: selectedTab == 'Profile Details'
                                ? AppColors.themeColor
                                : AppColors.grey,
                            padding: 5.sp,
                            innerPadding: EdgeInsets.symmetric(vertical: 6.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final provider =
                                Provider.of<StudentDashboardProvider>(
                                  context,
                                  listen: false,
                                );

                            final success = await provider.getLongTermGoal(
                              widget.student.studentId.toString(),
                            );

                            if (success) {
                              setState(() {
                                selectedTab = 'Learning Objective';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.error ??
                                        'Failed to load long-term goals',
                                  ),
                                ),
                              );
                            }
                          },

                          child: CustomContainer(
                            textAlign: TextAlign.center,
                            borderRadius: 0,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            text: 'Long Term Goal',
                            containerColor: selectedTab == 'Learning Objective'
                                ? AppColors.themeColor
                                : AppColors.grey,
                            padding: 5.sp,
                            innerPadding: EdgeInsets.symmetric(vertical: 6.sp),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final provider =
                                Provider.of<StudentDashboardProvider>(
                                  context,
                                  listen: false,
                                );

                            final success = await provider.getWeeklyGoals(
                              widget.student.studentId.toString(),
                            );

                            if (success) {
                              setState(() {
                                selectedTab = 'Time Frame';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.error ??
                                        'Failed to load long-term goals',
                                  ),
                                ),
                              );
                            }
                          },
                          child: CustomContainer(
                            textAlign: TextAlign.center,
                            borderRadius: 0,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            text: 'Weekly Goal',
                            containerColor: selectedTab == 'Time Frame'
                                ? AppColors.themeColor
                                : AppColors.grey,
                            padding: 5.sp,
                            innerPadding: EdgeInsets.symmetric(vertical: 6.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          // onTap: () {
                          //   setState(() {
                          //     selectedTab = '';
                          //   });
                          // },
                          onTap: () async {
                            final provider =
                                Provider.of<StudentDashboardProvider>(
                                  context,
                                  listen: false,
                                );

                            final success = await provider.getLongTermGoal(
                              widget.student.studentId.toString(),
                            );

                            if (success) {
                              setState(() {
                                selectedTab = 'All Videos';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.error ??
                                        'Failed to load long-term goals',
                                  ),
                                ),
                              );
                            }
                          },
                          child: CustomContainer(
                            textAlign: TextAlign.center,
                            borderRadius: 0,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            text: 'All Videos',
                            containerColor: selectedTab == 'All Videos'
                                ? AppColors.themeColor
                                : AppColors.grey,
                            padding: 5.sp,
                            innerPadding: EdgeInsets.symmetric(vertical: 6.sp),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.sp),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: CustomText(
                      text: selectedTab,
                      fontSize: 22.sp,
                      fontFamily: 'Dm Serif',
                      fontWeight: FontWeight.w500,
                      color: AppColors.themeColor,
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  if (selectedTab == 'Profile Details')
                    ProfileDetailsView(student: widget.student)
                  else if (selectedTab == 'Learning Objective')
                    LongTermGoalView(
                      studentId: widget.student.studentId.toString(),
                    )
                  else if (selectedTab == 'Time Frame')
                    WeeklyGoalView(
                      studentId: widget.student.studentId.toString(),
                    )
                  else if (selectedTab == 'All Videos')
                    AllVideosView(studentId: widget.student.studentId.toString(),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
