import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';

class AddLongTermGoalView extends StatefulWidget {
  final String? studentId;
  final String? goalId;
  final String? initialText;

  const AddLongTermGoalView({
    super.key,
    this.studentId,
    this.goalId,
    this.initialText,
  });

  @override
  State<AddLongTermGoalView> createState() => _AddLongTermGoalViewState();
}

class _AddLongTermGoalViewState extends State<AddLongTermGoalView> {
  late final TextEditingController learningTextController;

  bool get isEdit => widget.goalId != null;

  @override
  void initState() {
    super.initState();
    learningTextController = TextEditingController(
      text: widget.initialText ?? '',
    );
  }

  @override
  void dispose() {
    learningTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.sp),
            child: Column(
              children: [
                SizedBox(height: 5.sp),
                CustomHeaderView(
                  courseName: "",
                  moduleName: isEdit
                      ? 'Update Long Term Goal'
                      : 'Add Long Term Goal',
                ),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp,vertical: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: isEdit
                        ? 'Update your long term goal below'
                        : 'Add Long Term Goal!',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: AppColors.darkGrey,
                  ),
                  const Divider(thickness: 1),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      CustomText(
                        text: 'Long Term Goal',
                        color: AppColors.darkGrey,
                        fontSize: 14.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.sp),
                        child: Icon(Icons.star, size: 8.sp, color: AppColors.themeColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: learningTextController,
                    maxLines: 8,
                    borderRadius: 0,
                    fontColor: AppColors.textGrey,
                    fontSize: 14.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Learning Outcome!',
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        borderRadius: 20.r,
                        borderColor: AppColors.yellow,
                        text: 'Back',
                        textColor: AppColors.yellow,
                        containerColor: AppColors.transparent,
                        padding: 1,
                        innerPadding: EdgeInsets.symmetric(
                          vertical: 8.sp,
                          horizontal: 35.sp,
                        ),
                        onTap: (){
                          NavigationHelper.pop(context);
                        },
                      ),
                      SizedBox(width: 25.sp),
                      CustomContainer(
                        borderRadius: 20.r,
                        text: isEdit ? 'Update' : 'Add',
                        containerColor: AppColors.yellow,
                        padding: 1,
                        innerPadding: EdgeInsets.symmetric(
                          vertical: 8.sp,
                          horizontal: 35.sp,
                        ),
                        onTap: () async {
                          final provider = Provider.of<StudentDashboardProvider>(
                            context,
                            listen: false,
                          );

                          final text = learningTextController.text.trim();

                          if (text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Goal cannot be empty')),
                            );
                            return;
                          }

                          bool success;

                          if (isEdit) {
                            success = await provider.updateLongTermCourse(
                              context,
                              widget.goalId!,
                              text,
                            );
                          } else {
                            success = await provider.addLongTermCourse(
                              context,
                              widget.studentId.toString(),
                              text,
                            );
                          }

                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEdit
                                      ? 'Goal updated successfully!'
                                      : 'Goal added successfully!',
                                ),
                              ),
                            );

                            await provider.getLongTermGoal(
                              context,
                              widget.studentId.toString(),
                            );

                            NavigationHelper.pop(context);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
