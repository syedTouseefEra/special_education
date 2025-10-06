

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmationDialog({
    Key? key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText = "Upload",
    this.cancelText = "Cancel",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: title,
              color: AppColors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.transparent),
                    child: CustomText(
                      text: cancelText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.red,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.themeColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: CustomText(
                      text: confirmText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
