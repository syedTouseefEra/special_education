
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 5.sp),
        const Divider(thickness: 1),
        SizedBox(height: 10.sp),
      ],
    );
  }
}
