

import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
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
    learningTextController =
        TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    learningTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.themeColor,
          onPressed: () => NavigationHelper.pop(context),
        ),
        title: CustomText(
          text: isEdit
              ? 'Update Long Term Goal'
              : 'Add Long Term Goal',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: AppColors.themeColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: isEdit
                    ? 'Update your long term goal below'
                    : 'Add Long Term Goal',
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
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    final provider =
                    Provider.of<StudentDashboardProvider>(
                      context,
                      listen: false,
                    );

                    final text =
                    learningTextController.text.trim();

                    if (text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Goal cannot be empty'),
                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
