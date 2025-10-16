import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class DatePickerHelper {
  static Widget datePicker(
      BuildContext context, {
        required DateTime date,
        required ValueChanged<DateTime> onChanged,
        Color? borderColor,
        Color? iconColor,
      }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date.isAfter(DateTime.now()) ? DateTime.now() : date,
          firstDate: DateTime.now(),
          lastDate: DateTime(2080),
        );

        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 15.sp),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? AppColors.themeColor,
          ),
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: DateFormat('dd-MM-yyyy').format(date),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: borderColor ?? AppColors.themeColor,
            ),
            SizedBox(width: 15.w),
            Icon(
              Icons.calendar_month,
              size: 25.sp,
              color: iconColor ?? AppColors.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}

String formatDuration(String? startDateStr, String? endDateStr) {
  if (startDateStr == null || endDateStr == null) return "NA";

  try {
    final inputFormat = DateFormat("yyyy-MM-dd");
    final outputFormat = DateFormat("d MMMM yyyy");

    final startDate = inputFormat.parse(startDateStr);
    final endDate = inputFormat.parse(endDateStr);

    return "${outputFormat.format(startDate)} - ${outputFormat.format(endDate)}";
  } catch (e) {
    return "Invalid date";
  }
}

String fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
