import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/student/profile_detail/widget/student_profile_data_model.dart';
import 'package:special_education/utils/text_case_utils.dart';

class ProfileDetailsView extends StatelessWidget {
  final StudentProfileDataModel student;
  const ProfileDetailsView({super.key,required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.sp),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey, width: 1.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 5.sp),
              child: CustomText(
                text: 'Pre-Assessment|Phyco-Motor Skill',
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: AppColors.themeColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Divider(thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Fine Moter:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Gross Moter Skill:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Sitting:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Sitting Posture:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Speech:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Visual Eye Contact:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Vision:",
                value: "Poor",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Eye Hand Coordination:",
                value: "Poor",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Hearing:",
                value: "Poor",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Cognitive:",
                value: "Poor",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Attention:",
                value: "Poor",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Command Following:",
                value: "Poor",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Learning:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomContainer(
                    borderRadius: 10.sp,
                    text: 'Update',
                    containerColor: AppColors.green,
                    padding: 1,
                    innerPadding: EdgeInsets.symmetric(
                      vertical: 8.sp,
                      horizontal: 25.sp,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: AppColors.textGrey),

            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 5.sp, 10.sp, 5.sp),
              child: CustomText(
                text: 'Pre-Assessment|Academic Skill',
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: AppColors.themeColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Divider(thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Color Holding:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 8.sp, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Coloring",
                value: "",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Free Hand:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Large Space:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Close Space:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 8.sp, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Written",
                value: "",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Pencil Holding:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Tracing:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Standing Line:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Sleeping Line:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Slanting Line:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Curve:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Pattern Tracing:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 5.sp, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Oral",
                value: "",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "A-Z:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "1-50/100:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 5.sp, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Recognition",
                value: "",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Letter:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Number:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Colors:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Shapes:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Rhymes:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Attention:",
                value: "Good",
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomContainer(
                    borderRadius: 10.sp,
                    text: 'Update',
                    containerColor: AppColors.green,
                    padding: 1,
                    innerPadding: EdgeInsets.symmetric(
                      vertical: 8.sp,
                      horizontal: 25.sp,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: AppColors.textGrey),
            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
              child: LabelValueText(
                isRow: true,
                label: "Aadhar card:",
                value: "922893767356737",
                labelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.themeBlue,
                ),
                valueStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
                valueCase: TextCase.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Divider(thickness: 1),
            ),
          ],
        ),
      ),
    );
  }
}
