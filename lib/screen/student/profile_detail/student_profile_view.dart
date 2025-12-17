import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/main.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_student_profile_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/all_videos_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/long_term_goal/long_term_goal_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/profile_details_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/weekly_goal_view.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ProfileView extends StatefulWidget {
  final String id;
  const ProfileView({super.key, required this.id});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with RouteAware {
  String selectedTab = 'Profile Details';

  @override
  void initState() {
    super.initState();
    Provider.of<StudentDashboardProvider>(
      context,
      listen: false,
    ).fetchProfileDetail(context, widget.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    Provider.of<StudentDashboardProvider>(
      context,
      listen: false,
    ).fetchProfileDetail(context,widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
              children: [
                SizedBox(height: 5.sp),
                CustomHeaderView(courseName: "", moduleName: "Profile Detail"),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),

          body: Consumer<StudentDashboardProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.studentProfileData == null ||
                  provider.studentProfileData!.isEmpty) {
                return const Center(child: Text("No profile data found"));
              }

              final student = provider.studentProfileData!.first;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: CustomText(
                          text: 'Add Weekly Goal And Possible Outcome!',
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(height: 10.sp),

                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gradientColorOne,
                              AppColors.gradientColorTwo,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.sp,horizontal: 15.sp),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 90.sp,
                                    width: 90.sp,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image:
                                          student.image != null &&
                                              student.image!.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                '${ApiServiceUrl.urlLauncher}uploads/${student.image}',
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : const DecorationImage(
                                              image: AssetImage(ImgAssets.user),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 15.sp),
                                  Expanded(
                                    child: Column(

                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15.sp,),
                                        CustomContainer(
                                          padding:0,
                                          text:
                                              '${student.firstName} ${student.middleName ?? ''} ${student.lastName}'
                                                  .trim(),
                                          containerColor: AppColors.yellow,
                                        ),
                                        SizedBox(height: 5.sp,),
                                        CustomText(
                                          text: 'Age - ${student.age}',
                                        ),
                                        CustomText(
                                          text: 'PID - ${student.pidNumber}',
                                        ),
                                        CustomText(
                                          text: 'Gender - ${student.gender}',
                                        ),
                                        CustomText(
                                          text: 'D.O.B - ${student.dob}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.sp),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  InkWell(
                                    onTap: () {
                                      NavigationHelper.push(
                                        context,
                                        UpdateStudentProfileView(
                                          student: student,
                                        ),
                                      );
                                    },
                                    child: CustomContainer(
                                      borderRadius: 10.sp,
                                      text: 'Update',
                                      containerColor: AppColors.green,
                                      padding: 1,
                                      innerPadding: EdgeInsets.symmetric(
                                        vertical: 8.sp,
                                        horizontal: 25.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.sp),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 15.sp),

                      Visibility(
                        visible: selectedTab != 'Learning Objective',
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            doubleButton(
                              context,
                              "",
                              "Are you sure? You can't undo this action afterwards.",
                              () async {
                                Navigator.pop(context);
                                await Provider.of<StudentDashboardProvider>(
                                  context,
                                  listen: false,
                                ).deleteStudent(context, widget.id);
                              },
                            );
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

                      SizedBox(height: 10.sp),

                      /// 🔹 TAB ROW 1
                      Row(
                        children: [
                          Expanded(
                            child: _tabButton(
                              text: 'Profile Details',
                              isSelected: selectedTab == 'Profile Details',
                              onTap: () {
                                setState(() {
                                  selectedTab = 'Profile Details';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: _tabButton(
                              text: 'Learning Objective',
                              isSelected: selectedTab == 'Learning Objective',
                              onTap: () async {
                                if (selectedTab == 'Learning Objective') return;

                                final success = await provider.getLongTermGoal(
                                  context,
                                  widget.id,
                                );

                                if (success) {
                                  setState(() {
                                    selectedTab = 'Learning Objective';
                                  });
                                } else {
                                  _showError(provider.error);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      /// 🔹 TAB ROW 2
                      Row(
                        children: [
                          Expanded(
                            child: _tabButton(
                              text: 'Weekly Goal',
                              isSelected: selectedTab == 'Weekly Goal',
                              onTap: () async {
                                if (selectedTab == 'Weekly Goal') return;

                                final success = await provider.getWeeklyGoals(
                                  context,
                                  widget.id,
                                );

                                if (success) {
                                  setState(() {
                                    selectedTab = 'Weekly Goal';
                                  });
                                } else {
                                  _showError(provider.error);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: _tabButton(
                              text: 'All Videos',
                              isSelected: selectedTab == 'All Videos',
                              onTap: () async {
                                if (selectedTab == 'All Videos') return;

                                final success = await provider.getAllVideos(
                                  context,
                                  widget.id,
                                );

                                if (success) {
                                  setState(() {
                                    selectedTab = 'All Videos';
                                  });
                                } else {
                                  _showError(provider.error);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.sp),

                      /// 🔹 TAB TITLE
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: CustomText(
                          text: selectedTab,
                          fontSize: 16.sp,
                          fontFamily: 'Dm Serif',
                          fontWeight: FontWeight.w500,
                          color: AppColors.themeColor,
                        ),
                      ),

                      SizedBox(height: 10.sp),


                      if (selectedTab == 'Profile Details')
                        ProfileDetailsView(student: student)
                      else if (selectedTab == 'Learning Objective')
                        LongTermGoalView(studentId: widget.id)
                      else if (selectedTab == 'Weekly Goal')
                        WeeklyGoalView(studentId: widget.id)
                      else if (selectedTab == 'All Videos')
                        AllVideosView(studentId: widget.id),

                      SizedBox(height: 20.sp),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔹 TAB BUTTON WIDGET
  Widget _tabButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: CustomContainer(
        textAlign: TextAlign.center,
        borderRadius: 0,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        text: text,
        containerColor: isSelected ? AppColors.themeColor : AppColors.grey,
        padding: 5.sp,
        innerPadding: EdgeInsets.symmetric(vertical: 6.sp),
      ),
    );
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? 'Something went wrong')));
  }
}
