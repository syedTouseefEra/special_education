import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/widget/cumulative_rating_row.dart';

class AssessmentSection extends StatelessWidget {
  final String title;
  final TextEditingController remarkController;
  final Function(int) onRatingChanged;

  const AssessmentSection({
    super.key,
    required this.title,
    required this.remarkController,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.sp),

        CustomText(
          text: title,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),

        SizedBox(height: 10.sp),

        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 9.sp,
                    width: double.infinity,
                    color: AppColors.grey.withOpacity(0.3),
                  ),
                  CumulativeRatingRow(
                    initial: 0,
                    onChanged: onRatingChanged,
                  ),
                ],
              ),
              SizedBox(height: 8.sp),
            ],
          ),
        ),

        CustomText(
          text: "Score on the scale of 1-5 (where 1 is lowest and 5 is highest)",
          fontSize: 10.sp,
          color: AppColors.grey,
        ),

        SizedBox(height: 10.sp),

        CustomText(text: "Remark"),

        SizedBox(height: 10.sp),

        TextField(
          controller: remarkController,
          maxLines: 3,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.sp,
              horizontal: 10.sp,
            ),
            border: OutlineInputBorder(),
            hintText: 'Enter Learning Outcome!',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontSize: 14.sp,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: AppColors.grey),
            ),
          ),
        ),

        SizedBox(height: 10.sp),
      ],
    );
  }
}
