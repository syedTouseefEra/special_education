import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/text_case_utils.dart';
import 'package:special_education/utils/video_player_screen.dart';
import 'package:special_education/utils/video_thumbnail_generator.dart';

class WeeklyGoalView extends StatefulWidget {
  final String studentId;

  const WeeklyGoalView({super.key, required this.studentId});

  @override
  State<WeeklyGoalView> createState() => _WeeklyGoalViewState();
}

class _WeeklyGoalViewState extends State<WeeklyGoalView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentDashboardProvider>(
        context,
        listen: false,
      ).getWeeklyGoals(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentDashboardProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Add Weekly Goal And Possible Outcome!',
            fontSize: 17.sp,
            fontFamily: 'Poppins',
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 15.sp),

          if (provider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.weeklyGoalData!.isEmpty)
            Center(
              child: CustomText(
                text: 'No weekly goals found.',
                fontSize: 15.sp,
                color: AppColors.grey,
              ),
            )
          else
            ...provider.weeklyGoalData!.map(
              (goal) => Padding(
                padding: EdgeInsets.only(bottom: 15.sp),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey, width: 1.sp),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: 'Week ${goal.weekCount}',
                              color: AppColors.themeColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: ' | ',
                              color: AppColors.textGrey,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: goal.goalStatus == 2
                                  ? '. Completed'
                                  : '. OnGoing',
                              color: goal.goalStatus == 2
                                  ? AppColors.green
                                  : AppColors.yellow,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        Divider(thickness: 1),
                        _buildGoalField("Duration", goal.durationDate),
                        _buildGoalField("Goal", goal.goals),
                        _buildGoalField("Intervention", goal.intervention),
                        _buildGoalField(
                          "Learning Barrier",
                          goal.learningBarriers,
                        ),
                        Visibility(
                          visible:
                              goal.videoList != null &&
                              goal.videoList!.isNotEmpty,
                          child: _buildGoalField(
                            "Learning Outcome",
                            goal.learningOutCome,
                          ),
                        ),
                        InkWell(
                          onTap: (){

                          },
                          child: Visibility(
                            visible: goal.videoList!.isEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Learning Outcome',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                                CustomText(
                                  text: '+Add',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.yellow,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              goal.remarks != null && goal.remarks!.isNotEmpty,
                          child: _buildGoalField("Remark", goal.remarks),
                        ),
                        if (goal.videoList != null &&
                            goal.videoList!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 10.sp),
                            child: SizedBox(
                              height: 105.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: goal.videoList!.length,
                                itemBuilder: (context, index) {
                                  final mainUrl =
                                      'https://hamaaresitaareapi.edumation.in/FileUploads/weeklyGoal/';
                                  final video = goal.videoList![index];
                                  final fullUrl =
                                      '$mainUrl${video.videoName ?? ''}';

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100.h,
                                        width: 160.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.grey.withOpacity(
                                            0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8.sp,
                                          ),
                                          border: Border.all(
                                            color: AppColors.grey,
                                            width: 1.sp,
                                          ),
                                        ),
                                        child: FutureBuilder<String?>(
                                          future:
                                              VideoThumbnailGenerator.generateThumbnail(
                                                fullUrl,
                                              ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
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
                                                          videoUrl: fullUrl,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.sp,
                                                        ),
                                                    child: Image.file(
                                                      File(snapshot.data!),
                                                      width: 160.w,
                                                      height: 100.h,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.play_circle_fill,
                                                    size: 40.sp,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalField(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: LabelValueText(
        isRow: false,
        label: parseHtmlToMultiline(label),
        value: parseHtmlToMultiline(value ?? 'NA'),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        ),
        valueStyle: TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
        valueCase: TextCase.title,
      ),
    );
  }
}
