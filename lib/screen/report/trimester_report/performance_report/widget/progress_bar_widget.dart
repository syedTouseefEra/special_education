import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class ProgressBar extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;

  const ProgressBar({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 24.sp,
        width: 24.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected ? Border.all(color: AppColors.white, width: 0.5.sp) : null,
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: text,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
