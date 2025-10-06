
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/utils/text_case_utils.dart';
import 'custom_text.dart';

class ContentBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final int height;
  final int width;

  const ContentBox({
    super.key,
    required this.icon,
    required this.label,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(6.sp),
      child: Container(
        height: height.sp,
        width: width.sp,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.themeColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25.sp, color: AppColors.white),
            SizedBox(width: 5.sp),
            CustomText(
              text: label,
              fontSize: 15.sp,
              color: AppColors.white,
              textCase:  TextCase.title,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
