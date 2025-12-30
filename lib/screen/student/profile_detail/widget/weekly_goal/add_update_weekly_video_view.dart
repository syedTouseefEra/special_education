


import 'dart:io';

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
import 'package:special_education/utils/image_picker.dart';
import 'package:special_education/utils/navigation_utils.dart';

class AddUpdateWeeklyVideoView extends StatefulWidget {
  final String? initialText;
  final String studentId;

  const AddUpdateWeeklyVideoView({
    super.key,
    this.initialText,
    required this.studentId,
  });

  @override
  State<AddUpdateWeeklyVideoView> createState() => _AddUpdateWeeklyVideoViewState();
}

class _AddUpdateWeeklyVideoViewState extends State<AddUpdateWeeklyVideoView> {
  File? _pickedVideo;

  final TextEditingController learningOutcomeController =
  TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      learningOutcomeController.text = widget.initialText!;
    }
  }

  @override
  void dispose() {
    learningOutcomeController.dispose();
    remarkController.dispose();
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
                  moduleName: 'Add Learning Outcome',
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
                    text: 'Add Weekly Learning Outcome!',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.textGrey,
                  ),

                  SizedBox(height: 15.h),

                  FieldLabel(text: "Learning Outcome",isRequired: true,),
                  SizedBox(height: 5.h),

                  CustomTextField(
                    controller: learningOutcomeController,
                    maxLines: 6,
                    borderRadius: 5.r,
                    borderColor: AppColors.grey,
                    label: '',
                  ),

                  SizedBox(height: 10.h),

                  FieldLabel(text: "Remark"),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    controller: remarkController,
                    maxLines: 5,
                    borderRadius: 5.r,
                    borderColor: AppColors.grey,
                    label: '',
                  ),

                  SizedBox(height: 15.h),

                  FieldLabel(text: "Add Video",isRequired: true,),
                  SizedBox(height: 5.h),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(5.r)
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final picked =
                            await ImagePickerHelper.pickVideoFromGallery();
                            if (picked != null) {
                              setState(() {
                                _pickedVideo = File(picked.path);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.textGrey,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical:2.sp,
                              horizontal: 10.sp,
                            ),
                            child: CustomText(
                              text: 'Add Video',
                              fontSize: 12.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),

                        if (_pickedVideo != null)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.sp),
                              child: CustomText(
                                text: _pickedVideo!.path.split('/').last,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50.h),

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
                      SizedBox(width: 15.sp,),
                      CustomContainer(
                        borderRadius: 20.r,
                        text: 'Add Learning Outcome',
                        containerColor: AppColors.yellow,
                        padding: 1,
                        innerPadding: EdgeInsets.symmetric(
                          vertical: 8.sp,
                          horizontal: 15.sp,
                        ),
                        onTap: () async {
                          final provider =
                          Provider.of<StudentDashboardProvider>(
                            context,
                            listen: false,
                          );

                          final text =
                          learningOutcomeController.text.trim();

                          bool success = await provider.addLongTermCourse(
                            context,
                            widget.studentId,
                            text,
                          );

                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Goal added successfully!'),
                              ),
                            );

                            await provider.getLongTermGoal(
                              context,
                              widget.studentId,
                            );

                            learningOutcomeController.clear();
                            remarkController.clear();
                            setState(() {
                              _pickedVideo = null;
                            });
                          }
                        },
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
}
