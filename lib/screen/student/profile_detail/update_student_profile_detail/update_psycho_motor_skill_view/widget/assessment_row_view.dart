import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_psycho_motor_skill_view/widget/radio_item_view.dart';

class AssessmentRowView extends StatelessWidget {
  final String title;
  final String groupValue;
  final bool isParent;
  final Function(String?) onChanged;

  const AssessmentRowView({
    super.key,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    this.isParent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isParent ? 15.sp : 14.sp,
            fontWeight: isParent ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.sp),

        Row(
          children: [
            Expanded(
              child: RadioItemView(
                value: 'Poor',
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioItemView(
                value: 'Average',
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.sp),

        Row(
          children: [
            Expanded(
              child: RadioItemView(
                value: 'Good',
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioItemView(
                value: 'Excellent',
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.sp),

        RadioItemView(
          value: 'Not Applicable',
          groupValue: groupValue,
          onChanged: onChanged,
        ),

        const Divider(height: 32),
      ],
    );
  }
}
