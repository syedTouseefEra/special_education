import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/date_picker_utils.dart';
import 'package:special_education/utils/navigation_utils.dart';

class AddUpdateWeeklyGoalView extends StatefulWidget {
  final String studentId;
  final String? weekCount;
  final String? goalId;
  final String? goalText;
  final String? interventionText;
  final String? learningBarrierText;
  final DateTime? durationDate;

  const AddUpdateWeeklyGoalView({
    super.key,
    required this.studentId,
    this.weekCount,
    this.goalId,
    this.goalText,
    this.interventionText,
    this.learningBarrierText,
    this.durationDate,
  });

  @override
  State<AddUpdateWeeklyGoalView> createState() =>
      _AddUpdateWeeklyGoalViewState();
}

class _AddUpdateWeeklyGoalViewState extends State<AddUpdateWeeklyGoalView> {
  final TextEditingController goalController = TextEditingController();
  final TextEditingController interventionController = TextEditingController();
  final TextEditingController learningBarrierController =
      TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.goalId != null) {
      goalController.text = widget.goalText ?? '';
      interventionController.text = widget.interventionText ?? '';
      learningBarrierController.text = widget.learningBarrierText ?? '';
      selectedDate = widget.durationDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    goalController.dispose();
    interventionController.dispose();
    learningBarrierController.dispose();
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
                  moduleName: widget.goalId == null
                      ? 'Add Weekly Goal'
                      : 'Edit Weekly Goal',
                ),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 0.sp,
                horizontal: 20.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.goalId == null
                        ? 'Add Weekly Learning Outcome!'
                        : 'Update this Weekly Goal!',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.themeColor,
                        width: 1.sp
                      ),
                      borderRadius: BorderRadius.circular(7.r)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.sp,horizontal: 20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel(text: 'Week ${widget.weekCount ?? '1'}', isRequired: true),
                          SizedBox(height: 5.h),
                          DatePickerHelper.datePicker(
                            context,
                            date: selectedDate,
                            onChanged: (newDate) {
                              setState(() => selectedDate = newDate);
                            },
                          ),

                          SizedBox(height: 20.h),

                          _buildTextField('Goal','Enter Goal For This Week', goalController),
                          _buildTextField('Intervention','Enter Intervention', interventionController),
                          _buildTextField(
                            'Learning Barrier','Enter Learning Barrier For The Goal',
                            learningBarrierController,
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        borderRadius: 20.r,
                        borderColor: AppColors.yellow,
                        textColor: AppColors.yellow,
                        text: 'Back',
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
                      SizedBox(width: 20.sp,),
                      CustomContainer(
                        borderRadius: 20.r,
                        text: widget.goalId == null
                            ? 'Add'
                            : 'Update',
                        containerColor: AppColors.yellow,
                        padding: 1,
                        innerPadding: EdgeInsets.symmetric(
                          vertical: 8.sp,
                          horizontal: 35.sp,
                        ),
                        onTap: _onSubmit,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    final provider = Provider.of<StudentDashboardProvider>(
      context,
      listen: false,
    );

    final response = widget.goalId == null
        ? await provider.addWeeklyGoal(
            widget.studentId,
            fmt(selectedDate),
            goalController.text.trim(),
            interventionController.text.trim(),
            learningBarrierController.text.trim(),
          )
        : await provider.updateWeeklyGoal(
            widget.goalId!,
            fmt(selectedDate),
            goalController.text.trim(),
            interventionController.text.trim(),
            learningBarrierController.text.trim(),
          );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response["responseMessage"] ??
              (widget.goalId == null
                  ? "Goal added successfully!"
                  : "Goal updated successfully!"),
        ),
      ),
    );

    if (response["responseStatus"] == true) {
      Navigator.pop(context);
      await provider.getWeeklyGoals(context, widget.studentId);
    }
  }

  Widget _buildTextField(String header,String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          FieldLabel(text: header, isRequired: true,fontSize: 13.sp,color: AppColors.black,),
          SizedBox(height: 5.h,),
          CustomTextField(
              controller: controller,
            label: label,
            borderRadius: 5,
            maxLines: 4,
            fontSize: 14.sp,
            borderColor: AppColors.grey,
          ),
        ],
      ),

    );
  }
}
