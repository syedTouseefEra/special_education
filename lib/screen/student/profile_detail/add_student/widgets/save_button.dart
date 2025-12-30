import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/utils/navigation_utils.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
          borderRadius: 20.r,
          borderColor: AppColors.yellow,
          text: 'Back',
          textColor: AppColors.yellow,
          containerColor: AppColors.transparent,
          padding: 1.sp,
          innerPadding: EdgeInsets.symmetric(
            vertical: 8.sp,
            horizontal: 35.sp,
          ),
          onTap: (){
            NavigationHelper.pop(context);
          },
        ),
        SizedBox(width: 20.sp),
        CustomContainer(
          text: 'Save And Continue',
          fontWeight: FontWeight.w400,
          padding: 5.sp,
          innerPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
          borderRadius: 20.r,
          onTap: onPressed,
        ),
      ],
    );
  }
}
