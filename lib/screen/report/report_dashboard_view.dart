import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/main.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/trimester_report_view.dart';
import 'package:special_education/screen/report/trimester_report/weekly_report/weekly_report_view.dart';
import 'package:special_education/screen/top_right_button/top_option_sheet_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ReportDashboard extends StatefulWidget {
  const ReportDashboard({super.key});

  @override
  State<ReportDashboard> createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<ReportDashboard> with RouteAware {
  final searchController = TextEditingController();
  late BuildContext scaffoldContext;
  late var isSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportDashboardProvider>(
        context,
        listen: false,
      ).fetchReportStudentList(context);
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
    Provider.of<ReportDashboardProvider>(
      context,
      listen: false,
    ).fetchReportStudentList(context);
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
              appBar: CustomAppBar(
                enableTheming: false,
                onNotificationTap: () {
                  showTopSheet(
                    context,
                    TopOptionSheet(
                      name: UserData().getUserData.name!.isEmpty?'NA': UserData().getUserData.name.toString(),
                      subtitle: UserData().getUserData.instituteName!.isEmpty?'NA': UserData().getUserData.instituteName.toString(),
                      profileImage: '${ApiServiceUrl.urlLauncher}uploads/${UserData().getUserData.profileImage}',
                    ),
                  );
                },
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                setState(() => isSelected = true);
                              },
                              child: CustomContainer(
                                padding: 5.sp,
                                text: "Weekly Report",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                borderRadius: 5.r,
                                textColor: isSelected
                                    ? AppColors.white
                                    : AppColors.themeColor,
                                containerColor: isSelected
                                    ? AppColors.themeColor
                                    : AppColors.white,
                                borderColor: isSelected
                                    ? Colors.transparent
                                    : AppColors.themeColor,
                                borderWidth: isSelected ? 0 : 0.7.sp,
                                innerPadding: EdgeInsets.symmetric(
                                  vertical: 8.sp,
                                  horizontal: 25.sp,
                                ),
                              ),
                            ),

                            InkWell(
                              splashColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                setState(() => isSelected = false);
                              },
                              child: CustomContainer(
                                padding: 5.sp,
                                text: "Trimester Report",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                borderRadius: 5.r,
                                textAlign: TextAlign.center,
                                textColor: !isSelected
                                    ? AppColors.white
                                    : AppColors.themeColor,
                                containerColor: !isSelected
                                    ? AppColors.themeColor
                                    : AppColors.white,
                                borderColor: !isSelected
                                    ? Colors.transparent
                                    : AppColors.themeColor,
                                borderWidth: !isSelected ? 0 : 0.7.sp,
                                innerPadding: EdgeInsets.symmetric(
                                  vertical: 8.sp,
                                  horizontal: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1.sp, color: AppColors.grey),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.sp,
                        horizontal: 15.sp,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 1.sp),
                          CustomTextField(
                            controller: searchController,
                            prefixIcon: SizedBox(
                              width: 60.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 20.sp,
                                    color: AppColors.themeColor,
                                  ),
                                  SizedBox(width: 8.sp),
                                  Container(
                                    width: 1.sp,
                                    height: 20.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            fontSize: 15.sp,
                            fontColor: AppColors.darkGrey,
                            borderColor: AppColors.grey,
                            label: 'Search',
                            onChanged: (value) {
                              Provider.of<ReportDashboardProvider>(
                                context,
                                listen: false,
                              ).updateSearchQuery(value);
                            },
                          ),
                          SizedBox(height: 5.sp),
                          Expanded(
                            child: Consumer<ReportDashboardProvider>(
                              builder: (context, provider, _) {
                                if (provider.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (provider.error != null) {
                                  return Center(child: Text(provider.error!));
                                } else if (provider.studentData == null ||
                                    provider.studentData!.isEmpty) {
                                  return const Center(
                                    child: Text("No report found"),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: provider.studentData!.length,
                                  itemBuilder: (context, index) {
                                    final student =
                                        provider.studentData![index];
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 12.sp),
                                      padding: EdgeInsets.fromLTRB(
                                        15.sp,
                                        10.sp,
                                        10.sp,
                                        10.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.borderColor,
                                          width: 1.sp,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      student.studentImage !=
                                                              null &&
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.themeColor,
                                                    ),
                                                    SizedBox(height: 2.sp),
                                                    CustomText(
                                                      text:
                                                          "PID - ${student.pidNumber ?? "N/A"}",
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.textGrey,
                                                    ),
                                                    SizedBox(height: 2.sp),
                                                    CustomText(
                                                      text:
                                                          "Diagnosis - ${student.diagnosis ?? "N/A"}",
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.textGrey,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                if (isSelected) {
                                                  final success = await provider
                                                      .getWeeklyReportData(
                                                        context,
                                                        student.id.toString(),
                                                      );
                                                  if (!mounted) return;
                                                  if (success &&
                                                      provider.weeklyReportData !=
                                                          null &&
                                                      provider
                                                          .weeklyReportData!
                                                          .isNotEmpty) {
                                                    final weeklyReport = provider
                                                        .weeklyReportData![0];
                                                    NavigationHelper.push(
                                                      scaffoldContext,
                                                      WeeklyReportView(
                                                        student: weeklyReport,
                                                      ),
                                                    );
                                                  } else {
                                                    showSnackBar(
                                                      "Failed to load top_right_button",
                                                      context,
                                                    );
                                                  }
                                                } else {
                                                  final success = await provider
                                                      .getTrimesterReportData(
                                                        context,
                                                        student.id.toString(),
                                                      );
                                                  if (!mounted) return;
                                                  if (success &&
                                                      provider.trimesterReportData !=
                                                          null &&
                                                      provider
                                                          .trimesterReportData!
                                                          .isNotEmpty) {
                                                    final profile = provider
                                                        .trimesterReportData![0];
                                                    NavigationHelper.push(
                                                      scaffoldContext,
                                                      TrimesterReportView(
                                                        student: profile,
                                                      ),
                                                    );
                                                  } else {
                                                    showSnackBar(
                                                      "Failed to load top_right_button",
                                                      context,
                                                    );
                                                  }
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: CustomContainer(
                                                  padding: 0.sp,
                                                  text: 'View',
                                                  innerPadding:
                                                      EdgeInsets.symmetric(
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
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
