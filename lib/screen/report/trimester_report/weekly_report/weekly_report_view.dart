import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/download_save_video.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/utils/null_safely_handle.dart';
import 'package:special_education/utils/text_case_utils.dart';
import 'package:special_education/utils/video_player_screen.dart';
import 'package:special_education/utils/video_thumbnail_generator.dart';
import 'package:special_education/screen/report/trimester_report/weekly_report/weekly_report_data_model.dart';


class WeeklyReportView extends StatefulWidget {
  final WeeklyReportDataModel student;
  const WeeklyReportView({super.key, required this.student});

  @override
  State<WeeklyReportView> createState() => _WeeklyReportViewState();
}

class _WeeklyReportViewState extends State<WeeklyReportView> {
  late final List<dynamic> weeklyGoal;
  late final ReportDashboardProvider provider;

  bool isGenerateClicked = false;
  List<bool> checkedList = [];

  List<int> getSelectedWeeklyGoalIds() {
    List<int> selectedIds = [];

    for (int i = 0; i < checkedList.length; i++) {
      if (checkedList[i]) {
        final id = weeklyGoal[i].id;
        if (id != null) {
          selectedIds.add(id);
        }
      }
    }

    return selectedIds;
  }

  void resetCheckedList() {
    checkedList = List<bool>.filled(weeklyGoal.length, false);
  }

