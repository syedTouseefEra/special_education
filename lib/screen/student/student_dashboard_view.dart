import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/main.dart';
import 'package:special_education/screen/student/profile_detail/student_profile_view.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';


class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> with RouteAware {
  final searchController = TextEditingController();
  late BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();
    Provider.of<StudentDashboardProvider>(context, listen: false).fetchStudentList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    Provider.of<StudentDashboardProvider>(context, listen: false).fetchStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Builder(
          builder: (BuildContext newContext) {
            scaffoldContext = newContext;
            return Scaffold(
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
                      onChanged: (value) {
                        Provider.of<StudentDashboardProvider>(context, listen: false)
                            .updateSearchQuery(value);
                      },
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Consumer<StudentDashboardProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (provider.error != null) {
                            return Center(child: Text(provider.error!));
                          } else if (provider.studentData == null || provider.studentData!.isEmpty) {
                            return const Center(child: Text("No students found"));
                          }

                          return ListView.builder(
                            itemCount: provider.studentData!.length,
                            itemBuilder: (context, index) {
                              final student = provider.studentData![index];
                              return Container(
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
                                      children: [
                                        Container(
                                          height: 70.sp,
                                          width: 70.sp,
                                          decoration: BoxDecoration(
                                            color: AppColors.themeColor.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            image: student.studentImage != null && student.studentImage!.isNotEmpty
                                                ? DecorationImage(
                                              image: NetworkImage('${ApiServiceUrl.urlLauncher}uploads/${student.studentImage}'),
                                              fit: BoxFit.cover,
                                            )
                                                : const DecorationImage(
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
                                                text: student.studentName ?? "Unknown Student",
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.themeColor,
                                              ),
                                              SizedBox(height: 2.sp),
                                              CustomText(
                                                text: "PID - ${student.pidNumber ?? "N/A"}",
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textGrey,
                                              ),
                                              SizedBox(height: 2.sp),
                                              CustomText(
                                                text: "Diagnosis - ${student.diagnosis ?? "N/A"}",
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
                                        onTap: () async {
                                          final success = await provider.fetchProfileDetail(student.id.toString());
                                          if (!mounted) return;
                                          if (success && provider.studentProfileData != null && provider.studentProfileData!.isNotEmpty) {
                                            final profile = provider.studentProfileData![0];
                                            NavigationHelper.push(scaffoldContext, ProfileView(student: profile));
                                          } else {
                                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                              SnackBar(content: Text(provider.error ?? "Failed to load profile")),
                                            );
                                          }
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
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

