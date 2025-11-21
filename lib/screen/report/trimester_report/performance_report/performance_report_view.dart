import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/cumulative_rating_row.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/save_continue_button_widget.dart';
import 'package:special_education/screen/report/trimester_report/performance_report/widget/progress_bar_widget.dart';

class PerformanceReportView extends StatefulWidget {
  final String studentName;
  final String studentId;

  const PerformanceReportView({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<PerformanceReportView> createState() => _PerformanceReportViewState();
}

class _PerformanceReportViewState extends State<PerformanceReportView> {
  final remarkController = TextEditingController();
  int selected = 0;

  final List<Color> ratingColors = [
    Color(0xFFFF0000), // 1
    Color(0xFFFF7A00), // 2
    Color(0xFFFFD100), // 3
    Color(0xFF2ECC40), // 4
    Color(0xFF007F00), // 5
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomHeaderView(
                  courseName: widget.studentName,
                  moduleName: "Performance Report",
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(12.sp, 0.sp, 12.sp, 0.sp),
                  child: Consumer<ReportDashboardProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(thickness: 1.sp),
                          SizedBox(height: 10.sp),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.sp),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.themeColor,
                                  width: 1.sp,
                                ),
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                              padding: EdgeInsets.all(10.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "1. Attention (concentration/focus)",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 10.sp),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 9.sp,
                                              width: double.infinity,
                                              color: AppColors.grey.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                            // inside any widget build method
                                            CumulativeRatingRow(
                                              initial: 0,
                                              onChanged: (val) {
                                                print("Selected rating: $val");
                                                // update your model e.g. area.star = val;
                                              },
                                            ),

                                          ],
                                        ),

                                        SizedBox(height: 8.sp),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 10.sp),
                                  CustomText(
                                    text:
                                        "Score on the scale of 1-5 (where 1 is lowest and 5 is higher)",
                                    fontSize: 11.sp,
                                    color: AppColors.grey,
                                  ),
                                  SizedBox(height: 10.sp),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Remark",
                                        fontSize: 15.sp,
                                      ),
                                      SizedBox(height: 10.sp),
                                      TextField(
                                        controller: remarkController,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.sp,
                                            horizontal: 10.sp,
                                          ),
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Learning Outcome!',
                                          hintStyle: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 14.sp,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.sp),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.sp),
                          SaveContinueButton(
                            onPressed: () {
                              // provider.saveTrimesterReport(context);
                            },
                          ),
                          SizedBox(height: 30.sp),
                        ],
                      );
                    },
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
