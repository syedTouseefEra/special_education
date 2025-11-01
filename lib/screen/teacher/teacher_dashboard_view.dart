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
import 'package:special_education/screen/teacher/add_teacher/add_teacher_view.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/screen/teacher/teacher_profile_details/teacher_profile_details_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> with RouteAware {
  final searchController = TextEditingController();
  late BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherDashboardProvider>(context, listen: false)
          .fetchTeacherList();
    });
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
    Provider.of<TeacherDashboardProvider>(context, listen: false)
        .fetchTeacherList();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.sp),
                    CustomText(
                      text: "View Teacher",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DMSerif',
                      color: AppColors.themeColor,
                    ),
                    SizedBox(height: 5.sp),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.sp),
                            child: CustomTextField(
                              controller: searchController,
                              suffixIcon: Icon(
                                Icons.search,
                                size: 18.sp,
                                color: AppColors.themeColor,
                              ),
                              borderColor: AppColors.grey,
                              label: 'Search',
                              onChanged: (value) {
                                Provider.of<TeacherDashboardProvider>(
                                  context,
                                  listen: false,
                                ).updateSearchQuery(value);
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: AppColors.transparent,
                          highlightColor: AppColors.transparent,
                          onTap: () {
                            NavigationHelper.push(context, AddTeacherView());
                          },
                          child: CustomContainer(
                            text: "Add Teacher",
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            borderRadius: 20.r,
                            innerPadding: EdgeInsets.symmetric(
                              vertical: 10.sp,
                              horizontal: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.sp),
                    Expanded(
                      child: Consumer<TeacherDashboardProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (provider.error != null) {
                            return Center(child: Text(provider.error!));
                          } else if (provider.teacherData == null ||
                              provider.teacherData!.isEmpty) {
                            return const Center(
                              child: Text("No Teacher found"),
                            );
                          }

                          return ListView.builder(
                            itemCount: provider.teacherData!.length,
                            itemBuilder: (context, index) {
                              final teacher = provider.teacherData![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12.sp),
                                padding: EdgeInsets.fromLTRB(
                                  15.sp,
                                  15.sp,
                                  10.sp,
                                  0.sp,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 0.5.sp,
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
                                            image: teacher.image != null &&
                                                teacher.image!.isNotEmpty
                                                ? DecorationImage(
                                              image: NetworkImage(
                                                '${ApiServiceUrl.urlLauncher}uploads/${teacher.image}',
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
                                                text: teacher.teacherName ??
                                                    "Unknown Teacher",
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.themeColor,
                                              ),
                                              SizedBox(height: 2.sp),
                                              CustomText(
                                                text:
                                                "PID - ${teacher.employeeId ?? "N/A"}",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textGrey,
                                              ),
                                              SizedBox(height: 2.sp),
                                              CustomText(
                                                text:
                                                "Designation - ${teacher.designation ?? "N/A"}",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textGrey,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 2.sp),
                                              CustomText(
                                                text:
                                                "Mobile Number - ${teacher.mobileNumber ?? "N/A"}",
                                                fontSize: 12.sp,
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
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              // TODO: Implement remove functionality
                                            },
                                            child: CustomContainer(
                                              text: 'Remove',
                                              innerPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 4.sp,
                                                  horizontal: 22.sp),
                                              containerColor: Colors.red,
                                              textColor: AppColors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 10.sp),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              NavigationHelper.push(context, TeacherProfileDetailsView(id: teacher.userId!,));
                                            },
                                            child: CustomContainer(
                                              text: 'View',
                                              innerPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 3.sp,
                                                  horizontal: 22.sp),
                                              containerColor: Colors.white,
                                              textColor: AppColors.yellow,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              borderColor: AppColors.yellow,
                                              borderWidth: 1.r,
                                            ),
                                          ),
                                        ],
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