  @override
  void initState() {
    super.initState();
    weeklyGoal = widget.student.weeklyGoal ?? <dynamic>[];
    provider = Provider.of<ReportDashboardProvider>(context, listen: false);
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
                CustomHeaderView(courseName: "", moduleName: "Weekly Report"),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientColorOne,
                          AppColors.gradientColorTwo,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.sp),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomContainer(
                                      borderRadius: 0,
                                      text: '${widget.student.studentName}'
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
                                      text:
                                          'Gender- ${widget.student.gender ?? 'NA'}',
                                    ),
                                    CustomText(
                                      text:
                                          'D.O.B- ${widget.student.age == ' Years' ? "NA" : widget.student.age}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weeklyGoal.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.sp),
                    itemBuilder: (context, index) {
                      final item = weeklyGoal[index];

                      final weekCount =
                          item.weekCount?.toString().checkNull ?? "NA";
                      final goalStatus =
                          item.goalStatus?.toString().checkNull ?? "NA";
                      final durationDate =
                          item.durationDate?.toString().checkNull ?? 'NA';
                      final goals =
                          item.goals?.toString().checkNull ?? 'NA';
                      final intervention =
                          item.intervention?.toString().checkNull ?? 'NA';
                      final learningBarriers =
                          item.learningBarriers?.toString().checkNull ??
                              'NA';
                      final learningOutCome =
                          item.learningOutCome?.toString().checkNull ??
                              'NA';
                      final remarks =
                          item.remarks?.toString().checkNull ?? 'NA';

                      final hasLearningOutcome =
                          item.learningOutCome != null &&
                              item.learningOutCome.toString().trim().isNotEmpty;

                      return Padding(
                        padding: EdgeInsets.all(5.sp),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(0.r),
                            border: Border.all(
                              color: AppColors.textGrey,
                              width: 0.8.sp,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: 'Week $weekCount',
                                          fontSize: 16.sp,
                                          color: AppColors.themeColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(width: 8.sp),
                                        CustomText(
                                          text: '|',
                                          color: AppColors.grey,
                                          fontSize: 14.sp,
                                        ),
                                        SizedBox(width: 12.sp),
                                        CustomText(
                                          text: goalStatus == "2"
                                              ? '.Completed'
                                              : ' .Ongoing',
                                          color: goalStatus == "2"
                                              ? AppColors.green
                                              : AppColors.yellow,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),

                                    if (isGenerateClicked &&
                                        hasLearningOutcome)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkedList[index] =
                                            !checkedList[index];
                                          });
                                        },
                                        child: Icon(
                                          checkedList[index]
                                              ? Icons.check_box
                                              : Icons
                                              .check_box_outline_blank,
                                          color: checkedList[index]
                                              ? AppColors.green
                                              : AppColors.black,
                                          size: 20.sp,
                                        ),
                                      ),
                                  ],
                                ),

                                SizedBox(height: 3.sp),
                                Divider(
                                  thickness: 0.7.sp,
                                  color: AppColors.black,
                                ),
                                SizedBox(height: 3.sp),
                                LabelValueText(
                                  isRow: false,
                                  label: "Duration",
                                  value: durationDate,
                                  labelStyle: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey,
                                  ),
                                  valueStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.darkGrey,
                                  ),
                                  valueCase: TextCase.title,
                                ),
                                SizedBox(height: 10.sp),
                                LabelValueText(
                                  isRow: false,
                                  label: "Goal",
                                  value: goals,
                                  labelStyle: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey,
                                  ),
                                  valueStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.darkGrey,
                                  ),
                                  valueCase: TextCase.title,
                                ),
                                SizedBox(height: 10.sp),
                                LabelValueText(
                                  isRow: false,
                                  label: "Intervention",
                                  value: intervention,
                                  labelStyle: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey,
                                  ),
                                  valueStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.darkGrey,
                                  ),
                                  valueCase: TextCase.title,
                                ),
                                SizedBox(height: 10.sp),
                                LabelValueText(
                                  isRow: false,
                                  label: "LearningBarriers",
                                  value: learningBarriers,
                                  labelStyle: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.themeColor,
                                  ),
                                  valueStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.darkGrey,
                                  ),
                                  valueCase: TextCase.title,
                                ),
                                SizedBox(height: 10.sp),
                                LabelValueText(
                                  isRow: false,
                                  label: "Learning Outcome",
                                  value: learningOutCome,
                                  labelStyle: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.green,
                                  ),
                                  valueStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.darkGrey,
                                  ),
                                  valueCase: TextCase.title,
                                ),
                                SizedBox(height: 10.sp),
                                LabelValueText(
                                  isRow: false,
                                  label: "Remarks",
                                  value: remarks,
                                  labelStyle: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey,
                                  ),
                                  valueStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.darkGrey,
                                  ),
                                  valueCase: TextCase.title,
                                ),
                                SizedBox(height: 10.sp),
                                ListView.builder(
                                  itemCount: item.videoList?.length ?? 0,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, videoIndex) {
                                    final mainUrl =
                                        'https://hamaaresitaareapi.edumation.in/FileUploads/weeklyGoal/';
                                    final video = item
                                        .videoList![videoIndex];

                                    final fullUrl =
                                        '$mainUrl${video.videoName ?? ''}';
                                    final fileName =
                                        video.videoName ?? 'video.mp4';

                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 180.h,
                                          width: MediaQuery.sizeOf(
                                            context,
                                          ).width,
                                          child: FutureBuilder<String?>(
                                            future:
                                            VideoThumbnailGenerator.generateThumbnail(
                                              fullUrl,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot
                                                  .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                  CircularProgressIndicator(),
                                                );
                                              }

                                              if (snapshot.hasError ||
                                                  snapshot.data == null) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          VideoPlayerScreen(
                                                            videoUrl:
                                                            fullUrl,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                      Alignment.center,
                                                      children: [
                                                        ClipRRect(
                                                          child: Image.file(
                                                            File(
                                                              snapshot
                                                                  .data!,
                                                            ),
                                                            width:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width,
                                                            height: 149.h,
                                                            fit: BoxFit
                                                                .cover,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          size: 40.sp,
                                                          color: Colors
                                                              .white
                                                              .withOpacity(
                                                            0.8,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      color: AppColors
                                                          .themeColor,
                                                      height: 30.sp,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal:
                                                          10.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .fullscreen,
                                                              color:
                                                              AppColors
                                                                  .white,
                                                              size: 25.sp,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                downloadAndShareVideo(
                                                                  fullUrl,
                                                                  fileName,
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .save_alt,
                                                                    color: AppColors
                                                                        .white,
                                                                    size: 18
                                                                        .sp,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2
                                                                        .sp,
                                                                  ),
                                                                  CustomText(
                                                                    text:
                                                                    'Download',
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                  ),
                                                                ],
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
                                        SizedBox(height: 10.sp),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.sp),
                  Visibility(
                    visible: weeklyGoal.isNotEmpty && !isGenerateClicked,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomContainer(
                          borderRadius: 20.r,
                          padding: 0,
                          innerPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 15.sp,
                          ),
                          containerColor: AppColors.themeColor,
                          text: 'Generate Report',
                          onTap: () {
                            setState(() {
                              isGenerateClicked = true;
                              resetCheckedList();
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: isGenerateClicked,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomContainer(
                          borderRadius: 20.r,
                          borderColor: AppColors.black,
                          borderWidth: 0.7.sp,
                          padding: 0,
                          textColor: AppColors.black,
                          innerPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 20.sp,
                          ),
                          containerColor: AppColors.transparent,
                          text: 'Cancel',
                          onTap: () {
                            setState(() {
                              isGenerateClicked = false;
                              resetCheckedList();
                            });
                          },
                        ),

                        SizedBox(width: 10.sp),
                        CustomContainer(
                          borderRadius: 20.r,
                          padding: 0.sp,
                          innerPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 15.sp,
                          ),
                          containerColor: AppColors.themeColor,
                          text: 'Save Report',
                          onTap: () {
                            final selectedWeekIds = getSelectedWeeklyGoalIds();

                            if (selectedWeekIds.isEmpty) {
                              showSnackBar(
                                'Please select at least one week report.',
                                context,
                              );
                              return;
                            }

                            provider.getWeeklyPDFReportData(
                              context,
                              widget.student.studentId.toString(),
                              selectedWeekIds.join(','),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.sp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
