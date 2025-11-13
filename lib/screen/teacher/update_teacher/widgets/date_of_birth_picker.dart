import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/utils/date_picker_utils.dart';
import 'package:special_education/constant/colors.dart';

class DateOfBirthPicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final String labelText;
  final bool isRequired;

  const DateOfBirthPicker({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    this.labelText = "Date of Birth",
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(
          text: labelText,
          isRequired: isRequired,
          fontSize: 14.sp,
          color: AppColors.black,
        ),
        SizedBox(height: 5.sp),
        DatePickerHelper.datePicker(
          dateColor: AppColors.black.withAlpha(450),
          borderColor: AppColors.grey,
          iconColor: AppColors.black.withAlpha(450),
          context,
          date: selectedDate,
          onChanged: onChanged,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ),
        SizedBox(height: 7.sp),
      ],
    );
  }
}
