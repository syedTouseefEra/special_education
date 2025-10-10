import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class LongTermGoalView extends StatefulWidget {
  final String studentId;
  const LongTermGoalView({Key? key, required this.studentId}) : super(key: key);

  @override
  State<LongTermGoalView> createState() => _LongTermGoalViewState();
}

class _LongTermGoalViewState extends State<LongTermGoalView> {
  final TextEditingController learningTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentDashboardProvider>(
        context,
        listen: false,
      ).getLongTermGoal(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final longTermGoals = provider.longTermGoalData;

        return SingleChildScrollView(
          child: Column(
            children: [
              CustomText(
                text: 'Add Long Term Goal Which Kid Achieve',
                fontSize: 17.sp,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w400,
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
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
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Add Long Term Goal',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    color: AppColors.themeColor,
                                  ),
                                  CustomText(
                                    text: 'Add Long Term Goal',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: AppColors.grey,
                                  ),
                                  Divider(thickness: 1),
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
                                          NavigationHelper.pop(context);
                                          await provider.addLongTermCourse(
                                            widget.studentId,
                                            learningTextController.value.text.trim(),
                                          );
                                          provider.getLongTermGoal(widget.studentId);
                                          learningTextController.clear();
                                        },

                                        child: CustomContainer(
                                          borderRadius: 20.r,
                                          text: 'Back',
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("No long term goals found."),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: longTermGoals.length,
                  itemBuilder: (context, index) {
                    final goal = longTermGoals[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                              child: Divider(thickness: 1),
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
                                    CustomContainer(
                                      borderRadius: 7.r,
                                      text: 'Edit',
                                      containerColor: AppColors.green,
                                      padding: 1,
                                      innerPadding: EdgeInsets.symmetric(
                                        vertical: 8.sp,
                                        horizontal: 35.sp,
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
