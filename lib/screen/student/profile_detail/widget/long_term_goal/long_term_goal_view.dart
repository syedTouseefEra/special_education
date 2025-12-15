import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/profile_detail/add_student/add_student_view.dart';
import 'package:special_education/screen/student/profile_detail/widget/long_term_goal/add_long_term_goal_view.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class LongTermGoalView extends StatefulWidget {
  final String studentId;
  const LongTermGoalView({super.key, required this.studentId});

  @override
  State<LongTermGoalView> createState() => _LongTermGoalViewState();
}

class _LongTermGoalViewState extends State<LongTermGoalView> {
  final TextEditingController learningTextController = TextEditingController();

  void showLongTermGoalDialog({
    String? initialText,
    String? goalId,
  }) {
    bool isEdit = goalId != null;
    if (initialText != null) {
      learningTextController.text = initialText;
    } else {
      learningTextController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 450.h,
            child: Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: isEdit ? 'Update Long Term Goal' : 'Add Long Term Goal',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: AppColors.themeColor,
                    ),
                    CustomText(
                      text: isEdit ? 'Update your long term goal below' : 'Add Long Term Goal',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColors.grey,
                    ),
                    const Divider(thickness: 1),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        CustomText(
                          text: 'Long Term Goal',
                          color: AppColors.textGrey,
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
                      controller: learningTextController,
                      maxLines: 10,
                      borderRadius: 0,
                      borderColor: AppColors.grey,
                      height: 220.sp,
                      label: '',
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            final provider = Provider.of<StudentDashboardProvider>(
                              context,
                              listen: false,
                            );

                            final text = learningTextController.text.trim();

                            bool success = false;

                            if (isEdit) {
                              success = await provider.updateLongTermCourse(context,goalId, text);
                              if (success) {
                                if (!mounted) return;
                                NavigationHelper.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Goal updated successfully!')),
                                );
                              }
                            } else {
                              success = await provider.addLongTermCourse(context,widget.studentId, text);
                              if (success) {
                                if (!mounted) return;
                                NavigationHelper.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Goal added successfully!')),
                                );
                              }
                            }

                            if (success) {
                              await provider.getLongTermGoal(context,widget.studentId);
                              learningTextController.clear();
                            }
                          },

                          child: CustomContainer(
                            borderRadius: 20.r,
                            text: isEdit ? 'Update' : 'Add',
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
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentDashboardProvider>(
        context,
        listen: false,
      ).getLongTermGoal(context,widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final longTermGoals = provider.longTermGoalData;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Add Long Term Goal Which Kid Achieve',
                fontSize: 16.sp,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w400,
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  // showLongTermGoalDialog();
                  NavigationHelper.push(context, AddLongTermGoalView(studentId: widget.studentId,));
                },
                child: CustomContainer(
                  width: MediaQuery.sizeOf(context).width,
                  text: '+ Add Long Term Goal',
                  containerColor: AppColors.yellow,
                  textAlign: TextAlign.center,
                  borderRadius: 20.r,
                ),
              ),
              if (longTermGoals == null || longTermGoals.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No long term goals found."),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: longTermGoals.length,
                  itemBuilder: (context, index) {
                    final goal = longTermGoals[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 8.sp,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "Long Term Goal ${index + 1} - ",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.themeColor,
                                ),
                                CustomText(
                                  text: goal.goalStatus == 1
                                      ? 'Ongoing'
                                      : 'Completed',
                                  fontSize: 11.sp,
                                  color: AppColors.yellow,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.sp),
                              child: const Divider(thickness: 1),
                            ),
                            CustomText(
                              text: 'Goals',
                              color: AppColors.textGrey,
                            ),
                            SizedBox(height: 5.h),
                            CustomText(
                              text: parseHtmlToMultiline(
                                goal.longTermGoal ?? "",
                              ),
                              color: AppColors.black,
                            ),
                            Visibility(
                              visible: goal.goalStatus == 1,
                              child: Padding(
                                padding: EdgeInsets.all(5.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        NavigationHelper.push(context, AddLongTermGoalView(
                                            studentId: widget.studentId,
                                            initialText: goal.longTermGoal,
                                          goalId: goal.id.toString()));
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
                            ),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

