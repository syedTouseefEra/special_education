import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/assessment_section_widget.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/save_continue_button_widget.dart';
import 'package:special_education/screen/report/trimester_report/performance_report/widget/performance_item.dart';


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
  late List<PerformanceItem> performanceItems;

  @override
  void initState() {
    super.initState();

    performanceItems = [
      PerformanceItem(
        name: "Attention (Concentration/Focus)",
        remarkController: TextEditingController(),
      ),
      PerformanceItem(
        name: "Memory (Retention And Recall)",
        remarkController: TextEditingController(),
      ),
      PerformanceItem(
        name: "Learning (Interest/Engagement)",
        remarkController: TextEditingController(),
      ),
      PerformanceItem(
        name: "Command (Following/Responsive)",
        remarkController: TextEditingController(),
      ),
    ];
  }



  String buildPerformanceTextJson() {
    final List<Map<String, dynamic>> jsonList =
    performanceItems.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }


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
                  padding: EdgeInsets.fromLTRB(12.sp, 0, 12.sp, 0),
                  child: Consumer<ReportDashboardProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          Divider(thickness: 1.sp),
                          SizedBox(height: 10.sp),

                          Column(
                            children: List.generate(performanceItems.length, (index) {
                              final item = performanceItems[index];

                              return Padding(
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

                                  child: AssessmentSection(
                                    title: item.name,
                                    remarkController: item.remarkController,
                                    onRatingChanged: (rating) {
                                      item.ratingId = rating;
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: 20.sp),

                          SaveContinueButton(
                            onPressed: () {
                              String performanceText = buildPerformanceTextJson();
                              print("performanceText "+performanceText.toString());

                              provider.savePerformanceReport(
                                context,
                                performanceText,
                              );
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
