import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/generate_trimester_report_data_modal.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/option_item_widget.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/save_continue_button_widget.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/star_collect_widget.dart';
import 'package:special_education/screen/teacher/update_teacher/widgets/update_button.dart';

class GenerateTrimesterReportView extends StatefulWidget {
  final String studentName;
  final String studentId;

  const GenerateTrimesterReportView({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<GenerateTrimesterReportView> createState() =>
      _GenerateTrimesterReportViewState();
}

class _GenerateTrimesterReportViewState
    extends State<GenerateTrimesterReportView> {
  late ReportDashboardProvider _provider;
  bool _initialized = false;
  final remarkController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _provider = Provider.of<ReportDashboardProvider>(context, listen: false);
      _fetchData();
      _initialized = true;
    }
  }

  Future<void> _fetchData() async {
    final bool trimesterOk =
    await _provider.getTrimesterReportData(context, widget.studentId);
    final bool learningOk =
    await _provider.getLearningAreasData(context, widget.studentId);
    if (!trimesterOk && !learningOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load report data.")),
      );
    }
  }

  // Common options for every skill parent
  final List<String> _options = ["Poor", "Average", "Good", "Excellent"];

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
                  moduleName: "Learning Areas",
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(12.sp, 0.sp, 12.sp, 0.sp),
                  child: Consumer<ReportDashboardProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final List<TrimesterGenerateReportDataModel> learningAreasList =
                          provider.learningAreasData ?? <TrimesterGenerateReportDataModel>[];

                      final int learningAreas = learningAreasList.length;

                      if (learningAreas == 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.sp),
                          child: Center(
                            child: CustomText(text: "No learning areas found"),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(thickness: 1.sp,),
                          SizedBox(height: 10.sp,),
                          ListView.builder(
                            itemCount: learningAreas,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final TrimesterGenerateReportDataModel area = learningAreasList[index];
                              // final String areaName = area.name ?? 'Untitled';

                              final List<SkillQualityParent> parents = area.skillQualityParent ?? <SkillQualityParent>[];
                              print("Star Count "+area.star.toString());
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     CustomText(text: "${index + 1}."),
                                      //     SizedBox(width: 10.sp,),
                                      //     CustomText(text: areaName),
                                      //   ],
                                      // ),
                                      //
                                      // SizedBox(height: 8.sp),

                                      ListView.separated(
                                        itemCount: parents.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (_, __) => SizedBox(height: 8.sp),
                                        itemBuilder: (context, pIndex) {
                                          final SkillQualityParent parent = parents[pIndex];
                                          final String parentName = parent.name ?? '';

                                          int selectedRating = parent.ratingId ?? 0;

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(text: parentName,fontSize: 14.sp,),
                                              SizedBox(height: 10.sp),

                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 3,
                                                          label: "Good",
                                                          selected: selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId = 3;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 4,
                                                          label: "Excellent",
                                                          selected: selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId = 4;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.sp),

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 1,
                                                          label: "Poor",
                                                          selected: selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId = 1;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 2,
                                                          label: "Average",
                                                          selected: selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId = 2;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                              SizedBox(height: 10.sp),
                                              Divider(thickness: 1,)
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(height: 5.sp),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(text: "Remark"),
                                          SizedBox(height: 6.sp),
                                          TextField(
                                            controller: remarkController,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter remark here...',
                                              hintStyle: TextStyle(fontSize: 14.sp),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                borderSide: BorderSide(color: AppColors.grey),
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.sp),
                                      CustomText(text: "Star Collected"),
                                      SizedBox(height: 10.sp),
                                      InteractiveStarRating(
                                        apiStarCount: area.star ?? 0,
                                        maxDisplay: 10,
                                        size: 20.sp,
                                        onChanged: (value) {
                                          setState(() {
                                            area.star = value;
                                          });
                                          // optionally call provider/api to persist
                                          // Provider.of<ReportDashboardProvider>(context, listen: false)
                                          //     .updateStar(area.qualityId, value);
                                        },
                                      ),
                                      SizedBox(height: 10.sp),

                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20.sp,),
                          SaveContinueButton(onPressed: (){}),
                          SizedBox(height: 30.sp,),
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


