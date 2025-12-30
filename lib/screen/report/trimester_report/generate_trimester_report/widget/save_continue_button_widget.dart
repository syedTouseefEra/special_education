import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/constant/colors.dart';

class SaveContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
          text: 'Cancel',
          fontWeight: FontWeight.w400,
          padding: 5.sp,
          innerPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 7.sp),
          borderRadius: 20.r,
          fontSize: 13.sp,
          borderColor: AppColors.yellow,
          borderWidth: 1.sp,
          containerColor: AppColors.white,
          textColor: AppColors.yellow,
          onTap: (){
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 10.sp,),
        CustomContainer(
          containerColor: AppColors.yellow,
          text: 'Save And Continue',
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          padding: 5.sp,
          innerPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
          borderRadius: 20.r,
          onTap: onPressed,
        ),
      ],
    );
  }
}
