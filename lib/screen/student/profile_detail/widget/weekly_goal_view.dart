import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/date_picker_utils.dart';
import 'package:special_education/utils/image_picker.dart';
import 'package:special_education/utils/navigation_utils.dart';
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
  final TextEditingController learningOutcomeController =
      TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  final TextEditingController goalController = TextEditingController();
  final TextEditingController interventionController = TextEditingController();
  final TextEditingController learningBarrierController =
      TextEditingController();

  File? _pickedVideo;
  DateTime selectedDate = DateTime.now();

  void showAddVideoDialog({String? initialText, String? goalId}) {
    _pickedVideo = null;
    if (initialText != null) {
      learningOutcomeController.text = initialText;
    } else {
      learningOutcomeController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Add Learning Outcome',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: AppColors.themeColor,
                          ),
                          CustomText(
                            text: 'Add Weekly Learning Outcome!',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: AppColors.textGrey,
                          ),
                          SizedBox(height: 15.h),

                          Row(
                            children: [
                              CustomText(
                                text: 'Learning Outcome',
                                color: AppColors.black,
                                fontSize: 14.h,
                              ),
                              Icon(
                                Icons.star,
                                size: 10.sp,
                                color: AppColors.themeColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            controller: learningOutcomeController,
                            maxLines: 10,
                            borderRadius: 0,
                            borderColor: AppColors.grey,
                            height: 120.sp,
                            label: '',
                          ),
                          SizedBox(height: 10.h),
                          CustomText(
                            text: 'Remark',
                            color: AppColors.black,
                            fontSize: 14.h,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            controller: remarkController,
                            maxLines: 10,
                            borderRadius: 0,
                            borderColor: AppColors.grey,
                            height: 120.sp,
                            label: '',
                          ),

                          SizedBox(height: 15.h),

                          Row(
                            children: [
                              CustomText(
                                text: 'Add Video',
                                color: AppColors.black,
                                fontSize: 14.h,
                              ),
                              Icon(
                                Icons.star,
                                size: 10.sp,
                                color: AppColors.themeColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final picked =
                                          await ImagePickerHelper.pickVideoFromGallery();
                                      if (picked != null) {
                                        setDialogState(() {
                                          _pickedVideo = File(picked.path);
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.textGrey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.sp,
                                        horizontal: 10.sp,
                                      ),
                                      child: CustomText(
                                        text: 'Add Video',
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),

                                  if (_pickedVideo != null)
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.sp),
                                        child: CustomText(
                                          text: _pickedVideo!.path
                                              .split('/')
                                              .last,
                                          color: AppColors.textGrey,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 40.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final provider =
                                      Provider.of<StudentDashboardProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final text = learningOutcomeController.text
                                      .trim();
                                  bool success = await provider
                                      .addLongTermCourse(
                                        context,
                                        widget.studentId,
                                        text,
                                      );

                                  if (success && context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Goal added successfully!',
                                        ),
                                      ),
                                    );
                                    await provider.getLongTermGoal(
                                      context,
                                      widget.studentId
                                    );
                                    learningOutcomeController.clear();
                                  }
                                },
                                child: CustomContainer(
                                  borderRadius: 20.r,
                                  text: 'Weekly Goal Completed',
                                  containerColor: AppColors.yellow,
                                  padding: 1,
                                  innerPadding: EdgeInsets.symmetric(
                                    vertical: 8.sp,
                                    horizontal: 35.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showAddUpdateDialog({
    String? goalId,
    String? goalText,
    String? interventionText,
    String? learningBarrierText,
    DateTime? durationDate,
  }) {
    _pickedVideo = null;

    if (goalId != null) {
      goalController.text = goalText ?? '';
      interventionController.text = interventionText ?? '';
      learningBarrierController.text = learningBarrierText ?? '';
      selectedDate = durationDate ?? DateTime.now();
    } else {
      goalController.clear();
      interventionController.clear();
      learningBarrierController.clear();
      selectedDate = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: goalId == null
                                ? 'Add Weekly Goal'
                                : 'Edit Weekly Goal',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: AppColors.themeColor,
                          ),
                          CustomText(
                            text: goalId == null
                                ? 'Add Weekly Learning Outcome!'
                                : 'Update this Weekly Goal!',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: AppColors.textGrey,
                          ),
                          SizedBox(height: 15.h),

                          DatePickerHelper.datePicker(
                            context,
                            date: selectedDate,
                            onChanged: (newDate) {
                              setDialogState(() {
                                selectedDate = newDate;
                              });
                            },
                          ),
                          SizedBox(height: 10.h),

                          _buildTextField('Goal', goalController),
                          _buildTextField(
                            'Intervention',
                            interventionController,
                          ),
                          _buildTextField(
                            'Learning Barrier',
                            learningBarrierController,
                          ),

                          SizedBox(height: 30.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final provider =
                                      Provider.of<StudentDashboardProvider>(
                                        context,
                                        listen: false,
                                      );

                                  final response = goalId == null
                                      ? await provider.addWeeklyGoal(
                                          widget.studentId,
                                          fmt(selectedDate),
                                          goalController.text.trim(),
                                          interventionController.text.trim(),
                                          learningBarrierController.text.trim(),
                                        )
                                      : await provider.updateWeeklyGoal(
                                          goalId,
                                          fmt(selectedDate),
                                          goalController.text.trim(),
                                          interventionController.text.trim(),
                                          learningBarrierController.text.trim(),
                                        );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response["responseMessage"] ??
                                              (goalId == null
                                                  ? "Goal added successfully!"
                                                  : "Goal updated successfully!"),
                                        ),
                                      ),
                                    );
                                  }

                                  if (response["responseStatus"] == true &&
                                      context.mounted) {
                                    Navigator.pop(context);
                                    await provider.getWeeklyGoals(
                                      context,
                                      widget.studentId
                                    );
                                  }
                                },
                                child: CustomContainer(
                                  borderRadius: 20.r,
                                  text: goalId == null
                                      ? 'Add Weekly Goal'
                                      : 'Update Goal',
                                  containerColor: AppColors.yellow,
                                  padding: 1,
                                  innerPadding: EdgeInsets.symmetric(
                                    vertical: 8.sp,
                                    horizontal: 35.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(text: label, color: AppColors.black, fontSize: 14.h),
            Icon(Icons.star, size: 10.sp, color: AppColors.themeColor),
          ],
        ),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: controller,
          maxLines: 10,
          borderRadius: 0,
          borderColor: AppColors.grey,
          height: 120.sp,
          label: '',
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentDashboardProvider>(
        context,
        listen: false,
      ).getWeeklyGoals(context,widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentDashboardProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
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
                                  : goal.goalStatus == 3
                                  ? '. Upcoming'
                                  : '. OnGoing',
                              color: goal.goalStatus == 2
                                  ? AppColors.green
                                  : goal.goalStatus == 3
                                  ? AppColors.yellow
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
                          onTap: () => showAddVideoDialog(),
                          child: Visibility(
                            visible: goal.goalStatus == 1,
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

                        Visibility(
                          visible: goal.goalStatus == 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  showAddUpdateDialog(
                                    goalId: goal.id.toString(),
                                    goalText: parseHtmlToMultiline(
                                      goal.goals.toString(),
                                    ),
                                    interventionText: parseHtmlToMultiline(
                                      goal.intervention.toString(),
                                    ),
                                    learningBarrierText: parseHtmlToMultiline(
                                      goal.learningBarriers.toString(),
                                    ),
                                    durationDate: DateTime.tryParse(
                                      goal.durationDate ?? '',
                                    ),
                                  );
                                },
                                child: CustomContainer(
                                  borderRadius: 7.r,
                                  text: 'Edit',
                                  containerColor: AppColors.green,
                                  padding: 1,
                                  innerPadding: EdgeInsets.symmetric(
                                    vertical: 8.sp,
                                    horizontal: 35.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  showAddUpdateDialog();
                },
                child: CustomContainer(
                  text: '+ Add More Weekly Goal',
                  innerPadding: EdgeInsets.symmetric(
                    horizontal: 15.sp,
                    vertical: 10.sp,
                  ),
                  borderRadius: 20.r,
                  containerColor: AppColors.themeColor,
                ),
              ),
            ],
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
