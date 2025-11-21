import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/learning_area_report_data_modal.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/option_item_widget.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/save_continue_button_widget.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/star_collect_widget.dart';
import 'package:special_education/screen/report/trimester_report/performance_report/performance_report_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

class LearningAreaReportView extends StatefulWidget {
  final String studentName;
  final String studentId;

  const LearningAreaReportView({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<LearningAreaReportView> createState() => _LearningAreaReportViewState();
}

class _LearningAreaReportViewState extends State<LearningAreaReportView> {
  late ReportDashboardProvider _provider;
  bool _initialized = false;

  /// Per-area remark controllers keyed by `qualityId`/`id`/`name` (string).
  final Map<String, TextEditingController> _remarkControllers = {};

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
    final bool trimesterOk = await _provider.getTrimesterReportData(
      context,
      widget.studentId,
    );
    final bool learningOk = await _provider.getLearningAreasData(
      context,
      widget.studentId,
    );
    if (!trimesterOk && !learningOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load report data.")),
      );
    }
    // Note: controllers are created lazily in the builder, but if you prefer
    // to pre-initialize controllers here you may iterate _provider.learningAreasData
    // and call _controllerForArea for each area.
  }

  /// Returns a controller for the given key, creating it if missing.
  /// Optionally sets initialText if provided and controller is empty.
  TextEditingController _controllerForArea(String key, {String? initialText}) {
    if (!_remarkControllers.containsKey(key)) {
      _remarkControllers[key] = TextEditingController();
      if (initialText != null && initialText.trim().isNotEmpty) {
        _remarkControllers[key]!.text = initialText;
      }
    } else {
      // if controller exists but empty and initialText provided, set it
      if (initialText != null &&
          initialText.trim().isNotEmpty &&
          _remarkControllers[key]!.text.isEmpty) {
        _remarkControllers[key]!.text = initialText;
      }
    }
    return _remarkControllers[key]!;
  }

  /// Build the JSON payload from current model + per-area controllers
  // String _buildLearningText(List<LearningAreaReportDataModal> learningAreas) {
  //   final List<Map<String, dynamic>> qualityText = [];
  //   final List<Map<String, dynamic>> otherText = [];
  //
  //   for (int i = 0; i < learningAreas.length; i++) {
  //     final area = learningAreas[i];
  //
  //     final dynamic areaQualityId =
  //         area.qualityId ?? area.id ?? area.name ?? 'area_index_$i';
  //     final String areaKey = areaQualityId.toString();
  //
  //     final List<SkillQualityParent> parents =
  //         area.skillQualityParent ?? <SkillQualityParent>[];
  //     for (final parent in parents) {
  //       final dynamic parentId =
  //           parent.qualityParentId ?? parent.qualityParentId ?? parent.name ?? null;
  //       final int ratingId = parent.ratingId ?? 0;
  //
  //       qualityText.add({
  //         "qualityId": areaQualityId,
  //         "qualityParentId": parentId,
  //         "trimesterReportId": 0,
  //         "ratingId": ratingId,
  //       });
  //     }
  //
  //     // Read remark from per-area controller if available, otherwise fallback to model's remark or empty string
  //     final String remark = (_remarkControllers.containsKey(areaKey) &&
  //         _remarkControllers[areaKey]!.text.trim().isNotEmpty)
  //         ? _remarkControllers[areaKey]!.text.trim()
  //         : (area.remarks != null ? area.remarks.toString() : '');
  //
  //     final int stars = (area.star != null) ? area.star as int : 0;
  //
  //     otherText.add({
  //       "remark": remark,
  //       "stars": stars,
  //       "qualityId": areaQualityId,
  //     });
  //   }
  //
  //   final Map<String, dynamic> allEntry = {
  //     "qualityText": qualityText,
  //     "otherText": otherText,
  //   };
  //
  //   final Map<String, dynamic> payload = {
  //     "allText": [allEntry],
  //   };
  //
  //   return jsonEncode(payload);
  // }

  /// Build the JSON payload from current model + per-area controllers
  /// Returns a JSON *string* representing a LIST of {"allText":[{...}]} objects,
  /// one for each learning area (matching the structure you requested).
  String _buildLearningText(List<LearningAreaReportDataModal> learningAreas) {
    final List<Map<String, dynamic>> entries = [];

    for (int i = 0; i < learningAreas.length; i++) {
      final area = learningAreas[i];

      final dynamic areaQualityId =
          area.qualityId ?? area.id ?? area.name ?? 'area_index_$i';

      // Build qualityText for this area (one entry per parent)
      final List<Map<String, dynamic>> qualityText = [];
      final List<SkillQualityParent> parents =
          area.skillQualityParent ?? <SkillQualityParent>[];
      for (final parent in parents) {
        final dynamic parentId =
            parent.qualityParentId ?? parent.qualityParentId ?? parent.name ?? null;
        final int ratingId = parent.ratingId ?? 0;

        qualityText.add({
          "qualityId": areaQualityId,
          "qualityParentId": parentId,
          "ratingId": ratingId,
          "trimesterReportId": 0,
        });
      }

      // Build otherText for this area (single object per area)
      // Prefer controller value if present; fall back to model remark
      final String areaKey = areaQualityId.toString();
      final String remark = (_remarkControllers.containsKey(areaKey) &&
          _remarkControllers[areaKey]!.text.trim().isNotEmpty)
          ? _remarkControllers[areaKey]!.text.trim()
          : (area.remarks != null ? area.remarks.toString() : '');

      final int stars = (area.star != null) ? (area.star as int) : 0;

      final List<Map<String, dynamic>> otherText = [
        {
          "remark": remark,
          "stars": stars,
          "qualityId": areaQualityId,
        }
      ];

      // Each entry matches: {"allText":[ { "qualityText":[...], "otherText":[...] } ]}
      final Map<String, dynamic> entry = {
        "allText": [
          {
            "qualityText": qualityText,
            "otherText": otherText,
          }
        ]
      };

      entries.add(entry);
    }

    // Return a JSON-encoded string of the array of entries.
    // This will produce a string like:
    // "[{\"allText\":[{...}]},{\"allText\":[{...}]}]"
    return jsonEncode(entries);
  }


  @override
  void dispose() {
    // dispose per-area controllers
    for (final controller in _remarkControllers.values) {
      controller.dispose();
    }
    _remarkControllers.clear();
    super.dispose();
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
                  moduleName: "Learning Areas",
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(12.sp, 0.sp, 12.sp, 0.sp),
                  child: Consumer<ReportDashboardProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final List<LearningAreaReportDataModal> learningAreasList =
                          provider.learningAreasData ??
                              <LearningAreaReportDataModal>[];

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
                          Divider(thickness: 1.sp),
                          SizedBox(height: 10.sp),
                          ListView.builder(
                            itemCount: learningAreas,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final LearningAreaReportDataModal area =
                              learningAreasList[index];

                              final List<SkillQualityParent> parents =
                                  area.skillQualityParent ??
                                      <SkillQualityParent>[];

                              // Determine a stable key for this area (qualityId / id / name / fallback index)
                              final dynamic rawKey =
                                  area.qualityId ?? area.id ?? area.name ?? 'area_index_$index';
                              final String areaKey = rawKey.toString();

                              // Create or fetch the controller for this area and initialize with any existing remark.
                              final TextEditingController areaRemarkController =
                              _controllerForArea(areaKey, initialText: area.remarks?.toString());

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
                                      ListView.separated(
                                        itemCount: parents.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 8.sp),
                                        itemBuilder: (context, pIndex) {
                                          final SkillQualityParent parent =
                                          parents[pIndex];
                                          final String parentName =
                                              parent.name ?? '';

                                          int selectedRating = parent.ratingId ?? 0;

                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: parentName,
                                                fontSize: 14.sp,
                                              ),
                                              SizedBox(height: 10.sp),

                                              Column(
                                                children: [

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 1,
                                                          label: "Poor",
                                                          selected:
                                                          selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId =
                                                              1;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 2,
                                                          label: "Average",
                                                          selected:
                                                          selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId =
                                                              2;
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
                                                          value: 3,
                                                          label: "Good",
                                                          selected:
                                                          selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId =
                                                              3;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: OptionItem(
                                                          value: 4,
                                                          label: "Excellent",
                                                          selected:
                                                          selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId =
                                                              4;
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
                                                          value: 0,
                                                          label:
                                                          "Not Applicable ",
                                                          selected:
                                                          selectedRating,
                                                          onTap: () {
                                                            setState(() {
                                                              parent.ratingId =
                                                              0;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.sp),
                                              Divider(thickness: 1),
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(height: 5.sp),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          CustomText(text: "Remark"),
                                          SizedBox(height: 6.sp),
                                          TextField(
                                            style: TextStyle(
                                              fontSize: 14.sp
                                            ),
                                            controller: areaRemarkController,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                vertical: 10.sp,
                                                horizontal: 10.sp,
                                              ),
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter remark here...',
                                              hintStyle: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 14.sp,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: AppColors.grey,
                                                ),
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
                                        },
                                      ),
                                      SizedBox(height: 10.sp),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20.sp),
                          SaveContinueButton(
                            onPressed: () {

                              NavigationHelper.push(context, PerformanceReportView(studentName: widget.studentName, studentId: widget.studentId,));
                              // final List<LearningAreaReportDataModal>
                              // learningAreasList =
                              //     provider.learningAreasData ??
                              //         <LearningAreaReportDataModal>[];
                              //
                              // final String learningTextJson =
                              // _buildLearningText(learningAreasList);
                              //
                              // provider.saveTrimesterReport(
                              //   context,
                              //   learningTextJson,
                              // );
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
